import { randomUUID } from 'node:crypto';
import {
  BadRequestException,
  Injectable,
  Logger,
  ServiceUnavailableException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';

/**
 * Files go to Supabase Storage, not through this API.
 *
 * The API's job is to decide *where* a file may be written and to hand back
 * a single-use signed URL for exactly that path. The bytes then travel from
 * the phone straight to storage. Three reasons it is built this way:
 *
 *   - a KYC scan or a gym photo never passes through our process, so a
 *     request body limit stays small and an upload cannot exhaust the API;
 *   - the path is ours to choose, so a gym can only ever write inside its
 *     own folder -- the client does not get to name the destination;
 *   - the signed URL expires, so a leaked link is not a standing write.
 *
 * The service-role key is used here and only here. It bypasses row-level
 * security, which is precisely why it must never reach a client: everything
 * it can do has to be gated by the permission checks in front of this.
 */

export type AssetKind = 'GYM_IMAGE' | 'EVENT_BANNER' | 'KYC_DOCUMENT';

interface BucketSpec {
  bucket: string;
  /** Public buckets serve by URL; private ones need a signed read. */
  isPublic: boolean;
  contentTypes: readonly string[];
}

const IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/webp'] as const;

/**
 * Mirrors the buckets created in Supabase. The limits are enforced there
 * too -- storage refuses an oversized or wrong-typed upload on its own --
 * but refusing here as well means the user is told before they spend a
 * minute pushing a file that was never going to be accepted.
 */
export const BUCKETS: Record<AssetKind, BucketSpec> = {
  GYM_IMAGE: { bucket: 'gym-images', isPublic: true, contentTypes: IMAGE_TYPES },
  EVENT_BANNER: {
    bucket: 'event-banners',
    isPublic: true,
    contentTypes: IMAGE_TYPES,
  },
  KYC_DOCUMENT: {
    bucket: 'kyc-documents',
    isPublic: false,
    contentTypes: [...IMAGE_TYPES, 'application/pdf'],
  },
};

const EXTENSIONS: Record<string, string> = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/webp': 'webp',
  'application/pdf': 'pdf',
};

/** How long a reviewer's link to a KYC document stays good. */
const SIGNED_READ_SECONDS = 300;

export interface SignedUpload {
  /** Where the client PUTs the bytes. Single use, and it expires. */
  uploadUrl: string;
  /** Where the file will live, to send back when submitting the form. */
  assetUrl: string;
  bucket: string;
  path: string;
  contentType: string;
  maxBytes: number;
}

@Injectable()
export class StorageService {
  private readonly log = new Logger(StorageService.name);
  private readonly baseUrl: string;
  private readonly serviceKey: string;
  private readonly http: AxiosInstance;

  constructor(config: ConfigService) {
    this.baseUrl = (config.get<string>('supabase.url') ?? '').replace(/\/+$/, '');
    this.serviceKey = config.get<string>('supabase.serviceRoleKey') ?? '';

    this.http = axios.create({
      baseURL: `${this.baseUrl}/storage/v1`,
      timeout: 15_000,
      headers: {
        Authorization: `Bearer ${this.serviceKey}`,
        apikey: this.serviceKey,
      },
    });
  }

  /** Configured well enough to sign anything. */
  get ready(): boolean {
    return Boolean(this.baseUrl && this.serviceKey);
  }

  /**
   * A place for one file, and permission to write it once.
   *
   * `ownerId` is the gym the file belongs to. It becomes the first path
   * segment, so a gym writes only inside its own folder even if two gyms
   * upload at the same instant. The filename is random rather than the
   * user's, which keeps a hostile name -- `../`, a script extension, a
   * 300-character unicode string -- out of the path entirely.
   */
  async signUpload(
    kind: AssetKind,
    ownerId: string,
    contentType: string,
  ): Promise<SignedUpload> {
    const spec = BUCKETS[kind];
    if (!spec.contentTypes.includes(contentType)) {
      throw new BadRequestException(
        `${kind} accepts ${spec.contentTypes.join(', ')}`,
      );
    }
    if (!this.ready) {
      // A misconfiguration, not the caller's fault, and worth saying so
      // rather than returning a URL that cannot work.
      this.log.error('Upload requested but Supabase storage is not configured');
      throw new ServiceUnavailableException(
        'File uploads are not configured on this server',
      );
    }

    const path = `${ownerId}/${randomUUID()}.${EXTENSIONS[contentType]}`;

    let token: string;
    try {
      const { data } = await this.http.post<{ url?: string; token?: string }>(
        `/object/upload/sign/${spec.bucket}/${path}`,
        {},
      );
      // Supabase returns the token both on its own and inside a relative
      // url, depending on version. Prefer the field, fall back to parsing.
      token = data.token ?? new URL(data.url ?? '', 'https://x').searchParams.get('token') ?? '';
      if (!token) throw new Error('no token in response');
    } catch (error) {
      this.log.error(
        `Could not sign an upload for ${spec.bucket}: ${(error as Error).message}`,
      );
      throw new ServiceUnavailableException('Could not start the upload');
    }

    return {
      uploadUrl:
        `${this.baseUrl}/storage/v1/object/upload/sign/${spec.bucket}/${path}` +
        `?token=${encodeURIComponent(token)}`,
      assetUrl: spec.isPublic
        ? this.publicUrl(spec.bucket, path)
        : this.objectUrl(spec.bucket, path),
      bucket: spec.bucket,
      path,
      contentType,
      maxBytes: spec.isPublic ? 5 * 1024 * 1024 : 10 * 1024 * 1024,
    };
  }

  /**
   * A short-lived link to a private file, for a reviewer who is allowed to
   * see it. Minutes rather than hours: long enough to open, short enough
   * that a link pasted into a chat is useless by the time anyone else finds
   * it.
   */
  async signDownload(bucket: string, path: string): Promise<string> {
    if (!this.ready) {
      throw new ServiceUnavailableException(
        'File storage is not configured on this server',
      );
    }
    try {
      const { data } = await this.http.post<{ signedURL: string }>(
        `/object/sign/${bucket}/${path}`,
        { expiresIn: SIGNED_READ_SECONDS },
      );
      return `${this.baseUrl}/storage/v1${data.signedURL}`;
    } catch (error) {
      this.log.error(
        `Could not sign a read of ${bucket}/${path}: ${(error as Error).message}`,
      );
      throw new ServiceUnavailableException('Could not open that document');
    }
  }

  publicUrl(bucket: string, path: string): string {
    return `${this.baseUrl}/storage/v1/object/public/${bucket}/${path}`;
  }

  private objectUrl(bucket: string, path: string): string {
    return `${this.baseUrl}/storage/v1/object/${bucket}/${path}`;
  }
}

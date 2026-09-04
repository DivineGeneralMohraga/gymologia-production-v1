import { registerDecorator, ValidationOptions } from 'class-validator';

/**
 * An uploaded asset must live in our own storage.
 *
 * `@IsUrl()` accepts any host, any scheme -- `http://attacker.example/x.png`
 * and `http://169.254.169.254/latest/meta-data/` both pass it. Every asset
 * field in this API took whatever the client sent and stored it, and those
 * URLs are then served to other people's devices:
 *
 *   - a gym's images load on every member's phone that opens the profile,
 *     so a hostile URL turns browsing into a beacon that hands a third
 *     party an IP and a user agent, over plain http at that;
 *   - an event banner does the same across the nationwide public listing;
 *   - an address proof or a KYC document is opened by a Gymologia reviewer,
 *     which points staff at a page the submitter controls.
 *
 * Files are uploaded by the client straight to Supabase Storage -- they do
 * not pass through this API -- so the only thing we can check is that the
 * URL we are asked to store is one of ours. That is what this does.
 */

const STORAGE_PATH = '/storage/v1/object/';

/** Cached so a request does not re-read the environment per field. */
let allowedHost: string | null | undefined;

function storageHost(): string | null {
  if (allowedHost !== undefined) return allowedHost;
  const configured = process.env.SUPABASE_URL ?? '';
  try {
    allowedHost = configured ? new URL(configured).host : null;
  } catch {
    allowedHost = null;
  }
  return allowedHost;
}

/** Exposed for tests; the cache would otherwise outlive a changed env. */
export function resetStorageHostCache(): void {
  allowedHost = undefined;
}

export function isStorageUrl(value: unknown): boolean {
  if (typeof value !== 'string' || value.length > 500) return false;

  let url: URL;
  try {
    url = new URL(value);
  } catch {
    return false;
  }

  // https only. An http asset would load insecurely on every device that
  // opens it, and would strip the guarantee the rest of the API has.
  if (url.protocol !== 'https:') return false;
  if (!url.pathname.startsWith(STORAGE_PATH)) return false;

  // Credentials in a URL are never right here, and they are a classic way
  // to make a hostile host look like ours to someone reading quickly:
  // https://our-project.supabase.co@evil.test/...
  if (url.username || url.password) return false;

  const host = storageHost();
  if (host) return url.host === host;

  // No SUPABASE_URL configured. Production cannot reach here -- the boot
  // check refuses to start without it -- so this is a developer machine.
  // Still refuse anything that is not a Supabase project rather than
  // falling open, because a permissive dev path is how a hostile URL ends
  // up in a fixture and then in a test everyone trusts.
  return url.host.endsWith('.supabase.co');
}

export function IsStorageUrl(options?: ValidationOptions) {
  return function (object: object, propertyName: string): void {
    registerDecorator({
      name: 'isStorageUrl',
      target: object.constructor,
      propertyName,
      options,
      validator: {
        validate: (value: unknown) => isStorageUrl(value),
        defaultMessage: () =>
          `${propertyName} must be an https URL in this project's Supabase Storage`,
      },
    });
  };
}

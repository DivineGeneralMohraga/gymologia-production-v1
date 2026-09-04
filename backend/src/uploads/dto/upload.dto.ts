import { ApiProperty } from '@nestjs/swagger';
import { IsIn, IsString } from 'class-validator';
import { BUCKETS, type AssetKind } from '../storage.service';

const KINDS = Object.keys(BUCKETS) as AssetKind[];

/** Every content type any bucket accepts; the bucket narrows it again. */
const CONTENT_TYPES = [
  ...new Set(Object.values(BUCKETS).flatMap((b) => b.contentTypes)),
];

export class SignUploadDto {
  @ApiProperty({ enum: KINDS })
  @IsIn(KINDS)
  kind!: AssetKind;

  /**
   * Declared up front so the wrong file type is refused before the user
   * spends a minute uploading it. Storage checks it again on arrival --
   * this is a courtesy, not the guard.
   */
  @ApiProperty({ enum: CONTENT_TYPES })
  @IsString()
  @IsIn(CONTENT_TYPES)
  contentType!: string;
}

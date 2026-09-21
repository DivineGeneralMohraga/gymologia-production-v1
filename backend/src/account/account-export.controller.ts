import { Controller, Get, Header } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AccountExportService } from './account-export.service';
import { CurrentUser, AuthUser } from '../rbac/rbac.decorators';

/**
 * DPDP Act 2023 Section 12(a) — Data Principal's right to information about
 * their personal data. Returns a JSON export of everything held for the
 * authenticated user.
 */
@ApiTags('me')
@ApiBearerAuth()
@Controller('me/export')
export class AccountExportController {
  constructor(private readonly exportSvc: AccountExportService) {}

  @Get()
  @Header('Content-Disposition', 'attachment; filename="gymologia-my-data.json"')
  @ApiOperation({
    summary: 'Download all personal data held for this account',
    description:
      'Returns a JSON file containing every personal data record Gymologia ' +
      'holds for the authenticated user. Required by DPDP Act 2023 Section 12(a).',
  })
  export(@CurrentUser() user: AuthUser) {
    return this.exportSvc.export(user.userId);
  }
}

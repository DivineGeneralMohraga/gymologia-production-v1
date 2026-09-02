import {
  Body, Controller, Delete, Get, Param, ParseUUIDPipe, Patch, Post, Put, Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import type { Request } from 'express';
import { RolesService } from './roles.service';
import { Actor, RequirePermissions } from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';
import { CreateRoleDto, ReorderRolesDto, UpdateRoleDto } from './dto/role.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

@ApiTags('roles')
@ApiBearerAuth()
@Controller('gyms/:gymId/roles')
export class RolesController {
  constructor(private readonly roles: RolesService) {}

  @Get('permissions')
  @RequirePermissions(Permission.ADD_ROLES, Permission.EDIT_PERMISSIONS)
  @ApiOperation({
    summary: 'The permission catalogue',
    description:
      'Grouped and labelled, and marked with whether this actor may grant each one — a screen that offered all of them would refuse half on save.',
  })
  catalogue(@Actor() actor: ActorContext) {
    return this.roles.catalogue(actor);
  }

  @Get(':roleId')
  @RequirePermissions(
    Permission.ADD_ROLES,
    Permission.EDIT_PERMISSIONS,
    Permission.DELETE_ROLES,
    Permission.EDIT_ROLE_HIERARCHY,
    Permission.MANAGE_STAFF,
  )
  @ApiOperation({ summary: 'One role and everything it holds' })
  findOne(
    @Actor() actor: ActorContext,
    @Param('roleId', ParseUUIDPipe) roleId: string,
  ) {
    return this.roles.findOne(actor, roleId);
  }

  @Post()
  @RequirePermissions(Permission.ADD_ROLES)
  @ApiOperation({ summary: 'Create a role' })
  create(
    @Actor() actor: ActorContext,
    @Body() dto: CreateRoleDto,
    @Req() req: Request,
  ) {
    return this.roles.create(actor, dto, meta(req));
  }

  @Put('hierarchy')
  @RequirePermissions(Permission.EDIT_ROLE_HIERARCHY)
  @ApiOperation({
    summary: 'Re-rank roles, most senior first',
    description: 'Only roles junior to your own, and never a default role.',
  })
  reorder(
    @Actor() actor: ActorContext,
    @Body() dto: ReorderRolesDto,
    @Req() req: Request,
  ) {
    return this.roles.reorder(actor, dto, meta(req));
  }

  @Patch(':roleId')
  @RequirePermissions(
    Permission.EDIT_PERMISSIONS,
    Permission.ADD_ROLES,
    Permission.EDIT_ROLE_HIERARCHY,
  )
  @ApiOperation({
    summary: 'Rename a role, change what it can do, or move it',
    description:
      'Permissions are replaced wholesale by what you send. Removing one you do not hold yourself is refused, the same as granting it.',
  })
  update(
    @Actor() actor: ActorContext,
    @Param('roleId', ParseUUIDPipe) roleId: string,
    @Body() dto: UpdateRoleDto,
    @Req() req: Request,
  ) {
    return this.roles.update(actor, roleId, dto, meta(req));
  }

  @Delete(':roleId')
  @RequirePermissions(Permission.DELETE_ROLES)
  @ApiOperation({
    summary: 'Delete a role',
    description: 'Refused for default roles, and while anyone still holds it.',
  })
  remove(
    @Actor() actor: ActorContext,
    @Param('roleId', ParseUUIDPipe) roleId: string,
    @Req() req: Request,
  ) {
    return this.roles.remove(actor, roleId, meta(req));
  }
}

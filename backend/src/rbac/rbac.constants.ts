import { Permission } from '@prisma/client';

/**
 * Role seniority. LOWER number = MORE senior.
 *
 * The gaps of ten are deliberate: custom roles created by an owner slot in
 * between the defaults without renumbering anything that already exists.
 */
export const ROLE_LEVEL = {
  OWNER: 0,
  MANAGER: 10,
  ADMIN: 20,
  SALES_STAFF: 30,
  TRAINER: 40,
} as const;

/** Lowest seniority a custom role may be given. */
export const CUSTOM_ROLE_MIN_LEVEL = ROLE_LEVEL.MANAGER + 1;
export const CUSTOM_ROLE_MAX_LEVEL = 999;

export const ALL_PERMISSIONS: Permission[] = Object.values(Permission);

/**
 * Permissions nobody can be granted, no matter who is doing the granting.
 * DELETE_GYM belongs to the person whose KYC the gym is registered under,
 * full stop — it is checked against Gym.ownerId, not against a role.
 */
export const NON_GRANTABLE: ReadonlySet<Permission> = new Set([
  Permission.DELETE_GYM,
]);

export const GRANTABLE_PERMISSIONS: Permission[] = ALL_PERMISSIONS.filter(
  (p) => !NON_GRANTABLE.has(p),
);

export interface DefaultRoleSpec {
  name: string;
  level: number;
  isSystem: boolean;
  isSuper: boolean;
  exemptFromAttendance: boolean;
  permissions: Permission[];
}

/**
 * Seeded into every new gym.
 *
 * Owner and Manager are `isSuper`: they hold every permission implicitly,
 * including permissions added to the product in future releases, so the
 * set is never enumerated for them.
 *
 * Note on trainers: "Personal Trainer" and "General Trainer" from the spec
 * are modelled as TrainerCategory rows on a single Trainer role, not as
 * two roles. A gym that wants them to differ in authority can still create
 * separate roles — this is just the default that avoids duplicating one
 * permission set twice on day one.
 */
export const DEFAULT_ROLES: DefaultRoleSpec[] = [
  {
    name: 'Owner',
    level: ROLE_LEVEL.OWNER,
    isSystem: true,
    isSuper: true,
    exemptFromAttendance: true,
    permissions: ALL_PERMISSIONS,
  },
  {
    name: 'Manager',
    level: ROLE_LEVEL.MANAGER,
    isSystem: true,
    isSuper: true,
    exemptFromAttendance: true,
    permissions: GRANTABLE_PERMISSIONS,
  },
  {
    name: 'Admin',
    level: ROLE_LEVEL.ADMIN,
    isSystem: true,
    isSuper: false,
    exemptFromAttendance: false,
    permissions: [
      Permission.MARK_ATTENDANCE_MEMBER,
      Permission.MARK_ATTENDANCE_STAFF,
      Permission.EDIT_ATTENDANCE_MEMBER,
      Permission.EDIT_ATTENDANCE_STAFF,
      Permission.VIEW_ATTENDANCE_MEMBER,
      Permission.VIEW_ATTENDANCE_STAFF,
      Permission.VIEW_LEAVE_MEMBER,
      Permission.APPROVE_LEAVE_MEMBER,
      Permission.ADD_MEMBER,
      Permission.MANAGE_MEMBER,
      Permission.VIEW_PROGRESS,
      Permission.VIEW_ANALYTICS,
      Permission.EDIT_GYM_PROFILE,
    ],
  },
  {
    name: 'Sales Staff',
    level: ROLE_LEVEL.SALES_STAFF,
    isSystem: true,
    isSuper: false,
    exemptFromAttendance: false,
    permissions: [
      Permission.MARK_ATTENDANCE_MEMBER,
      Permission.VIEW_ATTENDANCE_MEMBER,
      Permission.ADD_MEMBER,
      // MARK_ATTENDANCE_STAFF is deliberately absent: the spec says sales
      // staff need it granted explicitly before they can mark trainers.
    ],
  },
  {
    name: 'Trainer',
    level: ROLE_LEVEL.TRAINER,
    isSystem: true,
    isSuper: false,
    exemptFromAttendance: false,
    permissions: [
      Permission.MARK_ATTENDANCE_MEMBER,
      Permission.VIEW_ATTENDANCE_MEMBER,
      Permission.VIEW_PROGRESS,
    ],
  },
];

export const DEFAULT_TRAINER_CATEGORIES = [
  { name: 'General', allowsMultipleMembers: true, sortOrder: 0 },
  { name: 'Personal', allowsMultipleMembers: false, sortOrder: 1 },
];

/**
 * Which permission gates which CRM surface. The staff app asks the API for
 * the viewer's permission set once, then hides every tile whose gate is
 * absent — so a screen the user cannot act on never appears at all.
 * The server re-checks on every request regardless; this is for the UI.
 */
export const SCREEN_GATES: Record<string, Permission[]> = {
  attendanceMember: [
    Permission.MARK_ATTENDANCE_MEMBER,
    Permission.VIEW_ATTENDANCE_MEMBER,
  ],
  attendanceStaff: [
    Permission.MARK_ATTENDANCE_STAFF,
    Permission.VIEW_ATTENDANCE_STAFF,
  ],
  editAttendance: [
    Permission.EDIT_ATTENDANCE_MEMBER,
    Permission.EDIT_ATTENDANCE_STAFF,
  ],
  leaveMember: [Permission.VIEW_LEAVE_MEMBER, Permission.APPROVE_LEAVE_MEMBER],
  leaveStaff: [Permission.VIEW_LEAVE_STAFF, Permission.APPROVE_LEAVE_STAFF],
  addMember: [Permission.ADD_MEMBER],
  manageMembers: [Permission.MANAGE_MEMBER, Permission.REMOVE_MEMBER],
  addStaff: [Permission.ADD_STAFF],
  manageStaff: [Permission.MANAGE_STAFF, Permission.REMOVE_STAFF],
  manageRoles: [
    Permission.ADD_ROLES,
    Permission.EDIT_PERMISSIONS,
    Permission.DELETE_ROLES,
    Permission.EDIT_ROLE_HIERARCHY,
  ],
  manageTrainers: [Permission.ADD_TRAINER, Permission.MANAGE_TRAINERS],
  events: [Permission.HOST_EVENTS, Permission.MANAGE_EVENTS],
  progress: [Permission.VIEW_PROGRESS],
  analytics: [Permission.VIEW_ANALYTICS],
  ranking: [Permission.VIEW_RANKING],
  gymProfile: [Permission.EDIT_GYM_PROFILE],
  subscription: [Permission.MANAGE_SUBSCRIPTION],
  notifications: [Permission.SEND_NOTIFICATIONS],
};

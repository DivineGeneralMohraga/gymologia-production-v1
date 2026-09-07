/// Which console sections a signed-in role reaches.
///
/// A pure function of the role and the capability flags, deliberately not a
/// method on the controller. The first version of this logic lived inside
/// `AuthController`, read private state, and was wrong before it had ever
/// run: it invented an `ANALYST` role that does not exist and omitted
/// `KYC_AGENT` that does, so a real reviewer would have been shown the
/// wrong sections. Nothing could have caught that except running it, and
/// nothing could run it.
///
/// None of this is a security boundary. Every endpoint enforces the same
/// rule again on the server, and customer support is refused the audit log
/// there whether or not this app draws the button. It decides what to draw.
library;

/// The five internal roles, most privileged first.
///
/// The server's `AdminRole` values verbatim. An unknown role reaches
/// nothing, which is the right way for this list to be wrong: a role added
/// on the server and not here draws a bare dashboard rather than a console
/// with sections its holder cannot use.
const List<String> adminRoles = [
  'OWNER',
  'ADMIN',
  'MANAGER',
  'CUSTOMER_SUPPORT',
  'KYC_AGENT',
];

/// Whether [role], holding [flags], reaches [section].
///
/// The flags come from `/admin/me` and are the server's own answer. Where
/// one exists it is used rather than re-derived here, because two copies of
/// an authorisation rule drift and the copy in the client is the one that
/// goes wrong.
bool canReach(String section, String role, Map<String, dynamic>? flags) {
  bool flag(String key) => flags?[key] == true;

  switch (section) {
    case 'dashboard':
      // Everybody who can sign in at all lands somewhere.
      return adminRoles.contains(role);
    case 'kyc':
      // KYC_AGENT exists to do exactly this, and MANAGER upwards can too.
      // The only section without a server flag, so the rule is written out.
      return role == 'KYC_AGENT' || _isAtLeast(role, 'MANAGER');
    case 'tickets':
      return flag('canHandleSupport');
    case 'broadcast':
      return flag('canBroadcast');
    case 'staff':
      return flag('canManageStaff');
    case 'logs':
    case 'security':
      return flag('canSeeLogs');
    default:
      // An unknown section is not drawn. A typo in a section name should
      // hide a tab, never reveal one.
      return false;
  }
}

bool _isAtLeast(String role, String minimum) {
  final mine = adminRoles.indexOf(role);
  final bar = adminRoles.indexOf(minimum);
  if (mine < 0 || bar < 0) return false;
  return mine <= bar;
}

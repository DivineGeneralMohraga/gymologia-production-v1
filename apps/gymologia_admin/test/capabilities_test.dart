import 'package:flutter_test/flutter_test.dart';
import 'package:gymologia_admin/features/auth/capabilities.dart';

/// Which sections each internal role is shown.
///
/// This is the logic that was wrong before it had ever run. The first
/// version invented an `ANALYST` role that does not exist on the server and
/// omitted `KYC_AGENT` that does, so a real reviewer signing in would have
/// been shown the wrong console. It was caught by reading the server's
/// enum, not by anything in the app — because nothing in the app could run
/// it: it read private state on a controller that needed a session, a
/// network client and secure storage to exist at all.
///
/// It is a pure function now, so these are cheap. None of this is a
/// security boundary — the server enforces every one of these again — but
/// a console that draws a tab its holder is refused at is a console that
/// wastes somebody's time and looks broken.
void main() {
  /// The flags the server sends on /admin/me for each role. Written out
  /// rather than derived, so this table disagrees loudly if the server's
  /// idea of a role ever changes.
  Map<String, dynamic> flags({
    bool logs = false,
    bool broadcast = false,
    bool staff = false,
    bool support = false,
  }) =>
      {
        'canSeeLogs': logs,
        'canBroadcast': broadcast,
        'canManageStaff': staff,
        'canHandleSupport': support,
      };

  final owner = flags(logs: true, broadcast: true, staff: true, support: true);
  final support = flags(support: true);
  final kycAgent = flags();

  group('the roles are the server\'s', () {
    test('all five, and no invented sixth', () {
      // ANALYST was invented here once. KYC_AGENT was missing.
      expect(adminRoles, [
        'OWNER',
        'ADMIN',
        'MANAGER',
        'CUSTOMER_SUPPORT',
        'KYC_AGENT',
      ]);
      expect(adminRoles, isNot(contains('ANALYST')));
      expect(adminRoles, contains('KYC_AGENT'));
    });
  });

  group('verification desk', () {
    test('is open to the agents who exist to do it', () {
      // The bug: KYC_AGENT was not in the role list at all, so the person
      // hired to review documents saw no verification tab.
      expect(canReach('kyc', 'KYC_AGENT', kycAgent), isTrue);
    });

    test('and to manager upwards', () {
      expect(canReach('kyc', 'MANAGER', flags()), isTrue);
      expect(canReach('kyc', 'ADMIN', flags()), isTrue);
      expect(canReach('kyc', 'OWNER', owner), isTrue);
    });

    test('but not to customer support', () {
      expect(canReach('kyc', 'CUSTOMER_SUPPORT', support), isFalse);
    });
  });

  group('sections gated by a server flag', () {
    test('follow the flag, not the role name', () {
      // The point of reading flags: the server can change who may broadcast
      // without this app shipping a new build.
      expect(canReach('broadcast', 'CUSTOMER_SUPPORT', flags(broadcast: true)),
          isTrue);
      expect(canReach('broadcast', 'OWNER', flags()), isFalse,
          reason: 'no flag means no, even for an owner');
    });

    test('customer support handles tickets and nothing else', () {
      expect(canReach('tickets', 'CUSTOMER_SUPPORT', support), isTrue);
      expect(canReach('logs', 'CUSTOMER_SUPPORT', support), isFalse);
      expect(canReach('staff', 'CUSTOMER_SUPPORT', support), isFalse);
      expect(canReach('broadcast', 'CUSTOMER_SUPPORT', support), isFalse);
    });

    test('the audit log follows canSeeLogs, and so does security', () {
      expect(canReach('logs', 'ADMIN', flags(logs: true)), isTrue);
      expect(canReach('security', 'ADMIN', flags(logs: true)), isTrue);
      expect(canReach('logs', 'ADMIN', flags(logs: false)), isFalse);
      expect(canReach('security', 'ADMIN', flags(logs: false)), isFalse);
    });

    test('an owner with every flag reaches everything', () {
      for (final section in ['kyc', 'tickets', 'broadcast', 'staff', 'logs']) {
        expect(canReach(section, 'OWNER', owner), isTrue, reason: section);
      }
    });
  });

  group('when the answer is not known', () {
    test('missing flags are not a yes', () {
      // /admin/me answering without the flags, or an older server: the
      // absence of permission must never read as permission.
      expect(canReach('logs', 'OWNER', null), isFalse);
      expect(canReach('staff', 'OWNER', const {}), isFalse);
    });

    test('a non-boolean flag is not a yes either', () {
      // JSON from a server is not a typed object. "true" is not true.
      expect(canReach('logs', 'ADMIN', {'canSeeLogs': 'true'}), isFalse);
      expect(canReach('logs', 'ADMIN', {'canSeeLogs': 1}), isFalse);
    });

    test('an unknown role reaches nothing', () {
      // A role added on the server and not here draws a bare dashboard
      // rather than a console full of sections it will be refused at.
      expect(canReach('kyc', 'ANALYST', kycAgent), isFalse);
      expect(canReach('dashboard', 'ANALYST', owner), isFalse);
    });

    test('an unknown section is not drawn', () {
      // A typo in a section name should hide a tab, never reveal one.
      expect(canReach('payouts', 'OWNER', owner), isFalse);
      expect(canReach('', 'OWNER', owner), isFalse);
    });
  });
}

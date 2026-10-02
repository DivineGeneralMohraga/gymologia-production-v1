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

  group('accounts', () {
    test('support can look an account up but only managers up can ban', () {
      expect(canReach('accounts', 'CUSTOMER_SUPPORT', support), isTrue);
      expect(canReach('banAccounts', 'CUSTOMER_SUPPORT', support), isFalse);
      expect(canReach('banAccounts', 'MANAGER', support), isTrue);
      expect(canReach('banAccounts', 'OWNER', owner), isTrue);
    });

    test('a KYC agent sees neither', () {
      expect(canReach('accounts', 'KYC_AGENT', kycAgent), isFalse);
      expect(canReach('banAccounts', 'KYC_AGENT', kycAgent), isFalse);
    });
  });

  group('the report queue', () {
    test('is open to whoever works support', () {
      // Same desk, same flag, and the server admits the same three roles.
      // If these two ever disagree, a report queue appears for somebody
      // the API then refuses -- or, worse, does not appear for the person
      // whose job it is.
      expect(canReach('reports', 'CUSTOMER_SUPPORT', support), isTrue);
      expect(canReach('reports', 'OWNER', owner), isTrue);
    });

    test('is not drawn for a role that cannot work it', () {
      expect(canReach('reports', 'KYC_AGENT', kycAgent), isFalse);
      expect(canReach('reports', 'ADMIN', flags()), isFalse,
          reason: 'the flag decides, not the seniority');
    });

    test('tracks support exactly', () {
      // Written as an equality rather than two separate assertions,
      // because the point is that they are the same rule -- one of them
      // being changed alone is the failure this catches.
      for (final role in adminRoles) {
        for (final f in [owner, support, kycAgent, flags(support: true)]) {
          expect(canReach('reports', role, f), canReach('tickets', role, f),
              reason: 'reports and tickets diverged for $role');
        }
      }
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

  group('the payout desk', () {
    test('is owner and admin only', () {
      expect(canReach('payouts', 'OWNER', owner), isTrue);
      expect(canReach('payouts', 'ADMIN', flags()), isTrue);
    });

    test('and nobody else, whatever flags they carry', () {
      // Deliberately checked against a manager holding every flag: this is
      // the one screen where a button moves money, so it must not widen by
      // accident when a flag is granted for some other reason.
      expect(canReach('payouts', 'MANAGER', owner), isFalse);
      expect(canReach('payouts', 'CUSTOMER_SUPPORT', owner), isFalse);
      expect(canReach('payouts', 'KYC_AGENT', owner), isFalse);
    });

    test('and not for a role the server has never heard of', () {
      expect(canReach('payouts', 'ANALYST', owner), isFalse);
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
      //
      // The example used to be 'payouts', which stopped being unknown the
      // day the payout desk was added -- and the test failed, correctly,
      // for exactly that reason. Kept deliberately meaningless now.
      expect(canReach('refunds', 'OWNER', owner), isFalse);
      expect(canReach('payoutz', 'OWNER', owner), isFalse);
      expect(canReach('', 'OWNER', owner), isFalse);
    });
  });
}

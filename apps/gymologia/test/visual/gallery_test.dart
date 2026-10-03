// Renders the main screens against canned API data and writes PNGs, dark
// and light, so a design change can be looked at without a phone.
//
//   GALLERY=1 flutter test test/visual/gallery_test.dart
//
// Output: build/gallery/<screen>_<mode>.png. Photos come from
// GALLERY_PHOTOS (a folder of .jpg files) when set; without it the
// screens fall back to their no-photo placeholders.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:gymologia/core/api/api_client.dart';
import 'package:gymologia/features/auth/auth_controller.dart';
import 'package:gymologia/features/auth/phone_screen.dart';
import 'package:gymologia/features/member/events_page.dart';
import 'package:gymologia/features/member/gym_profile_page.dart';
import 'package:gymologia/features/settings/locale_controller.dart';
import 'package:gymologia/features/settings/settings_page.dart';
import 'package:gymologia/features/settings/theme_controller.dart';
import 'package:gymologia/features/shell/app_mode.dart';
import 'package:gymologia/features/shell/app_shell.dart';
import 'package:gymologia/core/api/models.dart';
import 'package:gymologia/features/staff/crm_dashboard_page.dart';
import 'package:gymologia/features/staff/gym_profile_edit_page.dart';
import 'package:gymologia/features/staff/kyc_page.dart';
import 'package:gymologia/features/staff/create_gym_page.dart';
import 'package:gymologia/features/staff/gym_location_picker.dart';
import 'package:gymologia/features/staff/attendance_page.dart';
import 'package:gymologia/l10n/app_localizations.dart';
import 'package:gymologia/theme.dart';

final _enabled = Platform.environment['GALLERY'] == '1';
final _photoDir = Platform.environment['GALLERY_PHOTOS'];
const _out = 'build/gallery';

String _img(int n) => 'https://img.test/gym_$n.jpg';

final _iso = DateTime.now().toUtc();
String _days(int d) => _iso.add(Duration(days: d)).toIso8601String();

const _perms = [
  'VIEW_ANALYTICS', 'EDIT_GYM_PROFILE', 'MANAGE_SUBSCRIPTION',
  'VIEW_RANKING', 'SEND_NOTIFICATIONS', 'MANAGE_EVENTS', 'HOST_EVENTS',
  'MARK_ATTENDANCE_MEMBER', 'MARK_ATTENDANCE_STAFF', 'VIEW_ATTENDANCE_MEMBER',
  'VIEW_ATTENDANCE_STAFF', 'EDIT_ATTENDANCE_MEMBER', 'EDIT_ATTENDANCE_STAFF',
];
const _screens = [
  'addMember', 'manageMembers', 'addStaff', 'manageStaff', 'leaveMember',
  'manageTrainers', 'manageRoles', 'events',
];

Map<String, dynamic> _routes(String path, {required bool member}) {
  final gymListing = [
    {
      'id': 'g1', 'displayName': 'Iron Temple - Andheri West', 'district': 'Mumbai',
      'rating': 4.7, 'ratingCount': 128, 'perkCount': 6, 'imageUrl': _img(1),
      'distanceKm': 1.2,
    },
    {
      'id': 'g2', 'displayName': 'Beast Factory - Koramangala', 'district': 'Bengaluru',
      'rating': 4.4, 'ratingCount': 52, 'perkCount': 4, 'imageUrl': _img(2),
      'distanceKm': 3.8,
    },
    {
      'id': 'g3', 'displayName': 'Muscle Lab - Salt Lake', 'district': 'Kolkata',
      'rating': 0, 'ratingCount': 0, 'perkCount': 0, 'imageUrl': null,
    },
  ];
  final event = {
    'id': 'e1', 'title': 'Deadlift Showdown', 'displayName': 'Deadlift Showdown - Mumbai',
    'description': 'Max deadlift, three attempts, judged on form. Open to all levels.',
    'howToParticipate': 'Register at the front desk with your membership card.',
    'prize': 'Rs 10,000 + 3 months free membership',
    'startsAt': _days(6), 'endsAt': _days(6),
    'registrationLastDate': _days(4), 'bannerUrl': _img(3),
    'registered': false, 'canParticipate': true,
    'gym': {'displayName': 'Iron Temple - Andheri West'},
  };
  return switch (path) {
    '/auth/me' => {
        'id': 'u1', 'phone': '+919876543210', 'name': 'Rahul Sharma',
        'email': 'rahul@example.com', 'age': 24,
      },
    '/me/memberships' => {
        'data': member
            ? [
                {
                  'membershipId': 'm1', 'status': 'ACTIVE', 'daysRemaining': 23,
                  'goal': 'Build muscle and drop to 15% body fat',
                  'trainerName': 'Vikram', 'maxLeaveDays': 6, 'leaveDaysUsed': 2,
                  'allowProgressMonitoring': true,
                  'gym': {'id': 'g1', 'displayName': 'Iron Temple - Andheri West', 'imageUrl': _img(1)},
                },
              ]
            : [],
      },
    '/me/notifications/unread' => {'unread': 3},
    '/me/metrics' => {
        // Due would auto-open the check-in sheet over the screenshot.
        'checkInDue': Platform.environment['GALLERY_CHECKIN'] == '1',
        'latest': {'recordedAt': _days(-30), 'weightKg': 72.4, 'heightCm': 178},
        'history': [],
      },
    '/gyms/search' => {'data': gymListing},
    '/gyms/g1/public' => {
        'id': 'g1', 'name': 'Iron Temple', 'displayName': 'Iron Temple - Andheri West',
        'description': 'Two floors of free weights, 12 squat racks, and coaches who '
            'actually watch your form. Open 5 am to 11 pm, every day.',
        'perks': ['Free diet plan', 'Steam room', 'Personal locker', 'Parking', 'Wi-Fi', 'Protein bar'],
        'images': [_img(1), _img(2), _img(10)],
        'rating': 4.7, 'ratingCount': 128, 'contactPhone': '+919820012345',
      },
    '/events' => {
        'myGyms': [
          event,
          {...event, 'id': 'e2', 'title': 'Summer Shred Challenge', 'bannerUrl': null,
            'registered': true, 'prize': null, 'startsAt': _days(12), 'endsAt': _days(42)},
        ],
        'global': [
          {...event, 'id': 'e3', 'title': 'Bench Press Open', 'canParticipate': false,
            'bannerUrl': _img(2), 'gym': {'displayName': 'Beast Factory - Koramangala'}},
        ],
      },
    '/gyms/mine' => {
        'data': [
          {
            'id': 'g1', 'name': 'Iron Temple', 'displayName': 'Iron Temple - Andheri West',
            'district': 'Mumbai', 'status': 'ACTIVE', 'memberCount': 214, 'staffCount': 12,
            'rating': 4.7, 'ratingCount': 128, 'isOwner': true, 'imageUrl': _img(1), 'plan': 'PRO',
          },
          {
            'id': 'g2', 'name': 'Iron Temple Express', 'displayName': 'Iron Temple Express - Bandra',
            'district': 'Mumbai', 'status': 'DRAFT', 'memberCount': 0, 'staffCount': 1,
            'rating': 0, 'ratingCount': 0, 'isOwner': true, 'imageUrl': null, 'plan': null,
          },
        ],
      },
    '/gyms/g1' => {
        'id': 'g1', 'name': 'Iron Temple', 'displayName': 'Iron Temple - Andheri West',
        'district': 'Mumbai', 'status': 'ACTIVE', 'memberCount': 214, 'staffCount': 12,
        'plan': {'plan': 'PRO'},
        'access': {
          'permissions': _perms, 'visibleScreens': _screens, 'isGymOwner': true,
          'role': {'name': 'Owner'},
        },
      },
    '/gyms/g1/members' => {
        'items': [
          for (final (i, n, d) in [
            (1, 'Aarav Mehta', 41), (2, 'Diya Kapoor', 12), (3, 'Ishaan Verma', 64),
            (4, 'Kabir Singh', 5), (5, 'Meera Iyer', 88), (6, 'Neha Joshi', 30),
            (7, 'Rohan Das', 19), (8, 'Sana Khan', 52), (9, 'Vikram Rao', 27),
          ])
            {'membershipId': 'ms$i', 'status': 'ACTIVE', 'daysRemaining': d,
              'user': {'id': 'mu$i', 'name': n, 'phone': '+91******00$i'},
              'trainer': i.isEven ? {'name': 'Vikram'} : null},
        ],
        'total': 9,
      },
    '/gyms/g1/attendance' => {
        'data': [
          for (final (u, st) in [('mu2', 'PRESENT'), ('mu5', 'PRESENT'), ('mu7', 'ABSENT'), ('mu8', 'PRESENT')])
            {'id': 'r$u', 'subjectId': u, 'status': st},
        ],
      },
    '/gyms/g1/attendance/analytics' => {
        'activeMembers': 214, 'joinedInWindow': 27, 'engagedMembers': 139,
        'engagementRate': 65, 'windowDays': 30, 'dailyPresent': [],
      },
    '/gyms/g2/kyc' => {
        'submitted': true, 'aadhaarLast4': '4821', 'panLast4': '234F', 'gstinLast4': null,
        'aadhaarStatus': 'PENDING', 'panStatus': 'PENDING', 'gstStatus': 'PENDING',
        'nocStatus': 'PENDING', 'premises': 'RENTED', 'altProofType': 'UDYAM',
        'verifiedAt': null, 'rejectionReason': null,
      },
    '/gyms/g3/kyc' => {
        'submitted': true, 'aadhaarLast4': '4821', 'panLast4': '234F', 'gstinLast4': '1Z5',
        'aadhaarStatus': 'VERIFIED', 'panStatus': 'VERIFIED', 'gstStatus': 'REJECTED',
        'nocStatus': 'NOT_SUBMITTED', 'premises': 'OWNED', 'altProofType': null,
        'verifiedAt': null,
        'rejectionReason': 'The GST certificate is for a different business name. Upload the one for this gym.',
      },
    '/gyms' => {
        'id': 'g9', 'name': 'Iron Temple', 'displayName': 'Iron Temple - Pune',
        'district': 'Pune', 'status': 'DRAFT', 'memberCount': 0, 'staffCount': 1,
        'access': {'permissions': _perms, 'visibleScreens': _screens, 'isGymOwner': true,
          'role': {'name': 'Owner'}},
      },
    _ => {},
  };
}

/// The owner's view of a gym, for pages that take a GymDetail directly.
GymDetail _gym(String id, {List<String> images = const []}) {
  final j = Map<String, dynamic>.from(_routes('/gyms/g1', member: true));
  j['id'] = id;
  j['images'] = images;
  j['perks'] = ['Free diet plan', 'Steam room', 'Parking'];
  j['description'] = 'Two floors of free weights.';
  j['contactPhone'] = '+919820012345';
  j['latitude'] = 18.5204;
  j['longitude'] = 73.8567;
  return GymDetail.fromJson(j);
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({required this.member});
  final bool member;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? _,
      Future<void>? __) async {
    final path = options.uri.path.replaceFirst(RegExp(r'^/api/v1'), '');
    return ResponseBody.fromString(
      jsonEncode(_routes(path, member: member)),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final p in paths) {
    final bytes = File(p).readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

Future<void> _precachePhotos() async {
  final dir = _photoDir;
  if (dir == null) return;
  for (final n in [1, 2, 3, 10]) {
    final file = File('$dir/gym_$n.jpg');
    if (!file.existsSync()) continue;
    final bytes = file.readAsBytesSync();
    PaintingBinding.instance.imageCache.putIfAbsent(
      NetworkImage(_img(n)),
      () => MemoryImage(bytes).resolve(ImageConfiguration.empty).completer!,
    );
  }
}

Widget _app({
  required AuthController auth,
  required ThemeMode mode,
  required Widget home,
  bool staff = false,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: auth),
      ChangeNotifierProvider(
        create: (_) {
          final c = AppModeController();
          if (staff) c.toggle();
          return c;
        },
      ),
      ChangeNotifierProvider(create: (_) => LocaleController()),
      ChangeNotifierProvider(create: (_) => ThemeController()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: mode,
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // flutter_map caches tiles under the app's cache directory; there is no
    // path_provider plugin in a test, so hand it a temp folder.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('plugins.flutter.io/path_provider'),
            (call) async => Directory.systemTemp.createTempSync('gallery').path);
    final sdk = Platform.environment['FLUTTER_ROOT'] ??
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent.path;
    final fonts = '$sdk/bin/cache/artifacts/material_fonts';
    await _loadFont('Roboto', [
      '$fonts/roboto-regular.ttf', '$fonts/roboto-medium.ttf',
      '$fonts/roboto-bold.ttf', '$fonts/roboto-black.ttf',
    ]);
    await _loadFont('MaterialIcons', ['$fonts/materialicons-regular.otf']);
    await _loadFont(displayFont, [
      for (final w in ['SemiBold', 'Bold', 'ExtraBold', 'ExtraBoldItalic', 'Black', 'BlackItalic'])
        'assets/fonts/BarlowCondensed-$w.ttf',
    ]);
    Directory(_out).createSync(recursive: true);
  });

  Future<void> shoot(
    WidgetTester tester,
    String name,
    Widget Function(AuthController auth) home, {
    bool member = true,
    bool staff = false,
    double height = 852,
    Future<void> Function(WidgetTester tester)? act,
  }) async {
    for (final mode in [ThemeMode.dark, ThemeMode.light]) {
      FlutterSecureStorage.setMockInitialValues({'access_token': 't'});
      tester.view.physicalSize = Size(393 * 2, height * 2);
      tester.view.devicePixelRatio = 2;

      final client = ApiClient(dio: Dio()..httpClientAdapter = _FakeAdapter(member: member));
      final auth = AuthController(client: client);
      await tester.runAsync(() async {
        await auth.restoreSession();
        await _precachePhotos();
      });

      final key = GlobalKey();
      await tester.pumpWidget(RepaintBoundary(
        key: key,
        child: _app(auth: auth, mode: mode, home: home(auth), staff: staff),
      ));
      // Let the fake API calls land and the photos decode.
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 60)));
        await tester.pump(const Duration(milliseconds: 300));
      }
      if (act != null) {
        await act(tester);
        for (var i = 0; i < 4; i++) {
          await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 60)));
          await tester.pump(const Duration(milliseconds: 300));
        }
      }

      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 1.5);
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        File('$_out/${name}_${mode.name}.png')
            .writeAsBytesSync(png!.buffer.asUint8List());
      });
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }

  group('gallery', skip: !_enabled, () {
    testWidgets('login', (t) => shoot(t, '01_login', (_) => const PhoneScreen()));
    testWidgets('member home', (t) => shoot(t, '02_home', (_) => const AppShell(), height: 1200));
    testWidgets('gym browser',
        (t) => shoot(t, '03_browser', (_) => const AppShell(), member: false, height: 1100));
    testWidgets('gym profile', (t) => shoot(t, '04_profile', (_) => const GymProfilePage(gymId: 'g1'), height: 1000));
    testWidgets('events',
        (t) => shoot(t, '05_events', (_) => const Scaffold(body: SafeArea(child: EventsPage())), height: 1500));
    testWidgets('settings',
        (t) => shoot(t, '06_settings', (_) => const Scaffold(body: SafeArea(child: SettingsPage())), height: 1250));
    testWidgets('staff gyms',
        (t) => shoot(t, '07_staff_gyms', (_) => const AppShell(), staff: true, height: 900));
    testWidgets('kyc form',
        (t) => shoot(t, '09_kyc_form', (_) => KycPage(gym: _gym('g1')), height: 1700));
    testWidgets('kyc under review',
        (t) => shoot(t, '10_kyc_review', (_) => KycPage(gym: _gym('g2')), height: 1000));
    testWidgets('kyc needs changes',
        (t) => shoot(t, '11_kyc_changes', (_) => KycPage(gym: _gym('g3')), height: 1900));
    testWidgets('gym photos',
        (t) => shoot(t, '12_gym_photos',
            (_) => GymProfileEditPage(gym: _gym('g1', images: [_img(1), _img(2), _img(10)])),
            height: 1000));
    testWidgets('create gym form',
        (t) => shoot(t, '13_create_gym', (_) => const CreateGymPage(), height: 1900));
    testWidgets('create gym photo step', (t) => shoot(t, '14_create_photos',
        (_) => const CreateGymPage(), height: 1900, act: (tester) async {
          final fields = find.byType(TextFormField);
          for (final (i, v) in [(0, 'Iron Temple'), (2, '1 MG Road'), (3, 'Pune'),
              (4, 'Pune'), (5, 'Maharashtra'), (6, '411001'), (7, '9820012345')]) {
            await tester.enterText(fields.at(i), v);
          }
          final create = find.widgetWithText(FilledButton, 'Create gym');
          await tester.ensureVisible(create);
          await tester.tap(create);
        }));
    testWidgets('location picker', (t) => shoot(t, '15_location_picker',
        (_) => const GymLocationPickerPage(initial: (latitude: 18.5204, longitude: 73.8567)),
        height: 852));
    testWidgets('attendance',
        (t) => shoot(t, '16_attendance', (_) => AttendancePage(gym: _gym('g1')), height: 1100));
    testWidgets('crm dashboard',
        (t) => shoot(t, '08_crm', (_) => const CrmDashboardPage(gymId: 'g1'), height: 1250));
  });
}

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';
import '../safety/safety_actions.dart';
import '../../theme.dart';
import '../../ui/kit.dart';

/// A gym as a prospective member sees it: photos, description, perks, and
/// a way to get in touch. Exactly what the spec lists, and nothing that
/// would only matter to someone who already trains there.
class GymProfilePage extends StatefulWidget {
  const GymProfilePage({super.key, required this.gymId});

  final String gymId;

  @override
  State<GymProfilePage> createState() => _GymProfilePageState();
}

class _GymProfilePageState extends State<GymProfilePage> {
  Map<String, dynamic>? _gym;
  String? _error;

  /// True once the photo header has scrolled under the app bar -- only
  /// then does the bar carry the name, or it would say it twice.
  bool _collapsed = false;
  static const _headerHeight = 360.0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final api = GymApi(context.read<AuthController>().client);
      final gym = await api.publicGym(widget.gymId);
      if (mounted) setState(() => _gym = gym);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  /// Opens the dialer with the gym's number filled in -- the member still
  /// presses call themselves. Copying is only the fallback for a device
  /// with nothing that can dial (a tablet without telephony).
  Future<void> _contact(String phone) async {
    final dialled = await launchUrl(Uri(scheme: 'tel', path: phone))
        .catchError((_) => false);
    if (dialled) return;
    await Clipboard.setData(ClipboardData(text: phone));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).copiedToClipboard(phone)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final gym = _gym;

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: EmptyState(
            icon: Icons.cloud_off_rounded,
            title: t.somethingWentWrongTryAgain,
            message: _error,
          ),
        ),
      );
    }

    if (gym == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final images = ((gym['images'] as List?) ?? const []).cast<String>();
    final perks = ((gym['perks'] as List?) ?? const []).cast<String>();
    final rating = (gym['rating'] as num?)?.toDouble() ?? 0;
    final ratingCount = (gym['ratingCount'] as int?) ?? 0;
    final phone = gym['contactPhone'] as String?;
    final description = gym['description'] as String?;

    // "Gym Name - District": the name is the headline, the district a line.
    final displayName = gym['displayName'] as String? ?? '';
    final split = displayName.split(' - ');
    final name = gym['name'] as String? ?? split.first;
    final district = split.length > 1 ? split.sublist(1).join(' - ') : null;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          final collapsed =
              n.metrics.pixels > _headerHeight - kToolbarHeight - 60;
          if (n.depth == 0 && collapsed != _collapsed) {
            setState(() => _collapsed = collapsed);
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: _headerHeight,
              backgroundColor: ink,
              foregroundColor: const Color(0xFFF5F5F2),
              title: AnimatedOpacity(
                opacity: _collapsed ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Text(name.toUpperCase()),
              ),
              titleTextStyle: theme.appBarTheme.titleTextStyle?.copyWith(
                color: const Color(0xFFF5F5F2),
              ),
              actions: [
                // Reporting lives behind the menu, not on the page: it is
                // for the rare listing that needs it, and a flag beside
                // every gym's name would read as an accusation.
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (_) => showListingReportSheet(
                    context,
                    api: GymApi(context.read<AuthController>().client),
                    kind: ReportedListing.gym,
                    id: widget.gymId,
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'report',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.flag_outlined),
                        title: Text(AppLocalizations.of(context).reportGym),
                      ),
                    ),
                  ],
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: _PhotoHeader(
                  images: images,
                  name: name,
                  district: district,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              sliver: SliverList.list(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          label: t.rating,
                          icon: Icons.star_rounded,
                          accent: ratingCount > 0
                              ? const Color(0xFFFFC53D)
                              : null,
                          value: ratingCount > 0
                              ? rating.toStringAsFixed(1)
                              : '—',
                          unit: ratingCount > 0 ? '($ratingCount)' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatTile(
                          label: t.perks,
                          icon: Icons.card_giftcard_rounded,
                          accent: context.gym.accentText,
                          value: '${perks.length}',
                        ),
                      ),
                    ],
                  ),
                  if (description?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 22),
                    SectionLabel(t.about),
                    Text(
                      description!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.55,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.85,
                        ),
                      ),
                    ),
                  ],
                  if (perks.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    SectionLabel(t.whatYouGet),
                    for (final perk in perks)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: theme.brightness == Brightness.dark
                                    ? volt
                                    : ink,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: theme.brightness == Brightness.dark
                                    ? ink
                                    : volt,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                perk,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                  const SizedBox(height: 18),
                  Text(
                    t.howToJoinGym,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: phone == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton.icon(
                  onPressed: () => _contact(phone),
                  icon: const Icon(Icons.phone_rounded),
                  label: Text(t.contactWithPhone(phone).toUpperCase()),
                ),
              ),
            ),
    );
  }
}

/// Swipeable photos with the gym's name set over the bottom of them.
class _PhotoHeader extends StatefulWidget {
  const _PhotoHeader({
    required this.images,
    required this.name,
    required this.district,
  });

  final List<String> images;
  final String name;
  final String? district;

  @override
  State<_PhotoHeader> createState() => _PhotoHeaderState();
}

class _PhotoHeaderState extends State<_PhotoHeader> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    const onPhoto = Color(0xFFF5F5F2);
    final images = widget.images;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (images.isEmpty)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF26262C), ink],
              ),
            ),
          )
        else
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => Image.network(
              images[i],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(color: ink),
            ),
          ),
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 1.0],
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.95),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 18,
          right: 18,
          bottom: 20,
          child: IgnorePointer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (images.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        for (var i = 0; i < images.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 5),
                            width: i == _page ? 22 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: i == _page
                                  ? volt
                                  : onPhoto.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                      ],
                    ),
                  ),
                Text(
                  widget.name.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: displayFont,
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    height: 0.92,
                    color: onPhoto,
                  ),
                ),
                if (widget.district != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: volt,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.district!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: onPhoto.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

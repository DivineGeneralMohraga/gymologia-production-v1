import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';
import '../../core/utils/dates.dart';

/// Joins and departures over time, grouped by day, month or year.
///
/// The dashboard card answers "how are we doing right now". This answers
/// "are we growing", which needs more than one window to see.
class GrowthPage extends StatefulWidget {
  const GrowthPage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<GrowthPage> createState() => _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {
  static const _units = ['day', 'month', 'year'];
  static const _periods = {'day': 30, 'month': 12, 'year': 5};

  String _unit = 'month';
  Map<String, dynamic>? _data;
  String? _error;
  bool _loading = false;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _api.growth(
        widget.gym.id,
        unit: _unit,
        periods: _periods[_unit]!,
      );
      if (mounted) setState(() => _data = data);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _data;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).growth)),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    FilledButton.tonal(
                        onPressed: _load, child: Text(AppLocalizations.of(context).tryAgain)),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                children: [
                  SegmentedButton<String>(
                    segments: [
                      for (final unit in _units)
                        ButtonSegment(
                          value: unit,
                          label: Text(_unitLabel(
                              AppLocalizations.of(context), unit)),
                        ),
                    ],
                    selected: {_unit},
                    onSelectionChanged: _loading
                        ? null
                        : (selection) {
                            setState(() => _unit = selection.first);
                            _load();
                          },
                  ),
                  const SizedBox(height: 20),
                  if (data == null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 80),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    Row(
                      children: [
                        _Figure(
                          label: AppLocalizations.of(context).joined,
                          value: '${data['totalJoined'] ?? 0}',
                          tone: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 28),
                        _Figure(
                          label: AppLocalizations.of(context).leftCount,
                          value: '${data['totalDeparted'] ?? 0}',
                          tone: theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 28),
                        _Figure(
                          label: AppLocalizations.of(context).net,
                          value: _net(data),
                          tone: _netValue(data) < 0
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _GrowthChart(
                      buckets: _buckets(data),
                      unit: _unit,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context).quietPeriodsNote,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  static String _unitLabel(AppLocalizations t, String unit) =>
      switch (unit) {
        'day' => t.daily,
        'year' => t.yearly,
        _ => t.monthly,
      };

  List<Map<String, dynamic>> _buckets(Map<String, dynamic> data) {
    final raw = data['buckets'];
    if (raw is List) return raw.cast<Map<String, dynamic>>();
    return const [];
  }

  int _netValue(Map<String, dynamic> data) =>
      ((data['totalJoined'] as int?) ?? 0) -
      ((data['totalDeparted'] as int?) ?? 0);

  String _net(Map<String, dynamic> data) {
    final net = _netValue(data);
    return net > 0 ? '+$net' : '$net';
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value, required this.tone});

  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700, color: tone)),
        Text(label,
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 0.8,
              color: theme.colorScheme.onSurfaceVariant,
            )),
      ],
    );
  }
}

/// Paired bars per period: joins up, departures beside them.
///
/// Hand-drawn rather than pulled from a charting package — this is one
/// chart, and a dependency for it would ship a whole plotting library into
/// an app that needs no other.
class _GrowthChart extends StatelessWidget {
  const _GrowthChart({required this.buckets, required this.unit});

  final List<Map<String, dynamic>> buckets;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (buckets.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(
            child: Text(AppLocalizations.of(context).nothingToChartYet)),
      );
    }

    final peak = buckets.fold<int>(
      1,
      (best, b) {
        final joined = (b['joined'] as int?) ?? 0;
        final departed = (b['departed'] as int?) ?? 0;
        final local = joined > departed ? joined : departed;
        return local > best ? local : best;
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Key(
                colour: theme.colorScheme.primary,
                label: AppLocalizations.of(context).joined),
            const SizedBox(width: 16),
            _Key(
              colour: theme.colorScheme.outlineVariant,
              label: AppLocalizations.of(context).leftCount,
            ),
            const Spacer(),
            Text(AppLocalizations.of(context).peakValue(peak),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                )),
          ],
        ),
        const SizedBox(height: 12),
        // Wide ranges scroll rather than squeezing bars to invisibility.
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets)
                  _BucketColumn(
                    bucket: bucket,
                    peak: peak,
                    unit: unit,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BucketColumn extends StatelessWidget {
  const _BucketColumn({
    required this.bucket,
    required this.peak,
    required this.unit,
  });

  final Map<String, dynamic> bucket;
  final int peak;
  final String unit;

  static const _barArea = 150.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final joined = (bucket['joined'] as int?) ?? 0;
    final departed = (bucket['departed'] as int?) ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            joined == 0 && departed == 0 ? '' : '$joined',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Bar(
                height: _height(joined),
                colour: theme.colorScheme.primary,
              ),
              const SizedBox(width: 3),
              _Bar(
                height: _height(departed),
                colour: theme.colorScheme.outlineVariant,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 42,
            child: Text(
              _label(bucket['period'] as String? ?? '', Dates.localeOf(context)),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _height(int value) {
    if (value == 0) return 2; // A visible floor, so empty reads as empty.
    return (value / peak) * _barArea;
  }

  /// The server sends `YYYY-MM-DD` for every unit. Day and year labels are
  /// cut from the string; the month name comes from the locale, so a chart
  /// read in Tamil is labelled in Tamil.
  String _label(String period, String locale) {
    final parts = period.split('-');
    if (parts.length != 3) return period;
    final date = DateTime.tryParse(period);
    return switch (unit) {
      'day' => '${parts[2]}/${parts[1]}',
      'year' => parts[0],
      _ => date == null
          ? period
          : '${Dates.month(date, locale)}\n${parts[0].substring(2)}',
    };
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.colour});

  final double height;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: height,
      decoration: BoxDecoration(
        color: colour,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.colour, required this.label});

  final Color colour;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: colour,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';

/// The member's own progress: measurements over time, and how often they
/// have actually turned up.
///
/// Attendance is the half the member could not see before — every other
/// attendance screen belongs to staff and is permission-gated, which left
/// the person the record is about with no way to read it.
class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key, required this.memberships});

  final List<MyMembership> memberships;

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  MetricsSnapshot? _metrics;
  List<Map<String, dynamic>>? _attendance;
  String? _error;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final results = await Future.wait([
        _api.myMetrics(),
        _api.myAttendance(),
      ]);
      if (!mounted) return;
      setState(() {
        _metrics = results[0] as MetricsSnapshot;
        _attendance = results[1] as List<Map<String, dynamic>>;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metrics = _metrics;
    final attendance = _attendance;

    return Scaffold(
      appBar: AppBar(title: const Text('Your progress')),
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
                        onPressed: _load, child: const Text('Try again')),
                  ],
                ),
              ),
            )
          : metrics == null || attendance == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                    children: [
                      for (final membership in widget.memberships)
                        _GoalCard(membership: membership),
                      const SizedBox(height: 4),
                      _WeightCard(metrics: metrics),
                      const SizedBox(height: 16),
                      for (final gym in attendance)
                        _AttendanceCard(record: gym),
                      if (attendance.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              'Attendance appears here once you are a member '
                              'of a gym and staff start marking you in.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.membership});

  final MyMembership membership;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goal = membership.goal;
    if (goal == null || goal.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('YOUR GOAL AT ${membership.gymName.toUpperCase()}',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.9,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )),
            const SizedBox(height: 6),
            Text(goal, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

/// Weight over time. Height is shown as a figure rather than plotted —
/// an adult's height line is flat, and a flat line reads as broken.
class _WeightCard extends StatelessWidget {
  const _WeightCard({required this.metrics});

  final MetricsSnapshot metrics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // History arrives newest first; a chart reads left to right in time.
    final points = metrics.history
        .where((entry) => entry.weightKg != null)
        .toList()
        .reversed
        .toList();

    final latest = metrics.latest;
    final change = points.length >= 2
        ? points.last.weightKg! - points.first.weightKg!
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weight',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  latest?.weightKg == null
                      ? '—'
                      : '${latest!.weightKg!.toStringAsFixed(1)} kg',
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 12),
                if (change != null && change.abs() >= 0.1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg '
                      'over ${points.length} check-ins',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            if (points.length < 2)
              Text(
                'Two check-ins draw a line. Add your weight each month and '
                'this fills in.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              SizedBox(
                height: 150,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _WeightLinePainter(
                    weights: [for (final p in points) p.weightKg!],
                    line: theme.colorScheme.primary,
                    fill: theme.colorScheme.primary.withValues(alpha: 0.12),
                    grid: theme.colorScheme.outlineVariant,
                  ),
                ),
              ),
            if (latest?.heightCm != null) ...[
              const SizedBox(height: 14),
              Text(
                'Height ${latest!.heightCm!.toStringAsFixed(0)} cm',
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
}

/// A line with a soft fill under it. Drawn by hand rather than pulling in a
/// charting package for one chart.
class _WeightLinePainter extends CustomPainter {
  _WeightLinePainter({
    required this.weights,
    required this.line,
    required this.fill,
    required this.grid,
  });

  final List<double> weights;
  final Color line;
  final Color fill;
  final Color grid;

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.length < 2) return;

    var low = weights.reduce((a, b) => a < b ? a : b);
    var high = weights.reduce((a, b) => a > b ? a : b);
    // A flat series would divide by zero and, worse, draw a line pinned to
    // one edge. Give it breathing room instead.
    if ((high - low).abs() < 0.5) {
      low -= 1;
      high += 1;
    }
    final span = high - low;

    final stepX = size.width / (weights.length - 1);
    double yFor(double weight) =>
        size.height - ((weight - low) / span) * size.height;

    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path()..moveTo(0, yFor(weights.first));
    for (var i = 1; i < weights.length; i++) {
      path.lineTo(stepX * i, yFor(weights[i]));
    }

    final area = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(area, Paint()..color = fill);

    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );

    // The most recent reading gets a dot, because it is the one that matters.
    canvas.drawCircle(
      Offset(size.width, yFor(weights.last)),
      4,
      Paint()..color = line,
    );
  }

  @override
  bool shouldRepaint(_WeightLinePainter old) =>
      old.weights != weights || old.line != line;
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({required this.record});

  final Map<String, dynamic> record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final present = (record['present'] as int?) ?? 0;
    final thisMonth = (record['thisMonth'] as int?) ?? 0;
    final streak = (record['weekStreak'] as int?) ?? 0;
    final perWeek = (record['visitsPerWeek'] as num?)?.toDouble() ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record['gymDisplayName'] as String? ?? 'Your gym',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            Row(
              children: [
                _Stat(label: 'This month', value: '$thisMonth'),
                const SizedBox(width: 26),
                _Stat(label: 'Per week', value: perWeek.toStringAsFixed(1)),
                const SizedBox(width: 26),
                _Stat(
                  label: streak == 1 ? 'Week running' : 'Weeks running',
                  value: '$streak',
                  tone: streak >= 3 ? theme.colorScheme.primary : null,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _Heatmap(days: _days(record)),
            const SizedBox(height: 10),
            Text(
              present == 0
                  ? 'No visits recorded in the last ${record['windowDays']} days.'
                  : '$present visit${present == 1 ? '' : 's'} in the last '
                      '${record['windowDays']} days.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _days(Map<String, dynamic> record) {
    final raw = record['days'];
    if (raw is List) return raw.cast<Map<String, dynamic>>();
    return const [];
  }
}

/// The last eight weeks as a grid, one square a day.
class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.days});

  final List<Map<String, dynamic>> days;

  static const _weeks = 8;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dates arrive as ISO strings; only the calendar day is compared, so the
    // first ten characters are enough and no timezone maths is involved.
    final present = <String>{};
    for (final day in days) {
      if (day['status'] != 'PRESENT') continue;
      final raw = day['date'];
      if (raw is String && raw.length >= 10) present.add(raw.substring(0, 10));
    }

    final today = DateTime.now();
    final columns = <Widget>[];
    for (var week = _weeks - 1; week >= 0; week--) {
      final squares = <Widget>[];
      for (var weekday = 0; weekday < 7; weekday++) {
        final offset = week * 7 + (today.weekday - 1 - weekday);
        final date = today.subtract(Duration(days: offset));
        final future = date.isAfter(today);
        final attended = present.contains(_key(date));
        squares.add(
          Container(
            width: 13,
            height: 13,
            margin: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              color: future
                  ? Colors.transparent
                  : attended
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }
      columns.add(Column(children: squares));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: columns),
        ),
        const SizedBox(height: 6),
        Text('Last 8 weeks',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
      ],
    );
  }

  static String _key(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.tone});

  final String label;
  final String value;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: tone,
            )),
        Text(label,
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 0.6,
              color: theme.colorScheme.onSurfaceVariant,
            )),
      ],
    );
  }
}

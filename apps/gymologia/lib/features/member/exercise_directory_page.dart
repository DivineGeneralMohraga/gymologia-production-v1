import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';

/// The exercise directory.
///
/// Filters are grouped by what a member actually asks: which body part,
/// or which goal. Goal is offered first because "I want to lose weight"
/// is a more common starting point than "I want to train my hamstrings".
class ExerciseDirectoryPage extends StatefulWidget {
  const ExerciseDirectoryPage({super.key, this.initialGoal});

  /// Pre-selected from the member's own stated goal where one exists.
  final String? initialGoal;

  @override
  State<ExerciseDirectoryPage> createState() => _ExerciseDirectoryPageState();
}

class _ExerciseDirectoryPageState extends State<ExerciseDirectoryPage> {
  List<Map<String, dynamic>>? _exercises;
  Map<String, dynamic>? _filters;
  String? _error;

  String? _goal;
  String? _muscle;
  String? _discipline;
  final _search = TextEditingController();

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _goal = widget.initialGoal;
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final filters = _filters ?? await _api.exerciseFilters();
      final exercises = await _api.exercises(
        goal: _goal,
        muscle: _muscle,
        discipline: _discipline,
        query: _search.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _filters = filters;
        _exercises = exercises;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  void _clearFilters() {
    setState(() {
      _goal = null;
      _muscle = null;
      _discipline = null;
      _search.clear();
    });
    _load();
  }

  bool get _anyFilter =>
      _goal != null ||
      _muscle != null ||
      _discipline != null ||
      _search.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exercises = _exercises;
    final filters = _filters;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).exercises),
        actions: [
          if (_anyFilter)
            TextButton(onPressed: _clearFilters, child: Text(AppLocalizations.of(context).clear)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _load(),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).searchExercises,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          if (filters != null)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final g in const [
                    ('MUSCLE_GAIN', 'Build muscle'),
                    ('FAT_LOSS', 'Lose fat'),
                    ('STRENGTH', 'Get stronger'),
                    ('FLEXIBILITY', 'Flexibility'),
                    ('REHAB', 'Rehab'),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(g.$2),
                        selected: _goal == g.$1,
                        onSelected: (on) {
                          setState(() => _goal = on ? g.$1 : null);
                          _load();
                        },
                      ),
                    ),
                ],
              ),
            ),

          if (filters != null)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final d in ((filters['disciplines'] as List?) ?? const [])
                      .cast<Map<String, dynamic>>())
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text('${_pretty(d['value'] as String)} (${d['count']})'),
                        selected: _discipline == d['value'],
                        onSelected: (on) {
                          setState(() =>
                              _discipline = on ? d['value'] as String : null);
                          _load();
                        },
                      ),
                    ),
                ],
              ),
            ),

          const SizedBox(height: 6),
          Expanded(
            child: _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_error!, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          FilledButton.tonal(
                              onPressed: _load, child: Text(AppLocalizations.of(context).tryAgain)),
                        ],
                      ),
                    ),
                  )
                : exercises == null
                    ? const Center(child: CircularProgressIndicator())
                    : exercises.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                AppLocalizations.of(context).nothingMatchesFilters,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 6, 16, 32),
                            itemCount: exercises.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              final e = exercises[i];
                              return Card(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(14),
                                  title: Text(e['name'] as String? ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(e['summary'] as String? ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: [
                                          _Pill(_pretty(e['primaryMuscle'] as String? ?? '')),
                                          _Pill(_pretty(e['difficulty'] as String? ?? '')),
                                          if (e['equipment'] != null)
                                            _Pill(e['equipment'] as String),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => _ExerciseDetailPage(
                                        slug: e['slug'] as String,
                                        api: _api,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseDetailPage extends StatefulWidget {
  const _ExerciseDetailPage({required this.slug, required this.api});

  final String slug;
  final GymApi api;

  @override
  State<_ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<_ExerciseDetailPage> {
  Map<String, dynamic>? _exercise;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final e = await widget.api.exercise(widget.slug);
      if (mounted) setState(() => _exercise = e);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = _exercise;

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error!)),
      );
    }
    if (e == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final steps = ((e['steps'] as List?) ?? const []).cast<String>();
    final cautions = ((e['cautions'] as List?) ?? const []).cast<String>();

    return Scaffold(
      appBar: AppBar(title: Text(e['name'] as String? ?? '')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          Text(e['summary'] as String? ?? '',
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _Pill(_pretty(e['primaryMuscle'] as String? ?? '')),
              _Pill(_pretty(e['discipline'] as String? ?? '')),
              _Pill(_pretty(e['difficulty'] as String? ?? '')),
              if (e['equipment'] != null) _Pill(e['equipment'] as String),
            ],
          ),

          const SizedBox(height: 26),
          Text(AppLocalizations.of(context).howToDoIt.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 0.9,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              )),
          const SizedBox(height: 12),
          // Numbered because these genuinely are a sequence, unlike the
          // pill rows above.
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Text('${i + 1}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onPrimaryContainer,
                        )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(steps[i],
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.45)),
                  ),
                ],
              ),
            ),

          if (cautions.isNotEmpty) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 18, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context).watchOutFor.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.error,
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  for (final c in cautions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('• $c',
                          style: theme.textTheme.bodyMedium?.copyWith(height: 1.45)),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          )),
    );
  }
}

/// MUSCLE_GAIN becomes Muscle gain.
String _pretty(String enumValue) {
  if (enumValue.isEmpty) return '';
  final words = enumValue.toLowerCase().split('_');
  return words[0][0].toUpperCase() + words[0].substring(1) +
      (words.length > 1 ? ' ${words.sublist(1).join(' ')}' : '');
}

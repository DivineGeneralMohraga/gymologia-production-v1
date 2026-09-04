import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';

/// Trainer categories — "General", "Personal", and whatever else a gym runs.
///
/// Every gym starts with the first two, so this screen exists to change them
/// afterwards. The one rule worth surfacing before the tap: a category that
/// still has trainers in it cannot be deleted, because a trainer with no
/// category cannot be assigned to anybody.
class TrainerCategoriesPage extends StatefulWidget {
  const TrainerCategoriesPage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<TrainerCategoriesPage> createState() => _TrainerCategoriesPageState();
}

class _TrainerCategoriesPageState extends State<TrainerCategoriesPage> {
  List<Map<String, dynamic>>? _categories;
  String? _error;
  bool _busy = false;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  bool get _canEdit => widget.gym.can(P.manageTrainers);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final rows = await _api.trainerCategories(widget.gym.id);
      if (mounted) setState(() => _categories = rows);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  /// Runs a change, shows whatever the server says, and never leaves the
  /// screen showing a list the server has already moved past.
  Future<void> _mutate(
    Future<List<Map<String, dynamic>>> Function() action, {
    String? success,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final rows = await action();
      if (!mounted) return;
      setState(() => _categories = rows);
      if (success != null) _say(success);
    } on ApiException catch (e) {
      if (mounted) _say(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _say(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _create() async {
    final t = AppLocalizations.of(context);
    final result = await showModalBottomSheet<({String name, bool multiple})>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _CategorySheet(),
    );
    if (result == null) return;
    await _mutate(
      () => _api.createTrainerCategory(
        widget.gym.id,
        name: result.name,
        allowsMultipleMembers: result.multiple,
      ),
      success: t.addedNamed(result.name),
    );
  }

  Future<void> _rename(Map<String, dynamic> category) async {
    final result = await showModalBottomSheet<({String name, bool multiple})>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CategorySheet(
        initialName: category['name'] as String,
        initialMultiple: category['allowsMultipleMembers'] as bool? ?? true,
      ),
    );
    if (result == null) return;

    setState(() => _busy = true);
    try {
      final updated = await _api.updateTrainerCategory(
        widget.gym.id,
        category['id'] as String,
        name: result.name,
        allowsMultipleMembers: result.multiple,
      );
      if (!mounted) return;
      setState(() => _categories = updated.categories);
      // The server explains when narrowing a category leaves trainers
      // holding more members than the new rule would allow.
      _say(updated.note ?? AppLocalizations.of(context).saved);
    } on ApiException catch (e) {
      if (mounted) _say(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete(Map<String, dynamic> category) async {
    final t = AppLocalizations.of(context);
    final name = category['name'] as String;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteNamed(name)),
        content: Text(
            AppLocalizations.of(context).deleteTrainerCategoryWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppLocalizations.of(context).keepIt),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _mutate(
      () => _api.deleteTrainerCategory(widget.gym.id, category['id'] as String),
      success: t.deletedNamed(name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = _categories;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).trainerCategories)),
      floatingActionButton: _canEdit
          ? FloatingActionButton.extended(
              onPressed: _busy ? null : _create,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context).newCategory),
            )
          : null,
      body: _error != null
          ? _Retry(message: _error!, onRetry: _load)
          : categories == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    children: [
                      Text(
                        _canEdit
                            ? AppLocalizations.of(context)
                                .trainerCategoriesIntro
                            : AppLocalizations.of(context)
                                .trainerCategoriesReadOnly,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final category in categories)
                        _CategoryTile(
                          category: category,
                          canEdit: _canEdit && !_busy,
                          onRename: () => _rename(category),
                          onDelete: () => _delete(category),
                        ),
                      if (categories.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text(AppLocalizations.of(context)
                                .noTrainerCategoriesYet),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.canEdit,
    required this.onRename,
    required this.onDelete,
  });

  final Map<String, dynamic> category;
  final bool canEdit;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trainerCount = category['trainerCount'] as int? ?? 0;
    final canDelete = category['canDelete'] as bool? ?? false;
    final multiple = category['allowsMultipleMembers'] as bool? ?? true;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category['name'] as String,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    multiple
                        ? AppLocalizations.of(context)
                            .oneTrainerManyMembersShort
                        : AppLocalizations.of(context).oneMemberPerTrainer,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    trainerCount == 0
                        ? AppLocalizations.of(context).noTrainers
                        : AppLocalizations.of(context)
                            .trainerCount(trainerCount),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (canEdit)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'rename') onRename();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                      value: 'rename',
                      child: Text(AppLocalizations.of(context).edit)),
                  PopupMenuItem(
                    value: 'delete',
                    // Disabled rather than hidden, so the reason is visible
                    // instead of the option quietly not being there.
                    enabled: canDelete,
                    child: Text(
                      canDelete
                          ? AppLocalizations.of(context).delete
                          : AppLocalizations.of(context)
                              .deleteMoveTrainersFirst,
                      style: TextStyle(
                        color: canDelete
                            ? theme.colorScheme.error
                            : theme.disabledColor,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Create and edit share one sheet: the fields are identical.
class _CategorySheet extends StatefulWidget {
  const _CategorySheet({this.initialName, this.initialMultiple = true});

  final String? initialName;
  final bool initialMultiple;

  @override
  State<_CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends State<_CategorySheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.initialName ?? '');
  late bool _multiple = widget.initialMultiple;
  String? _nameError;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.length < 2) {
      setState(() =>
          _nameError = AppLocalizations.of(context).giveCategoryAName);
      return;
    }
    Navigator.of(context).pop((name: name, multiple: _multiple));
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initialName != null;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            editing
                ? AppLocalizations.of(context).editCategory
                : AppLocalizations.of(context).newTrainerCategory,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).name,
              hintText: AppLocalizations.of(context).categoryNameHint,
              errorText: _nameError,
            ),
            onChanged: (_) {
              if (_nameError != null) setState(() => _nameError = null);
            },
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _multiple,
            onChanged: (value) => setState(() => _multiple = value),
            title: Text(AppLocalizations.of(context).oneTrainerManyMembers),
            subtitle: Text(
              _multiple
                  ? AppLocalizations.of(context).generalTrainingNote
                  : AppLocalizations.of(context).personalTrainingNote,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: Text(editing
                  ? AppLocalizations.of(context).save
                  : AppLocalizations.of(context).addCategory),
            ),
          ),
        ],
      ),
    );
  }
}

class _Retry extends StatelessWidget {
  const _Retry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 18),
            FilledButton.tonal(onPressed: onRetry, child: Text(AppLocalizations.of(context).tryAgain)),
          ],
        ),
      ),
    );
  }
}

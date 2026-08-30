import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';

/// Starting a conversation.
///
/// Everyone at the gym is listed, including people you may not message —
/// shown greyed with the reason rather than hidden. Hiding the owner would
/// leave a member wondering where they went; saying "only managers can
/// start a conversation with the owner" answers the question.
class NewChatSheet extends StatefulWidget {
  const NewChatSheet({super.key, required this.gymId, required this.api});

  final String gymId;
  final GymApi api;

  @override
  State<NewChatSheet> createState() => _NewChatSheetState();
}

class _NewChatSheetState extends State<NewChatSheet> {
  List<Map<String, dynamic>>? _people;
  String? _error;
  final _search = TextEditingController();
  final Set<String> _selected = {};
  bool _groupMode = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final people = await widget.api.chatDirectory(widget.gymId);
      if (mounted) setState(() => _people = people);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _openDirect(Map<String, dynamic> person) async {
    setState(() => _busy = true);
    try {
      final conversation = await widget.api.openDirect(
        widget.gymId,
        person['userId'] as String,
      );
      if (mounted) Navigator.of(context).pop(conversation['id'] as String?);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _createGroup() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _GroupNameDialog(),
    );
    if (name == null || name.isEmpty) return;

    setState(() => _busy = true);
    try {
      final group = await widget.api.createGroup(
        widget.gymId,
        name: name,
        userIds: _selected.toList(),
      );
      if (mounted) Navigator.of(context).pop(group['id'] as String?);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final all = _people;
    final query = _search.text.trim().toLowerCase();
    final people = all
        ?.where((p) =>
            query.isEmpty ||
            (p['name'] as String? ?? '').toLowerCase().contains(query))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      builder: (_, controller) => Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _groupMode
                        ? 'New group (${_selected.length} selected)'
                        : 'New message',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() {
                    _groupMode = !_groupMode;
                    _selected.clear();
                  }),
                  icon: Icon(_groupMode ? Icons.person : Icons.groups, size: 18),
                  label: Text(_groupMode ? 'One to one' : 'Group'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Search people',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(_error!, textAlign: TextAlign.center),
                    ),
                  )
                : people == null
                    ? const Center(child: CircularProgressIndicator())
                    : people.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'Nobody else here yet.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: controller,
                            itemCount: people.length,
                            itemBuilder: (_, i) {
                              final p = people[i];
                              final canMessage = p['canMessage'] == true;
                              final id = p['userId'] as String;

                              return ListTile(
                                enabled: canMessage && !_busy,
                                leading: CircleAvatar(
                                  child: Text((p['name'] as String? ?? '?')
                                      .characters
                                      .first
                                      .toUpperCase()),
                                ),
                                title: Text(p['name'] as String? ?? ''),
                                subtitle: Text(
                                  canMessage
                                      ? p['role'] as String? ?? ''
                                      : p['reason'] as String? ?? '',
                                  style: canMessage
                                      ? null
                                      : theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.error,
                                        ),
                                ),
                                trailing: !canMessage
                                    ? Icon(Icons.lock_outline,
                                        size: 16,
                                        color: theme.colorScheme.outline)
                                    : _groupMode
                                        ? Checkbox(
                                            value: _selected.contains(id),
                                            onChanged: (on) => setState(() {
                                              if (on == true) {
                                                _selected.add(id);
                                              } else {
                                                _selected.remove(id);
                                              }
                                            }),
                                          )
                                        : const Icon(Icons.chevron_right),
                                onTap: !canMessage
                                    ? null
                                    : _groupMode
                                        ? () => setState(() {
                                              if (_selected.contains(id)) {
                                                _selected.remove(id);
                                              } else {
                                                _selected.add(id);
                                              }
                                            })
                                        : () => _openDirect(p),
                              );
                            },
                          ),
          ),
          if (_groupMode)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed:
                        _selected.isEmpty || _busy ? null : _createGroup,
                    child: Text(_selected.isEmpty
                        ? 'Pick who is in the group'
                        : 'Create group with ${_selected.length}'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GroupNameDialog extends StatefulWidget {
  const _GroupNameDialog();

  @override
  State<_GroupNameDialog> createState() => _GroupNameDialogState();
}

class _GroupNameDialogState extends State<_GroupNameDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Name the group'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 120,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          hintText: 'Saturday morning crew',
          counterText: '',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: const Text('Create'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';
import 'chat_page.dart';
import 'new_chat_sheet.dart';

/// Conversations at one gym.
///
/// The two standing groups sit at the top because they are the ones
/// everybody has, and the server already returns them in that order.
class ConversationsPage extends StatefulWidget {
  const ConversationsPage({
    super.key,
    required this.gymId,
    required this.gymName,
  });

  final String gymId;
  final String gymName;

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  List<Map<String, dynamic>>? _conversations;
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
      final rows = await _api.conversations(widget.gymId);
      if (mounted) setState(() => _conversations = rows);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _newChat() async {
    final conversationId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => NewChatSheet(gymId: widget.gymId, api: _api),
    );
    if (conversationId == null || !mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatPage(
          gymId: widget.gymId,
          conversationId: conversationId,
          title: 'Chat',
        ),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conversations = _conversations;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chat', style: TextStyle(fontSize: 17)),
            Text(
              widget.gymName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newChat,
        child: const Icon(Icons.edit_outlined),
      ),
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
          : conversations == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 96),
                    itemCount: conversations.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final c = conversations[i];
                      final last = c['lastMessage'] as Map<String, dynamic>?;
                      final unread = (c['unread'] as int?) ?? 0;
                      final type = c['type'] as String? ?? 'DIRECT';

                      return ListTile(
                        leading: _Avatar(type: type, name: c['name'] as String? ?? ''),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                c['name'] as String? ?? '',
                                style: TextStyle(
                                  fontWeight: unread > 0
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (last != null)
                              Text(
                                _ago(last['at']),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            last == null
                                ? _emptyLine(type)
                                : '${last['fromMe'] == true ? 'You: ' : ''}${last['preview']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: last == null
                                  ? theme.colorScheme.outline
                                  : theme.colorScheme.onSurfaceVariant,
                              fontStyle:
                                  last == null ? FontStyle.italic : null,
                            ),
                          ),
                        ),
                        trailing: unread > 0
                            ? Badge(label: Text('$unread'))
                            : null,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatPage(
                                gymId: widget.gymId,
                                conversationId: c['id'] as String,
                                title: c['name'] as String? ?? 'Chat',
                              ),
                            ),
                          );
                          await _load();
                        },
                      );
                    },
                  ),
                ),
    );
  }
}

String _emptyLine(String type) => switch (type) {
      'OFFICIAL_GROUP' => 'Everyone at this gym. Nothing said yet.',
      'UNOFFICIAL_GROUP' => 'Members only. Nothing said yet.',
      _ => 'No messages yet',
    };

class _Avatar extends StatelessWidget {
  const _Avatar({required this.type, required this.name});
  final String type;
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGroup = type != 'DIRECT';

    return CircleAvatar(
      backgroundColor: isGroup
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      child: isGroup
          ? Icon(
              type == 'OFFICIAL_GROUP' ? Icons.campaign_outlined : Icons.groups_outlined,
              size: 20,
              color: theme.colorScheme.onPrimaryContainer,
            )
          : Text(name.isEmpty ? '?' : name.characters.first.toUpperCase()),
    );
  }
}

String _ago(dynamic iso) {
  final d = iso is String ? DateTime.tryParse(iso) : null;
  if (d == null) return '';
  final diff = DateTime.now().difference(d);
  if (diff.inMinutes < 1) return 'now';
  if (diff.inHours < 1) return '${diff.inMinutes}m';
  if (diff.inDays < 1) return '${diff.inHours}h';
  if (diff.inDays < 7) return '${diff.inDays}d';
  return '${(diff.inDays / 7).floor()}w';
}

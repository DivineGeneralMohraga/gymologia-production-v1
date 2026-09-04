import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';

/// One conversation.
///
/// Messages are polled rather than pushed. The backend has a websocket
/// gateway, but wiring a socket client through the app's auth and
/// lifecycle is its own piece of work — polling every few seconds while
/// the screen is open is honest, costs little, and the REST history is the
/// source of truth either way.
class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.gymId,
    required this.conversationId,
    required this.title,
  });

  final String gymId;
  final String conversationId;
  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  List<Map<String, dynamic>>? _messages;
  String? _error;
  bool _sending = false;
  bool _disposed = false;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load(scrollToEnd: true);
    _poll();
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Refreshes while the screen is open. Stops the moment it is not.
  Future<void> _poll() async {
    while (!_disposed) {
      await Future<void>.delayed(const Duration(seconds: 5));
      if (_disposed || !mounted) return;
      await _load();
    }
  }

  Future<void> _load({bool scrollToEnd = false}) async {
    try {
      final messages = await _api.messages(widget.gymId, widget.conversationId);
      if (!mounted) return;

      final grew = _messages == null || messages.length > _messages!.length;
      setState(() {
        _messages = messages;
        _error = null;
      });
      if (scrollToEnd || grew) _scrollToEnd();
    } on ApiException catch (e) {
      if (mounted && _messages == null) setState(() => _error = e.message);
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final body = _controller.text.trim();
    if (body.isEmpty || _sending) return;

    setState(() => _sending = true);
    _controller.clear();

    try {
      final sent = await _api.sendMessage(
        widget.gymId,
        widget.conversationId,
        body,
      );
      if (!mounted) return;
      setState(() {
        _messages = [...?_messages, sent];
        _sending = false;
      });
      _scrollToEnd();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      // Put the text back rather than losing what they typed.
      _controller.text = body;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messages = _messages;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Text(_error!, textAlign: TextAlign.center),
                    ),
                  )
                : messages == null
                    ? const Center(child: CircularProgressIndicator())
                    : messages.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                AppLocalizations.of(context)
                                    .nothingHereYetSaySomething,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scroll,
                            padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                            itemCount: messages.length,
                            itemBuilder: (_, i) {
                              final m = messages[i];
                              final prev = i > 0 ? messages[i - 1] : null;
                              // Only label the sender when it changes, so a
                              // run of messages from one person reads as one
                              // block rather than a stack of name tags.
                              final showSender = m['fromMe'] != true &&
                                  (prev == null ||
                                      (prev['sender']
                                              as Map<String, dynamic>?)?['id'] !=
                                          (m['sender']
                                              as Map<String, dynamic>?)?['id']);
                              return _Bubble(message: m, showSender: showSender);
                            },
                          ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 5,
                      maxLength: 4000,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).message,
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2.2),
                          )
                        : const Icon(Icons.send, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.showSender});

  final Map<String, dynamic> message;
  final bool showSender;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mine = message['fromMe'] == true;
    final sender = message['sender'] as Map<String, dynamic>?;

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment:
              mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (showSender)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 2, top: 6),
                child: Text(
                  sender?['name'] as String? ?? '',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: mine
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(mine ? 16 : 4),
                  bottomRight: Radius.circular(mine ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['body'] as String? ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: mine ? theme.colorScheme.onPrimary : null,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _time(message['createdAt']),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: mine
                          ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _time(dynamic iso) {
  final d = iso is String ? DateTime.tryParse(iso)?.toLocal() : null;
  if (d == null) return '';
  return '${d.hour.toString().padLeft(2, '0')}:'
      '${d.minute.toString().padLeft(2, '0')}';
}

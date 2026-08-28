import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';
import 'add_person_sheet.dart';

/// The member list, with attendance marking inline.
///
/// Marking attendance is the single most repeated action in a gym — it
/// happens dozens of times a day at the front desk — so it is a tap on the
/// row rather than a screen someone has to navigate into.
class MembersPage extends StatefulWidget {
  const MembersPage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final _search = TextEditingController();
  List<MemberRow>? _members;
  final Set<String> _markedToday = {};
  final Set<String> _marking = {};
  String? _error;

  GymApi get _api => GymApi(context.read<AuthController>().client);

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
    setState(() => _error = null);
    try {
      final result = await _api.members(widget.gym.id, query: _search.text.trim());
      if (!mounted) return;
      setState(() => _members = result.items);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _mark(MemberRow member) async {
    setState(() => _marking.add(member.membershipId));
    try {
      await _api.markAttendance(
        gymId: widget.gym.id,
        subjectType: 'MEMBER',
        subjectId: member.membershipId,
      );
      if (!mounted) return;
      setState(() {
        _markedToday.add(member.membershipId);
        _marking.remove(member.membershipId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${member.name} marked present')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _marking.remove(member.membershipId));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _add() async {
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddPersonSheet(gym: widget.gym, mode: AddMode.member),
    );
    if (added == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final members = _members;
    final canMark = widget.gym.can(P.markAttendanceMember);

    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      floatingActionButton: widget.gym.can(P.addMember)
          ? FloatingActionButton.extended(
              onPressed: _add,
              icon: const Icon(Icons.person_add_alt),
              label: const Text('Add member'),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _load(),
              decoration: const InputDecoration(
                hintText: 'Search by name or number',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          if (canMark)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.touch_app_outlined,
                      size: 15, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text('Tap a member to mark them present today',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      )),
                ],
              ),
            ),
          Expanded(
            child: _error != null
                ? Center(child: Text(_error!))
                : members == null
                    ? const Center(child: CircularProgressIndicator())
                    : members.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                _search.text.isEmpty
                                    ? 'No members yet. Add your first one.'
                                    : 'Nobody matched that search.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _load,
                            child: ListView.separated(
                              padding: const EdgeInsets.only(bottom: 96),
                              itemCount: members.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final m = members[i];
                                final marked = _markedToday.contains(m.membershipId);
                                final busy = _marking.contains(m.membershipId);

                                return ListTile(
                                  onTap: canMark && !marked && !busy
                                      ? () => _mark(m)
                                      : null,
                                  leading: CircleAvatar(
                                    backgroundColor: marked
                                        ? Colors.green.withValues(alpha: 0.18)
                                        : theme.colorScheme.surfaceContainerHighest,
                                    child: busy
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2.2),
                                          )
                                        : marked
                                            ? const Icon(Icons.check,
                                                color: Colors.green, size: 20)
                                            : Text(m.name.isEmpty
                                                ? '?'
                                                : m.name.characters.first
                                                    .toUpperCase()),
                                  ),
                                  title: Text(m.name),
                                  subtitle: Text(
                                    [
                                      m.phone,
                                      if (m.trainerName != null)
                                        'Trainer: ${m.trainerName}',
                                    ].join('  ·  '),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: _DaysBadge(member: m),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _DaysBadge extends StatelessWidget {
  const _DaysBadge({required this.member});
  final MemberRow member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color) = member.expired
        ? ('Expired', theme.colorScheme.error)
        : member.expiringSoon
            ? ('${member.daysRemaining}d left', theme.colorScheme.error)
            : ('${member.daysRemaining}d', theme.colorScheme.onSurfaceVariant);

    return Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: color,
        fontWeight: member.expiringSoon || member.expired
            ? FontWeight.w700
            : FontWeight.w400,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';
import 'add_person_sheet.dart';
import 'attendance_history_page.dart';
import 'staff_detail_sheet.dart';
import '../../theme.dart';

/// The staff list, ordered by seniority.
///
/// Rows the viewer cannot act on are shown but locked rather than hidden —
/// a colleague vanishing from the list would be more confusing than seeing
/// them and understanding why they are out of reach.
class StaffPage extends StatefulWidget {
  const StaffPage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  List<StaffRow>? _staff;
  String? _error;
  final Set<String> _markedToday = {};
  final Set<String> _marking = {};

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final staff = await _api.staff(widget.gym.id);
      if (mounted) setState(() => _staff = staff);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _mark(StaffRow staff) async {
    setState(() => _marking.add(staff.userId));
    try {
      await _api.markAttendance(
        gymId: widget.gym.id,
        subjectType: 'STAFF',
        subjectId: staff.userId,
      );
      if (!mounted) return;
      setState(() {
        _markedToday.add(staff.userId);
        _marking.remove(staff.userId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).markedPresent(staff.name)),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _marking.remove(staff.userId));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _edit(StaffRow staff) async {
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => StaffDetailSheet(gym: widget.gym, staff: staff),
    );
    if (changed == true) await _load();
  }

  Future<void> _add() async {
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddPersonSheet(gym: widget.gym, mode: AddMode.staff),
    );
    if (added == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final staff = _staff;
    final canMark = widget.gym.can(P.markAttendanceStaff);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).staff)),
      floatingActionButton: widget.gym.can(P.addStaff)
          ? FloatingActionButton.extended(
              onPressed: _add,
              icon: const Icon(Icons.person_add_alt),
              label: Text(AppLocalizations.of(context).addStaff),
            )
          : null,
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : staff == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: Column(
                children: [
                  if (canMark)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.touch_app_outlined,
                            size: 15,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            AppLocalizations.of(context).tapCircleToMarkPresent,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 96),
                      itemCount: staff.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final s = staff[i];
                        final trainerDetail = s.isTrainer
                            ? '${s.trainerCategoryName ?? 'Trainer'} · '
                                  '${s.assignedMemberCount} member'
                                  '${s.assignedMemberCount == 1 ? '' : 's'}'
                            : null;
                        final canMarkThis = canMark && s.canManage && !s.isSelf;
                        final marked = _markedToday.contains(s.userId);
                        final busy = _marking.contains(s.userId);

                        return ListTile(
                          leading: _StaffMarkAvatar(
                            name: s.name,
                            marked: marked,
                            busy: busy,
                            onMark: canMarkThis && !marked && !busy
                                ? () => _mark(s)
                                : null,
                          ),
                          title: Row(
                            children: [
                              Flexible(child: Text(s.name)),
                              if (s.isSelf) ...[
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context).youLabel,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            [
                              s.roleName,
                              if (trainerDetail != null) trainerDetail,
                            ].join('  ·  '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: s.canManage
                              ? const Icon(Icons.chevron_right)
                              : Icon(
                                  Icons.lock_outline,
                                  size: 15,
                                  color: theme.colorScheme.outline,
                                ),
                          onTap: s.canManage ? () => _edit(s) : null,
                          onLongPress:
                              widget.gym.can(P.viewAttendanceStaff) &&
                                  s.canManage
                              ? () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AttendanceHistoryPage(
                                      gym: widget.gym,
                                      subjectType: 'STAFF',
                                      userId: s.userId,
                                      name: s.name,
                                    ),
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// The avatar doubles as the mark-present button — same pattern as
/// MembersPage's _MarkAvatar, kept local because it is small and each
/// screen's row shape (member vs. staff) differs enough that sharing it
/// would need more parameters than it would save lines.
class _StaffMarkAvatar extends StatelessWidget {
  const _StaffMarkAvatar({
    required this.name,
    required this.marked,
    required this.busy,
    required this.onMark,
  });

  final String name;
  final bool marked;
  final bool busy;
  final VoidCallback? onMark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onMark,
      customBorder: const CircleBorder(),
      child: CircleAvatar(
        backgroundColor: marked
            ? context.gym.success.withValues(alpha: 0.18)
            : theme.colorScheme.surfaceContainerHighest,
        child: busy
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              )
            : marked
            ? Icon(Icons.check_rounded, color: context.gym.success, size: 20)
            : Text(name.isEmpty ? '?' : name.characters.first.toUpperCase()),
      ),
    );
  }
}

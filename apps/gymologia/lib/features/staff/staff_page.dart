import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';
import 'add_person_sheet.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Staff')),
      floatingActionButton: widget.gym.can(P.addStaff)
          ? FloatingActionButton.extended(
              onPressed: _add,
              icon: const Icon(Icons.person_add_alt),
              label: const Text('Add staff'),
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

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          child: Text(s.name.isEmpty
                              ? '?'
                              : s.name.characters.first.toUpperCase()),
                        ),
                        title: Row(
                          children: [
                            Flexible(child: Text(s.name)),
                            if (s.isSelf) ...[
                              const SizedBox(width: 8),
                              Text(
                                'you',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: theme.colorScheme.primary),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Text(
                          [s.roleName, if (trainerDetail != null) trainerDetail]
                              .join('  ·  '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: s.canManage
                            ? const Icon(Icons.chevron_right)
                            : Icon(Icons.lock_outline,
                                size: 15, color: theme.colorScheme.outline),
                        onTap: s.canManage
                            ? () => ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Editing staff is not built yet.'),
                                  ),
                                )
                            : null,
                      );
                    },
                  ),
                ),
    );
  }
}

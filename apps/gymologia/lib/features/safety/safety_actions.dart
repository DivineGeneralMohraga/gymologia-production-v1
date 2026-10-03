import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';

/// Getting away from somebody, from wherever you are looking at them.
///
/// These are functions rather than a screen because the place a person
/// needs them is the place they are being bothered — holding a message,
/// or the menu of the conversation itself — not a settings page they have
/// to go and find while it is still happening.
///
/// Two things this file is careful about:
///
/// * A block is silent. Nothing here ever tells the other person, and the
///   copy says so, because somebody deciding whether to block is usually
///   weighing exactly that risk.
/// * A report is not a block. The sheet says it plainly and offers to do
///   both, because "I reported them and nothing happened" is almost always
///   somebody who expected the report to stop it.

/// The server's `ReportCategory` enum, in the order a person is offered it.
///
/// Top-level, and not a private field of the sheet, so a test can hold it
/// against the enum in `backend/prisma/schema.prisma`. A typo in one of
/// these strings is invisible until somebody in the middle of reporting
/// harassment gets a validation error, which is the worst possible moment
/// to discover it.
///
/// Harassment leads because it is what most reports are, and a list whose
/// first item is usually the right one is a list people finish.
const reportCategoryValues = <String>[
  'HARASSMENT',
  'SPAM',
  'SEXUAL_CONTENT',
  'HATE_SPEECH',
  'VIOLENCE_OR_THREAT',
  'SCAM_OR_FRAUD',
  'IMPERSONATION',
  'FAKE_LISTING',
  'MISLEADING',
  'OTHER',
];

/// Categories that only make sense for a gym or an event, not a person.
const listingOnlyCategories = <String>{'FAKE_LISTING', 'MISLEADING'};

/// What the report sheet for a person offers.
final personReportCategories = [
  for (final v in reportCategoryValues)
    if (!listingOnlyCategories.contains(v)) v,
];

/// What the report sheet for a gym or event offers, most likely first:
/// an offensive name or photo, then a listing that is not real.
const listingReportCategories = <String>[
  'SEXUAL_CONTENT',
  'HATE_SPEECH',
  'FAKE_LISTING',
  'MISLEADING',
  'SCAM_OR_FRAUD',
  'IMPERSONATION',
  'SPAM',
  'OTHER',
];

/// Wording a person would recognise, for one of [reportCategoryValues].
String reportCategoryLabel(AppLocalizations t, String value) => switch (value) {
      'HARASSMENT' => t.reportCategoryHarassment,
      'SPAM' => t.reportCategorySpam,
      'SEXUAL_CONTENT' => t.reportCategorySexual,
      'HATE_SPEECH' => t.reportCategoryHate,
      'VIOLENCE_OR_THREAT' => t.reportCategoryViolence,
      'SCAM_OR_FRAUD' => t.reportCategoryScam,
      'IMPERSONATION' => t.reportCategoryImpersonation,
      'FAKE_LISTING' => t.reportCategoryFakeListing,
      'MISLEADING' => t.reportCategoryMisleading,
      _ => t.reportCategoryOther,
    };

/// What a listing report is about.
enum ReportedListing { gym, event }

/// The report form for a gym or an event. Category required, words
/// optional: the listing is public, so the reviewer sees what the reporter
/// saw. True when a report was filed.
Future<bool> showListingReportSheet(
  BuildContext context, {
  required GymApi api,
  required ReportedListing kind,
  required String id,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
      ),
      child: _ListingReportSheet(api: api, kind: kind, id: id),
    ),
  );
  return result ?? false;
}

class _ListingReportSheet extends StatefulWidget {
  const _ListingReportSheet({
    required this.api,
    required this.kind,
    required this.id,
  });

  final GymApi api;
  final ReportedListing kind;
  final String id;

  @override
  State<_ListingReportSheet> createState() => _ListingReportSheetState();
}

class _ListingReportSheetState extends State<_ListingReportSheet> {
  final _details = TextEditingController();
  String? _category;
  bool _sending = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final t = AppLocalizations.of(context);
    final category = _category;
    if (category == null || _sending) return;

    setState(() => _sending = true);
    try {
      final details = _details.text.trim();
      final res = widget.kind == ReportedListing.gym
          ? await widget.api.reportGym(widget.id,
              category: category, details: details)
          : await widget.api.reportEvent(widget.id,
              category: category, details: details);
      if (!mounted) return;
      Navigator.of(context).pop(true);
      // A repeat report gets the server's "already reported" wording.
      final repeat = res['id'] == null && res['message'] is String;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(repeat ? res['message'] as String : t.reportListingSent),
      ));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.kind == ReportedListing.gym ? t.reportGym : t.reportEvent,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 18),
            Text(t.whyReporting, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final value in listingReportCategories)
                  ChoiceChip(
                    label: Text(reportCategoryLabel(t, value)),
                    selected: _category == value,
                    onSelected: (_) => setState(() => _category = value),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(t.reportDetailsOptional, style: theme.textTheme.labelLarge),
            const SizedBox(height: 6),
            Text(
              t.reportListingDetailsHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _details,
              minLines: 2,
              maxLines: 5,
              maxLength: 2000,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _category != null && !_sending ? _send : null,
                child: _sending
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      )
                    : Text(t.sendReport),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The menu shown when a person is held down on, or picked from a chat
/// header. Returns true when the caller should refresh — a block changes
/// what the screen is allowed to show.
Future<bool> showPersonSafetySheet(
  BuildContext context, {
  required GymApi api,
  required String userId,
  required String name,
  String? messageId,
  String? conversationId,
  String? gymId,
}) async {
  final t = AppLocalizations.of(context);

  final action = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            title: Text(
              name,
              style: Theme.of(sheetContext).textTheme.titleSmall,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: Text(t.reportPerson(name)),
            onTap: () => Navigator.of(sheetContext).pop('report'),
          ),
          ListTile(
            leading: Icon(
              Icons.block,
              color: Theme.of(sheetContext).colorScheme.error,
            ),
            title: Text(
              t.blockPerson(name),
              style: TextStyle(
                color: Theme.of(sheetContext).colorScheme.error,
              ),
            ),
            onTap: () => Navigator.of(sheetContext).pop('block'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );

  if (action == null || !context.mounted) return false;

  if (action == 'block') {
    return confirmAndBlock(context, api: api, userId: userId, name: name);
  }

  return showReportSheet(
    context,
    api: api,
    userId: userId,
    name: name,
    messageId: messageId,
    conversationId: conversationId,
    gymId: gymId,
  );
}

/// Confirms, then blocks. True when the block went through.
Future<bool> confirmAndBlock(
  BuildContext context, {
  required GymApi api,
  required String userId,
  required String name,
}) async {
  final t = AppLocalizations.of(context);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(t.blockPerson(name)),
      // Three facts, in the order they matter: they cannot reach you, they
      // are not told, and you can undo it. The third is what makes the
      // decision easy to make while something is happening.
      content: Text(t.blockConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(t.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(dialogContext).colorScheme.error,
          ),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(t.block),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return false;

  try {
    await api.blockUser(userId);
    if (!context.mounted) return true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${t.blocked}: $name')),
    );
    return true;
  } on ApiException catch (e) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.message)));
    return false;
  }
}

/// The report form. True when a report was filed, or a block was made from
/// inside it — either way the screen underneath may need to reload.
Future<bool> showReportSheet(
  BuildContext context, {
  required GymApi api,
  required String userId,
  required String name,
  String? messageId,
  String? conversationId,
  String? gymId,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => Padding(
      // The keyboard covers the send button otherwise, on a sheet whose
      // whole point is a paragraph of typing.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
      ),
      child: _ReportSheet(
        api: api,
        userId: userId,
        name: name,
        messageId: messageId,
        conversationId: conversationId,
        gymId: gymId,
      ),
    ),
  );
  return result ?? false;
}

class _ReportSheet extends StatefulWidget {
  const _ReportSheet({
    required this.api,
    required this.userId,
    required this.name,
    this.messageId,
    this.conversationId,
    this.gymId,
  });

  final GymApi api;
  final String userId;
  final String name;
  final String? messageId;
  final String? conversationId;
  final String? gymId;

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  final _details = TextEditingController();
  String? _category;
  bool _alsoBlock = true;
  bool _sending = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final t = AppLocalizations.of(context);
    final category = _category;
    final details = _details.text.trim();
    if (category == null || details.length < 10 || _sending) return;

    setState(() => _sending = true);
    try {
      await widget.api.reportUser(
        reportedUserId: widget.userId,
        category: category,
        details: details,
        messageId: widget.messageId,
        conversationId: widget.conversationId,
        gymId: widget.gymId,
      );

      // The block goes second and its failure is not fatal: the report is
      // filed either way, and losing it because a second call failed would
      // be the worse outcome of the two.
      if (_alsoBlock) {
        try {
          await widget.api.blockUser(widget.userId);
        } on ApiException {
          // Nothing to say here. The report landed, and Settings still
          // offers the block.
        }
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.reportSent)));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ready = _category != null && _details.text.trim().length >= 10;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.reportPerson(widget.name),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 18),

            Text(t.whyReporting, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final value in personReportCategories)
                  ChoiceChip(
                    label: Text(reportCategoryLabel(t, value)),
                    selected: _category == value,
                    onSelected: (_) => setState(() => _category = value),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            Text(t.reportDetails, style: theme.textTheme.labelLarge),
            const SizedBox(height: 6),
            // Said before they type rather than as an error afterwards.
            // Somebody who writes "see the message" and is then told the
            // message cannot be read has been wasted twice.
            Text(
              t.reportDetailsHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _details,
              minLines: 3,
              maxLines: 6,
              maxLength: 2000,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 4),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _alsoBlock,
              onChanged: (v) => setState(() => _alsoBlock = v ?? false),
              title: Text(t.alsoBlockThem),
              // On by default. Somebody far enough along to be filling in
              // this form usually wants it to stop now, not after review.
              subtitle: Text(
                t.alsoBlockThemExplainer,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: ready && !_sending ? _send : null,
                child: _sending
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      )
                    : Text(t.sendReport),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

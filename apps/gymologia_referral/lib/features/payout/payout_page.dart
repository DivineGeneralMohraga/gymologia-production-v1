import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/validation.dart';
import '../../core/api/error_text.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';
import '../referral/referral_controller.dart';

/// Where the money goes: a UPI ID, a name to check it against, and a PAN.
///
/// The client checks the shape of both before sending, and the server
/// checks them again — the client copy exists to answer instantly, not to
/// be trusted. Neither is the real defence, because the real risk here is
/// not a malformed address, it is a well-formed one belonging to somebody
/// else. `sarthaq@okhdfcbank` passes every check ever written and the money
/// does not come back. That is what the warning on this screen is for, and
/// why the ₹10 name check exists at all.
class PayoutPage extends StatelessWidget {
  const PayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final referral = context.watch<ReferralController>();

    if (referral.account == null) {
      if (referral.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(referral.failureText(context, t.genericError), textAlign: TextAlign.center),
            const SizedBox(height: 14),
            FilledButton(
                onPressed: () => referral.load(), child: Text(t.tryAgain)),
          ]),
        ),
      );
    }

    final payout = referral.payout;
    final stillNeeded = referral.stillNeeded;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // Said first, and said by the server. Rewards are being earned and
        // none of them can move yet; a screen that collected an address
        // without saying so would be implying otherwise.
        Card(
          color: theme.colorScheme.tertiaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline,
                    size: 20, color: theme.colorScheme.onTertiaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.payoutsNotLive,
                    style: TextStyle(
                        color: theme.colorScheme.onTertiaryContainer),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (stillNeeded.isNotEmpty) ...[
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.stillNeededTitle,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // The server's own sentences, not re-derived here. It is
                  // the thing that will refuse the payout, so it is the
                  // thing that gets to say what is missing.
                  for (final line in stillNeeded)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('•  '),
                          Expanded(child: Text(line)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        _UpiCard(payout: payout),
        const SizedBox(height: 14),
        _PanCard(payout: payout),
      ],
    );
  }
}

class _UpiCard extends StatefulWidget {
  const _UpiCard({required this.payout});

  final Map<String, dynamic> payout;

  @override
  State<_UpiCard> createState() => _UpiCardState();
}

class _UpiCardState extends State<_UpiCard> {
  final _upi = TextEditingController();
  final _holder = TextEditingController();
  bool _editing = false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _holder.text = '${widget.payout['upiHolderName'] ?? ''}';
  }

  @override
  void dispose() {
    _upi.dispose();
    _holder.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    // Normalised the same way the server does before it is checked, so
    // the client and the server are judging the same string.
    final upi = normaliseVpa(_upi.text);
    final holder = normaliseHolderName(_holder.text);

    if (!looksLikeUpiId(upi)) {
      setState(() => _error = t.invalidUpi);
      return;
    }
    if (holder.length < 2) {
      setState(() => _error = t.holderNameRequired);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    final referral = context.read<ReferralController>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final updated = await context
          .read<AuthController>()
          .api
          .setPayoutMethod(upiId: upi, holderName: holder);
      referral.adoptPayout(updated);
      if (!mounted) return;
      setState(() {
        _editing = false;
        _upi.clear();
      });
      messenger.showSnackBar(SnackBar(content: Text(t.saved)));
    } on ApiException catch (e) {
      // Includes the 409 for a payout already in flight, which this app
      // has in all ten languages and answers by code.
      if (mounted) setState(() => _error = apiErrorText(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final masked = widget.payout['upiIdMasked'] as String?;
    final verified = widget.payout['upiVerified'] == true;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(t.upiSectionTitle,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
                if (!_editing)
                  TextButton(
                    onPressed: () => setState(() => _editing = true),
                    child: Text(masked == null ? t.add : t.change),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            if (!_editing) ...[
              // Only ever the masked handle. The full address is not sent
              // back to the app at all, which is why re-typing it is the
              // only way to change it.
              Text(masked ?? t.upiNotSet,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              if (widget.payout['upiHolderName'] != null)
                Text('${widget.payout['upiHolderName']}',
                    style: theme.textTheme.bodyMedium),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    verified ? Icons.verified_outlined : Icons.pending_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    verified ? t.upiVerifiedYes : t.upiVerifiedNo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ] else ...[
              TextField(
                controller: _upi,
                enabled: !_busy,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [LengthLimitingTextInputFormatter(120)],
                decoration: InputDecoration(
                  labelText: t.upiIdLabel,
                  hintText: t.upiIdHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _holder,
                enabled: !_busy,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [LengthLimitingTextInputFormatter(120)],
                decoration: InputDecoration(
                  labelText: t.holderNameLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              _Note(t.holderNameWhy),
              _Note(t.upiTypoWarning, warning: true),
              if (masked != null) _Note(t.upiChangedClearsVerification),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              ],
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _busy ? null : _cancel,
                    child: Text(t.cancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _busy ? null : _save,
                    child: _busy
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(t.save),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Cancel means cancel. Without resetting the fields, an abandoned edit
  /// is still sitting there the next time the form is opened -- and on this
  /// form the abandoned value is half a payment address.
  void _cancel() {
    setState(() {
      _editing = false;
      _error = null;
      _upi.clear();
      _holder.text = '${widget.payout['upiHolderName'] ?? ''}';
    });
  }
}

class _PanCard extends StatefulWidget {
  const _PanCard({required this.payout});

  final Map<String, dynamic> payout;

  @override
  State<_PanCard> createState() => _PanCardState();
}

class _PanCardState extends State<_PanCard> {
  final _pan = TextEditingController();
  bool _editing = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _pan.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    final pan = normalisePan(_pan.text);
    if (!looksLikePan(pan)) {
      setState(() => _error = t.invalidPan);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final referral = context.read<ReferralController>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final updated = await context.read<AuthController>().api.setPan(pan);
      referral.adoptPayout(updated);
      if (!mounted) return;
      setState(() {
        _editing = false;
        _pan.clear();
      });
      messenger.showSnackBar(SnackBar(content: Text(t.saved)));
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = apiErrorText(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final last4 = widget.payout['panLast4'] as String?;
    final status = '${widget.payout['panStatus'] ?? 'NOT_SUBMITTED'}';

    final statusLine = switch (status) {
      'PENDING' => t.panStatusPending,
      'VERIFIED' => t.panStatusVerified,
      'REJECTED' => t.panStatusRejected,
      _ => t.panNotSet,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(t.panSectionTitle,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
                if (!_editing)
                  TextButton(
                    onPressed: () => setState(() => _editing = true),
                    child: Text(last4 == null ? t.add : t.change),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            if (!_editing) ...[
              Text(last4 == null ? t.panNotSet : '••••••$last4',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(statusLine,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: status == 'REJECTED'
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  )),
              const SizedBox(height: 8),
              _Note(t.panWhy),
            ] else ...[
              TextField(
                controller: _pan,
                enabled: !_busy,
                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  // Upper-cased as it is typed, so the field shows what
                  // will actually be sent.
                  TextInputFormatter.withFunction((_, next) =>
                      next.copyWith(text: next.text.toUpperCase())),
                ],
                decoration: InputDecoration(
                  labelText: t.panLabel,
                  hintText: t.panHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              _Note(t.panWhy),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              ],
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => setState(() {
                              _editing = false;
                              _error = null;
                              // Same reason as the address above: an
                              // abandoned tax number should not be waiting
                              // in the field next time.
                              _pan.clear();
                            }),
                    child: Text(t.cancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _busy ? null : _save,
                    child: _busy
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(t.save),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text, {this.warning = false});

  final String text;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: warning
              ? theme.colorScheme.error
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: warning ? FontWeight.w600 : null,
        ),
      ),
    );
  }
}

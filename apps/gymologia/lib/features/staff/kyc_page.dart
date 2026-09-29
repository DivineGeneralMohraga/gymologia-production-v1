import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../../core/api/uploads.dart';
import '../../core/media/media_picker.dart';
import '../../core/utils/dates.dart';
import '../../l10n/app_localizations.dart';
import '../../theme.dart';
import '../../ui/kit.dart';
import '../auth/auth_controller.dart';

/// Verifying the gym: Aadhaar, PAN, and either GST or another business
/// proof, plus the landlord's NOC when the premises are rented.
///
/// Verification is what lets a gym into the public gym browser, so this is
/// where a Pro plan starts paying off. Documents go straight to private
/// storage the moment they are picked; the form carries only their
/// addresses. Numbers are encrypted by the server and come back as their
/// last four digits -- this screen never holds anyone's full Aadhaar after
/// it has been sent.
class KycPage extends StatefulWidget {
  const KycPage({super.key, required this.gym});
  final GymDetail gym;

  @override
  State<KycPage> createState() => _KycPageState();
}

class _KycPageState extends State<KycPage> {
  KycStatus? _status;
  String? _loadError;

  final _formKey = GlobalKey<FormState>();
  final _aadhaar = TextEditingController();
  final _pan = TextEditingController();
  final _gstin = TextEditingController();
  bool _hasGst = true;
  String _altProofType = 'UDYAM';
  String _premises = 'OWNED';
  final _altProof = _DocState();
  final _noc = _DocState();
  bool _submitting = false;
  bool _showDocErrors = false;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [_aadhaar, _pan, _gstin]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loadError = null);
    try {
      final status = await _api.kyc(widget.gym.id);
      if (!mounted) return;
      setState(() {
        _status = status;
        // A resubmission starts from what was sent last time.
        if (status.premises != null) _premises = status.premises!;
        if (status.submitted && status.gstinLast4 == null) _hasGst = false;
        if (status.altProofType != null) _altProofType = status.altProofType!;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e.message);
    }
  }

  Future<void> _pick(_DocState doc) async {
    final t = AppLocalizations.of(context);
    final picked = await pickDocument(context);
    if (picked == null || !mounted) return;
    setState(() {
      doc.uploading = true;
      doc.name = picked.name;
    });
    try {
      final url = await Uploader(context.read<AuthController>().client).upload(
        gymId: widget.gym.id,
        kind: UploadKind.kycDocument,
        bytes: picked.bytes,
        contentType: picked.contentType,
      );
      if (!mounted) return;
      setState(() {
        doc.url = url;
        doc.isPdf = picked.isPdf;
      });
    } on UploadTooLarge catch (e) {
      _toast(t.fileTooLarge(e.maxMb));
      doc.name = null;
    } on ApiException catch (e) {
      _toast(e.message);
      doc.name = null;
    } finally {
      if (mounted) setState(() => doc.uploading = false);
    }
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context);
    setState(() => _showDocErrors = true);
    final docsOk = (_hasGst || _altProof.url != null) &&
        (_premises != 'RENTED' || _noc.url != null);
    if (!_formKey.currentState!.validate() || !docsOk) return;
    FocusScope.of(context).unfocus();

    setState(() => _submitting = true);
    try {
      final status = await _api.submitKyc(widget.gym.id, {
        'aadhaar': _aadhaar.text.replaceAll(RegExp(r'\s'), ''),
        'pan': _pan.text.trim().toUpperCase(),
        if (_hasGst) 'gstin': _gstin.text.trim().toUpperCase(),
        if (!_hasGst) 'altProofType': _altProofType,
        if (!_hasGst) 'altProofUrl': _altProof.url,
        'premises': _premises,
        if (_premises == 'RENTED') 'nocUrl': _noc.url,
      });
      if (!mounted) return;
      // The numbers are with the server now, and should not linger here.
      _aadhaar.clear();
      _pan.clear();
      _gstin.clear();
      setState(() {
        _status = status;
        _showDocErrors = false;
      });
      _toast(t.kycSubmittedSnackbar);
    } on ApiException catch (e) {
      _toast(e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final status = _status;

    return Scaffold(
      appBar: AppBar(title: Text(t.verification.toUpperCase())),
      body: _loadError != null
          ? Center(
              child: SingleChildScrollView(
                child: EmptyState(
                  icon: Icons.cloud_off_rounded,
                  title: t.somethingWentWrongTryAgain,
                  message: _loadError,
                  action: SizedBox(
                    width: 200,
                    child: FilledButton(
                      onPressed: _load,
                      child: Text(t.tryAgain.toUpperCase()),
                    ),
                  ),
                ),
              ),
            )
          : status == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                    children: [
                      _StatusBanner(status: status),
                      if (status.submitted) ...[
                        const SizedBox(height: 22),
                        SectionLabel(t.whatYouSent),
                        _SentSummary(status: status),
                      ],
                      if (status.canSubmit) ...[
                        const SizedBox(height: 22),
                        if (widget.gym.isGymOwner)
                          _form(context)
                        else
                          _Note(
                            icon: Icons.lock_rounded,
                            text: t.kycOnlyOwner,
                          ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _form(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionLabel(t.identity),
          TextFormField(
            controller: _aadhaar,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12),
            ],
            decoration: InputDecoration(
              labelText: t.aadhaarNumber,
              prefixIcon: const Icon(Icons.badge_rounded),
            ),
            validator: (v) => RegExp(r'^[2-9]\d{11}$').hasMatch(v ?? '')
                ? null
                : t.enterValidAadhaar,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _pan,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              LengthLimitingTextInputFormatter(10),
              _UpperCase(),
            ],
            decoration: InputDecoration(
              labelText: t.panNumber,
              hintText: 'ABCDE1234F',
              prefixIcon: const Icon(Icons.credit_card_rounded),
            ),
            validator: (v) =>
                RegExp(r'^[A-Z]{5}\d{4}[A-Z]$').hasMatch((v ?? '').toUpperCase())
                    ? null
                    : t.enterValidPan,
          ),

          const SizedBox(height: 22),
          SectionLabel(t.business),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _hasGst,
            onChanged: (v) => setState(() => _hasGst = v),
            title: Text(t.hasGstRegistration),
          ),
          if (_hasGst)
            TextFormField(
              controller: _gstin,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                LengthLimitingTextInputFormatter(15),
                _UpperCase(),
              ],
              decoration: InputDecoration(
                labelText: t.gstin,
                hintText: '27ABCDE1234F1Z5',
                prefixIcon: const Icon(Icons.receipt_long_rounded),
              ),
              validator: (v) => RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z][1-9A-Z]Z[0-9A-Z]$')
                      .hasMatch((v ?? '').toUpperCase())
                  ? null
                  : t.enterValidGstin,
            )
          else ...[
            Text(t.businessProofHint,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                )),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: 'UDYAM', label: Text(t.proofUdyam)),
                ButtonSegment(
                    value: 'ELECTRICITY_BILL', label: Text(t.proofElectricityBill)),
                ButtonSegment(value: 'OTHER', label: Text(t.proofOther)),
              ],
              selected: {_altProofType},
              onSelectionChanged: (s) => setState(() => _altProofType = s.first),
            ),
            const SizedBox(height: 12),
            _DocumentSlot(
              label: t.businessProof,
              doc: _altProof,
              showError: _showDocErrors,
              onPick: () => _pick(_altProof),
            ),
          ],

          const SizedBox(height: 22),
          SectionLabel(t.premisesQuestion),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: 'OWNED',
                label: Text(t.premisesOwned),
                icon: const Icon(Icons.home_rounded),
              ),
              ButtonSegment(
                value: 'RENTED',
                label: Text(t.premisesRented),
                icon: const Icon(Icons.key_rounded),
              ),
            ],
            selected: {_premises},
            onSelectionChanged: (s) => setState(() => _premises = s.first),
          ),
          if (_premises == 'RENTED') ...[
            const SizedBox(height: 12),
            _DocumentSlot(
              label: t.landlordNoc,
              hint: t.landlordNocHint,
              doc: _noc,
              showError: _showDocErrors,
              onPick: () => _pick(_noc),
            ),
          ],

          const SizedBox(height: 22),
          _Note(icon: Icons.shield_rounded, text: t.kycEncryptedNote),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _submitting || _altProof.uploading || _noc.uploading
                ? null
                : _submit,
            icon: _submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.4))
                : const Icon(Icons.verified_user_rounded),
            label: Text(t.submitForVerification.toUpperCase()),
          ),
        ],
      ),
    );
  }
}

/// One uploaded document's progress. Mutable on purpose: it lives inside
/// the page's state and is redrawn with setState.
class _DocState {
  String? url;
  String? name;
  bool uploading = false;
  bool isPdf = false;
}

class _UpperCase extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue _, TextEditingValue next) =>
      next.copyWith(text: next.text.toUpperCase());
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status});
  final KycStatus status;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tokens = context.gym;
    final (IconData icon, Color color, String title, String body) = status.isVerified
        ? (
            Icons.verified_rounded,
            volt,
            t.verified,
            t.kycVerifiedOn(Dates.full(status.verifiedAt!.toLocal(), Dates.localeOf(context))),
          )
        : status.needsChanges
            ? (
                Icons.report_rounded,
                tokens.flame,
                t.kycNeedsChanges,
                status.rejectionReason!,
              )
            : status.isUnderReview
                ? (
                    Icons.hourglass_top_rounded,
                    tokens.warning,
                    t.kycUnderReview,
                    t.kycUnderReviewBody,
                  )
                : (Icons.shield_rounded, volt, t.getVerified, t.kycIntro);

    return HeroPanel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontFamily: displayFont,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    height: 1.0,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(body, style: const TextStyle(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SentSummary extends StatelessWidget {
  const _SentSummary({required this.status});
  final KycStatus status;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    String masked(String? last4) => last4 == null ? '—' : '•••• $last4';
    final rows = <(String, String, String)>[
      (t.aadhaarNumber, masked(status.aadhaarLast4), status.aadhaarStatus),
      (t.panNumber, masked(status.panLast4), status.panStatus),
      if (status.gstinLast4 != null)
        (t.gstin, masked(status.gstinLast4), status.gstStatus)
      else
        (t.businessProof, _proofName(t, status.altProofType), status.gstStatus),
      if (status.premises == 'RENTED') (t.landlordNoc, '', status.nocStatus),
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Eyebrow(rows[i].$1),
                        if (rows[i].$2.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(rows[i].$2,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              )),
                        ],
                      ],
                    ),
                  ),
                  _StatusPill(status: rows[i].$3),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _proofName(AppLocalizations t, String? type) => switch (type) {
        'UDYAM' => t.proofUdyam,
        'ELECTRICITY_BILL' => t.proofElectricityBill,
        'OTHER' => t.proofOther,
        _ => '—',
      };
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tokens = context.gym;
    final scheme = Theme.of(context).colorScheme;
    final (String label, Color bg) = switch (status) {
      'VERIFIED' => (t.verified, tokens.success),
      'PENDING' => (t.statusPending, tokens.warning),
      'REJECTED' => (t.statusRejected, scheme.error),
      _ => (t.statusNotSubmitted, scheme.outline),
    };
    return Pill(label, background: bg, foreground: ink);
  }
}

class _DocumentSlot extends StatelessWidget {
  const _DocumentSlot({
    required this.label,
    required this.doc,
    required this.showError,
    required this.onPick,
    this.hint,
  });

  final String label;
  final String? hint;
  final _DocState doc;
  final bool showError;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final missing = showError && doc.url == null && !doc.uploading;
    final done = doc.url != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActionTile(
          icon: doc.uploading
              ? Icons.cloud_upload_rounded
              : done
                  ? (doc.isPdf ? Icons.picture_as_pdf_rounded : Icons.check_circle_rounded)
                  : Icons.upload_file_rounded,
          accent: done,
          title: label,
          subtitle: doc.uploading
              ? t.uploading
              : done
                  ? '${t.documentUploaded} · ${doc.name ?? ''}'
                  : (hint ?? t.uploadDocument),
          trailing: doc.uploading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.4))
              : Text(
                  (done ? t.replaceDocument : t.uploadDocument).toUpperCase(),
                  style: TextStyle(
                    fontFamily: displayFont,
                    fontWeight: FontWeight.w800,
                    color: context.gym.accentText,
                  ),
                ),
          onTap: doc.uploading ? null : onPick,
        ),
        if (missing)
          Padding(
            padding: const EdgeInsets.only(left: 6, top: 6),
            child: Text(t.documentRequired,
                style: TextStyle(color: scheme.error, fontSize: 12.5)),
          ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: context.gym.accentText),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: scheme.onSurfaceVariant,
                )),
          ),
        ],
      ),
    );
  }
}

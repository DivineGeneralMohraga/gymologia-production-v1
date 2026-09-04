import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';

import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';

/// Choosing a plan.
///
/// Two paths out of here. The free trial activates immediately with no
/// payment at all, which is what most new owners will take. Paying opens
/// Cashfree's sheet, and when it closes the app asks our server what
/// actually happened rather than believing the sheet's own result — the
/// webhook may well have got there first.
class PlanPage extends StatefulWidget {
  const PlanPage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  Map<String, dynamic>? _quote;
  Map<String, dynamic>? _current;
  final _referral = TextEditingController();
  String? _appliedCode;
  bool _busy = false;
  String? _error;

  /// Set while Cashfree's sheet is open, so its callbacks know which
  /// subscription to confirm afterwards.
  String? _pendingSubscriptionId;

  /// Read from the server rather than hardcoded. A client pinned to
  /// SANDBOX against a live backend opens the wrong payment environment,
  /// and the failure looks like a broken sheet rather than a config error.
  CFEnvironment _cashfreeEnv = CFEnvironment.SANDBOX;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();

    // Web checkout rather than drop-in: the drop-in integration is
    // deprecated in the SDK.
    CFPaymentGatewayService().setCallback(_onPaymentDone, _onPaymentError);
  }

  @override
  void dispose() {
    _referral.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final quote = await _api.subscriptionQuote(
        widget.gym.id,
        referralCode: _appliedCode,
      );
      final current = await _api.subscription(widget.gym.id);

      // Defaults to sandbox if the server does not say, which fails safe:
      // a sandbox sheet against production takes no real money.
      CFEnvironment env = CFEnvironment.SANDBOX;
      try {
        final config = await _api.serverConfig();
        if (config['cashfreeEnv'] == 'PRODUCTION') {
          env = CFEnvironment.PRODUCTION;
        }
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _quote = quote;
        _current = current;
        _cashfreeEnv = env;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _applyCode() async {
    final code = _referral.text.trim().toUpperCase();
    setState(() => _appliedCode = code.isEmpty ? null : code);
    await _load();

    if (!mounted) return;
    final referral = _quote?['referral'] as Map<String, dynamic>?;
    if (referral != null && referral['valid'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(referral['message'] as String? ??
                AppLocalizations.of(context).invalidCode)),
      );
      setState(() => _appliedCode = null);
      await _load();
    }
  }

  Future<void> _startTrial() async {
    setState(() => _busy = true);
    try {
      await _api.startTrial(widget.gym.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).trialStarted)),
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _busy = false;
        });
      }
    }
  }

  Future<void> _pay(String plan) async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final checkout = await _api.checkout(
        widget.gym.id,
        plan: plan,
        referralCode: _appliedCode,
      );
      _pendingSubscriptionId = checkout['subscriptionId'] as String?;

      final session = CFSessionBuilder()
          .setEnvironment(_cashfreeEnv)
          .setOrderId(checkout['orderId'] as String)
          .setPaymentSessionId(checkout['paymentSessionId'] as String)
          .build();

      final payment = CFWebCheckoutPaymentBuilder()
          .setSession(session)
          .setTheme(
            CFThemeBuilder()
                .setNavigationBarBackgroundColorColor('#E8452C')
                .setNavigationBarTextColor('#FFFFFF')
                .build(),
          )
          .build();

      CFPaymentGatewayService().doPayment(payment);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _busy = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error =
              '${AppLocalizations.of(context).couldNotOpenPayment} $e';
          _busy = false;
        });
      }
    }
  }

  /// The sheet closed saying it succeeded. That is a hint, not proof — the
  /// server confirms with Cashfree directly before anything is activated.
  void _onPaymentDone(String orderId) {
    _confirm();
  }

  void _onPaymentError(CFErrorResponse error, String orderId) {
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(error.getMessage() ??
              AppLocalizations.of(context).paymentNotCompleted)),
    );
    // Confirm anyway: the sheet reports an error for a cancel too, and the
    // webhook may already have activated a payment that did go through.
    _confirm(quiet: true);
  }

  Future<void> _confirm({bool quiet = false}) async {
    final subscriptionId = _pendingSubscriptionId;
    if (subscriptionId == null) return;

    try {
      final result = await _api.verifySubscription(widget.gym.id, subscriptionId);
      if (!mounted) return;

      if (result['status'] == 'ACTIVE') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .planIsActive('${result['plan']}')),
          ),
        );
        Navigator.of(context).pop(true);
        return;
      }

      setState(() => _busy = false);
      if (!quiet) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context).paymentNotCompletedYet),
          ),
        );
      }
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          if (!quiet) _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final quote = _quote;
    final current = (_current?['current'] as Map<String, dynamic>?);

    if (_error != null && quote == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.plan)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!, textAlign: TextAlign.center),
                const SizedBox(height: 18),
                FilledButton.tonal(
                    onPressed: _load, child: Text(t.tryAgain)),
              ],
            ),
          ),
        ),
      );
    }

    if (quote == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.plan)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final plans = ((quote['plans'] as List?) ?? const [])
        .cast<Map<String, dynamic>>();
    final trialAvailable = quote['trialAvailable'] == true;
    final referral = quote['referral'] as Map<String, dynamic>?;
    final discountApplied = referral != null && referral['valid'] == true;

    return Scaffold(
      appBar: AppBar(title: Text(t.plan)),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            if (current != null) _CurrentPlanCard(current: current),

            if (current == null && trialAvailable) ...[
              Card(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.daysFree((quote['trialDays'] as int?) ?? 0),
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                        t.trialBlurb,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                      ),
                      const SizedBox(height: 14),
                      FilledButton(
                        onPressed: _busy ? null : _startTrial,
                        child: Text(t.startFreeTrial),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // ── Referral code ────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _referral,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                      LengthLimitingTextInputFormatter(20),
                    ],
                    decoration: InputDecoration(
                      labelText: t.referralCode,
                      hintText: t.optional,
                      suffixIcon: discountApplied
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: _busy ? null : _applyCode,
                  child: Text(t.apply),
                ),
              ],
            ),
            if (discountApplied) ...[
              const SizedBox(height: 8),
              Text(
                referral['message'] as String? ?? '',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.green.shade700),
              ),
            ],

            const SizedBox(height: 22),
            for (final plan in plans) ...[
              _PlanCard(
                plan: plan,
                recommended: plan['plan'] == 'PRO',
                busy: _busy,
                onChoose: () => _pay(plan['plan'] as String),
              ),
              const SizedBox(height: 12),
            ],

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error)),
            ],

            const SizedBox(height: 16),
            Text(
              t.gstNote,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentPlanCard extends StatelessWidget {
  const _CurrentPlanCard({required this.current});
  final Map<String, dynamic> current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final days = (current['daysRemaining'] as int?) ?? 0;
    final isTrial = current['isTrial'] == true;
    final listed = current['listedInSearch'] == true;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(t.planNamed('${current['plan']}'),
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                if (isTrial) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(t.trialBadge,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: theme.colorScheme.onTertiaryContainer,
                        )),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Text(
              days < 0 ? t.expired : t.daysRemainingPlan(days),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: days <= 7 ? theme.colorScheme.error : null,
                fontWeight: days <= 7 ? FontWeight.w600 : null,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  listed ? Icons.visibility : Icons.visibility_off_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    listed ? t.listedInSearch : t.notListedUpgrade,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            if (isTrial) ...[
              const SizedBox(height: 12),
              Text(
                t.trialEndsNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.recommended,
    required this.busy,
    required this.onChoose,
  });

  final Map<String, dynamic> plan;
  final bool recommended;
  final bool busy;
  final VoidCallback onChoose;

  String _rupees(int paise) {
    final whole = paise ~/ 100;
    final part = paise % 100;
    return part == 0
        ? '₹$whole'
        : '₹$whole.${part.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final base = (plan['basePricePaise'] as int?) ?? 0;
    final payable = (plan['amountPayablePaise'] as int?) ?? 0;
    final discounted = payable < base;
    final features = ((plan['features'] as List?) ?? const []).cast<String>();

    return Card(
      shape: recommended
          ? RoundedRectangleBorder(
              side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('${plan['plan']}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                if (recommended) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(t.getsYouListed.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: theme.colorScheme.onPrimary,
                        )),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(_rupees(payable),
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                if (discounted)
                  Text(
                    _rupees(base),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(width: 6),
                Text(t.perMonth,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 14),
            for (final feature in features)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check, size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(feature, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: recommended
                  ? FilledButton(
                      onPressed: busy ? null : onChoose,
                      child: Text(t.choosePlanNamed('${plan['plan']}')),
                    )
                  : OutlinedButton(
                      onPressed: busy ? null : onChoose,
                      child: Text(t.choosePlanNamed('${plan['plan']}')),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

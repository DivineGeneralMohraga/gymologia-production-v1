import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';

/// The monthly weight and height check-in.
///
/// Pre-filled with the last entry, because month to month most people
/// change one number and not the other — retyping their height every time
/// is the fastest way to make them stop doing it at all.
class CheckInSheet extends StatefulWidget {
  const CheckInSheet({super.key, required this.api, this.latest});

  final GymApi api;
  final BodyMetric? latest;

  @override
  State<CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends State<CheckInSheet> {
  late final TextEditingController _weight = TextEditingController(
    text: widget.latest?.weightKg?.toStringAsFixed(1) ?? '',
  );
  late final TextEditingController _height = TextEditingController(
    text: widget.latest?.heightCm?.toStringAsFixed(0) ?? '',
  );

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final weight = double.tryParse(_weight.text.trim());
    final height = double.tryParse(_height.text.trim());

    if (weight == null && height == null) {
      setState(() => _error = 'Enter a weight or a height.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final updated =
          await widget.api.recordMetric(weightKg: weight, heightCm: height);
      if (mounted) Navigator.of(context).pop(updated);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context).monthlyCheckIn,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context).checkInGoalNote,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weight,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}\.?\d{0,1}')),
                  ],
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).weight,
                    suffixText: 'kg',
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: _height,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).height,
                    suffixText: 'cm',
                  ),
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(_error!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: 22),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: _busy
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Text(AppLocalizations.of(context).save),
          ),
          TextButton(
            onPressed: _busy ? null : () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).notNow),
          ),
        ],
      ),
    );
  }
}

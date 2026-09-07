import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import 'locale_controller.dart';

/// The language picker.
///
/// Every language is written in its own script, because somebody looking
/// for their language cannot read a list presented in a language they do
/// not have. "Use device language" is the top entry and the default.
///
/// This app cares about the choice more than the other two do: the sentence
/// it produces is not read here, it is forwarded to a gym owner. The server
/// builds that sentence from the same language code, so picking Marathi
/// here changes what gets pasted into somebody else's WhatsApp.
class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final controller = context.watch<LocaleController>();
    final device = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.languageTitle)),
      body: RadioGroup<Locale?>(
        groupValue: controller.locale,
        onChanged: controller.set,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                t.languageSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            RadioListTile<Locale?>(
              value: null,
              title: Text(t.useDeviceLanguage),
              subtitle: Text(nameFor(device.languageCode)),
            ),
            const Divider(height: 1),
            for (final locale in AppLocalizations.supportedLocales)
              RadioListTile<Locale?>(
                value: locale,
                title: Text(nameFor(locale.languageCode)),
                // Said plainly on every translated language rather than
                // left for somebody to discover: these have not been read
                // by a native speaker yet.
                subtitle: locale.languageCode == 'en'
                    ? null
                    : Text(
                        t.needsReview,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                t.untranslatedFallbackNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Each language's own name. Kept here rather than in the ARB so the
  /// picker can show every language at once, not just the active one.
  static String nameFor(String code) => switch (code) {
        'en' => 'English',
        'hi' => 'हिन्दी',
        'bn' => 'বাংলা',
        'ta' => 'தமிழ்',
        'te' => 'తెలుగు',
        'mr' => 'मराठी',
        'ml' => 'മലയാളം',
        'kn' => 'ಕನ್ನಡ',
        'gu' => 'ગુજરાતી',
        'pa' => 'ਪੰਜਾਬੀ',
        _ => code,
      };
}

import 'package:flutter/material.dart';

/// "Beast Mode": near-black, one electric volt accent, and heavy condensed
/// headings. Every screen reads its colours from here, so the whole app
/// moves when this file does.
///
/// Volt is a fill colour, never a text colour on light backgrounds: on a
/// light surface it is unreadable, so light mode inverts it -- black
/// buttons with volt labels -- and keeps volt only for filled accents.

/// The one accent. Fills only; see [GymTokens.accentText] for text.
const volt = Color(0xFFC6FF00);
const ink = Color(0xFF0B0B0C);

/// Heavy condensed display face for headings, numbers and buttons. It
/// carries Latin only; Indic scripts fall through to the system font glyph
/// by glyph, which is what keeps every translation legible.
const displayFont = 'BarlowCondensed';

/// Colours the Material scheme has no slot for.
@immutable
class GymTokens extends ThemeExtension<GymTokens> {
  const GymTokens({
    required this.accentText,
    required this.success,
    required this.warning,
    required this.flame,
    required this.cardBorder,
    required this.heroGradient,
  });

  /// Accent for text and small icons -- volt in the dark, olive in the light.
  final Color accentText;
  final Color success;
  final Color warning;

  /// Streaks, "hot" and attention -- the old brand orange, turned up.
  final Color flame;
  final Color cardBorder;

  /// Behind the big numbers at the top of a screen.
  final List<Color> heroGradient;

  static const dark = GymTokens(
    accentText: volt,
    success: Color(0xFF3DDC84),
    warning: Color(0xFFFFB020),
    flame: Color(0xFFFF6B35),
    cardBorder: Color(0xFF232329),
    heroGradient: [Color(0xFF1D2608), Color(0xFF121214)],
  );

  static const light = GymTokens(
    accentText: Color(0xFF4A6800),
    success: Color(0xFF1E8E3E),
    warning: Color(0xFFB26A00),
    flame: Color(0xFFD9480F),
    cardBorder: Color(0xFFE2E3DC),
    heroGradient: [Color(0xFF151518), Color(0xFF2A2F1A)],
  );

  @override
  GymTokens copyWith({
    Color? accentText,
    Color? success,
    Color? warning,
    Color? flame,
    Color? cardBorder,
    List<Color>? heroGradient,
  }) =>
      GymTokens(
        accentText: accentText ?? this.accentText,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        flame: flame ?? this.flame,
        cardBorder: cardBorder ?? this.cardBorder,
        heroGradient: heroGradient ?? this.heroGradient,
      );

  @override
  GymTokens lerp(ThemeExtension<GymTokens>? other, double t) {
    if (other is! GymTokens) return this;
    return GymTokens(
      accentText: Color.lerp(accentText, other.accentText, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      flame: Color.lerp(flame, other.flame, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      heroGradient: [
        for (var i = 0; i < heroGradient.length; i++)
          Color.lerp(heroGradient[i], other.heroGradient[i], t)!,
      ],
    );
  }
}

extension GymTheme on BuildContext {
  /// Falls back by brightness, so a screen under some other ThemeData --
  /// a test harness, a Theme override -- still renders instead of throwing.
  GymTokens get gym {
    final theme = Theme.of(this);
    return theme.extension<GymTokens>() ??
        (theme.brightness == Brightness.dark
            ? GymTokens.dark
            : GymTokens.light);
  }
}

const _darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: volt,
  onPrimary: ink,
  primaryContainer: Color(0xFF2A3800),
  onPrimaryContainer: Color(0xFFDBFF66),
  // Graphite, so tonal buttons and selected rows read as "pressed steel"
  // rather than a second accent competing with volt.
  secondary: Color(0xFFE6E6E1),
  onSecondary: ink,
  secondaryContainer: Color(0xFF26262D),
  onSecondaryContainer: Color(0xFFF2F2EE),
  tertiary: Color(0xFFFF6B35),
  onTertiary: ink,
  tertiaryContainer: Color(0xFF3F1B0B),
  onTertiaryContainer: Color(0xFFFFB896),
  error: Color(0xFFFF5C5C),
  onError: ink,
  errorContainer: Color(0xFF4A1212),
  onErrorContainer: Color(0xFFFFB4AB),
  surface: ink,
  onSurface: Color(0xFFF5F5F2),
  onSurfaceVariant: Color(0xFF9C9CA5),
  surfaceContainerLowest: Color(0xFF070708),
  surfaceContainerLow: Color(0xFF121214),
  surfaceContainer: Color(0xFF17171A),
  surfaceContainerHigh: Color(0xFF1E1E23),
  surfaceContainerHighest: Color(0xFF26262C),
  outline: Color(0xFF3C3C45),
  outlineVariant: Color(0xFF26262C),
  inverseSurface: Color(0xFFF5F5F2),
  onInverseSurface: ink,
  inversePrimary: Color(0xFF4A6800),
  shadow: Colors.black,
  scrim: Colors.black,
  surfaceTint: Colors.transparent,
);

const _lightScheme = ColorScheme(
  brightness: Brightness.light,
  // Inverted: black does the accent's job, volt rides on it.
  primary: ink,
  onPrimary: volt,
  primaryContainer: volt,
  onPrimaryContainer: ink,
  secondary: Color(0xFF3A3A40),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFE4E5DE),
  onSecondaryContainer: ink,
  tertiary: Color(0xFFD9480F),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFFFE3D6),
  onTertiaryContainer: Color(0xFF5A1E00),
  error: Color(0xFFD32F2F),
  onError: Colors.white,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFF3F4EF),
  onSurface: ink,
  onSurfaceVariant: Color(0xFF5E5F66),
  surfaceContainerLowest: Colors.white,
  surfaceContainerLow: Colors.white,
  surfaceContainer: Color(0xFFECEDE7),
  surfaceContainerHigh: Color(0xFFE6E7E0),
  surfaceContainerHighest: Color(0xFFDDDED7),
  outline: Color(0xFFAEAFA7),
  outlineVariant: Color(0xFFDADBD3),
  inverseSurface: Color(0xFF17171A),
  onInverseSurface: Color(0xFFF5F5F2),
  inversePrimary: volt,
  shadow: Colors.black,
  scrim: Colors.black,
  surfaceTint: Colors.transparent,
);

TextTheme _textTheme(ColorScheme s) {
  TextStyle display(double size, FontWeight w, {double spacing = 0.2}) =>
      TextStyle(
        fontFamily: displayFont,
        fontSize: size,
        fontWeight: w,
        letterSpacing: spacing,
        height: 1.05,
        color: s.onSurface,
      );

  final base = ThemeData(brightness: s.brightness).textTheme.apply(
        bodyColor: s.onSurface,
        displayColor: s.onSurface,
      );

  return base.copyWith(
    displayLarge: display(56, FontWeight.w900, spacing: -0.5),
    displayMedium: display(46, FontWeight.w900, spacing: -0.3),
    displaySmall: display(38, FontWeight.w900),
    headlineLarge: display(34, FontWeight.w800),
    headlineMedium: display(30, FontWeight.w800),
    headlineSmall: display(26, FontWeight.w800),
    titleLarge: display(23, FontWeight.w800, spacing: 0.3),
    titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    labelSmall: base.labelSmall?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
    ),
  );
}

ThemeData _build(ColorScheme s, GymTokens tokens) {
  final text = _textTheme(s);
  final isDark = s.brightness == Brightness.dark;

  final buttonLabel = TextStyle(
    fontFamily: displayFont,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.8,
  );
  final rounded14 =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));

  return ThemeData(
    useMaterial3: true,
    brightness: s.brightness,
    colorScheme: s,
    textTheme: text,
    scaffoldBackgroundColor: s.surface,
    canvasColor: s.surface,
    extensions: [tokens],
    splashFactory: InkSparkle.splashFactory,

    appBarTheme: AppBarTheme(
      backgroundColor: s.surface,
      foregroundColor: s.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: displayFont,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
        color: s.onSurface,
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      height: 70,
      elevation: 0,
      backgroundColor: isDark ? const Color(0xFF0F0F11) : Colors.white,
      surfaceTintColor: Colors.transparent,
      indicatorColor: isDark ? volt : ink,
      indicatorShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? (isDark ? ink : volt)
                : s.onSurfaceVariant,
          )),
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
            fontFamily: displayFont,
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: states.contains(WidgetState.selected)
                ? s.onSurface
                : s.onSurfaceVariant,
          )),
    ),

    cardTheme: CardThemeData(
      color: s.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: tokens.cardBorder),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        shape: rounded14,
        textStyle: buttonLabel,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        foregroundColor: s.onSurface,
        side: BorderSide(color: s.outline, width: 1.4),
        shape: rounded14,
        textStyle: buttonLabel.copyWith(fontSize: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: tokens.accentText,
        textStyle: buttonLabel.copyWith(fontSize: 16),
        shape: rounded14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: s.surfaceContainerHigh,
        foregroundColor: s.onSurface,
        elevation: 0,
        shape: rounded14,
        textStyle: buttonLabel.copyWith(fontSize: 16),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: s.onSurface),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: s.primary,
      foregroundColor: s.onPrimary,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      extendedTextStyle: buttonLabel,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: s.surfaceContainerHigh,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: tokens.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: isDark ? volt : ink, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: s.error, width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: s.error, width: 2),
      ),
      floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) =>
          TextStyle(
            fontWeight: FontWeight.w600,
            color: states.contains(WidgetState.error)
                ? s.error
                : states.contains(WidgetState.focused)
                    ? tokens.accentText
                    : s.onSurfaceVariant,
          )),
      prefixIconColor: s.onSurfaceVariant,
      suffixIconColor: s.onSurfaceVariant,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: s.surfaceContainerHigh,
      selectedColor: isDark ? volt : ink,
      checkmarkColor: isDark ? ink : volt,
      side: BorderSide(color: tokens.cardBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // From the text theme rather than a bare TextStyle: a chip takes this
      // as is, and a bare style has no font family to fall back on.
      labelStyle: text.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: s.onSurface,
      ),
      secondaryLabelStyle: text.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: isDark ? ink : volt,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? (isDark ? volt : ink)
                : Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? (isDark ? ink : volt)
                : s.onSurface),
        side: WidgetStatePropertyAll(BorderSide(color: s.outline)),
        textStyle: WidgetStatePropertyAll(
          buttonLabel.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    ),

    tabBarTheme: TabBarThemeData(
      indicatorColor: isDark ? volt : ink,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: s.outlineVariant,
      labelColor: s.onSurface,
      unselectedLabelColor: s.onSurfaceVariant,
      labelStyle: buttonLabel.copyWith(fontSize: 16),
      unselectedLabelStyle:
          buttonLabel.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? (isDark ? ink : volt)
              : s.outline),
      trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? (isDark ? volt : ink)
              : s.surfaceContainerHighest),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? Colors.transparent
              : s.outline),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? (isDark ? volt : ink)
              : Colors.transparent),
      checkColor: WidgetStatePropertyAll(isDark ? ink : volt),
      side: BorderSide(color: s.outline, width: 1.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? tokens.accentText
              : s.outline),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: isDark ? volt : ink,
      linearTrackColor: s.surfaceContainerHighest,
      circularTrackColor: Colors.transparent,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: isDark ? volt : ink,
      thumbColor: isDark ? volt : ink,
      inactiveTrackColor: s.surfaceContainerHighest,
    ),

    listTileTheme: ListTileThemeData(
      iconColor: s.onSurfaceVariant,
      titleTextStyle: text.titleMedium,
      subtitleTextStyle:
          text.bodyMedium?.copyWith(color: s.onSurfaceVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerTheme: DividerThemeData(color: s.outlineVariant, space: 1),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: s.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      // Off by default: most sheets here draw their own handle.
      dragHandleColor: s.outline,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: s.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: text.headlineSmall,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: s.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: s.inverseSurface,
      contentTextStyle: TextStyle(
        color: s.onInverseSurface,
        fontWeight: FontWeight.w600,
      ),
      actionTextColor: isDark ? const Color(0xFF4A6800) : volt,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    badgeTheme: BadgeThemeData(
      backgroundColor: tokens.flame,
      textColor: Colors.white,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: s.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      headerHeadlineStyle: text.headlineMedium,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: s.surfaceContainer,
    ),
  );
}

// Built once: HeroPanel re-applies the dark theme inside light screens.
final ThemeData lightTheme = _build(_lightScheme, GymTokens.light);
final ThemeData darkTheme = _build(_darkScheme, GymTokens.dark);

import 'package:flutter/material.dart';
import '../theme.dart';

/// The pieces every screen is built from, so the look stays one look.
/// Colours come from the theme only -- nothing here hard-codes a shade
/// except the brand volt/ink pair, which is the same in both modes.

/// The mark: a volt tile with the dumbbell, tilted like a plate mid-lift.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 28});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: volt,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: -0.6,
        child: Icon(Icons.fitness_center, size: size * 0.62, color: ink),
      ),
    );
  }
}

/// Mark plus name, for the app bar.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BrandMark(size: 30),
        const SizedBox(width: 10),
        Text(
          name.toUpperCase(),
          style: TextStyle(
            fontFamily: displayFont,
            fontSize: 25,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 0.6,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// A heading over a block of content: volt bar, condensed caps.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing, this.padding});
  final String text;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(2, 8, 2, 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: scheme.brightness == Brightness.dark ? volt : ink,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text.toUpperCase(),
              style: TextStyle(
                fontFamily: displayFont,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: scheme.onSurface,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Small caps caption, as used over a number.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// A big condensed number with its caption. [unit] sits small beside it.
class BigNumber extends StatelessWidget {
  const BigNumber({
    super.key,
    required this.value,
    this.unit,
    this.size = 40,
    this.color,
  });
  final String value;
  final String? unit;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? Theme.of(context).colorScheme.onSurface;
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: value,
          style: TextStyle(
            fontFamily: displayFont,
            fontSize: size,
            fontWeight: FontWeight.w900,
            height: 1.0,
            color: fg,
          ),
        ),
        if (unit != null)
          TextSpan(
            text: ' $unit',
            style: TextStyle(
              fontFamily: displayFont,
              fontSize: size * 0.45,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: fg.withValues(alpha: 0.7),
            ),
          ),
      ]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// A card holding one stat. Use two or three in a Row with Expanded.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.icon,
    this.accent,
    this.onTap,
  });
  final String label;
  final String value;
  final String? unit;
  final IconData? icon;

  /// Tints the number and icon -- flame for a warning, volt for a win.
  final Color? accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: context.gym.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon,
                        size: 15, color: accent ?? scheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                  ],
                  Expanded(child: Eyebrow(label)),
                ],
              ),
              const SizedBox(height: 10),
              BigNumber(value: value, unit: unit, size: 34, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}

const _onHero = Color(0xFFF5F5F2);

/// The dark gradient block at the top of a screen. Dark in both modes on
/// purpose: it is the one place light mode still gets the full vibe.
class HeroPanel extends StatelessWidget {
  const HeroPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.image,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Optional photo behind the gradient.
  final String? image;

  @override
  Widget build(BuildContext context) {
    final tokens = context.gym;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: tokens.heroGradient,
                ),
              ),
            ),
          ),
          if (image != null)
            Positioned.fill(
              child: Image.network(
                image!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          if (image != null)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.88),
                    ],
                  ),
                ),
              ),
            ),
          // A volt glow in the corner, the signature of the look.
          Positioned(
            right: -60,
            top: -60,
            child: IgnorePointer(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    volt.withValues(alpha: 0.28),
                    volt.withValues(alpha: 0.0),
                  ]),
                ),
              ),
            ),
          ),
          Padding(
            padding: padding,
            // Hero content is always on dark, so force the dark palette
            // for anything inside that reads from the theme.
            // Plain Text and Icon read the ambient defaults rather than the
            // theme, so those are forced too.
            child: Theme(
              data: darkTheme,
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: _onHero),
                child: IconTheme.merge(
                  data: const IconThemeData(color: _onHero),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A row that goes somewhere: icon tile, title, subtitle, chevron.
class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.accent = false,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  /// Volt icon tile instead of graphite -- for the one thing to do next.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final tileBg = accent
        ? (isDark ? volt : ink)
        : scheme.surfaceContainerHighest;
    final tileFg = accent ? (isDark ? ink : volt) : scheme.onSurface;

    return Material(
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: context.gym.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: tileBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: tileFg, size: 22),
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
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: scheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing ??
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 15, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

/// A small rounded label. Defaults to graphite; pass colours for status.
class Pill extends StatelessWidget {
  const Pill(
    this.text, {
    super.key,
    this.icon,
    this.background,
    this.foreground,
  });
  final String text;
  final IconData? icon;
  final Color? background;
  final Color? foreground;

  /// Volt fill with ink text -- the "live / active" pill.
  factory Pill.volt(String text, {IconData? icon}) =>
      Pill(text, icon: icon, background: volt, foreground: ink);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = foreground ?? scheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background ?? scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 5),
          ],
          Text(
            text.toUpperCase(),
            style: TextStyle(
              fontFamily: displayFont,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

/// Nothing to show yet: a big icon in a tile, a heading, a line, a button.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: context.gym.cardBorder),
            ),
            child: Icon(icon, size: 34, color: context.gym.accentText),
          ),
          const SizedBox(height: 18),
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.45,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: 20),
            action!,
          ],
        ],
      ),
    );
  }
}

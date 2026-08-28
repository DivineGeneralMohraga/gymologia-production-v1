import 'package:flutter/material.dart';

/// Events are modelled in the database but have no endpoints yet, so this
/// says so rather than showing an empty list that looks like a bug.
class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const SizedBox(height: 40),
        Icon(Icons.event_outlined,
            size: 48, color: theme.colorScheme.outline),
        const SizedBox(height: 18),
        Text('Events are not live yet',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Text(
          'Gyms on the Pro plan will be able to host events here, and you will '
          'see the ones near you alongside anything your own gym runs.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.5),
        ),
      ],
    );
  }
}

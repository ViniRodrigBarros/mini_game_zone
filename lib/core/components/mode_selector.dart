import 'package:flutter/material.dart';
import 'package:mini_game_zone/core/components/mode_button.dart';

class ModeSelector extends StatelessWidget {
  final String title;
  final String description;
  final List<ModeSelectorOption> options;

  const ModeSelector({
    super.key,
    required this.title,
    required this.description,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: 1.2,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 32),
          Text(
            description,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final option in options) ...[
                ModeButton(
                  label: option.label,
                  icon: option.icon,
                  color: option.color,
                  onTap: option.onTap,
                ),
                if (option != options.last) const SizedBox(width: 32),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class ModeSelectorOption {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const ModeSelectorOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

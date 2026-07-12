import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? badge;
  final VoidCallback? onViewAll;

  const SectionHeader({
    required this.title,
    this.badge,
    this.onViewAll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (badge != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Row(
                children: const [
                  Text('View All'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

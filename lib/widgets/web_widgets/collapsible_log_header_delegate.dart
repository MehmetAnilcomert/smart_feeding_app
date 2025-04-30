import 'package:flutter/material.dart';
import 'package:smart_feeding_app/widgets/web_widgets/collapsible_log_header_widget.dart';

// Custom delegate for collapsible log header
class CollapsibleLogHeaderDelegate extends SliverPersistentHeaderDelegate {
  final bool isExpanded;
  final VoidCallback onToggle;

  CollapsibleLogHeaderDelegate({
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode
          ? Color(0xFF303030)
          : Theme.of(context).scaffoldBackgroundColor,
      child: CollapsibleLogHeaderWidget(
        isExpanded: isExpanded,
        onToggle: onToggle,
      ),
    );
  }

  @override
  double get maxExtent => 60.0; // Height of the header

  @override
  double get minExtent => 60.0; // Height when collapsed

  @override
  bool shouldRebuild(covariant CollapsibleLogHeaderDelegate oldDelegate) {
    return oldDelegate.isExpanded != isExpanded;
  }
}

library;

import 'package:flutter/material.dart';
import '../../domain/domain.dart';
import 'compact_subject_card.dart';
import 'featured_subject_card.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.subject,
    this.onTap,
    this.onLongPress,
  });

  final Subject subject;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${subject.category} ${subject.name}',
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: subject.isFeatured
            ? FeaturedSubjectCard(
                subject: subject,
                onTap: onTap,
                onLongPress: onLongPress,
              )
            : CompactSubjectCard(
                subject: subject,
                onTap: onTap,
                onLongPress: onLongPress,
              ),
      ),
    );
  }
}

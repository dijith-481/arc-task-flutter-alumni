// lib/widgets/alumni_card.dart
import 'dart:ui';
import 'package:alumni_app/widgets/highlighted_text.dart';
import 'package:flutter/material.dart';
import '../models/alumni.dart';

class AlumniCard extends StatelessWidget {
  final Alumni alumni;
  final VoidCallback onTap;
  final List<int>? nameMatches;
  final List<int>? roleMatches;
  final List<int>? companyMatches;

  const AlumniCard({
    super.key,
    required this.alumni,
    required this.onTap,
    this.nameMatches,
    this.roleMatches,
    this.companyMatches,
  });

  Widget _buildHighlightableText(
    String text,
    List<int>? matches,
    TextStyle? style,
    ThemeData theme,
  ) {
    if (matches != null && matches.isNotEmpty) {
      return HighlightedText(
        text: text,
        highlightIndices: matches,
        style: style,
        highlightStyle: style?.copyWith(
          color: theme.colorScheme.secondary,
          backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
        ),
      );
    }
    return Text(
      text,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                alumni.imageUrl ?? 'https://i.pravatar.cc/300',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.surface.withOpacity(0.85),
                      theme.colorScheme.surface.withOpacity(0.95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(
                      alumni.imageUrl ?? 'https://i.pravatar.cc/150',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHighlightableText(
                          alumni.name,
                          nameMatches,
                          textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          theme,
                        ),
                        const SizedBox(height: 4),
                        _buildHighlightableText(
                          alumni.role,
                          roleMatches,
                          textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          theme,
                        ),
                        const SizedBox(height: 2),
                        _buildHighlightableText(
                          alumni.company,
                          companyMatches,
                          textTheme.bodyMedium?.copyWith(
                            color: textTheme.bodySmall?.color?.withOpacity(0.8),
                          ),
                          theme,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${alumni.batch} - ${alumni.branch}',
                            style: textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

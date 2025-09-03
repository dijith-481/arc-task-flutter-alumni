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
  final List<int>? batchMatches;
  final List<int>? branchMatches;

  const AlumniCard({
    super.key,
    required this.alumni,
    required this.onTap,
    this.nameMatches,
    this.roleMatches,
    this.companyMatches,
    this.batchMatches,
    this.branchMatches,
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
          backgroundColor: theme.colorScheme.primary.withAlpha(70),
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
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  color: theme.colorScheme.secondaryContainer.withAlpha(220),
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
                            color: theme.colorScheme.onSecondaryContainer,
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
                            color: textTheme.bodySmall?.color?.withAlpha(220),
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
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.secondary,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildHighlightableText(
                                alumni.batch,
                                batchMatches,
                                textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                                theme,
                              ),
                              _buildHighlightableText(
                                ' - ',
                                [],
                                textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                                theme,
                              ),
                              _buildHighlightableText(
                                alumni.branch,
                                branchMatches,
                                textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                                theme,
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
          ],
        ),
      ),
    );
  }
}

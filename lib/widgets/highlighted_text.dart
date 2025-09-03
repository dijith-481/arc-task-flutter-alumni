import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final List<int> highlightIndices;
  final TextStyle? style;
  final TextStyle? highlightStyle;

  const HighlightedText({
    super.key,
    required this.text,
    required this.highlightIndices,
    this.style,
    this.highlightStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (highlightIndices.isEmpty) {
      return Text(text, style: style);
    }

    final defaultStyle = style ?? DefaultTextStyle.of(context).style;
    final finalHighlightStyle =
        highlightStyle ?? defaultStyle.copyWith(fontWeight: FontWeight.bold);

    final flatIndices = highlightIndices.toSet();

    List<TextSpan> spans = [];
    for (var i = 0; i < text.length; i++) {
      spans.add(
        TextSpan(
          text: text[i],
          style: flatIndices.contains(i) ? finalHighlightStyle : defaultStyle,
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}

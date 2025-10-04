import 'package:flutter/material.dart';

enum ExpandableTextAction { expand, collapse }

typedef ActionCallback = void Function(ExpandableTextAction);

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle baseTextStyle;
  final String expandActionText;
  final String collapseActionText;
  final ActionCallback? onActionPress;

  final TextDirection? textDirection;

  final double actionIconSize = 12;
  final double actionStartPadding = 10;
  final double actionIconSpacing = 4;

  const ExpandableText({
    super.key,
    required this.text,
    required this.expandActionText,
    required this.collapseActionText,
    required this.baseTextStyle,
    this.onActionPress,
    this.maxLines = 2,
    this.textDirection,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin {
  bool _expanded = false;

  double? _lastWidth;

  InlineSpan? _collapsedSpanCache;
  InlineSpan? _expandedInlineSpanCache;
  bool? _expandedInlineFits;

  bool? _originalOverflowed;

  TextDirection? textDirection;

  @override
  void initState() {
    textDirection = widget.textDirection ?? TextDirection.ltr;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ExpandableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.maxLines != widget.maxLines ||
        oldWidget.expandActionText != widget.expandActionText ||
        oldWidget.collapseActionText != widget.collapseActionText) {
      _invalidateCaches();
    }
  }

  void _invalidateCaches() {
    _collapsedSpanCache = null;
    _expandedInlineSpanCache = null;
    _expandedInlineFits = null;
    _lastWidth = null;
    _originalOverflowed = null;
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        if (_lastWidth != width) {
          _invalidateCaches();
          _lastWidth = width;
        }

        final expandActionWidget = _actionWidget(ExpandableTextAction.expand);
        final collapseActionWidget = _actionWidget(
          ExpandableTextAction.collapse,
        );

        _ensureOverflowInfo(width);
        final noNeedShowAction = !(_originalOverflowed == true);

        Widget body;
        if (noNeedShowAction) {
          body = Text.rich(_getBaseText());
        } else if (_expanded) {
          _ensureExpandedInline(width, collapseActionWidget);
          if (_expandedInlineFits == true) {
            body = Stack(
              children: [
                Text.rich(_expandedInlineSpanCache!),
                Positioned(right: 0, bottom: 0, child: collapseActionWidget),
              ],
            );
          } else {
            body = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text.rich(_expandedInlineSpanCache!),
                collapseActionWidget,
              ],
            );
          }
        } else {
          _ensureCollapsed(width);
          body = Stack(
            children: [
              Text.rich(_collapsedSpanCache!),
              Positioned(right: 0, bottom: 0, child: expandActionWidget),
            ],
          );
        }

        return AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: body,
        );
      },
    );
  }

  Widget _actionWidget(ExpandableTextAction action) {
    final isExpand = action == ExpandableTextAction.expand;
    return Padding(
      padding: EdgeInsets.only(left: widget.actionStartPadding),
      child: GestureDetector(
        onTap: () {
          _toggle();
          widget.onActionPress?.call(action);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: widget.actionIconSpacing,
          children: [
            Text(
              isExpand ? widget.expandActionText : widget.collapseActionText,
              style: widget.baseTextStyle.copyWith(
                decoration: TextDecoration.underline,
              ),
              maxLines: 1,
            ),
            Icon(
              isExpand ? Icons.arrow_downward : Icons.arrow_upward,
              size: widget.actionIconSize,
              color: widget.baseTextStyle.color,
            ),
          ],
        ),
      ),
    );
  }

  InlineSpan _getBaseText() {
    return TextSpan(text: widget.text, style: widget.baseTextStyle);
  }

  void _ensureOverflowInfo(double width) {
    if (_originalOverflowed != null) return;
    final tp = TextPainter(
      text: _getBaseText(),
      maxLines: widget.maxLines,
      textDirection: textDirection,
    )..layout(maxWidth: width);
    _originalOverflowed = tp.didExceedMaxLines;
  }

  void _ensureCollapsed(double width) {
    if (_collapsedSpanCache != null) return;

    final dimensions = _getActionButtonDimensions(
      width,
      ExpandableTextAction.expand,
    );
    final actionButtonWidth = dimensions[0].size.width.toInt();

    final tp = TextPainter(
      text: _getBaseText(),
      maxLines: widget.maxLines,
      textDirection: textDirection,
    )..layout(maxWidth: width);

    final index = tp.getPositionForOffset(
      Offset(
        width - actionButtonWidth,
        widget.maxLines * tp.preferredLineHeight,
      ),
    );

    debugPrint(
      'collapsed cut index $index, width=$width, btnWidth=$actionButtonWidth',
    );

    final ellipsisChar = '\u2026';
    _collapsedSpanCache = TextSpan(
      text: widget.text.substring(0, index.offset - 1) + ellipsisChar,
      style: widget.baseTextStyle,
    );
  }

  List<PlaceholderDimensions> _getActionButtonDimensions(
    double width,
    ExpandableTextAction action,
  ) {
    final actionText = action == ExpandableTextAction.expand
        ? widget.expandActionText
        : widget.collapseActionText;
    final tp = TextPainter(
      text: TextSpan(text: actionText, style: widget.baseTextStyle),
      maxLines: null,
      textDirection: textDirection,
    )..layout(maxWidth: width);

    final actionWidgetWidth =
        tp.width +
        widget.actionStartPadding +
        widget.actionIconSpacing +
        widget.actionIconSize;
    debugPrint('action btn width=$actionWidgetWidth, textWidth=${tp.width}');
    return [
      PlaceholderDimensions(
        size: Size(actionWidgetWidth, tp.height),
        alignment: PlaceholderAlignment.middle,
      ),
    ];
  }

  void _ensureExpandedInline(double width, Widget collapseActionWidget) {
    if (_expandedInlineFits != null) return;

    final baseTextSpan = _getBaseText();
    final collapseActionWidgetSpan = WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: collapseActionWidget,
    );

    final baseTp = TextPainter(
      text: baseTextSpan,
      maxLines: null,
      textDirection: textDirection,
    )..layout(maxWidth: width);
    final baseLines = baseTp.computeLineMetrics().length;

    final dimensions = _getActionButtonDimensions(
      width,
      ExpandableTextAction.collapse,
    );
    final testTp =
        TextPainter(
            text: TextSpan(children: [baseTextSpan, collapseActionWidgetSpan]),
            maxLines: null,
            textDirection: textDirection,
          )
          ..setPlaceholderDimensions(dimensions)
          ..layout(maxWidth: width);
    final testLines = testTp.computeLineMetrics().length;

    _expandedInlineFits = testLines == baseLines;
    _expandedInlineSpanCache = baseTextSpan;
  }
}

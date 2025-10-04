# ExpandableText

A customizable Flutter widget that displays text with elegant expandable/collapsible functionality and action buttons seamlessly integrated in the bottom-right corner.


> [!CAUTION]
> Can only work with `useMaterial3 = false`, see [TextPainter behavior no longer matches Text behavior, when useMaterial3 is true](https://github.com/flutter/flutter/issues/141172).

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  expandable_text: ^1.0.0
```

## Usage

### Basic Example

```dart
import 'package:expandable_text/expandable_text.dart';

ExpandableText(
  text: 'Your long text goes here...',
  expandActionText: 'Read More',
  collapseActionText: 'Read Less',
  baseTextStyle: TextStyle(fontSize: 16, color: Colors.black),
  maxLines: 2,
  onActionPress: (action) {
    print(action == ExpandableTextAction.expand 
        ? 'Expanded' 
        : 'Collapsed');
  },
)
```

### Advanced Customization

```dart
ExpandableText(
  text: 'Very long text content that needs to be truncated...',
  expandActionText: 'Show more',
  collapseActionText: 'Show less', 
  baseTextStyle: TextStyle(
    fontSize: 14,
    color: Colors.grey[800],
    fontWeight: FontWeight.w400,
  ),
  maxLines: 3,
  textDirection: TextDirection.rtl, // For RTL languages
  onActionPress: (action) {
    // Handle expand/collapse actions
    if (action == ExpandableTextAction.expand) {
      // Analytics tracking, etc.
    }
  },
)
```

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## License

[MIT License](./LICENSE)


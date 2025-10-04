import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ExpandableText Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            _buildDemoSection(
              'Basic Example',
              'This is a very long text that will be truncated and show a "Read More" button when it exceeds the maximum line limit. The button will appear neatly in the bottom-right corner.',
            ),
            _buildDemoSection(
              'Custom Styling',
              'You can customize the text style and action labels. This example uses different colors and labels for the expand/collapse actions.',
              expandText: 'Show more',
              collapseText: 'Show less',
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.purple,
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildDemoSection(
              'Short Text',
              'This text is short and won\'t show the expand button.',
            ),
            _buildDemoSection(
              'Very Long Text Example',
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. '
                  'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
              maxLines: 3,
            ),
            _buildDemoSection(
              'Perform Action On Whole Text Example',
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. '
                  'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
              maxLines: 3,
              performActionOnWholeText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoSection(
    String title,
    String content, {
    String expandText = 'Read More',
    String collapseText = 'Read Less',
    TextStyle? textStyle,
    int maxLines = 2,
    bool performActionOnWholeText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ExpandableText(
            text: content,
            expandActionText: expandText,
            collapseActionText: collapseText,
            baseTextStyle:
                textStyle ??
                const TextStyle(fontSize: 14, color: Colors.black87),
            maxLines: maxLines,
            performActionOnWholeText: performActionOnWholeText,
            onActionPress: (action) {
              debugPrint('Action pressed: $action');
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:snap_local/common/utils/helper/linkfy_handler.dart';

class SelectableLinkifyText extends StatelessWidget {
  const SelectableLinkifyText({
    super.key,
    required this.text,
    this.textStyle,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? textStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return SelectableLinkify(
      text: text,
      contextMenuBuilder: (context, editableTextState) {
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: <ContextMenuButtonItem>[
            ContextMenuButtonItem(
              onPressed: () {
                editableTextState.copySelection(SelectionChangedCause.toolbar);
              },
              type: ContextMenuButtonType.copy,
            ),
            ContextMenuButtonItem(
              onPressed: () {
                editableTextState.selectAll(SelectionChangedCause.toolbar);
              },
              type: ContextMenuButtonType.selectAll,
            ),
          ],
        );
      },
      maxLines: maxLines,
      // overflow: overflow,
      style: textStyle,
      linkStyle: const TextStyle(color: Colors.blue),
      options: const LinkifyOptions(humanize: false),
      onOpen: (link) => LinkfyHandler().onLinkTap(
        context,
        url: link.url,
      ),
    );
  }
}

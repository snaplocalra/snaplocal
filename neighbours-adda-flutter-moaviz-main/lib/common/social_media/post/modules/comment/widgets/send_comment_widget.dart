import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:flutter/material.dart';

class SendCommentWidget extends StatefulWidget {
  final String? hint;
  final FocusNode? focusNode;
  final bool closeKeyboardAfterMessageSend;
  final bool enable;
  final TextEditingController textController;
  final void Function(String message) onCommentSend;
  final void Function(String)? onChanged;
  const SendCommentWidget({
    super.key,
    required this.onCommentSend,
    required this.textController,
    this.closeKeyboardAfterMessageSend = false,
    this.enable = true,
    this.focusNode,
    this.hint,
    this.onChanged,
  });

  @override
  State<SendCommentWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ThemeTextFormField(
                enabled: widget.enable,
                focusNode: widget.focusNode,
                controller: widget.textController,
                hint: widget.hint ?? "Write a comment...",
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 4,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                fillColor: Colors.grey.shade100,
                hintStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                onChanged: (text) {
                  setState(() {});
                  if (widget.onChanged != null) {
                    widget.onChanged!.call(text);
                  }
                },
              ),
            ),
            const SizedBox(width: 5),
            StatefulBuilder(builder: (context, buttonState) {
              return Visibility(
                visible: widget.textController.text.trim().isNotEmpty,
                child: GestureDetector(
                  onTap: !widget.enable
                      ? null
                      : () {
                          if (widget.textController.text.trim().isNotEmpty) {
                            if (widget.closeKeyboardAfterMessageSend) {
                              FocusScope.of(context).unfocus();
                              //unfocus from the parent focus node
                              widget.focusNode?.unfocus();
                            }
                            buttonState(() {
                              widget.onCommentSend
                                  .call(widget.textController.text.trim());
                              widget.textController.clear();
                            });
                          }
                        },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

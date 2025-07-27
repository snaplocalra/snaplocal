// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:designer/widgets/theme_spinner.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class SearchTextField extends StatefulWidget {
  final String? hint;
  final FocusNode? focusNode;
  final bool dataLoading;
  final void Function(String text) onQuery;
  final int waitingMilliSeconds;
  final TextEditingController? controller;
  final Widget? extraSuffixIcon;
  final Color? fillColor;
  final Color? searchIconColor;
  const SearchTextField({
    super.key,
    this.hint,
    this.focusNode,
    this.waitingMilliSeconds = 500,
    this.dataLoading = false,
    required this.onQuery,
    this.controller,
    this.extraSuffixIcon,
    this.fillColor,
    this.searchIconColor,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController searchController =
      widget.controller ?? TextEditingController();

  Timer? timer;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, textFieldState) {
      return ThemeTextFormField(
        focusNode: widget.focusNode,
        controller: searchController,
        keyboardType: TextInputType.text,
        fillColor: widget.fillColor ?? const Color.fromRGBO(249, 249, 249, 1),
        hint: widget.hint != null ? tr(widget.hint!) : null,
        hintStyle: const TextStyle(fontSize: 14),
        style: const TextStyle(fontSize: 14),
        prefixIcon: Icon(
          FeatherIcons.search,
          color:
              widget.searchIconColor ?? const Color.fromRGBO(193, 193, 194, 1),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (searchController.text.isNotEmpty)
              widget.dataLoading
                  ? const SizedBox(
                      width: 20,
                      child: ThemeSpinner(size: 25),
                    )
                  : GestureDetector(
                      onTap: searchController.text.trim().isEmpty
                          ? null
                          : () {
                              searchController.clear();
                              FocusScope.of(context).unfocus();
                              widget.onQuery.call("");
                            },
                      child: const Icon(Icons.cancel),
                    ),
            if (widget.extraSuffixIcon != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: widget.extraSuffixIcon!,
              ),
          ],
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            if (timer != null && timer!.isActive) {
              timer!.cancel();
            }
            widget.onQuery.call(value);
          } else {
            if (timer != null && timer!.isActive) {
              timer!.cancel();
            }
            timer =
                Timer(Duration(milliseconds: widget.waitingMilliSeconds), () {
              // Call method here after defined milliseconds of no activity in the text field
              widget.onQuery.call(value);
            });
          }
          textFieldState(() {});
        },
        validator: (text) => TextFieldValidator.standardValidator(text),
      );
    });
  }
}

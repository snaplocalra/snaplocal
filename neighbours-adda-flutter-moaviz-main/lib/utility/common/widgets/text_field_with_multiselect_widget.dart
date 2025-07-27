import 'dart:async';

import 'package:designer/widgets/theme_type_ahed_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class TextFieldWithMultiSelectWidget<T> extends StatefulWidget {
  final String heading;
  final bool showStarMark;
  final bool showOptional;
  final bool enabled;
  final String hint;
  final FutureOr<List<T>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, T?) itemBuilder;
  final void Function(T?) onSuggestionSelected;
  final List<T> selectedItems;
  final String noItemFoundText;
  final Widget Function(BuildContext, int) gridItemBuilder;
  final Widget Function(
    SuggestionsController<T>? suggestionsBoxController,
    String text,
  )? custonNoItemsFoundBuilder;
  final int? maxLength;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldWithMultiSelectWidget({
    super.key,
    required this.heading,
    this.showStarMark = false,
    this.showOptional = false,
    this.enabled = true,
    this.custonNoItemsFoundBuilder,
    required this.hint,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.onSuggestionSelected,
    required this.selectedItems,
    this.noItemFoundText = LocaleKeys.noItemFound,
    required this.gridItemBuilder,
    this.maxLength,
    required this.controller,
    this.inputFormatters,
  });

  @override
  State<TextFieldWithMultiSelectWidget<T>> createState() =>
      _TextFieldWithMultiSelectWidgetState<T>();
}

class _TextFieldWithMultiSelectWidgetState<T>
    extends State<TextFieldWithMultiSelectWidget<T>> {
  final SuggestionsController<T> _suggestionsBoxController =
      SuggestionsController();
  @override
  void dispose() {
    _suggestionsBoxController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFieldWithHeading(
          textFieldHeading: widget.heading,
          showStarMark: widget.showStarMark,
          showOptional: widget.showOptional,
          child: ThemeTypeAheadFormField<T>(
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            suggestionsController: _suggestionsBoxController,
            direction: VerticalDirection.up,
            enabled: widget.enabled,
            controller: widget.controller,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            hint: widget.hint,
            style: const TextStyle(fontSize: 14),
            hintStyle: const TextStyle(fontSize: 14),
            suggestionsCallback: widget.suggestionsCallback,
            itemBuilder: widget.itemBuilder,
            onSuggestionSelected: widget.onSuggestionSelected,
            noItemsFoundBuilder: (context) {
              if (widget.custonNoItemsFoundBuilder != null) {
                //Close the suggestion box
                return widget.controller.text.trim().isEmpty
                    ? const SizedBox.shrink()
                    : widget.custonNoItemsFoundBuilder!(
                        _suggestionsBoxController,
                        widget.controller.text,
                      );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tr(widget.noItemFoundText),
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }
            },
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.only(top: 5),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 2,
            childAspectRatio: 3,
          ),
          itemCount: widget.selectedItems.length,
          itemBuilder: widget.gridItemBuilder,
        )
      ],
    );
  }
}

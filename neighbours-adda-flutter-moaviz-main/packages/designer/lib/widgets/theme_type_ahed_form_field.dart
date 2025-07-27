// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ThemeTypeAheadFormField<T> extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;
  final String? hint;
  final int? maxLines;
  final bool enabled;
  final void Function()? onTap;
  final Widget Function(BuildContext context, T? snapshot) itemBuilder;
  final void Function(T? selecteditem) onSuggestionSelected;
  final FutureOr<List<T>> Function(String query) suggestionsCallback;
  final Widget Function(BuildContext context)? noItemsFoundBuilder;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final OutlineInputBorder? activeBorderStyle;
  final OutlineInputBorder? deActiveBorderStyle;
  final VerticalDirection direction;
  final SuggestionsController<T>? suggestionsController;
  final int? maxLength;

  const ThemeTypeAheadFormField({
    super.key,

    //This text controller is mandatory for the type ahead field to run the suggestions callback
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.hint,
    this.maxLines = 1,
    this.enabled = true,
    this.onTap,
    required this.itemBuilder,
    required this.onSuggestionSelected,
    required this.suggestionsCallback,
    this.noItemsFoundBuilder,
    this.suffixIcon,
    this.hintStyle,
    this.style,
    this.prefixIcon,
    this.contentPadding,
    this.borderRadius,
    this.activeBorderStyle,
    this.deActiveBorderStyle,
    this.direction = VerticalDirection.down,
    this.suggestionsController,
    this.maxLength,
  });

  @override
  State<ThemeTypeAheadFormField<T>> createState() =>
      _ThemeTypeAheadFormFieldState<T>();
}

class _ThemeTypeAheadFormFieldState<T>
    extends State<ThemeTypeAheadFormField<T>> {
  late OutlineInputBorder activeBorderStyle;
  late OutlineInputBorder deActiveBorderStyle;
  @override
  void initState() {
    super.initState();

    activeBorderStyle = widget.activeBorderStyle ??
        OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
        );

    deActiveBorderStyle = widget.deActiveBorderStyle ??
        OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
        );
  }

  @override
  Widget build(BuildContext context) => TypeAheadField<T>(
        autoFlipDirection: true,
        direction: widget.direction,
        itemBuilder: widget.itemBuilder,
        onSelected: widget.onSuggestionSelected,
        suggestionsCallback: widget.suggestionsCallback,
        controller: widget.controller,
        suggestionsController: widget.suggestionsController,
        emptyBuilder: widget.noItemsFoundBuilder,
        builder: (context, controller, focusNode) => TextFormField(
          focusNode: focusNode,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          controller: widget.controller,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          onTap: widget.onTap,
          style: widget.style,
          decoration: InputDecoration(
            contentPadding: widget.contentPadding,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            hintText: widget.hint,
            hintStyle: widget.hintStyle,
            filled: true,
            fillColor: Colors.white,
            focusedBorder: activeBorderStyle,
            enabledBorder: deActiveBorderStyle,
            focusedErrorBorder: activeBorderStyle,
            errorBorder: deActiveBorderStyle,
            disabledBorder: deActiveBorderStyle,
          ),
          validator: widget.validator,
        ),
      );
}

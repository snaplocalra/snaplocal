// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ThemeTextFormFieldDropDown<T> extends StatefulWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(T?)? validator;
  final String? label;
  final String? hint;
  final int? maxLines;
  final Widget? prefixIcon;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Color? fillColor;
  final TextStyle? style;
  final double? borderRadius;
  final OutlineInputBorder? activeBorderStyle;
  final OutlineInputBorder? deActiveBorderStyle;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? textFieldPadding;

  const ThemeTextFormFieldDropDown({
    super.key,
    required this.items,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.label,
    this.hint,
    this.borderRadius,
    this.prefixIcon,
    this.maxLines = 1,
    this.value,
    this.hintStyle,
    this.labelStyle,
    this.fillColor,
    this.style,
    this.activeBorderStyle,
    this.deActiveBorderStyle,
    this.contentPadding,
    this.textFieldPadding,
  });

  @override
  State<ThemeTextFormFieldDropDown<T>> createState() =>
      _ThemeTextFormFieldDropDownState<T>();
}

class _ThemeTextFormFieldDropDownState<T>
    extends State<ThemeTextFormFieldDropDown<T>> {
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
  Widget build(BuildContext context) => Padding(
        padding: widget.textFieldPadding == null
            ? EdgeInsets.zero
            : widget.textFieldPadding!,
        child: DropdownButtonFormField<T>(
          value: widget.value,
          items: widget.items,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            prefixIcon: widget.prefixIcon,
            labelText: widget.label,
            hintText: widget.hint,
            hintStyle: widget.hintStyle,
            labelStyle: widget.labelStyle,
            filled: true,
            fillColor: widget.fillColor ?? Colors.white,
            focusedBorder: activeBorderStyle,
            enabledBorder: deActiveBorderStyle,
            focusedErrorBorder: activeBorderStyle,
            errorBorder: deActiveBorderStyle,
            disabledBorder: deActiveBorderStyle,
          ),
        ),
      );
}

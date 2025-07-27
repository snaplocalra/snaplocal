// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeTextFormField extends StatefulWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String? text)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;
  final String? label;
  final String? hint;
  final int? maxLines;
  final int? minLines;
  final bool? enabled;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final bool readOnly;
  final bool obscureText;
  final int? maxLength;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? textFieldPadding;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final Color? fillColor;
  final OutlineInputBorder? activeBorderStyle;
  final OutlineInputBorder? deActiveBorderStyle;
  final FocusNode? focusNode;

  const ThemeTextFormField({
    super.key,
    this.initialValue,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.maxLines = 1,
    this.minLines = 1,
    this.textCapitalization = TextCapitalization.words,
    this.label,
    this.hint,
    this.enabled,
    this.onTap,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLength,
    this.borderRadius,
    this.contentPadding,
    this.textFieldPadding,
    this.hintStyle,
    this.labelStyle,
    this.style,
    this.fillColor,
    this.activeBorderStyle,
    this.deActiveBorderStyle,
    this.focusNode,
  });

  @override
  State<ThemeTextFormField> createState() => _ThemeTextFormFieldState();
}

class _ThemeTextFormFieldState extends State<ThemeTextFormField> {
  late OutlineInputBorder activeBorderStyle;
  late OutlineInputBorder deActiveBorderStyle;

  String? initialValue;

  @override
  void initState() {
    super.initState();
    initialValue = widget.initialValue;
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
  void didUpdateWidget(covariant ThemeTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      initialValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: widget.textFieldPadding == null
            ? EdgeInsets.zero
            : widget.textFieldPadding!,
        child: TextFormField(
          focusNode: widget.focusNode,
          initialValue: initialValue,
          
          maxLength: widget.maxLength,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          onChanged: widget.onChanged,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          onTap: widget.onTap,
          style: widget.style,
          decoration: InputDecoration(
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            suffixIcon: widget.suffixIcon,
            prefix: widget.prefix,
            prefixIcon: widget.prefixIcon,
            hintText: widget.hint,
            hintStyle: widget.hintStyle,
            labelStyle: widget.labelStyle,
            labelText: widget.label,
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

import 'package:client/src/theme/custom_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum RequiredFormat {
  required,
  optional,
}

class InputField extends StatelessWidget {
  final String? label;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final bool? enableSuggestions;
  final bool? autocorrect;
  final double? marginBottom;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final int? minLines;
  final RequiredFormat? requiredFormat;
  final String? hintText;
  final bool? enabled;
  final List<String>? autofillHints;
  final bool? readOnly;
  final double? cursorHeight;
  final double? cursorWidth;
  final String? initialValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onEditingComplete;

  const InputField({
    super.key,
    this.label,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.enableSuggestions,
    this.autocorrect,
    this.marginBottom,
    this.controller,
    this.validator,
    this.minLines,
    this.decoration,
    this.requiredFormat,
    this.hintText,
    this.enabled,
    this.autofillHints,
    this.readOnly,
    this.cursorHeight,
    this.cursorWidth,
    this.initialValue,
    this.keyboardType,
    this.inputFormatters,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom ?? 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label != null
              ? InputLabel(
                  label: label,
                  requiredFormat: requiredFormat,
                )
              : const SizedBox(),
          StyledTextField(
            obscureText: obscureText,
            enableSuggestions: enableSuggestions,
            autocorrect: autocorrect,
            onChanged: onChanged,
            controller: controller,
            minLines: minLines,
            validator: validator,
            decoration: decoration,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: hintText,
            enabled: enabled,
            autofillHints: autofillHints,
            readOnly: readOnly,
            cursorHeight: cursorHeight,
            cursorWidth: cursorWidth,
            initialValue: initialValue,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onEditingComplete: onEditingComplete,
          ),
        ],
      ),
    );
  }
}

class StyledTextField extends StatelessWidget {
  const StyledTextField({
    super.key,
    this.obscureText,
    this.enableSuggestions,
    this.autocorrect,
    this.onChanged,
    this.controller,
    this.minLines,
    this.validator,
    this.decoration,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.hintText,
    this.enabled,
    this.autofillHints,
    this.readOnly,
    this.cursorHeight,
    this.cursorWidth,
    this.initialValue,
    this.keyboardType,
    this.inputFormatters,
    this.onEditingComplete,
  });

  final bool? obscureText;
  final bool? enableSuggestions;
  final bool? autocorrect;
  final Function(String p1)? onChanged;
  final TextEditingController? controller;
  final int? minLines;
  final String? Function(String? p1)? validator;
  final InputDecoration? decoration;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final String? hintText;
  final bool? enabled;
  final List<String>? autofillHints;
  final bool? readOnly;
  final double? cursorHeight;
  final double? cursorWidth;
  final String? initialValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: onEditingComplete,
      inputFormatters: inputFormatters,
      initialValue: initialValue,
      enabled: enabled,
      autofillHints: autofillHints,
      obscureText: obscureText ?? false,
      enableSuggestions: enableSuggestions ?? true,
      autocorrect: autocorrect ?? true,
      onChanged: onChanged,
      controller: controller,
      minLines: minLines,
      maxLines: minLines ?? 1,
      validator: validator,
      focusNode: focusNode,
      readOnly: readOnly ?? false,
      cursorHeight: cursorHeight,
      cursorWidth: cursorWidth ?? 2.0,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyMedium?.merge(
            const TextStyle(
              fontWeight: FontWeight.w500,
              color: CustomPalette.text,
            ),
          ),
      decoration: inputDecoration.copyWith(
        enabled: decoration?.enabled,
        errorText: decoration?.errorText,
        errorStyle: decoration?.errorStyle,
        errorMaxLines: decoration?.errorMaxLines,
        floatingLabelBehavior: decoration?.floatingLabelBehavior,
        floatingLabelStyle: decoration?.floatingLabelStyle,
        helperMaxLines: decoration?.helperMaxLines,
        helperStyle: decoration?.helperStyle,
        helperText: decoration?.helperText,
        isCollapsed: decoration?.isCollapsed,
        isDense: decoration?.isDense,
        focusedBorder: decoration?.focusedBorder,
        focusedErrorBorder: decoration?.focusedErrorBorder,
        fillColor: decoration?.fillColor,
        focusColor: decoration?.focusColor,
        hoverColor: decoration?.hoverColor,
        icon: decoration?.icon,
        labelStyle: decoration?.labelStyle,
        labelText: decoration?.labelText,
        prefix: decoration?.prefix,
        prefixIconConstraints: decoration?.prefixIconConstraints,
        prefixStyle: decoration?.prefixStyle,
        suffix: decoration?.suffix,
        suffixIconConstraints: decoration?.suffixIconConstraints,
        suffixStyle: decoration?.suffixStyle,
        filled: !(enabled ?? true),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: hintText,
        contentPadding: decoration?.contentPadding,
      ),
    );
  }
}

class InputLabel extends StatelessWidget {
  const InputLabel({
    super.key,
    required this.label,
    this.requiredFormat,
    this.style,
    this.paddingBottom,
  });

  final String? label;
  final RequiredFormat? requiredFormat;
  final TextStyle? style;
  final double? paddingBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom ?? 5, left: 1),
      child: Row(
        children: [
          Text(
            label ?? "",
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyMedium?.merge(
                  const TextStyle(
                    color: CustomPalette.text,
                    fontWeight: FontWeight.w500,
                  ).merge(style),
                ),
          ),
          requiredFormat != null
              ? Text(
                  requiredFormat == RequiredFormat.required
                      ? "*"
                      : " (optional)",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.merge(
                        TextStyle(
                          color: requiredFormat == RequiredFormat.required
                              ? CustomPalette.error
                              : CustomPalette.primary[50],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}

// final inputDecoration =
final inputDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(6.7),
    borderSide: BorderSide(
      color: CustomPalette.primary[100] as Color,
      style: BorderStyle.solid,
      width: 1,
    ),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      color: CustomPalette.primary,
      style: BorderStyle.solid,
      width: 1,
    ),
  ),
  errorBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      color: CustomPalette.error,
      style: BorderStyle.solid,
      width: 1,
    ),
  ),
  focusedErrorBorder: const OutlineInputBorder(
    borderSide: BorderSide(
      color: CustomPalette.error,
      style: BorderStyle.solid,
      width: 1,
    ),
  ),
  contentPadding: const EdgeInsets.all(8),
  fillColor: CustomPalette.white[900],
  hintStyle: TextStyle(color: CustomPalette.primary[50] as Color, fontSize: 14),
);

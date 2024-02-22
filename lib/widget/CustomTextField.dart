import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFields extends StatefulWidget {
  const CustomTextFields({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.disableOrEnable,
    this.labelText,
    required this.borderColor,
    required this.filled,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool disableOrEnable;
  final int borderColor;
  final bool filled;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconPressed;

  @override
  State<CustomTextFields> createState() => _CustomTextFieldsState();
}

class _CustomTextFieldsState extends State<CustomTextFields> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFFFFFFFF)),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            enabled: widget.disableOrEnable,
            filled: widget.filled,
            suffixIcon: widget.suffixIcon != null
                ? GestureDetector(
              onTap: widget.onSuffixIconPressed,
              child: widget.suffixIcon!,
            )
                : null,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon) // Wrap the IconData in an Icon widget
                : null,
            hintText: widget.hintText,
            labelText: widget.labelText,
            labelStyle: TextStyle(color: Colors.black),
          ),
          style: TextStyle(color: Colors.black),
          maxLines: 1,
          minLines: 1,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
        ),
      ),
    );
  }

  List<TextInputFormatter> _getInputFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
    ];
  }
}

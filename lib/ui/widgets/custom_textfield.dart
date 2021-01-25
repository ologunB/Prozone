import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliance_app/constants/styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final FocusNode focusNode;
  final int maxLength;
  final int maxLines;
  final bool enabled;
  final bool autoFocus;
  final String labelText;
  final String hintText;
  final Widget suffixIcon;
  final Function(String) validator;
  final Function(String) onChanged;

  const CustomTextField(
      {Key key,
      this.controller,
      this.enabled = true,
      this.autoFocus = false,
      this.inputType,
      this.inputAction,
      this.focusNode,
      this.maxLength,
      this.maxLines,
      this.labelText,
      this.suffixIcon,
      this.validator,
      this.onChanged,
      this.hintText})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.inputType,
      controller: widget.controller,
      textInputAction: widget.inputAction,
      maxLength: widget.maxLength,
      autofocus: widget.autoFocus,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      cursorColor: Colors.black,
      style:
          GoogleFonts.nunito(color: Styles.colorBlack, fontWeight: FontWeight.w600, fontSize: 16),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        labelText: widget.labelText,
        fillColor: Styles.colorGrey.withOpacity(0.05),
        filled: true,
        hintStyle:
            GoogleFonts.nunito(color: Styles.colorGrey, fontWeight: FontWeight.w600, fontSize: 16),
        hintText: widget.hintText,
        labelStyle:
            GoogleFonts.nunito(color: Styles.colorGrey, fontWeight: FontWeight.w600, fontSize: 16),
        errorStyle: TextStyle(
          color: Color(0xff222222),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Styles.colorPurple, width: 1.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Styles.colorBlack.withOpacity(0.2), width: 2),
        ),
        border: OutlineInputBorder(),
        counterText: '',
      ),
      validator: widget.validator,
    );
  }
}

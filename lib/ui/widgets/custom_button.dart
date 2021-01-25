import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class CustomButton extends StatefulWidget {
  final double height;
  final double width;
  final Function onPressed;
  final bool busy;
  final Color textColor;
  final Color buttonColor;
  final String title;
  final double fontSize;

  const CustomButton(
      {Key key,
      this.height,
      this.width,
      this.onPressed,
      this.busy = false,
      this.textColor,
      this.buttonColor,
      this.title,
      this.fontSize})
      : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.busy ? null : widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              color: Color(0x20000000),
              spreadRadius: 0.0,
              offset: Offset(3.5, 5.0),
            ),
          ],
          color: widget.busy
              ? widget.buttonColor.withOpacity(0.5)
              : widget.buttonColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.busy
                ? Platform.isIOS
                    ? CupertinoActivityIndicator(radius: 12)
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                : Text(
                    widget.title.toUpperCase(),
                    style: GoogleFonts.nunito(
                        letterSpacing: 1,
                        color: widget.textColor,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.bold),
                  ),
          ],
        ),
      ),
    );
  }
}

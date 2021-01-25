import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliance_app/constants/styles.dart';
import 'package:reliance_app/model/dialog_model.dart';

import '../locator.dart';
import 'dialog_service.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;
    var isFunction = request.onOkayClicked != null;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          request.title,
          style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(
          request.description,
          style: GoogleFonts.nunito(
              fontSize: 16, fontWeight: FontWeight.w600, color: Styles.colorGrey),
        ),
        actions: <Widget>[
          if (isConfirmationDialog)
            GestureDetector(
              onTap: () {
                _dialogService.dialogComplete(
                  DialogResponse(confirmed: false),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  request.cancelTitle,
                  style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: Styles.colorPurple,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          GestureDetector(
            onTap: isFunction
                ? request.onOkayClicked
                : () {
                    _dialogService.dialogComplete(
                      DialogResponse(confirmed: true),
                    );
                  },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Styles.appCanvasYellow),
              child: Text(
                request.buttonTitle,
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    letterSpacing: 1,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliance_app/constants/consts.dart';
import 'package:reliance_app/constants/styles.dart';
import 'package:reliance_app/model/provider_model.dart';
import 'package:reliance_app/ui/widgets/custom_button.dart';
import 'package:reliance_app/ui/widgets/custom_textfield.dart';
import 'package:reliance_app/ui/widgets/snackbar.dart';
import 'package:reliance_app/utils/base_view.dart';
import 'package:reliance_app/utils/spacing.dart';
import 'package:reliance_app/utils/util.dart';
import 'package:reliance_app/view_models/providers_vm.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AddProviderScreen extends StatefulWidget {
  @override
  _AddProviderScreenState createState() => _AddProviderScreenState();
}

class _AddProviderScreenState extends State<AddProviderScreen> {
  String statusSelected;
  ProviderType providerTypeSelected;
  StatesModel stateSelected;
  double ratingSelected = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<ProvidersViewModel>(
        onModelReady: (model) {},
        builder: (context, model, _) => GestureDetector(
              onTap: () => Util.offKeyboard(context),
              child: Scaffold(
                appBar: AppBar(
                    title: Text(
                      "Add Provider",
                      style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    iconTheme: IconThemeData(color: Colors.black),
                    centerTitle: true,
                    elevation: 2),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10,
                        spreadRadius: 8,
                        offset: Offset(0.0, 3.0)),
                  ]),
                  padding: EdgeInsets.all(12),
                  child: SafeArea(
                    child: CustomButton(
                      title: "confirm",
                      busy: model.busy,
                      buttonColor: Styles.appCanvasYellow,
                      textColor: Styles.colorBlack,
                      fontSize: 14,
                      height: 50,
                      width: screenWidth(context),
                      onPressed: () {
                        Util.offKeyboard(context);
                        if (isValid()) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Are you sure you want to add this provider?",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                            child: Text(
                                              "NO",
                                              style: GoogleFonts.nunito(
                                                  fontSize: 12,
                                                  color: Styles.colorPurple,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        horizontalSpaceMedium,
                                        InkWell(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            Map data = {
                                              "name": nameController.text,
                                              "description": descController.text,
                                              "rating": ratingSelected.floor(),
                                              "address": addressController.text,
                                              "active_status": statusSelected,
                                              "provider_type": providerTypeSelected.id.toString(),
                                              "state": stateSelected.id.toString()
                                            };
                                            var result = await model.createProvider(data);
                                            if (result == "Success") {
                                              nameController.clear();
                                              descController.clear();
                                              addressController.clear();
                                              ratingSelected = 3;
                                              statusSelected = null;
                                              providerTypeSelected = null;
                                              stateSelected = null;
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            padding:
                                                EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Styles.appCanvasYellow),
                                            child: Text(
                                              "YES",
                                              style: GoogleFonts.nunito(
                                                  fontSize: 12,
                                                  letterSpacing: 1,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                body: SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: ListView(
                      children: [
                        Text("Name",
                            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                        verticalSpaceTiny,
                        CustomTextField(maxLines: 1, controller: nameController),
                        verticalSpaceSmall,
                        Text("Description",
                            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                        verticalSpaceTiny,
                        CustomTextField(maxLines: 3, controller: descController),
                        verticalSpaceSmall,
                        Text("Address",
                            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                        verticalSpaceTiny,
                        CustomTextField(maxLines: 2, controller: addressController),
                        verticalSpaceSmall,
                        Text("Status",
                            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                        verticalSpaceTiny,
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Styles.colorGrey.withOpacity(0.05),
                              border:
                                  Border.all(color: Styles.colorBlack.withOpacity(0.2), width: 2)),
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: DropdownButton<String>(
                            hint: Text(
                              "Select...",
                              style: GoogleFonts.nunito(
                                  fontSize: 14.0,
                                  color: Styles.colorGrey,
                                  fontWeight: FontWeight.w600),
                            ),
                            value: statusSelected,
                            underline: SizedBox(),
                            isExpanded: true,
                            iconEnabledColor: Styles.colorBlue,
                            dropdownColor: Styles.colorWhite,
                            items: ["Pending", "Active"].map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              Util.offKeyboard(context);
                              statusSelected = value;
                              setState(() {});
                            },
                          ),
                        ),
                        verticalSpaceSmall,
                        Text("Provider Type",
                            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                        verticalSpaceTiny,
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Styles.colorGrey.withOpacity(0.05),
                              border:
                                  Border.all(color: Styles.colorBlack.withOpacity(0.2), width: 2)),
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: DropdownButton<ProviderType>(
                            hint: Text(
                              "Select...",
                              style: GoogleFonts.nunito(
                                  fontSize: 14.0,
                                  color: Styles.colorGrey,
                                  fontWeight: FontWeight.w600),
                            ),
                            value: providerTypeSelected,
                            underline: SizedBox(),
                            isExpanded: true,
                            iconEnabledColor: Styles.colorBlue,
                            dropdownColor: Styles.colorWhite,
                            items: allProviderTypes.map((value) {
                              return DropdownMenuItem<ProviderType>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    value.name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              Util.offKeyboard(context);

                              providerTypeSelected = value;

                              setState(() {});
                            },
                          ),
                        ),
                        verticalSpaceSmall,
                        Text("State",
                            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                        verticalSpaceTiny,
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Styles.colorGrey.withOpacity(0.05),
                              border:
                                  Border.all(color: Styles.colorBlack.withOpacity(0.2), width: 2)),
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: DropdownButton<StatesModel>(
                            hint: Text(
                              "Select...",
                              style: GoogleFonts.nunito(
                                  fontSize: 14.0,
                                  color: Styles.colorGrey,
                                  fontWeight: FontWeight.w600),
                            ),
                            value: stateSelected,
                            underline: SizedBox(),
                            isExpanded: true,
                            iconEnabledColor: Styles.colorBlue,
                            dropdownColor: Styles.colorWhite,
                            items: nigeriaStates.map((value) {
                              return DropdownMenuItem<StatesModel>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    value.name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              Util.offKeyboard(context);
                              stateSelected = value;
                              setState(() {});
                            },
                          ),
                        ),
                        verticalSpaceSmall,
                        Text("Rating",
                            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                        verticalSpaceTiny,
                        SmoothStarRating(
                            onRated: (val) => setState(() {
                                  Util.offKeyboard(context);
                                  ratingSelected = val;
                                }),
                            starCount: 5,
                            rating: ratingSelected,
                            size: 50.0,
                            filledIconData: Icons.star,
                            color: Styles.colorBlue,
                            borderColor: Styles.colorBlue,
                            spacing: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  bool isValid() {
    if (nameController.text.isEmpty) {
      showSnackBar(context, "Error", "Name cannot be empty");
      return false;
    } else if (descController.text.isEmpty) {
      showSnackBar(context, "Error", "Description cannot be empty");
      return false;
    } else if (addressController.text.isEmpty) {
      showSnackBar(context, "Error", "Address cannot be empty");
      return false;
    } else if (statusSelected == null) {
      showSnackBar(context, "Error", "Select status");
      return false;
    } else if (providerTypeSelected == null) {
      showSnackBar(context, "Error", "Select a Provider-type");
      return false;
    } else if (stateSelected == null) {
      showSnackBar(context, "Error", "Select a State");
      return false;
    }
    return true;
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reliance_app/constants/consts.dart';
import 'package:reliance_app/constants/styles.dart';
import 'package:reliance_app/model/provider_model.dart';
import 'package:reliance_app/ui/widgets/custom_button.dart';
import 'package:reliance_app/ui/widgets/custom_textfield.dart';
import 'package:reliance_app/ui/widgets/rating_stars.dart';
import 'package:reliance_app/ui/widgets/snackbar.dart';
import 'package:reliance_app/utils/base_view.dart';
import 'package:reliance_app/utils/spacing.dart';
import 'package:reliance_app/utils/util.dart';
import 'package:reliance_app/view_models/providers_vm.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProDetailsScreen extends StatefulWidget {
  final ProvidersModel model;

  const ProDetailsScreen({Key key, this.model}) : super(key: key);

  @override
  _ProDetailsScreenState createState() => _ProDetailsScreenState();
}

class _ProDetailsScreenState extends State<ProDetailsScreen> {
  bool isEditing = false;
  List<File> selectedPictures = [];

  String statusSelected;
  ProviderType providerTypeSelected;
  StatesModel stateSelected;
  int ratingSelected;

  TextEditingController nameController;
  TextEditingController descController;
  TextEditingController addressController;

  @override
  Widget build(BuildContext context) {
    CarouselOptions carouselOptions = CarouselOptions(
      height: MediaQuery.of(context).size.height / 3,
      autoPlay: true,
      enableInfiniteScroll: true,
      enlargeCenterPage: true,
      pauseAutoPlayOnTouch: true,
    );
    return BaseView<ProvidersViewModel>(
        onModelReady: (model) {
          nameController = TextEditingController(text: widget.model.name);
          descController = TextEditingController(text: widget.model.description);
          addressController = TextEditingController(text: widget.model.address);
          stateSelected =
              nigeriaStates.firstWhere((element) => element.id == widget.model.state.id);
          ratingSelected = widget.model.rating;
          providerTypeSelected =
              allProviderTypes.firstWhere((element) => element.id == widget.model.providerType.id);

          statusSelected = widget.model.activeStatus;
        },
        builder: (context, model, _) =>
            Scaffold(
              appBar: AppBar(
                  title: Text(
                    isEditing ? "Edit Provider" : "Provider Details",
                    style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    InkWell(
                        onTap: () => editPackage(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            horizontalSpaceSmall,
                            Text("Edit",
                                style:
                                GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                            horizontalSpaceTiny,
                            Icon(Icons.edit, size: 18),
                            horizontalSpaceSmall
                          ],
                        ))
                  ],
                  iconTheme: IconThemeData(color: Colors.black),
                  centerTitle: true,
                  elevation: 2),
              bottomNavigationBar: isEditing
                  ? SafeArea(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: CustomButton(
                      buttonColor: Styles.appCanvasYellow,
                      textColor: Styles.colorBlack,
                      fontSize: 14,
                      height: 50,
                      busy: model.busy,
                      width: screenWidth(context),
                      title: "Update Provider",
                      onPressed: () async {
                        if (isValid()) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Are you sure you want to update this provider?",
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
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
                                              "rating": ratingSelected,
                                              "address": addressController.text,
                                              "active_status": statusSelected,
                                              "provider_type": providerTypeSelected.id,
                                              "state": stateSelected.id
                                            };

                                            var result = await model.updateDetails(
                                                data, selectedPictures, widget.model.id);
                                            if (result == "Success") {
                                              isEditing = false;
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
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
                      }),
                ),
              )
                  : SizedBox(),
              body: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CarouselSlider(
                      options: carouselOptions,
                      items: widget.model.images.isNotEmpty
                          ? widget.model.images.map((i) {
                        return Builder(
                          builder: (context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: i.url,
                                height: MediaQuery.of(context).size.height / 3.5,
                                placeholder: (context, url) => CupertinoActivityIndicator(
                                  radius: 15,
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            );
                          },
                        );
                      }).toList()
                          : [""].map((i) {
                        return Builder(
                          builder: (context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                "images/placeholder.png",
                                height: MediaQuery.of(context).size.height / 3.5,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  isEditing
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Styles.colorGrey.withOpacity(.5),
                        ),
                        margin: EdgeInsets.all(10),
                        child: InkWell(
                            onTap: () {
                              getImageGallery();
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, size: 40),
                                verticalSpaceTiny,
                                Text("Add Image", style: GoogleFonts.nunito(fontSize: 12))
                              ],
                            )),
                      ),
                      Expanded(
                        child: Container(
                          height: 150,
                          child: ListView.builder(
                              itemCount: selectedPictures.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Image.file(selectedPictures[index]),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            selectedPictures.removeAt(index);
                                            setState(() {});
                                          },
                                          child: Icon(Icons.cancel, color: Colors.red),
                                        ),
                                        Align(
                                            child: Container(
                                              color: Colors.white,
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ));
                              }),
                        ),
                      ),
                    ],
                  )
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(nameController.text ?? "No name",
                                style:
                                GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold)),
                            horizontalSpaceTiny,
                            statusSelected.toLowerCase() == "pending"
                                ? Text(" - pending".toLowerCase(),
                                style:
                                GoogleFonts.nunito(fontSize: 16, color: Styles.colorGrey))
                                : Icon(
                              Icons.check_circle,
                              color: Colors.lightGreen,
                              size: 20,
                            ),
                          ],
                        ),
                        Text(
                          providerTypeSelected.name ?? "No Type",
                          style: GoogleFonts.nunito(
                              fontSize: 18, color: Styles.colorGrey, fontWeight: FontWeight.w600),
                        ),
                        ratingSelected != null
                            ? Row(
                          children: [
                            RatingStar(ratingSelected.toDouble(), 25),
                            horizontalSpaceSmall,
                            Text(
                              "${ratingSelected.toDouble()} / 5.0",
                              style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  color: Styles.colorBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                            : Text(
                          "No rating yet",
                          style: GoogleFonts.nunito(fontSize: 14, color: Styles.colorBlack),
                        ),
                        verticalSpaceSmall,
                        Text(
                          "${addressController.text ?? "No Address"}, ${stateSelected.name ??
                              "No State"}",
                          style: GoogleFonts.nunito(
                              fontSize: 16, color: Styles.colorBlack, fontWeight: FontWeight.w600),
                        ),
                        verticalSpaceMedium,
                        Text(
                          "Description",
                          style: GoogleFonts.nunito(
                              fontSize: 16, color: Styles.colorBlack, fontWeight: FontWeight.bold),
                        ),
                        verticalSpaceTiny,
                        Container(height: 4, width: 50, color: Styles.colorBlue),
                        verticalSpaceSmall,
                        Text(
                          descController.text ?? "No Description",
                          style: GoogleFonts.nunito(
                              fontSize: 14, color: Styles.colorBlack, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  Future getImageGallery() async {
    Util.offKeyboard(context);
    final result = await ImagePicker().getImage(source: ImageSource.gallery);
    File file;
    if (result != null) {
      file = File(result.path);
    } else {
      return;
    }
    selectedPictures.add(file);
    setState(() {});
  }

  editPackage(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(child: StatefulBuilder(
              builder: (context, _setState) {
                return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Edit Details",
                        style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(thickness: 1.5),
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
                            statusSelected = value;
                            print(allProviderTypes.length);
                            setState(() {});
                            _setState(() {});
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
                          items: allProviderTypes
                              .map((value) {
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
                          })
                              .toSet()
                              .toList(),
                          onChanged: (value) {
                            providerTypeSelected = value;
                            setState(() {});
                            _setState(() {});
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
                          items: nigeriaStates
                              .map((value) {
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
                          })
                              .toSet()
                              .toList(),
                          onChanged: (value) {
                            stateSelected = value;
                            setState(() {});
                            _setState(() {});
                          },
                        ),
                      ),
                      verticalSpaceSmall,
                      Text("Rating",
                          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                      verticalSpaceTiny,
                      SmoothStarRating(
                          onRated: (value) => setState(() => ratingSelected = value.toInt()),
                          starCount: 5,
                          rating: ratingSelected.toDouble(),
                          size: 30.0,
                          filledIconData: Icons.star,
                          color: Styles.colorBlue,
                          borderColor: Styles.colorBlue,
                          spacing: 10),
                      Divider(thickness: 1.5),
                    ]);
              },
            )),
            actions: [
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
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(
                          "CANCEL",
                          style: GoogleFonts.nunito(
                              fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    horizontalSpaceMedium,
                    InkWell(
                      onTap: () {
                        isEditing = true;
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), color: Styles.appCanvasYellow),
                        child: Text(
                          "YES",
                          style: GoogleFonts.nunito(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          );
        });
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

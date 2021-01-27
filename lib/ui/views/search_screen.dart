import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliance_app/constants/styles.dart';
import 'package:reliance_app/model/provider_model.dart';
import 'package:reliance_app/ui/views/pro_details_screen.dart';
import 'package:reliance_app/ui/widgets/network_image.dart';
import 'package:reliance_app/ui/widgets/rating_stars.dart';
import 'package:reliance_app/utils/router.dart';
import 'package:reliance_app/utils/spacing.dart';

class SearchScreen extends StatefulWidget {
  final List<ProvidersModel> mainList;

  const SearchScreen({Key key, this.mainList}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchType = "Name";
  List<ProvidersModel> sortedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Styles.colorBlue.withOpacity(0.3),
                border: Border.all(color: Styles.colorBlue.withOpacity(0.3), width: 2)),
            margin: EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: searchType,
                  underline: SizedBox(),
                  iconEnabledColor: Styles.appCanvasYellow,
                  dropdownColor: Styles.colorWhite,
                  items: ["Name", "Location"].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600, color: Styles.colorBlue),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    searchType = value;

                    setState(() {});
                  },
                ),
                Expanded(
                    child: TextFormField(
                  maxLines: 1,
                  autofocus: true,
                  cursorColor: Colors.grey,
                  style: GoogleFonts.nunito(
                      color: Styles.colorBlack, fontWeight: FontWeight.w600, fontSize: 14),
                  onChanged: onSearchUsers,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    hintStyle: GoogleFonts.nunito(
                        color: Styles.colorBlue, fontWeight: FontWeight.w600, fontSize: 14),
                    hintText: "Search ${searchType.toLowerCase()}...",
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    counterText: '',
                  ),
                )),
              ],
            ),
          ),
        ),
        body: sortedList.isEmpty
            ? Container(
                color: Colors.white,
                alignment: Alignment.center,
                height: screenHeight(context),
                child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "images/empty.svg",
                            height: screenWidthFraction(context, dividedBy: 4),
                          ),
                          verticalSpaceMedium,
                          Text(
                            "Unfortunately, the providers are empty.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Styles.colorBlack),
                          ),
                          verticalSpaceSmall,
                        ],
                      ),
                    )))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: sortedList.length,
                    padding: EdgeInsets.zero,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () => moveTo(context, ProDetailsScreen(model: sortedList[index])),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              verticalSpaceSmall,
                              Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Styles.colorGrey.withOpacity(.2),
                                            spreadRadius: 4,
                                            blurRadius: 5)
                                      ],
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: sortedList[index].images.isEmpty
                                              ? Image.asset("images/placeholder.png")
                                              : CachedImage(sortedList[index].images[0].url)),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(sortedList[index].name ?? "No name",
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold)),
                                                  horizontalSpaceTiny,
                                                  sortedList[index].activeStatus.toLowerCase() ==
                                                          "pending"
                                                      ? Text(" - pending".toLowerCase(),
                                                          style: GoogleFonts.nunito(
                                                              fontSize: 12,
                                                              color: Styles.colorGrey))
                                                      : Icon(
                                                          Icons.check_circle,
                                                          color: Colors.lightGreen,
                                                          size: 16,
                                                        ),
                                                ],
                                              ),
                                              Text(
                                                sortedList[index].providerType.name ?? "No Type",
                                                style: GoogleFonts.nunito(
                                                    fontSize: 14,
                                                    color: Styles.colorGrey,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              sortedList[index].rating != null
                                                  ? RatingStar(
                                                      sortedList[index].rating.toDouble(), 15)
                                                  : Text(
                                                      "No rating yet",
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 14, color: Styles.colorBlack),
                                                    ),
                                              Expanded(
                                                child: Text(
                                                  sortedList[index].address +
                                                          ", " +
                                                          sortedList[index].state.name ??
                                                      "No Address",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 14,
                                                      color: Styles.colorBlack,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              verticalSpaceSmall
                            ],
                          ));
                    }),
              ));
  }

  void onSearchUsers(String val) {
    if (widget.mainList != null) {
      val = val.trim();
      if (val.isNotEmpty) {
        sortedList.clear();
        for (var item in widget.mainList) {
          if (searchType.toLowerCase() == "name") {
            if (item.name.toUpperCase().contains(val.toUpperCase())) {
              sortedList.add(item);
            }
          } else {
            if (item.state.name.toUpperCase().contains(val.toUpperCase()) ||
                item.address.toUpperCase().contains(val.toUpperCase())) {
              sortedList.add(item);
            }
          }
        }
        if (sortedList.isEmpty) {
          setState(() {});
          return;
        }
        setState(() {});
      } else {
        sortedList.clear();
        setState(() {
          FocusScope.of(context).unfocus();
        });
      }
    } else {
      return;
    }
  }
}

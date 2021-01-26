import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliance_app/constants/consts.dart';
import 'package:reliance_app/constants/styles.dart';
import 'package:reliance_app/model/provider_model.dart';
import 'package:reliance_app/ui/views/pro_details_screen.dart';
import 'package:reliance_app/ui/views/search_screen.dart';
import 'package:reliance_app/ui/widgets/error_widget.dart';
import 'package:reliance_app/ui/widgets/network_image.dart';
import 'package:reliance_app/ui/widgets/rating_stars.dart';
import 'package:reliance_app/ui/widgets/snackbar.dart';
import 'package:reliance_app/utils/base_view.dart';
import 'package:reliance_app/utils/router.dart';
import 'package:reliance_app/utils/spacing.dart';
import 'package:reliance_app/utils/util.dart';
import 'package:reliance_app/view_models/providers_vm.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedProvider = 100;
  TextEditingController searchController = TextEditingController();
  String searchType = "Name";

  List<ProvidersModel> sortedList;
  int doOnce = 0;
  String filter = "None";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Styles.colorBlue.withOpacity(.5)));
    return BaseView<ProvidersViewModel>(onModelReady: (model) {
      model.getAllProvidersData();
    }, builder: (context, model, _) {
      if (doOnce == 0) {
        if (model.providersList == null) {
          sortedList = null;
        } else {
          sortedList = [];
          sortedList = sortedByType(model.providersList);
          doOnce++;
        }
      }

      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          //get all provider info again
          model.getAllProvidersData();
        },
        child: GestureDetector(
          onTap: () => Util.offKeyboard(context),
          child: Scaffold(
            body: ListView(
              padding: EdgeInsets.only(top: 0, bottom: 100),
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Styles.colorBlue.withOpacity(.8),
                        Styles.colorBlue.withOpacity(.7),
                        Styles.colorBlue.withOpacity(.6)
                      ], begin: Alignment.topRight),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(bottom: false, child: SizedBox()),
                      Text(
                        greeting() + ",",
                        style: GoogleFonts.nunito(
                            fontSize: 24, fontWeight: FontWeight.bold, color: Styles.colorWhite),
                      ),
                      verticalSpaceSmall,
                      Text("Search for a provider via ${searchType.toLowerCase()}",
                          style: GoogleFonts.nunito(
                              fontSize: 18, fontWeight: FontWeight.w600, color: Styles.colorWhite)),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Styles.colorWhite.withOpacity(0.3),
                            border:
                                Border.all(color: Styles.colorWhite.withOpacity(0.3), width: 2)),
                        margin: EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          children: [
                            DropdownButton<String>(
                              value: searchType,
                              underline: SizedBox(),
                              iconEnabledColor: Styles.appCanvasYellow,
                              dropdownColor: Styles.colorGrey,
                              items: ["Name", "Location"].map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white70),
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
                                child: InkWell(
                              onTap: () {
                                if (model.providersList == null) {
                                  showSnackBar(context, "Error", "List is Empty");
                                  return;
                                }
                                moveTo(context, SearchScreen(mainList: model.providersList),
                                    dialog: true);
                              },
                              child: TextFormField(
                                controller: searchController,
                                maxLines: 1,
                                cursorColor: Colors.grey,
                                enabled: false,
                                style: GoogleFonts.nunito(
                                    color: Styles.colorBlack,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                                onChanged: (a) {},
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  hintStyle: GoogleFonts.nunito(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                  hintText: "Search ${searchType.toLowerCase()}...",
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                      verticalSpaceSmall,
                      sortedList == null
                          ? SizedBox()
                          : Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                setState(() {
                                  selectedProvider = 100;
                                  if (model.providersList == null) {
                                    sortedList = null;
                                  } else {
                                    filter = "None";
                                    sortedList = [];
                                    sortedList = sortedByType(model.providersList);
                                    setState(() {});
                                  }
                                }),
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                margin: EdgeInsets.only(top: 6, bottom: 6, right: 10),
                                decoration: BoxDecoration(
                                    color: selectedProvider == 100 ? Styles.colorBlue : null,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    selectedProvider == 100
                                        ? Container(
                                        height: 6,
                                        width: 6,
                                        margin: EdgeInsets.only(right: 10, left: 5),
                                        decoration: BoxDecoration(
                                            color: Styles.appCanvasYellow,
                                            borderRadius: BorderRadius.circular(3)))
                                        : SizedBox(),
                                    Text(
                                      "All" +
                                          "${selectedProvider == 100
                                              ? " (${sortedList.length})"
                                              : ""}",
                                      style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          color: selectedProvider == 100
                                              ? Styles.colorWhite
                                              : Colors.white54,
                                          fontWeight: selectedProvider == 100
                                              ? FontWeight.bold
                                              : null),
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                            child: Container(
                              height: 50,
                              child: ListView.builder(
                                  itemCount: allProviderTypes.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () =>
                                          setState(() {
                                            selectedProvider = index;
                                            if (model.providersList == null) {
                                              sortedList = null;
                                            } else {
                                              filter = "None";
                                              sortedList = [];
                                              sortedList = sortedByType(model.providersList);
                                              setState(() {});
                                            }
                                          }),
                                      child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 20),
                                          margin:
                                          EdgeInsets.only(top: 6, bottom: 6, right: 10),
                                          decoration: BoxDecoration(
                                              color: selectedProvider == index
                                                  ? Styles.colorBlue
                                                  : null,
                                              borderRadius: BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              selectedProvider == index
                                                  ? Container(
                                                  height: 6,
                                                  width: 6,
                                                  margin:
                                                  EdgeInsets.only(right: 10, left: 5),
                                                  decoration: BoxDecoration(
                                                      color: Styles.appCanvasYellow,
                                                      borderRadius:
                                                      BorderRadius.circular(3)))
                                                  : SizedBox(),
                                              Text(
                                                allProviderTypes[index].name +
                                                    "${selectedProvider == index ? " (${sortedList
                                                        .length})" : ""}",
                                                style: GoogleFonts.nunito(
                                                    fontSize: 14,
                                                    color: selectedProvider == index
                                                        ? Styles.colorWhite
                                                        : Colors.white54,
                                                    fontWeight: selectedProvider == index
                                                        ? FontWeight.bold
                                                        : null),
                                              ),
                                            ],
                                          )),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All ${selectedProvider == 100 ? "Providers" : plurals(
                            allProviderTypes[selectedProvider].name)}",
                        style: GoogleFonts.nunito(
                            fontSize: 18, color: Styles.colorBlack, fontWeight: FontWeight.bold),
                      ),
                      PopupMenuButton(
                          onSelected: (a) {
                            if (a == 0) {
                              setState(() => filter = "None");
                            } else if (a == 1) {
                              setState(() => filter = "Active");
                            } else if (a == 2) {
                              setState(() => filter = "Pending");
                            }
                            sortedList = sortedByType(model.providersList);
                            setState(() {});
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(filter),
                                  horizontalSpaceTiny,
                                  Icon(Icons.filter_list, color: Styles.colorGrey),
                                ],
                              )),
                          itemBuilder: (context) => [
                                PopupMenuItem(value: 0, child: Text('None')),
                                PopupMenuItem(value: 1, child: Text('Active')),
                                PopupMenuItem(value: 2, child: Text('Pending')),
                              ])
                    ],
                  ),
                ),
                model.busy
                    ? Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: screenHeight(context) / 2,
                        child: CupertinoActivityIndicator())
                    : sortedList == null
                        ? Container(
                            height: screenHeight(context) / 2,
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: ErrorOccurredWidget(error: model.error))
                        : sortedList.isEmpty
                            ? Container(
                                color: Colors.white,
                                alignment: Alignment.center,
                                height: screenHeight(context) / 2,
                                child: Container(
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          verticalSpaceMedium,
                                          SvgPicture.asset(
                                            "images/empty.svg",
                                            height: screenWidthFraction(context, dividedBy: 4),
                                          ),
                                          verticalSpaceMedium,
                                          Text(
                                            "Unfortunately, We do not have \n ${plurals(
                                                allProviderTypes[selectedProvider].name)} yet.",
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
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: ListView.builder(
                                    itemCount: sortedList.length,
                                    padding: EdgeInsets.zero,
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                          onTap: () => moveTo(
                                              context, ProDetailsScreen(model: sortedList[index])),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
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
                                                              ? Image.asset(
                                                                  "images/placeholder.png")
                                                              : CachedImage(
                                                                  sortedList[index].images[0].url)),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    sortedList[index].name ??
                                                                        "No name",
                                                                    style: GoogleFonts.nunito(
                                                                        fontSize: 14,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                horizontalSpaceTiny,
                                                                sortedList[index]
                                                                            .activeStatus
                                                                            .toLowerCase() ==
                                                                        "pending"
                                                                    ? Text(
                                                                        sortedList[index]
                                                                            .activeStatus
                                                                            .toLowerCase(),
                                                                        style: GoogleFonts.nunito(
                                                                            fontSize: 12,
                                                                            color:
                                                                                Styles.colorGrey))
                                                                    : Icon(
                                                                        Icons.check_circle,
                                                                        color: Colors.lightGreen,
                                                                        size: 16,
                                                                      ),
                                                              ],
                                                            ),
                                                            Text(
                                                              sortedList[index].providerType.name ??
                                                                  "No Type",
                                                              style: GoogleFonts.nunito(
                                                                  fontSize: 14,
                                                                  color: Styles.colorGrey,
                                                                  fontWeight: FontWeight.w600),
                                                            ),
                                                            sortedList[index].rating != null
                                                                ? RatingStar(
                                                                    sortedList[index]
                                                                        .rating
                                                                        .toDouble(),
                                                                    15)
                                                                : Text(
                                                                    "No rating yet",
                                                                    style: GoogleFonts.nunito(
                                                                        fontSize: 14,
                                                                        color: Styles.colorBlack),
                                                                  ),
                                                            Text(
                                                              sortedList[index].address.toString() +
                                                                  ", " +
                                                                      sortedList[index]
                                                                          .state
                                                                          .name ??
                                                                  "No Address",
                                                              style: GoogleFonts.nunito(
                                                                  fontSize: 14,
                                                                  color: Styles.colorBlack,
                                                                  fontWeight: FontWeight.w600),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                              verticalSpaceSmall
                                            ],
                                          ));
                                    }),
                              )
              ],
            ),
          ),
        ),
      );
    });
  }

  List<ProvidersModel> sortedByType(List<ProvidersModel> list) {
    List<ProvidersModel> _sorted = [];

    if (selectedProvider == 100) {
      if (filter == "None") {
        return list;
      } else {
        list.forEach((element) {
          if (element.activeStatus.contains(filter)) {
            _sorted.add(element);
          }
        });
        return _sorted;
      }
    } else {
      if (filter == "None") {
        list.forEach((element) {
          if (element.providerType == null) {
            return;
          } else if (element.providerType.name.toLowerCase() ==
              allProviderTypes[selectedProvider].name.toLowerCase()) {
            _sorted.add(element);
          }
        });
      } else {
        list.forEach((element) {
          if (element.providerType == null) {
            return;
          } else if (element.providerType.name.toLowerCase() ==
              allProviderTypes[selectedProvider].name.toLowerCase() &&
              element.activeStatus.contains(filter)) {
            _sorted.add(element);
          }
        });
      }
    }

    return _sorted;
  }
}

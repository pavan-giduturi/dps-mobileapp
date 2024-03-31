import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/gopa/home/gopahome.dart';
import '../screens/gopa/searchortrack/gopa_searchortrack.dart';
import '../widgets/constants.dart';
import 'package:http/http.dart' as http;

// ConnectivityResult connectivityResult;

class Utilities {
  static int selectedmenuIndex = 0;
  static String? title;
  static String? empRole;
  static int filledQues = 0;
  static int countFilled = 0;
  static List gopaCheckList = [];
  static List scheduledStations = [];
  static List gopaList = [];
  static List annexureList = [];
  static List gopaCheckObj = [];
  static List gopaAttachmentList = [];
  static List finalgopaCheckList = [];
  static int gopaQueposition = 0;
  static dynamic gopaDetails;
  static dynamic annexureDetails;
  static List draftList = [];
  static dynamic gopaDraftDetails;
  static List Readinesschecklist = [];
  static dynamic crewAuditDetails;
  static List cabincrewCheckList = [];
  static List crewCheckList = [];
  static dynamic draftByList;
  static dynamic GHADetails;
  static List GHAList = [];
  static bool isPermission = false;
  static List annexureOverviewCheckList = [];
  static List gopaOverviewCheckList = [];
  static List gopaDraftOverviewCheckList = [];
  static List checkListDisabledIdsList = [];
  static List moDisabledIds = [];
  static dynamic dynMenudata;
  static String dataState = "";
  static String? stationCode;
  static String? apmNumber;
  static String? rmNumber;
  static String? attachmentFilePathLocal;

  static bool isOrganizationPermission = false;

  // static List checklistRatingcommn = [];
  // static List checklistRatingIDbased = [];

  static void Snackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      margin: EdgeInsets.only(bottom: 70, left: 15, right: 15),
      duration: Duration(seconds: 3),
      content: Text(text.toString(),
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white),
          textHeightBehavior:
              TextHeightBehavior(applyHeightToFirstAscent: true)),
      backgroundColor: (Colors.black45),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void easyLoader() {
    EasyLoading.instance
      // ..displayDuration = const Duration(seconds: 5)
      ..textStyle = TextStyle(fontWeight: FontWeight.bold, color: red)
      ..loadingStyle =
          EasyLoadingStyle.custom //This was missing in earlier code
      ..backgroundColor = whiteColor
      ..userInteractions = false
      ..indicatorColor = red
      ..indicatorWidget = SizedBox(
        width: 200,
        height: 80,
        child: SpinKitFadingCircle(
          color: red,
          size: 60.0,
        ),
      )
      ..infoWidget = SizedBox(
        width: 200,
        height: 80,
        child: Center(
            child: Icon(
          Icons.error,
          color: red,
          size: 50,
        )),
      )
      ..successWidget = SizedBox(
        width: 200,
        height: 80,
        child: Center(
            child: Icon(
          Icons.check,
          color: red,
          size: 50,
        )),
      )
      ..maskType = EasyLoadingMaskType.black
      ..dismissOnTap = false;
  }

  static Future<bool> CheckUserConnection() async {
    // try {
    //   final result = await http.get(Uri.parse('www.google.com'));
    //   if(result.statusCode==200){
    //     return true;
    //   }
    //   else{
    //     return false;
    //   }
    // }
    // on SocketException catch (_) {
    //   return false;
    // }
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static void showAlert(
    BuildContext context,
    String text,
  ) {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Flexible(
              fit: FlexFit.loose,
              child: Text(
                text,
                overflow: TextOverflow.visible,
              ))
        ],
      ),
      actions: <Widget>[
        // ignore: deprecated_member_use
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return alert;
        });
  }

  ///////requestprmission/////////////
  static void requestPermission() async {
    print("calling.........................");
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationAlways,
      Permission.storage,
      Permission.camera,
      //add more permission to request here.
    ].request();
    print("-----------------------");
    print(statuses);
    print("-----------------------");
    // if (statuses[Permission.storage]!.isDenied) {
    //   isPermission = true;
    //   print("storage permission is denied.");
    // } else if (statuses[Permission.storage]!.isPermanentlyDenied) {
    //   isPermission = true;
    //   print("Permission is permanently denied");
    // }
    // if (statuses[Permission.location]!.isDenied) {
    //   //check each permission status after.
    //   print("Camera permission is denied.");
    // }
    // if (statuses[Permission.camera]!.isDenied) {
    //   //check each permission status after.
    //   print("stroage permission is denied.");
    // }
  }

  static void loader(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            height: 100,
            width: 100,
            child: Column(
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 3,
                  color: Color(0xff00ada9),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "L O A D I N G . . .",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static mainNavigateUrl(id, context) {
    log("id------$id");
    if (id == "1") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Gopasearchortrack()));
    } else if (id == "2") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GopaHome(),
          ));
    } else if (id == "3") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GopaHome()));
    }else if (id == "4") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GopaHome()));
    }
  }
}

class AuditchecklistModal {
  String? question, uploadFileName, followUpInfo, ratingStatus;
  int? id;
  AuditchecklistModal(question, uploadFileName, followUpInfo, ratingStatus, id);
}

class GopachecklistModal {
  String? checkListName;
  int? id;
  GopachecklistModal(checkListName, id);
}

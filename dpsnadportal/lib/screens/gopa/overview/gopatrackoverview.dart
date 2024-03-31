import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/restapi.dart';
import '../../../database/database_table.dart';
import '../../../helpers/utilities.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/responsive.dart';
import '../new/fileviewer.dart';

class GopatrackOverview extends StatefulWidget {
  final String gopaAuditid;
  final String gopaAuditnumber;
  final String navType;
  const GopatrackOverview({
    Key? key,
    required this.gopaAuditid,
    required this.gopaAuditnumber,
    required this.navType,
  }) : super(key: key);

  @override
  State<GopatrackOverview> createState() => _GopatrackOverviewState();
}

class _GopatrackOverviewState extends State<GopatrackOverview> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: AnnexureOverViewPage(
        number: widget.gopaAuditnumber,
        id: widget.gopaAuditid,
        navtype: widget.navType,
      ),
      desktop: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: AnnexureOverViewPage(
                      number: widget.gopaAuditnumber,
                      id: widget.gopaAuditid,
                      navtype: widget.navType),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnnexureOverViewPage extends StatefulWidget {
  final number;
  final id;
  final String navtype;
  AnnexureOverViewPage({Key? key, this.number, this.id, required this.navtype})
      : super(key: key);

  @override
  State<AnnexureOverViewPage> createState() => _AnnexureOverViewPageState();
}

class _AnnexureOverViewPageState extends State<AnnexureOverViewPage> {
  List overviewdata = [];
  List airlineList = [];
  List airlineNames = [];
  List moOverviewdata = [];
  List overviewchecklistdata = [];
  DatabaseHelper db = DatabaseHelper();
  List auditList = [];
  List ratingList = [];
  String attachedBaseImg = "";
  late DateTime fromdate;
  String? acTypeValue, buttonName = "";
  List<bool> isSelected = [];
  Color? selectedColor, fillColor, textColor, borderColor;
  String? checkListName = "";
  String? subHeading = "";
  String? auditId = "",
      stationAirport = "",
      groundHandler = "",
      auditDate = "",
      conductAudit = "",
      airLines = "";
  String? selectedFile = "";
  List<bool> singleCheck = [];
  bool vertical = false;
  bool isSubHeading = false;
  String id = "", followUp = "", uploadFile = "", ratingStatus = "";
  List files22 = [];
  TextEditingController followupController = new TextEditingController();
  List multipleSelection = [];
  List<bool> _selectedVegetables = [];
  bool isSubmit = false;
  bool isFollowUp = false;
  bool isUpload = false;
  double buttonWidth = 190;
  List? FileList = [];
  List<Widget> fruits = <Widget>[];
  String ratingIcon = "";
  String ratingName = "";
  String ratingId = "";
  List checklistRatingcommn = [];
  List checklistRatingIDbased = [];
  List finalSubmitgopaOverviewCheckList = [];
  String? finalSubmitStatus = '0';
  bool isInternetAvailable = false;
  Timer? _timer;

  @override
  void initState() {
    // gopaOverviewData();
    // GetChecklistRating();
  }

  Widget build(BuildContext context) {
    if (Utilities.dataState == "Connection lost") {
      setState(() {
        isInternetAvailable = false;
      });
    } else {
      setState(() {
        isInternetAvailable = true;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment Overview'),
        centerTitle: true,
        backgroundColor: red,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Color(0xFFe7e7e7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: darkgrey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Table(
                            children: [
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Class",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      "NURSERY (2023-24)",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Section",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      "A",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      "Subject",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      "Drawing",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Homework Date",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      "02-03-2024",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Title",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Standing Lines",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Max Marks",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      "10",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Evalution Date",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      "--",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Description",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      "--",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      "Marks Obtained",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      "--",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize)),
                                )),
                              ]),

                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),

            SizedBox(
              height: 10,
            ),

          ],
        ),
      ),

    );
  }

  GetChecklistRating() async {
    // _fetchData(context);
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading Overview",
    );
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    var dataLength;
    var gopaNumber = widget.number;
    var arry = gopaNumber.toString().split("_");

    if (isOnline) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      ApiService.get("GetChecklistRating", pref.getString('token'))
          .then((success) {
        setState(() {
          var checklistRating = jsonDecode(success.body);

          if (success.statusCode == 200) {
            EasyLoading.addStatusCallback((status) {
              if (status == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });
            checklistRatingcommn = checklistRating['checklistRatingcommn'];
            checklistRatingIDbased = checklistRating['checklistRatingIDbased'];
            // EasyLoading.showSuccess('Data Loading Success');
          } else {
            EasyLoading.showInfo("Loading Failed");
          }
        });
      });
    } else {
      List ratingcommonlistBody = await db.getRatingcommonData();
      List RatingIDbasedlistBody = await db.getRatingIDbasedData();

      dataLength = ratingcommonlistBody.length;
      if (dataLength != 0) {
        EasyLoading.addStatusCallback((dataLength) {
          if (dataLength == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        setState(() {
          checklistRatingcommn = ratingcommonlistBody;
          checklistRatingIDbased = RatingIDbasedlistBody;
        });
        EasyLoading.showSuccess('Loading Success');
      } else {
        EasyLoading.showInfo("Loading Failed");
      }
    }
    // gopaOverviewData();
  }

  getCheckListRatingIdbyName(ratingId) {
    String? ratingName = "";
    for (int i = 0; i < checklistRatingcommn.length; i++) {
      if (ratingId == checklistRatingcommn[i]['ratingID'].toString()) {
        ratingName = checklistRatingcommn[i]['ratingName'].toString();
      }
    }
    for (int j = 0; j < checklistRatingIDbased.length; j++) {
      if (ratingId == checklistRatingIDbased[j]['ratingID'].toString()) {
        ratingName = checklistRatingIDbased[j]['ratingName'].toString();
      }
    }
    return ratingName;
  }

  gopaOverviewData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading Overview",
    );
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    var dataLength;
    var auditId;
    var auditNumber;
    setState(() {
      auditId = widget.id;
      auditNumber = widget.number;
    });
    // ONLINE DATA
    var arry = auditNumber.toString().split("_");
    if (isOnline && !arry.contains("GOPA")) {
      ApiService.get(
              "GetGOPADataBasedonAuditID?AuditID=$auditId&AuditNumber=$auditNumber",
              pref.getString('token'))
          .then((success) {
        setState(() {
          if (success.statusCode == 200) {
            EasyLoading.addStatusCallback((status) {

              if (status == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });
            var body = jsonDecode(success.body);
            var data1 = body["auditGOPAOverviewMaindata"];
            var data2 = body["ccaChecklistsList"];
            moOverviewdata = body["annexuresOverviewDataforgopa"];
            GopaOverviewChecklistData(data1, data2);
            EasyLoading.showSuccess('Loading Success');
          } else {
            EasyLoading.showInfo("Loading Failed");
          }
        });
      });
      // OFFLINE DATA
    } else {
      try {
        try {
          List overviewBody = await db.getGOPAOverviewDataByAuditId(auditId);

          List checklistBody = await db.getGOPAChecklistDataByAuditId(auditId);

          var moOverviewdataObj =
              await db.getAnnexuresOverviewDataforgopa(auditId);

          dataLength = overviewBody.length;

          if (dataLength != 0) {
            EasyLoading.addStatusCallback((dataLength) {
              if (dataLength == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });
            setState(() {
              overviewdata = overviewBody;
              var data3 = overviewBody;
              var data4 = checklistBody;
              moOverviewdata = moOverviewdataObj;
              GopaOverviewChecklistData(data3, data4);
            });
            EasyLoading.showSuccess('Loading Success');
          } else {
            EasyLoading.showInfo("Loading Failed");
          }
        } catch (e) {
          print(e);
        }
      } catch (e) {
        print(e);
      }
    }
    GetChecklistRating();
  }

  GopaOverviewChecklistData(overviewData, checklistData) async {
    setState(() {
      overviewdata = overviewData;

      overviewchecklistdata = checklistData;
    });

    if (overviewchecklistdata.length > 0) {
      Utilities.gopaOverviewCheckList = [];
      finalSubmitgopaOverviewCheckList = [];
      String id = '0';
      for (int i = 0; i < overviewchecklistdata.length; i++) {
        if (id != overviewchecklistdata[i]['checklistID'].toString()) {
          List items = [];
          List subitems = [];
          for (int j = 0; j < overviewchecklistdata.length; j++) {
            if (overviewchecklistdata[j]['checklistID'].toString() ==
                overviewchecklistdata[i]['checklistID'].toString()) {
              if (overviewchecklistdata[i]['subchecklistID'] == '0') {
                var item = jsonEncode({
                  "subchecklistID": overviewchecklistdata[j]['subchecklistID'],
                  "checklistID": overviewchecklistdata[j]['checklistID'],
                  "subchecklistname": overviewchecklistdata[j]
                      ['subchecklistname'],
                  "checklistItemID": overviewchecklistdata[j]
                      ['checklistItemID'],
                  "itemName": overviewchecklistdata[j]['itemName'],
                  "checklistItemDataID": overviewchecklistdata[j]
                      ['checklistItemDataID'],
                  "comments": overviewchecklistdata[j]['comments'],
                  "imagename": overviewchecklistdata[j]['imagename'],
                });
                items.add(item);

                if (overviewchecklistdata[j]['checklistItemDataID']
                        .toString() ==
                    '0') {
                  finalSubmitgopaOverviewCheckList.add(item);
                }
              }
            }
          }

          String subid = '0';
          for (int k = 0; k < overviewchecklistdata.length; k++) {
            if (overviewchecklistdata[k]['checklistID'] ==
                overviewchecklistdata[i]['checklistID']) {
              if (subid !=
                  overviewchecklistdata[k]['subchecklistID'].toString()) {
                List itemsqns = [];
                for (int l = 0; l < overviewchecklistdata.length; l++) {
                  if (overviewchecklistdata[l]['subchecklistID'] ==
                      overviewchecklistdata[k]['subchecklistID']) {
                    var itemsqn = jsonEncode({
                      'itemID': overviewchecklistdata[l]['checklistItemID'],
                      'checklistID': overviewchecklistdata[l]['checklistID'],
                      'itemName': overviewchecklistdata[l]['itemName'],
                      'checklistItemDataID': overviewchecklistdata[l]
                          ['checklistItemDataID'],
                      'comments': overviewchecklistdata[l]['comments'],
                      'subchecklistID': overviewchecklistdata[l]['checklistID'],
                      'subchecklistname': overviewchecklistdata[l]
                          ['checkListName'],
                      "imagename": overviewchecklistdata[l]['imagename'],
                    });
                    itemsqns.add(itemsqn);

                    if (overviewchecklistdata[l]['checklistItemDataID']
                            .toString() ==
                        '0') {
                      finalSubmitgopaOverviewCheckList.add(itemsqn);
                    }
                  }
                }

                var subitem = {
                  'id': overviewchecklistdata[k]['subchecklistID'],
                  'title': overviewchecklistdata[k]['subchecklistname'],
                  'questions': itemsqns
                };
                subitems.add(subitem);
                subid = overviewchecklistdata[k]['subchecklistID'].toString();
              }
            }
          }

          var checkList = jsonEncode({
            "id": overviewchecklistdata[i]['checklistID'],
            "title": overviewchecklistdata[i]['checkListName'],
            "subId": overviewchecklistdata[i]['subchecklistID'],
            "subtitle": overviewchecklistdata[i]['subchecklistname'],
            "questions": items,
            "subquestions": subitems
          });

          Utilities.gopaOverviewCheckList.add(checkList);
          id = overviewchecklistdata[i]['checklistID'].toString();
        }
      }

      SharedPreferences prefRole = await SharedPreferences.getInstance();

      if (finalSubmitgopaOverviewCheckList.length > 0) {
        finalSubmitStatus = '0';
        setState(() {
          buttonName = "GoToHome";
        });
      } else {
        finalSubmitStatus = '1';
        setState(() {
          buttonName = "GoToHome";
        });
      }

      if (widget.navtype == "overview") {
        setState(() {
          buttonName = "Back";
        });
      }

      if ((finalSubmitStatus == "1") &&
          (widget.navtype == '3') &&
          prefRole.getString("user_role").toString() == "HO") {
        setState(() {
          buttonName = "Back";
        });
      }
    }

    makeAirlinesApiCall(overviewData[0]['stationID']);
  }

  makeAirlinesApiCall(id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    if (isOnline) {
      ApiService.get(
              "GetGOPAAirlinesData?StationID=$id", pref.getString('token'))
          .then((success) {
        var body = jsonDecode(success.body);
        setState(() {
          airlineList = body;
          airlineNames = [];
          for (int i = 0; i < airlineList.length; i++) {
            var str =
                overviewdata[0]['airlineIDs'].toString().trim().split(',');

            for (int j = 0; j < str.length; j++) {
              if (str[j] == airlineList[i]['id']) {
                airlineNames.add(airlineList[i]['airlineName'].toString());
              }
            }
          }
        });
      });
    } else {
      List body = await db.getAirlines(id);
      setState(() {
        for (int i = 0; i < body.length; i++) {
          airlineList.add(jsonDecode(body[i]));
        }
        airlineNames = [];
        for (int i = 0; i < airlineList.length; i++) {
          var str = overviewdata[0]['airlineIDs'].toString().trim().split(',');
          for (int j = 0; j < str.length; j++) {
            if (str[j] == airlineList[i]['id']) {
              airlineNames.add(airlineList[i]['airlineName'].toString());
            }
          }
        }
      });
    }
  }

  getGOPAFinalStatus() async {
    var auditId;
    var auditNumber;
    setState(() {
      auditId = widget.id;
      auditNumber = widget.number;
    });

    bool isOnline = await Utilities.CheckUserConnection() as bool;

    if (isOnline) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      ApiService.get("GOPAFinalStatus?GOPAID=$auditId&GOPANumber=$auditNumber",
              pref.getString('token'))
          .then((success) {
        var body = jsonDecode(success.body);
        if (body[0]['returnValue'].toString() == '0') {
          CoolAlert.show(
              width: 300,
              text: '',
              title:
                  'Please check all checklist in GOPA (OR) Mandatory Observations',
              flareAnimationName: "play",
              backgroundColor: Color(0xFFe7e7e7),
              barrierDismissible: false,
              context: context,
              type: CoolAlertType.error,
              confirmBtnText: 'Ok',
              cancelBtnText: 'Cancel',
              cancelBtnTextStyle:
                  TextStyle(color: red, fontWeight: FontWeight.bold),
              confirmBtnColor: Color(0xFF216f82),
              onCancelBtnTap: () {
                Navigator.pop(context);
              },
              onConfirmBtnTap: () {
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (context) => AuditHome()),
                //     (Route<dynamic> route) => false);
              });
        } else {
          makeSaveApiCall(2, auditId, auditNumber);
          Utilities.gopaDetails = {};

          CoolAlert.show(
              width: 300,
              text: '',
              title: 'GOPA Final Submission Successfull',
              flareAnimationName: "play",
              backgroundColor: Color(0xFFe7e7e7),
              barrierDismissible: false,
              context: context,
              type: CoolAlertType.success,
              confirmBtnText: 'Ok',
              cancelBtnText: '',
              confirmBtnColor: Color(0xFF216f82),
              onConfirmBtnTap: () {
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (context) => AuditHome()),
                //     (Route<dynamic> route) => false);
              });
        }
      });
    } else {}
  }

  getChecklistFileData(
      AuditID, AuditNumber, ChecklistID, ChecklistItemID, FileName) async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Opening File",
    );
    var dataLength;
    if (isOnline) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      ApiService.get(
              "GetAttachmentbasedonChecklistID?PluginID=137&AuditID=$AuditID&AuditNumber=$AuditNumber&ChecklistID=$ChecklistID&ChecklistItemID=$ChecklistItemID&FileName=$FileName",
              pref.getString('token'))
          .then((success) {
        var body = jsonDecode(success.body);
        if (success.statusCode == 200) {
          EasyLoading.addStatusCallback((status) {

            if (status == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          attachedBaseImg = body;
          var str = FileName.toString().split('.');

          var fileExt = str[1].toString();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageView(
                        linkExt: fileExt,
                        link: attachedBaseImg,
                      )));

          EasyLoading.showSuccess('Opening File Success');
        } else {
          EasyLoading.showInfo("File Opening Error");
        }

        return body.toString();
      });
    } else {
      var body1 = await db.getGOPAItemImageData(
          AuditID, AuditNumber, ChecklistID, ChecklistItemID, FileName);

      dataLength = body1.length;
      if (dataLength != 0) {
        EasyLoading.addStatusCallback((dataLength) {
          if (dataLength == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        setState(() {
          attachedBaseImg = body1[0]['ImageBase64'].toString();
        });
        var str = FileName.toString().split('.');
        var fileExt = str[1].toString();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageView(
                      linkExt: fileExt,
                      link: attachedBaseImg,
                    )));

        EasyLoading.showSuccess('Opening File Success');
      } else {
        EasyLoading.showInfo("File Opening Error");
      }

      return attachedBaseImg;
    }
  }

  makeSaveApiCall(status, auditID, auditNumber) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var gopaDetailsBody = jsonDecode(Utilities.gopaDetails);

    List GopaDetailsBodyData = [];
    List GopaDraftDetailsBodyData = [];

    bool isOnline = await Utilities.CheckUserConnection() as bool;
    List CCAChecklistsList = [];

    if (isOnline) {
      if (auditId != '') {
        for (int i = 0; i < Utilities.gopaList.length; i++) {
          var checkObject = jsonDecode(Utilities.gopaList[i].toString());
          var singleHeadQues = jsonDecode(checkObject['questions'].toString());
          if (singleHeadQues.length > 0) {
            for (int j = 0; j < singleHeadQues.length; j++) {
              var checklistObj = jsonEncode({
                "ObjectID": auditID,
                "ChecklistID": checkObject['id'],
                "ChecklistItemID": singleHeadQues[j]['itemID'],
                "ChecklistItemDataID": singleHeadQues[j]['ChecklistItemDataID'],
                "EmpID": pref.getString('employeeID'),
                "Comments": singleHeadQues[j]['comments'],
                "CheckListName": checkObject['title'],
                "ItemName": singleHeadQues[j]['itemName'],
                "SubchecklistID": checkObject['subId'],
                "Subchecklistname": checkObject['subtitle'],
                "Checklistorder": checkObject['checklistorder'],
                "SubChecklistorder": checkObject['subChecklistorder'],
              });

              var gopachkbody1 = jsonDecode(checklistObj);
              CCAChecklistsList.add(gopachkbody1);
            }
          } else {
            var multipleHead = checkObject['subquestions'];

            for (int k = 0; k < multipleHead.length; k++) {
              var multipleHeadQues =
                  jsonDecode(multipleHead[k]['questions'].toString());

              for (int l = 0; l < multipleHeadQues.length; l++) {
                var checklistObj = jsonEncode({
                  "ObjectID": auditID,
                  "ChecklistID": checkObject['id'],
                  "ChecklistItemID": multipleHeadQues[l]['itemID'],
                  "ChecklistItemDataID": multipleHeadQues[l]
                      ['ChecklistItemDataID'],
                  "EmpID": pref.getString('employeeID'),
                  "Comments": multipleHeadQues[l]['comments'],
                  "CheckListName": checkObject['title'],
                  "ItemName": multipleHeadQues[l]['itemName'],
                  "SubchecklistID": multipleHead[k]['id'],
                  "Subchecklistname": multipleHead[k]['title'],
                  "Checklistorder": multipleHeadQues[l]['checklistorder'],
                  "SubChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                });

                var ccachecklistbody = jsonDecode(checklistObj);
                CCAChecklistsList.add(ccachecklistbody);
              }
            }
          }
        }
        var GopaSaveBody = jsonEncode({
          "StationID": gopaDetailsBody['stationId'],
          "StationCode": Utilities.stationCode,
          "AuditID": auditID,
          "GGHID": gopaDetailsBody['groundHandlerId'],
          "AuditDate": gopaDetailsBody['auditDate'],
          "AuditDoneby": pref.getString('employeeCode'),
          "AirlineIDs": gopaDetailsBody['airlineIds'],
          "Statusid": status,
          "SubmittedBy": pref.getString('employeeCode'),
          "UserID": pref.getString('userID'),
          "Msg": '',
          "ImageBase64": '',
          "ImageName": '',
          "AttachedByName": '',
          "SubmittedDate": gopaDetailsBody['submitteddate'],
          "GOPANumber": auditNumber,
          "Restartoperations": gopaDetailsBody['restartOperations'],
          "Sameserviceprovider":
              gopaDetailsBody['allAirlinesSameServiceProvider'],
          "PBhandling": gopaDetailsBody['PBhandling'],
          "Ramphandling": gopaDetailsBody['Ramphandling'],
          "Cargohandling": gopaDetailsBody['Cargohandling'],
          "Deicingoperations": gopaDetailsBody['Deicingoperations'],
          "AircraftMarshalling": gopaDetailsBody['AircraftMarshalling'],
          "Loadcontrol": gopaDetailsBody['Loadcontrol'],
          "Aircraftmovement": gopaDetailsBody['Aircraftmovement'],
          "Headsetcommunication": gopaDetailsBody['Headsetcommunication'],
          "Passengerbridge": gopaDetailsBody['Passengerbridge'],
          "ISAGO": gopaDetailsBody['isagocertified'],
          "Duedate": gopaDetailsBody['isauditduedate'],
          "Reason": gopaDetailsBody['messages'],
          "PBhandlingServiceProvider":
              gopaDetailsBody['PBhandlingServiceProvider'],
          "RamphandlingServiceProvider":
              gopaDetailsBody['RamphandlingServiceProvider'],
          "CargohandlingServiceProvider":
              gopaDetailsBody['CargohandlingServiceProvider'],
          "DeicingoperationsServiceProvider":
              gopaDetailsBody['DeicingoperationsServiceProvider'],
          "AircraftMarshallingServiceProvider":
              gopaDetailsBody['AircraftMarshallingServiceProvider'],
          "LoadcontrolServiceProvider":
              gopaDetailsBody['LoadcontrolServiceProvider'],
          "AircraftmovementServiceProvider":
              gopaDetailsBody['AircraftmovementServiceProvider'],
          "HeadsetcommunicationServiceProvider":
              gopaDetailsBody['HeadsetcommunicationServiceProvider'],
          "PassengerbridgeServiceProvider":
              gopaDetailsBody['PassengerbridgeServiceProvider'],
          "CCAChecklistsList": CCAChecklistsList,
        });

        ApiService.post("NewGOPASave", GopaSaveBody, pref.getString('token'))
            .then((success) {});
      } else {
        auditID = 0;
        auditNumber = 0;
        for (int i = 0; i < Utilities.gopaList.length; i++) {
          var checkObject = jsonDecode(Utilities.gopaList[i].toString());
          var singleHeadQues = jsonDecode(checkObject['questions'].toString());
          if (singleHeadQues.length > 0) {
            for (int j = 0; j < singleHeadQues.length; j++) {
              var checklistObj = jsonEncode({
                "ObjectID": auditID,
                "ChecklistID": checkObject['id'],
                "ChecklistItemID": singleHeadQues[j]['itemID'],
                "ChecklistItemDataID": singleHeadQues[j]['ChecklistItemDataID'],
                "EmpID": pref.getString('employeeID'),
                "Comments": singleHeadQues[j]['comments'],
                "CheckListName": checkObject['title'],
                "ItemName": singleHeadQues[j]['itemName'],
                "SubchecklistID": checkObject['subId'],
                "Subchecklistname": checkObject['subtitle'],
                "Checklistorder": checkObject['checklistorder'],
                "SubChecklistorder": checkObject['subChecklistorder'],
              });

              var gopachkbody1 = jsonDecode(checklistObj);
              CCAChecklistsList.add(gopachkbody1);
            }
          } else {
            var multipleHead = checkObject['subquestions'];

            for (int k = 0; k < multipleHead.length; k++) {
              var multipleHeadQues =
                  jsonDecode(multipleHead[k]['questions'].toString());

              for (int l = 0; l < multipleHeadQues.length; l++) {
                var checklistObj = jsonEncode({
                  "ObjectID": auditID,
                  "ChecklistID": checkObject['id'],
                  "ChecklistItemID": multipleHeadQues[l]['itemID'],
                  "ChecklistItemDataID": multipleHeadQues[l]
                      ['ChecklistItemDataID'],
                  "EmpID": pref.getString('employeeID'),
                  "Comments": multipleHeadQues[l]['comments'],
                  "CheckListName": checkObject['title'],
                  "ItemName": multipleHeadQues[l]['itemName'],
                  "SubchecklistID": multipleHead[k]['id'],
                  "Subchecklistname": multipleHead[k]['title'],
                  "Checklistorder": multipleHeadQues[l]['checklistorder'],
                  "SubChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                });

                var ccachecklistbody = jsonDecode(checklistObj);
                CCAChecklistsList.add(ccachecklistbody);
              }
            }
          }
        }
        var GopaSaveBody = jsonEncode({
          "StationID": gopaDetailsBody['stationId'],
          "AuditID": auditID,
          "GGHID": gopaDetailsBody['groundHandlerId'],
          "AuditDate": gopaDetailsBody['auditDate'],
          "AuditDoneby": pref.getString('employeeCode'),
          "AirlineIDs": gopaDetailsBody['airlineIds'],
          "Statusid": status,
          "SubmittedBy": pref.getString('employeeCode'),
          "UserID": pref.getString('userID'),
          "Msg": '',
          "ImageBase64": '',
          "ImageName": '',
          "AttachedByName": '',
          "SubmittedDate": gopaDetailsBody['submitteddate'],
          "GOPANumber": auditNumber,
          "Restartoperations": gopaDetailsBody['restartOperations'],
          "Sameserviceprovider":
              gopaDetailsBody['allAirlinesSameServiceProvider'],
          "PBhandling": gopaDetailsBody['PBhandling'],
          "Ramphandling": gopaDetailsBody['Ramphandling'],
          "Cargohandling": gopaDetailsBody['Cargohandling'],
          "Deicingoperations": gopaDetailsBody['Deicingoperations'],
          "AircraftMarshalling": gopaDetailsBody['AircraftMarshalling'],
          "Loadcontrol": gopaDetailsBody['Loadcontrol'],
          "Aircraftmovement": gopaDetailsBody['Aircraftmovement'],
          "Headsetcommunication": gopaDetailsBody['Headsetcommunication'],
          "Passengerbridge": gopaDetailsBody['Passengerbridge'],
          "ISAGO": gopaDetailsBody['isagocertified'],
          "Duedate": gopaDetailsBody['isauditduedate'],
          "Reason": gopaDetailsBody['messages'],
          "PBhandlingServiceProvider":
              gopaDetailsBody['PBhandlingServiceProvider'],
          "RamphandlingServiceProvider":
              gopaDetailsBody['RamphandlingServiceProvider'],
          "CargohandlingServiceProvider":
              gopaDetailsBody['CargohandlingServiceProvider'],
          "DeicingoperationsServiceProvider":
              gopaDetailsBody['DeicingoperationsServiceProvider'],
          "AircraftMarshallingServiceProvider":
              gopaDetailsBody['AircraftMarshallingServiceProvider'],
          "LoadcontrolServiceProvider":
              gopaDetailsBody['LoadcontrolServiceProvider'],
          "AircraftmovementServiceProvider":
              gopaDetailsBody['AircraftmovementServiceProvider'],
          "HeadsetcommunicationServiceProvider":
              gopaDetailsBody['HeadsetcommunicationServiceProvider'],
          "PassengerbridgeServiceProvider":
              gopaDetailsBody['PassengerbridgeServiceProvider'],
          "CCAChecklistsList": CCAChecklistsList,
        });

        var id;
        ApiService.post("NewGOPASave", GopaSaveBody, pref.getString('token'))
            .then((success) {
          id = success.body;
        });
      }
    }
  }

  void _fetchData(BuildContext context, [bool mounted = true]) async {
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    height: 15,
                  ),
                  // The loading indicator
                  SpinKitFadingCircle(
                    color: red,
                    size: 60.0,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text(
                    'Loading Overview',
                    style: TextStyle(fontSize: headerSize),
                  )
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(const Duration(seconds: 20));

    // Close the dialog programmatically
    // We use "mounted" variable to get rid of the "Do not use BuildContexts across async gaps" warning
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/restapi.dart';
import '../../../database/database_table.dart';
import '../../../helpers/utilities.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/responsive.dart';
import '../new/checklistView.dart';
import '../new/newhome.dart';
import '../overview/gopatrackoverview.dart';

class DraftList extends StatefulWidget {
  const DraftList({Key? key}) : super(key: key);

  @override
  State<DraftList> createState() => _DraftListState();
}

class _DraftListState extends State<DraftList> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: GopaDraftList(),
      desktop: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Color(0xFFe7e7e7),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: GopaDraftList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GopaDraftList extends StatefulWidget {
  // final String conductedBy;
  // final String stationName;
  // final String groundHandler;
  // final String dtofAudit;
  //const GOPACheckList({Key? key, required this.conductedBy, required this.stationName, required this.groundHandler, required this.dtofAudit}) : super(key: key);
  const GopaDraftList({Key? key}) : super(key: key);
  @override
  State<GopaDraftList> createState() => _GopaDraftListState();
}

class _GopaDraftListState extends State<GopaDraftList> {
  DatabaseHelper db = DatabaseHelper();
  List checkListObj = [];
  int sno = 0;
  Timer? _timer;
  String dataMessage = "";

  var conductedBy;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setDraftObj();
  }

  DeleteGOPADataByGOPAId(GOPAId, GOPANumber) async {
    // var moOverview = await db.getAnnexureOverviewDetails(MOId, MONumber);
    // db.UpdateIsMOExists(moOverview[0]['airlineID']);
    db.deleteGOPAByID(GOPAId);



    setDraftObj();

    //db.deleteDraftedMOs(MOId, MONumber);
  }

  setDraftObj() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading Drafts",
    );
    // _fetchData(context);
    var dataLength;
    var empNumber = pref.getString('employeeCode');
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    var draftObjdb = await db.getGOPADraftAudits(empNumber);
    //var draftObjdb = await db.getGOPADraftAudits(empNumber);
    if (isOnline) {
      ApiService.get("GetGOPADraftAudits?LoginEMPNumber=$empNumber",
              pref.getString('token'))
          .then((success) {
        if (success.statusCode == 200) {
          EasyLoading.addStatusCallback((status) {

            if (status == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          setState(() {
            Utilities.draftList = [];
            var body = jsonDecode(success.body);
            Utilities.draftList = body;

            if (body.length == 0) {
              dataMessage = "No Draft Audits Found";
            }

          });
          Utilities.draftList.isNotEmpty? EasyLoading.showSuccess('Draft Audits Loading Success'):EasyLoading.showInfo("No Draft Audits Found");

        } else {
          EasyLoading.showInfo("No Draft Audits Found");
          dataMessage = "No Draft Audits Found";
        }
      });
    } else {
      dataLength = draftObjdb.length;

      if (dataLength != 0) {
        EasyLoading.addStatusCallback((dataLength) {

          if (dataLength == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        setState(() {
          Utilities.draftList = draftObjdb;
        });
        EasyLoading.showSuccess('Draft Audits Loading Success');
      } else {
        setState(() {
          Utilities.draftList = [];
        });
        EasyLoading.showInfo("No Draft Audits Found");
        dataMessage = "No Draft Audits Found";
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
                    'Loading Drafts',
                    style: TextStyle(fontSize: headerSize),
                  )
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(const Duration(seconds: 3));

    // Close the dialog programmatically
    // We use "mounted" variable to get rid of the "Do not use BuildContexts across async gaps" warning
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draft Audits"),
        centerTitle: true,
        backgroundColor: Color(0xFFf5003a),
      ),
      backgroundColor: Color(0xFFe7e7e7),
      body: Container(
        child: Utilities.draftList.isNotEmpty
            ? ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: Utilities.draftList.length,
                itemBuilder: (context, index) {
                  var arry = Utilities.draftList[index]['auditID']
                      .toString()
                      .split("_");
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: darkgrey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(children: [
                      Table(
                        columnWidths: {
                          0: FlexColumnWidth(15),
                          1: FlexColumnWidth(10)
                        },
                        children: [
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "GOPA ID",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: textSize),
                                    ))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        Utilities.draftList[index]['auditID'] ==
                                                null
                                            ? "--"
                                            : Utilities.draftList[index]
                                                ['auditID'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "GOPA Number",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: textSize),
                                    ))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        Utilities.draftList[index]
                                                    ['auditNumber'] ==
                                                null
                                            ? "--"
                                            : Utilities.draftList[index]
                                                ['auditNumber'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Station Name",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        Utilities.draftList[index]
                                                    ['stationName'] ==
                                                null
                                            ? "--"
                                            : Utilities.draftList[index]
                                                ['stationName'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("GroundHandler Name",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        Utilities.draftList[index]['gghName'] ==
                                                null
                                            ? "--"
                                            : Utilities.draftList[index]
                                                ['gghName'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Auditor Name ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        Utilities.draftList[index]
                                                    ['auditDoneby'] ==
                                                null
                                            ? "--"
                                            : Utilities.draftList[index]
                                                ['auditDoneby'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Date of conducting audit ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        Utilities.draftList[index]
                                                    ['auditDate'] ==
                                                null
                                            ? "--"
                                            : Utilities.draftList[index]
                                                ['auditDate'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Status ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        Utilities.draftList[index]
                                                    ['statusName'] ==
                                                null
                                            ? "--"
                                            : Utilities.draftList[index]
                                                ['statusName'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize)))),
                          ]),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(8),
                                  primary: red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GopaAuditHomePage(
                                              type: "draft",
                                              groundHandler: Utilities
                                                  .draftList[index]['gghName']
                                                  .toString(),
                                              conductedBy: Utilities.draftList[index]
                                                      ['conductAudit']
                                                  .toString(),
                                              auditDate: Utilities
                                                  .draftList[index]['auditDate']
                                                  .toString(),
                                              stationName: Utilities
                                                  .draftList[index]
                                                      ['stationName']
                                                  .toString(),
                                              auditId: Utilities
                                                  .draftList[index]['auditID']
                                                  .toString(),
                                              auditNumber: Utilities.draftList[index]['auditNumber'].toString(),
                                              airlineId: Utilities.draftList[index]['airlineIDs'].toString())));
                                },
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                      color: whiteColor, fontSize: textSize),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(8),
                                  primary: red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GopatrackOverview(
                                                gopaAuditid: Utilities
                                                    .draftList[index]['auditID']
                                                    .toString(),
                                                gopaAuditnumber: Utilities
                                                    .draftList[index]
                                                        ['auditNumber']
                                                    .toString(),
                                                navType: 'overview',
                                              )));
                                },
                                child: Text(
                                  "Overview",
                                  style: TextStyle(
                                      color: whiteColor, fontSize: textSize),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: arry.contains("GOPA") ? true : false,
                              child: IconButton(
                                  onPressed: () {
                                    CoolAlert.show(
                                        width: 300,
                                        text: 'You want to Delete!',
                                        title: 'Are you sure ',
                                        flareAnimationName: "play",
                                        backgroundColor: Color(0xFFe7e7e7),
                                        barrierDismissible: false,
                                        context: context,
                                        type: CoolAlertType.confirm,
                                        confirmBtnText: 'Confirm',
                                        cancelBtnText: 'Cancel',
                                        cancelBtnTextStyle:
                                            TextStyle(color: red),
                                        onCancelBtnTap: () {
                                          Navigator.pop(context);
                                        },
                                        confirmBtnColor: Color(0xFF216f82),
                                        onConfirmBtnTap: () {
                                          Navigator.pop(context);

                                          if (arry.contains("GOPA")) {
                                            DeleteGOPADataByGOPAId(
                                                Utilities.draftList[index]
                                                        ['auditID']
                                                    .toString(),
                                                Utilities.draftList[index]
                                                        ['auditNumber']
                                                    .toString());
                                          }
                                        });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: red,
                                    size: 30,
                                  )),
                            ),
                          ],
                        ),
                      )
                    ]),
                  );
                })
            : Center(
                child: Text(
                  dataMessage.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}

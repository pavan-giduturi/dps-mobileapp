import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/restapi.dart';
import '../../../database/database_table.dart';
import '../../../helpers/utilities.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/responsive.dart';
import '../new/level1form.dart';


class GopaScheduleList extends StatefulWidget {
  const GopaScheduleList({Key? key}) : super(key: key);

  @override
  State<GopaScheduleList> createState() => _GopaScheduleListState();
}

class _GopaScheduleListState extends State<GopaScheduleList> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const GopaScheduleListPage(),
      desktop: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: const GopaScheduleListPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GopaScheduleListPage extends StatefulWidget {
  const GopaScheduleListPage({Key? key}) : super(key: key);

  @override
  State<GopaScheduleListPage> createState() => _GopaScheduleListPageState();
}

class _GopaScheduleListPageState extends State<GopaScheduleListPage> {
  List searchortracklist = [];
  DatabaseHelper db = DatabaseHelper();
  Timer? _timer;
  var isGopaClosed;
  var isdraftAvail = [];

  @override
  void initState() {
    super.initState();
    getScheduleStationsData();
    checkIsdarft();
    log('pavan');
    log(Utilities.scheduledStations.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        title: const Text("Scheduled GOPA"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: SingleChildScrollView(
            child: searchortracklist.isNotEmpty
                ? SafeArea(
                    bottom: true,
                    child: ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: searchortracklist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: darkgrey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Table(
                                  children: [
                                    TableRow(children: [
                                      const TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text("Schedule Number",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchortracklist[index]
                                                    ['scheduleNo']
                                                .toString(),
                                            style: const TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                    ]),
                                    TableRow(children: [
                                      const TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text("Schedule Date",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchortracklist[index]
                                                    ['gopaScheduledDate']
                                                .toString(),
                                            style: const TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                    ]),
                                    TableRow(children: [
                                      const TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text("Station Name",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchortracklist[index]
                                                    ['stationName']
                                                .toString(),
                                            style: const TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                    ]),
                                    TableRow(children: [
                                      const TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text("Audit Type",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchortracklist[index]
                                                    ['auditType']
                                                .toString(),
                                            style: const TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                    ]),
                                    TableRow(children: [
                                      const TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text("Auditor",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchortracklist[index]
                                                    ['airportManager']
                                                .toString(),
                                            style: const TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                    ]),
                                    TableRow(children: [
                                      const TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text("Status",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchortracklist[index]['status']
                                                .toString(),
                                            style: const TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                    ]),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(8),
                                      backgroundColor: red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "Create",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: textSize),
                                    ),
                                    onPressed: () {
                                      // searchortracklist[index]['stationID']
                                      var employeeRole;
                                      var stationsList =
                                          Utilities.scheduledStations;
                                      log(Utilities.empRole.toString());
                                      if (Utilities.empRole == '1') {
                                        setState(() {
                                          employeeRole = "APM";
                                        });
                                      } else {
                                        setState(() {
                                          employeeRole = "RM";
                                        });
                                      }
                                      log(employeeRole.toString());
                                      log(stationsList.toString());

                                      if (employeeRole == "APM") {
                                        if (searchortracklist[index]
                                                    ['stationID']
                                                .toString()
                                                .isNotEmpty &&
                                            searchortracklist[index]
                                                        ['stationID']
                                                    .toString() !=
                                                'null') {
                                          if (isdraftAvail.isNotEmpty || isdraftAvail.length > 0) {
                                            CoolAlert.show(
                                                context: context,
                                                title: "A Draft Audit is Found",
                                                text:
                                                    "Please Select And Edit From Draft List",
                                                barrierDismissible: false,
                                                flareAnimationName: "play",
                                                type: CoolAlertType.confirm,
                                                cancelBtnText: "",
                                                confirmBtnText: "Cancel",
                                                onCancelBtnTap: () {
                                                  Navigator.pop(context);
                                                },
                                                showCancelBtn: false,
                                                confirmBtnColor:
                                                    Colors.deepOrangeAccent);
                                          } else if (isGopaClosed.isNotEmpty) {
                                            CoolAlert.show(
                                                context: context,
                                                title: "GOPA not closed",
                                                text: isGopaClosed.toString(),
                                                barrierDismissible: false,
                                                flareAnimationName: "play",
                                                type: CoolAlertType.confirm,
                                                cancelBtnText: "",
                                                confirmBtnText: "Cancel",
                                                onCancelBtnTap: () {
                                                  Navigator.pop(context);
                                                },
                                                showCancelBtn: false,
                                                confirmBtnColor:
                                                    Colors.deepOrangeAccent);
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Level1Form(
                                                    type: '',
                                                    groundHandler:
                                                        searchortracklist[index]
                                                                [
                                                                'groundhandlerName']
                                                            .toString(),
                                                    conductedBy: '',
                                                    stationName:
                                                        searchortracklist[index]
                                                                ['stationName']
                                                            .toString(),
                                                    auditId: '',
                                                    auditDate: '',
                                                    airlineId: '',
                                                    auditNumber: '',
                                                    gopaScheduleNo:
                                                        searchortracklist[index]
                                                                ['scheduleNo']
                                                            .toString(),
                                                    gopaScheduledDate:
                                                        searchortracklist[index]
                                                                [
                                                                'gopaScheduledDate']
                                                            .toString(),
                                                  ),
                                                ));
                                          }
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Level1Form(
                                                  type: '',
                                                  groundHandler:
                                                      searchortracklist[index][
                                                              'groundhandlerName']
                                                          .toString(),
                                                  conductedBy: '',
                                                  stationName:
                                                      searchortracklist[index]
                                                              ['stationName']
                                                          .toString(),
                                                  auditId: '',
                                                  auditDate: '',
                                                  airlineId: '',
                                                  auditNumber: '',
                                                  gopaScheduleNo:
                                                      searchortracklist[index]
                                                              ['scheduleNo']
                                                          .toString(),
                                                  gopaScheduledDate:
                                                      searchortracklist[index][
                                                              'gopaScheduledDate']
                                                          .toString(),
                                                ),
                                              ));
                                        }
                                      } else {
                                        getGopaDraftList(
                                            searchortracklist[index]
                                                    ['groundhandlerName']
                                                .toString(),
                                            searchortracklist[index]
                                                    ['stationName']
                                                .toString(),
                                            searchortracklist[index]
                                                    ['scheduleNo']
                                                .toString(),
                                            searchortracklist[index]
                                                    ['gopaScheduledDate']
                                                .toString());
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                : const Center(
                    heightFactor: 22,
                    child: Text(
                      "No Records Found",
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  getScheduleStationsData() async {
    var stationsList = Utilities.scheduledStations;
    log('Station 1');
    log(stationsList.toString());
    searchortracklist = [];
    if (stationsList.length > 0) {
      var stationLength = stationsList.length;
      for (int i = 0; i < stationLength; i++) {
        log('Station 2');
        log(stationsList[i].toString());
        var listData = await getGopaScheduledData(stationsList[i]['id']);
        log('listData');
        log(listData.toString());
      }
    }
  }

  checkIsdarft() async {
    bool isOnline = await Utilities.CheckUserConnection();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var empNumber = pref.getString('employeeCode');
    // var draftAudits = await db.getGOPAOfflineDraftAudits(empNumber);
    // var arry = draftAudits[0]['auditID'].toString().split("_");
    if (isOnline) {
      ApiService.get("GetGOPADraftAudits?LoginEMPNumber=$empNumber",
              pref.getString('token'))
          .then((success) {
        setState(() {
          var body = jsonDecode(success.body);
          log('response body');
          log(body.toString());
          Utilities.draftList = body;
          log('Utilities.draftList');
          log(Utilities.draftList.toString());
          isdraftAvail = body;
          log('isdraftAvail');
          log(isdraftAvail.toString());
        });
      });
    } else {
      var draftObjdb = await db.getGOPADraftAudits(empNumber);
      setState(() {
        isdraftAvail = draftObjdb;
      });
    }
  }

  checkIsGopaClosed(airportSationId) async {
    bool isOnline = await Utilities.CheckUserConnection();
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (isOnline) {
      ApiService.get("IsGOPAClosedbasedonStation?StationID=$airportSationId",
              pref.getString('token'))
          .then((success) {
        List body = jsonDecode(success.body);
        isGopaClosed = body[0]['capaFullNumbers'].toString();
      });
    } else {
      var body = await db.GetIsGOPAClosedbasedonStation(airportSationId);
      isGopaClosed = body[0]['capaFullNumbers'].toString();
    }
  }

  getGopaScheduledData(sID) async {

    var emplogin;
    SharedPreferences pref = await SharedPreferences.getInstance();
    // Utilities.easyLoader();
    // EasyLoading.show(
    //   status: "Loading Scheduled Data",
    // );
    log('stationsid--------');
    log(sID.toString());
    var dataLength;
    emplogin = pref.getString("employeeCode").toString();
    bool isOnline = await Utilities.CheckUserConnection();
    if (isOnline) {
      log('IFFFFFFFFFFFFF');
      ApiService.get(
              "GetGOPAAUditScheduleList?StationID=$sID&AuditTypeID=${Utilities.empRole}&EMPNo=$emplogin",
              pref.getString('token'))
          .then((success) async {
        setState(() {
          var response = jsonDecode(success.body);
          log(response.toString());
          log("response==================");
          if (response.length > 0) {
            EasyLoading.addStatusCallback((status) {
              if (status == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });
            for (int i = 0; i < response.length; i++) {
              log('response[i].toString()');
              log(response[i].toString());
              searchortracklist.add(response[i]);
            }
            log('searchortracklist');
            log(searchortracklist.toString());
            // EasyLoading.showSuccess('Scheduled Data Loading Success');
          }
        });
      });
    } else {
      List body = await db.getGOPASearchTrackAudits(emplogin);
      dataLength = body.length;
      if (dataLength != 0) {
        EasyLoading.addStatusCallback((dataLength) {
          if (dataLength == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        setState(() {
          var response = body;
        });
        EasyLoading.showSuccess('Scheduled Data Loading Success');
      } else {
        EasyLoading.showInfo("No Records Found");
      }
    }
    checkIsGopaClosed(sID);
  }

  getGopaDraftList(
      groundhandlerName, stationName, scheduleNo, gopaScheduledDate) async {
    bool isOnline = await Utilities.CheckUserConnection();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var empCode = pref.getString('employeeCode');

    if (isOnline) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Level1Form(
              type: '',
              groundHandler: groundhandlerName.toString(),
              conductedBy: '',
              stationName: stationName.toString(),
              auditId: '',
              auditDate: '',
              airlineId: '',
              auditNumber: '',
              gopaScheduleNo: scheduleNo.toString(),
              gopaScheduledDate: gopaScheduledDate.toString(),
            ),
          ));
    } else {
      var gopaDrafts = await db.GetGOPADraftByAudtitDoneBy(empCode);

      if (gopaDrafts.length > 0) {
        CoolAlert.show(
            context: context,
            title: "A Draft Audit is Found",
            text: "You can't create more than one GOPA in Offline",
            barrierDismissible: false,
            flareAnimationName: "play",
            type: CoolAlertType.confirm,
            cancelBtnText: "",
            confirmBtnText: "Cancel",
            onCancelBtnTap: () {
              Navigator.pop(context);
            },
            showCancelBtn: false,
            confirmBtnColor: Colors.deepOrangeAccent);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Level1Form(
                type: '',
                groundHandler: groundhandlerName.toString(),
                conductedBy: '',
                stationName: stationName.toString(),
                auditId: '',
                auditDate: '',
                airlineId: '',
                auditNumber: '',
                gopaScheduleNo: scheduleNo.toString(),
                gopaScheduledDate: gopaScheduledDate.toString(),
              ),
            ));
      }
    }
  }
}

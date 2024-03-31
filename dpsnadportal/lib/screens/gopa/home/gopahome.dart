import 'dart:async';
import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiservice/restapi.dart';
import '../../../database/database_table.dart';
import '../../../helpers/utilities.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/responsive.dart';
import '../../../widgets/textstyle.dart';
import '../../home/homescreen.dart';
import '../assignedtome/assignedtomehomepage.dart';
import '../draft/gopadraftslist.dart';
import '../new/level1form.dart';
import '../scheduledgopa/gopaschedulelist.dart';
import '../searchortrack/gopa_searchortrack.dart';

class GopaHome extends StatefulWidget {
  const GopaHome({Key? key}) : super(key: key);

  @override
  State<GopaHome> createState() => _GopaHomeState();
}

class _GopaHomeState extends State<GopaHome> {
  bool isInternetAvailable = false;
  var checknet = 0;
  String toolTip = "";
  int loaderTimer = 1;
  late Icon netIcon = Icon(Icons.sync);
  List stationList = [];
  String? airportSationId = '';
  String? selectedStation = "";
  List airlineList = [];
  List groundHandlers = [];
  String? selectedGroundHandler = "";
  String? groundHandlerId = '';
  List checkList = [];
  var saveBody;
  String alertMsg = "";
  late Icon wifiIcon = Icon(Icons.wifi);

  DatabaseHelper db = DatabaseHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Utilities.draftList.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (Utilities.dataState == "Connection lost") {
      setState(() {
        isInternetAvailable = false;
        checknet = 0;
        netIcon = Icon(
          Icons.sync_disabled,
          size: 30,
        );
        alertMsg = "You are offline";
        wifiIcon = Icon(
          Icons.wifi_off,
          size: 30,
        );
        toolTip = "offline";
      });
    } else {
      setState(() {
        isInternetAvailable = true;
        netIcon = Icon(
          Icons.sync,
          size: 30,
        );
        alertMsg = "You are online";
        wifiIcon = Icon(
          Icons.wifi,
          size: 30,
        );
        toolTip = "Sync";
        checknet = 1;
        if (checknet == 1) {
          checknet++;
        }
      });
    }
    return Scaffold(
      backgroundColor: Color(0xFFe7e7e7),
      appBar: AppBar(
        title: Text('GOPA'),
        centerTitle: true,
        backgroundColor: Color(0xFFf5003a),
        actions: [
          IconButton(
            onPressed: () {
              Utilities.showAlert(context, alertMsg);
            },
            icon: wifiIcon,
          ),
          // IconButton(
          //   onPressed: () {
          //     //checkInternetConnection();
          //     if (isInternetAvailable == true) {
          //       loaderTimer = 30;
          //       _fetchData(context);
          //       saveGOPAData();
          //
          //       GOPAOfflineDB();
          //     } else {
          //       Utilities.showAlert(
          //           context, 'Please connect to Internet for Syncing data');
          //     }
          //   },
          //   icon: netIcon,
          //   tooltip: toolTip,
          // ),
          IconButton(
              tooltip: "Go to homepage",
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => AuditHome(
                              fromType: 'GopaHome',
                            )),
                    (Route<dynamic> route) => false);
              },
              icon: Icon(
                Icons.home,
                color: whiteColor,
                size: 30,
              ))
        ],
      ),
      body: Responsive(
        mobile: GopaHomePage(type: "mobile"),
        desktop: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: GopaHomePage(type: "desktop"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveGOPAData() async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var emplogin = pref.getString("employeeCode").toString();
    var draftAudits = await db.getGOPAOfflineDraftAudits(emplogin);

    List CCAChecklistsList = [];
    var FileAttachmentSaveBody;

    for (int i = 0; i < draftAudits.length; i++) {
      var arry = draftAudits[i]['auditID'].toString().split("_");

      if (arry.contains("GOPA")) {
        var auditNumber = draftAudits[i]['auditNumber'];
        var deleteauditNumber = draftAudits[i]['auditNumber'];
        var gopaDetailsBody =
            await db.getGOPAOverviewDataByAuditId(auditNumber);

        var attachmentsBody = await db.getOfflineGOPAItemImageData(auditNumber);

        var auditID = draftAudits[i]['auditID'];
        var GopaChecklistBody = await db.getGOPAChecklistDataByAuditId(auditID);
        for (int k = 0; k < GopaChecklistBody.length; k++) {
          var checklistObj = jsonEncode({
            "ObjectID": "0",
            "ChecklistID": GopaChecklistBody[k]['checklistID'],
            "ChecklistItemID": GopaChecklistBody[k]['checklistItemID'],
            "ChecklistItemDataID":
                GopaChecklistBody[k]['checklistItemDataID'].toString(),
            "EmpID": GopaChecklistBody[k]['empID'].toString(),
            "Comments": GopaChecklistBody[k]['comments'].toString(),
            "CheckListName": GopaChecklistBody[k]['checkListName'].toString(),
            "ItemName": GopaChecklistBody[k]['itemName'],
            "SubchecklistID": GopaChecklistBody[k]['subchecklistID'].toString(),
            "Subchecklistname":
                GopaChecklistBody[k]['subchecklistname'].toString(),
            "Checklistorder": GopaChecklistBody[k]['checklistorder'].toString(),
            "SubChecklistorder":
                GopaChecklistBody[k]['subChecklistorder'].toString(),
          });

          var gopachkbody1 = jsonDecode(checklistObj);
          CCAChecklistsList.add(gopachkbody1);
        }

        for (int j = 0; j < gopaDetailsBody.length; j++) {
          var code = gopaDetailsBody[j]['gopaNumber'].toString().split('/');
          var stationCode = code[0];

          var GopaSaveBody = jsonEncode({
            "AuditID": "0",
            "StationID": gopaDetailsBody[j]['stationID'],
            "AuditDoneby": emplogin,
            "AirlineIDs": gopaDetailsBody[j]['airlineIDs'],
            "StationCode": stationCode,
            "Restartoperations": gopaDetailsBody[j]['restartoperationsID'],
            "GGHID": gopaDetailsBody[j]['gghid'],
            "UserID": gopaDetailsBody[j]['userID'],
            "CCAChecklistsList": CCAChecklistsList,
          });

          var response;
          ApiService.post("NewGOPAPart1", GopaSaveBody, pref.getString('token'))
              .then((success) {
            var body = jsonDecode(success.body);

            if (body['auditID'] > 0) {
              CCAChecklistsList = [];
              var id = body['auditID'];
              var gopaId = body['auditID'];
              var gopaNum = body['auditNumber'];

              for (int k = 0; k < GopaChecklistBody.length; k++) {
                var checklistObj = jsonEncode({
                  "ObjectID": gopaId,
                  "ChecklistID": GopaChecklistBody[k]['checklistID'],
                  "ChecklistItemID": GopaChecklistBody[k]['checklistItemID'],
                  "ChecklistItemDataID":
                      GopaChecklistBody[k]['checklistItemDataID'].toString(),
                  "EmpID": GopaChecklistBody[k]['empID'].toString(),
                  "Comments": GopaChecklistBody[k]['comments'].toString(),
                  "CheckListName":
                      GopaChecklistBody[k]['checkListName'].toString(),
                  "ItemName": GopaChecklistBody[k]['itemName'],
                  "SubchecklistID":
                      GopaChecklistBody[k]['subchecklistID'].toString(),
                  "Subchecklistname":
                      GopaChecklistBody[k]['subchecklistname'].toString(),
                  "Checklistorder":
                      GopaChecklistBody[k]['checklistorder'].toString(),
                  "SubChecklistorder":
                      GopaChecklistBody[k]['subChecklistorder'].toString(),
                });

                var gopachkbody1 = jsonDecode(checklistObj);
                CCAChecklistsList.add(gopachkbody1);
              }

              var GopaSaveBody2 = jsonEncode({
                "StationID": gopaDetailsBody[j]['stationID'],
                "StationCode": stationCode,
                "AuditID": gopaId,
                "HoNumber": gopaDetailsBody[j]['HoNumber'],
                "GGHID": gopaDetailsBody[j]['gghid'],
                "AuditDate": '',
                "AuditDoneby": emplogin,
                "AirlineIDs": gopaDetailsBody[j]['airlineIDs'],
                "Statusid": gopaDetailsBody[j]['statusid'],
                "SubmittedBy": emplogin,
                "UserID": gopaDetailsBody[j]['userID'],
                "Msg": '',
                "ImageBase64": '',
                "ImageName": '',
                "AttachedByName": '',
                "SubmittedDate": gopaDetailsBody[j]['submittedDate'],
                "GOPANumber": gopaNum,
                "Restartoperations": gopaDetailsBody[j]['restartoperationsID'],
                "Sameserviceprovider": gopaDetailsBody[j]
                    ['sameserviceproviderID'],
                "PBhandling": gopaDetailsBody[j]['pBhandlingID'],
                "Ramphandling": gopaDetailsBody[j]['ramphandlingID'],
                "Cargohandling": gopaDetailsBody[j]['cargohandlingID'],
                "Deicingoperations": gopaDetailsBody[j]['deicingoperationsID'],
                "AircraftMarshalling": gopaDetailsBody[j]
                    ['aircraftMarshallingID'],
                "Loadcontrol": gopaDetailsBody[j]['loadcontrolID'],
                "Aircraftmovement": gopaDetailsBody[j]['aircraftmovementID'],
                "Headsetcommunication": gopaDetailsBody[j]
                    ['headsetcommunicationID'],
                "Passengerbridge": gopaDetailsBody[j]['passengerbridgeID'],
                "ISAGO": gopaDetailsBody[j]['isagoid'],
                "Duedate": gopaDetailsBody[j]['duedateID'],
                "Reason": gopaDetailsBody[j]['reason'],
                "PBhandlingServiceProvider": gopaDetailsBody[j]
                    ['pBhandlingServiceProvider'],
                "RamphandlingServiceProvider": gopaDetailsBody[j]
                    ['ramphandlingServiceProvider'],
                "CargohandlingServiceProvider": gopaDetailsBody[j]
                    ['cargohandlingServiceProvider'],
                "DeicingoperationsServiceProvider": gopaDetailsBody[j]
                    ['deicingoperationsServiceProvider'],
                "AircraftMarshallingServiceProvider": gopaDetailsBody[j]
                    ['aircraftMarshallingServiceProvider'],
                "LoadcontrolServiceProvider": gopaDetailsBody[j]
                    ['loadcontrolServiceProvider'],
                "AircraftmovementServiceProvider": gopaDetailsBody[j]
                    ['aircraftmovementServiceProvider'],
                "HeadsetcommunicationServiceProvider": gopaDetailsBody[j]
                    ['headsetcommunicationServiceProvider'],
                "PassengerbridgeServiceProvider": gopaDetailsBody[j]
                    ['passengerbridgeServiceProvider'],
                "CCAChecklistsList": CCAChecklistsList,
              });

              ApiService.post(
                      "NewGOPASave", GopaSaveBody2, pref.getString('token'))
                  .then((success) {
                var finalsavebody = jsonDecode(success.body);

                // Sync Attachment Data start
                if (attachmentsBody.length > 0) {
                  for (int i = 0; i < attachmentsBody.length; i++) {
                    FileAttachmentSaveBody = jsonEncode({
                      "PluginID": attachmentsBody[i]['PluginID'],
                      "AuditID": gopaId,
                      "AuditNumber": gopaNum,
                      "featurID": attachmentsBody[i]['featurID'],
                      "ChecklistID": attachmentsBody[i]['ChecklistID'],
                      "ChecklistItemID": attachmentsBody[i]['ChecklistItemID'],
                      "SubchecklistID":
                          attachmentsBody[i]['SubchecklistID'].toString(),
                      "FileName": attachmentsBody[i]['FileName'].toString(),
                      "AttachedBy": attachmentsBody[i]['AttachedBy'].toString(),
                      "ImageBase64":
                          attachmentsBody[i]['ImageBase64'].toString(),
                    });

                    ApiService.post("SaveFileAttachmentforChecklist",
                            FileAttachmentSaveBody, pref.getString('token'))
                        .then((success) {});
                  }
                }
                //end
              });
            }
          });
        }
        if (isOnline) {
          deleteDB(deleteauditNumber);
        }
      } else {
        var auditNumber = draftAudits[i]['auditNumber'];
        var deleteauditNumber = draftAudits[i]['auditNumber'];
        var auditID = draftAudits[i]['auditID'];
        CCAChecklistsList = [];
        var gopaDetailsBody = await db.getGOPAOverviewDataByAuditId(auditID);

        var attachmentsBody = await db.getOfflineGOPAItemImageData(auditNumber);

        var GopaChecklistBody = await db.getGOPAChecklistDataByAuditId(auditID);

        for (int j = 0; j < gopaDetailsBody.length; j++) {
          var code = gopaDetailsBody[j]['gopaNumber'].toString().split('/');
          var stationCode = code[0];

          for (int k = 0; k < GopaChecklistBody.length; k++) {
            var checklistObj = jsonEncode({
              "ObjectID": draftAudits[i]['auditID'],
              "ChecklistID": GopaChecklistBody[k]['checklistID'],
              "ChecklistItemID": GopaChecklistBody[k]['checklistItemID'],
              "ChecklistItemDataID":
                  GopaChecklistBody[k]['checklistItemDataID'].toString(),
              "EmpID": GopaChecklistBody[k]['empID'].toString(),
              "Comments": GopaChecklistBody[k]['comments'].toString(),
              "CheckListName": GopaChecklistBody[k]['checkListName'].toString(),
              "ItemName": GopaChecklistBody[k]['itemName'],
              "SubchecklistID":
                  GopaChecklistBody[k]['subchecklistID'].toString(),
              "Subchecklistname":
                  GopaChecklistBody[k]['subchecklistname'].toString(),
              "Checklistorder":
                  GopaChecklistBody[k]['checklistorder'].toString(),
              "SubChecklistorder":
                  GopaChecklistBody[k]['subChecklistorder'].toString(),
            });

            var gopachkbody1 = jsonDecode(checklistObj);
            CCAChecklistsList.add(gopachkbody1);
          }

          var GopaSaveBody2 = jsonEncode({
            "StationID": gopaDetailsBody[j]['stationID'],
            "StationCode": stationCode,
            "AuditID": draftAudits[i]['auditID'],
            "HoNumber": gopaDetailsBody[j]['HoNumber'],
            "GGHID": gopaDetailsBody[j]['gghid'],
            "AuditDate": '',
            "AuditDoneby": emplogin,
            "AirlineIDs": gopaDetailsBody[j]['airlineIDs'],
            "Statusid": gopaDetailsBody[j]['statusid'],
            "SubmittedBy": emplogin,
            "UserID": gopaDetailsBody[j]['userID'],
            "Msg": '',
            "ImageBase64": '',
            "ImageName": '',
            "AttachedByName": '',
            "SubmittedDate": gopaDetailsBody[j]['submittedDate'],
            "GOPANumber": draftAudits[i]['auditNumber'],
            "Restartoperations": gopaDetailsBody[j]['restartoperationsID'],
            "Sameserviceprovider": gopaDetailsBody[j]['sameserviceproviderID'],
            "PBhandling": gopaDetailsBody[j]['pBhandlingID'],
            "Ramphandling": gopaDetailsBody[j]['ramphandlingID'],
            "Cargohandling": gopaDetailsBody[j]['cargohandlingID'],
            "Deicingoperations": gopaDetailsBody[j]['deicingoperationsID'],
            "AircraftMarshalling": gopaDetailsBody[j]['aircraftMarshallingID'],
            "Loadcontrol": gopaDetailsBody[j]['loadcontrolID'],
            "Aircraftmovement": gopaDetailsBody[j]['aircraftmovementID'],
            "Headsetcommunication": gopaDetailsBody[j]
                ['headsetcommunicationID'],
            "Passengerbridge": gopaDetailsBody[j]['passengerbridgeID'],
            "ISAGO": gopaDetailsBody[j]['isagoid'],
            "Duedate": gopaDetailsBody[j]['duedateID'],
            "Reason": gopaDetailsBody[j]['reason'],
            "PBhandlingServiceProvider": gopaDetailsBody[j]
                ['pBhandlingServiceProvider'],
            "RamphandlingServiceProvider": gopaDetailsBody[j]
                ['ramphandlingServiceProvider'],
            "CargohandlingServiceProvider": gopaDetailsBody[j]
                ['cargohandlingServiceProvider'],
            "DeicingoperationsServiceProvider": gopaDetailsBody[j]
                ['deicingoperationsServiceProvider'],
            "AircraftMarshallingServiceProvider": gopaDetailsBody[j]
                ['aircraftMarshallingServiceProvider'],
            "LoadcontrolServiceProvider": gopaDetailsBody[j]
                ['loadcontrolServiceProvider'],
            "AircraftmovementServiceProvider": gopaDetailsBody[j]
                ['aircraftmovementServiceProvider'],
            "HeadsetcommunicationServiceProvider": gopaDetailsBody[j]
                ['headsetcommunicationServiceProvider'],
            "PassengerbridgeServiceProvider": gopaDetailsBody[j]
                ['passengerbridgeServiceProvider'],
            "CCAChecklistsList": CCAChecklistsList,
          });
          ApiService.post("NewGOPASave", GopaSaveBody2, pref.getString('token'))
              .then((success) {
            var finalsavebody = jsonDecode(success.body);

            // Sync Attachment Data start
            if (attachmentsBody.length > 0) {
              for (int j = 0; j < attachmentsBody.length; j++) {
                FileAttachmentSaveBody = jsonEncode({
                  "PluginID": attachmentsBody[j]['PluginID'],
                  "AuditID": draftAudits[i]['auditID'],
                  "AuditNumber": draftAudits[i]['auditNumber'],
                  "featurID": attachmentsBody[j]['featurID'],
                  "ChecklistID": attachmentsBody[j]['ChecklistID'],
                  "ChecklistItemID": attachmentsBody[j]['ChecklistItemID'],
                  "SubchecklistID":
                      attachmentsBody[j]['SubchecklistID'].toString(),
                  "FileName": attachmentsBody[j]['FileName'].toString(),
                  "AttachedBy": attachmentsBody[j]['AttachedBy'].toString(),
                  "ImageBase64": attachmentsBody[j]['ImageBase64'].toString(),
                });

                ApiService.post("SaveFileAttachmentforChecklist",
                        FileAttachmentSaveBody, pref.getString('token'))
                    .then((success) {});
              }
            }
            //end
          });
        }
        if (isOnline) {
          deleteDB(deleteauditNumber);
        }
      }
    }
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => AuditHome()),
    //         (Route<dynamic> route) => false);
  }

  deleteDB(deleteauditNumber) async {
    await db.deleteGOPA(deleteauditNumber);
  }

  GOPAOfflineDB() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var emplogin = pref.getString("employeeCode").toString();
    var userId = pref.getString("userID").toString();

    // GOPA Checklist Api
    SharedPreferences prefRole = await SharedPreferences.getInstance();

    // var auditType;
    // var logRole;

    // setState(() {
    //   logRole = prefRole.getString('user_role');
    //   if (logRole == 'APM') {
    //     auditType = '1';
    //   } else if (logRole == 'RM') {
    //     auditType = '2';
    //   }
    // });

    //await db.AddColumn();

    // GOPA Draft Audits Api
    ApiService.get("GetGOPADraftAudits?LoginEMPNumber=$emplogin",
            pref.getString('token'))
        .then((success) async {
      // setState(() {
      var gopaDraftAudits = json.decode(success.body);

      for (int i = 0; i < gopaDraftAudits.length; i++) {
        await db.saveGOPADraftAudits(gopaDraftAudits[i], 1);

        var auditId = gopaDraftAudits[i]["auditID"];
        var auditNumber = gopaDraftAudits[i]["auditNumber"];
        ApiService.get(
                "GetGOPADataBasedonAuditID?AuditID=$auditId&AuditNumber=$auditNumber",
                pref.getString('token'))
            .then((success) async {
          var data = jsonDecode(success.body);
          var gopaoverviewdata1;
          var gopaoverviewchecklistdata1;
          var PluginID = 137;

          setState(() {
            gopaoverviewdata1 = data["auditGOPAOverviewMaindata"];
            gopaoverviewchecklistdata1 = data["ccaChecklistsList"];
          });

          for (int i = 0; i < gopaoverviewdata1.length; i++) {
            await db.saveGOPAOverviewDetails(gopaoverviewdata1[i]);
            GetMOAirlinesDataByStationGopaNumber(
                gopaoverviewdata1[i]['stationID'],
                gopaoverviewdata1[i]['auditNumber']);
          }

          if (gopaoverviewchecklistdata1.length > 0) {
            for (int i = 0; i < gopaoverviewchecklistdata1.length; i++) {
              await db.saveGOPAOverviewChecklistData(
                  gopaoverviewchecklistdata1[i], auditId, auditNumber, 1);

              if (gopaoverviewchecklistdata1[i]['imagename'] != "") {
                saveGOPAItemImageData(
                    gopaoverviewchecklistdata1[i], auditNumber, PluginID);
              }
            }
          }
        });

        ApiService.get(
                "GetMOMasterData?GOPANo=$auditNumber", pref.getString('token'))
            .then((success) async {
          var body = jsonDecode(success.body);

          var moIntrelinks =
              body['mointerlinksforchecklist'][0]['moIntrelinks'];
          var loadControl =
              body['mointerlinksforloadcontrols'][0]['loadControl'];
          var passengerBoardingBridge =
              body['mointerlinksforPassengerBoardingBridge'][0]
                  ['passengerBoardingBridge'];

          await db.saveMOMasterData(
              auditNumber, moIntrelinks, loadControl, passengerBoardingBridge);
        });
      }
      //});
    });

    ApiService.get("GetCAPAModules", pref.getString('token'))
        .then((success) async {
      //setState(() {
      var capaModulesList = json.decode(success.body);
      for (int i = 0; i < capaModulesList.length; i++) {
        await db.saveCapaModulesListMasterData(capaModulesList[i]);
      }
      //});
    });

    ApiService.get("GetGOPAScopeMasterData", pref.getString('token'))
        .then((success) async {
      //setState(() {
      var scopeOfAudit = json.decode(success.body);
      var getGOPAScopeMasterData = scopeOfAudit['getGOPAScopeMasterData'];
      for (int i = 0; i < getGOPAScopeMasterData.length; i++) {
        await db.saveScopeOfAuditMasterData(getGOPAScopeMasterData[i]);
      }
      //});
    });

    ApiService.get(
            "GetMenubasedonLoginEMPNo?EMPNumber=$emplogin&UserID=$userId",
            pref.getString('token'))
        .then((success) async {
      //setState(() {

      var primaryMenu = json.decode(success.body);

      var getPrimaryMenuMasterData = primaryMenu['dyMenuPlugin'];
      var getSecondryMenuMasterData = primaryMenu['dyMenuFeature'];
      for (int i = 0; i < getPrimaryMenuMasterData.length; i++) {
        await db.savePrimaryMenuMasterData(getPrimaryMenuMasterData[i]);
      }
      for (int i = 0; i < getSecondryMenuMasterData.length; i++) {
        await db.saveSecondryMenuMasterData(getSecondryMenuMasterData[i]);
      }
      //});
    });

    ApiService.get("GetChecklistRating", pref.getString('token'))
        .then((success) async {
      //setState(() {
      var checklistRating = json.decode(success.body);

      var getChecklistRatingcommnMasterData =
          checklistRating['checklistRatingcommn'];
      var getChecklistRatingIDbasedMasterData =
          checklistRating['checklistRatingIDbased'];
      for (int i = 0; i < getChecklistRatingcommnMasterData.length; i++) {
        await db.saveChecklistRatingcommnMasterData(
            getChecklistRatingcommnMasterData[i]);
      }
      for (int i = 0; i < getChecklistRatingIDbasedMasterData.length; i++) {
        await db.saveChecklistRatingIDbasedMasterData(
            getChecklistRatingIDbasedMasterData[i]);
      }
      //});
    });
  }

  saveGOPAItemImageData(checklistData, auditNumber, PluginID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var checklistID = checklistData["checklistID"].toString();
    var checklistItemID = checklistData["checklistItemID"].toString();
    var imagename = checklistData["imagename"].toString();
    var auditId = checklistData["objectID"].toString();
    ApiService.get(
            "GetAttachmentbasedonChecklistID?PluginID=$PluginID&AuditID=$auditId&AuditNumber=$auditNumber&ChecklistID=$checklistID&ChecklistItemID=$checklistItemID&FileName=$imagename",
            pref.getString('token'))
        .then((success) {
      var body = jsonDecode(success.body);

      saveQueryCalling(body.toString(), checklistData, auditNumber, PluginID);
    });
  }

  saveQueryCalling(ImgBase64, checklistData, auditNumber, PluginID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var emplogin = pref.getString("employeeCode").toString();

    var FileAttachmentSaveBody = jsonEncode({
      "PluginID": PluginID,
      "AuditID": checklistData["objectID"].toString(),
      "AuditNumber": auditNumber,
      "featurID": 0,
      "ChecklistID": checklistData["checklistID"].toString(),
      "ChecklistItemID": checklistData["checklistItemID"].toString(),
      "SubchecklistID": checklistData["subchecklistID"].toString(),
      "FileName": checklistData["imagename"].toString(),
      "AttachedBy": emplogin,
      "ImageBase64": ImgBase64,
    });

    await db.SaveFileAttachmentforChecklist(
        jsonDecode(FileAttachmentSaveBody), 1);
  }

  GetMOAirlinesDataByStationGopaNumber(StationID, GOPANumber) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ApiService.get(
            "GetMOAirlinesData?StationID=$StationID&GOPANumber=$GOPANumber",
            pref.getString('token'))
        .then((success) async {
      var MOAirlinesData = json.decode(success.body);

      if (MOAirlinesData.length > 0) {
        for (int i = 0; i < MOAirlinesData.length; i++) {
          await db.saveMOAirlinesData(MOAirlinesData[i], StationID, GOPANumber);
          IsMOExists(MOAirlinesData[i]['id'], GOPANumber);
          ISAnnexuresdraftedmodebsedrGOPAandAirlineID(
              MOAirlinesData[i]['id'], GOPANumber);
          GetPreviousAnnexuresFlighNoandDate(
              MOAirlinesData[i]['id'], StationID);
        }
      }
    });
  }

  GetPreviousAnnexuresFlighNoandDate(airlineID, StationID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ApiService.get(
            "PreviousAnnexuresFlighNoandDate?AirlineID=$airlineID&SationID=$StationID",
            pref.getString('token'))
        .then((success) async {
      var body = jsonDecode(success.body);
      for (int i = 0; i < body.length; i++) {
        db.savePreviousAnnexuresFlighNoandDate(body[i], airlineID, StationID);
      }
    });
  }

  IsMOExists(airlineID, GOPANumber) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ApiService.get("IsMOexists?GOPAID=$GOPANumber&AirlineID=$airlineID",
            pref.getString('token'))
        .then((success) async {
      var body = jsonDecode(success.body);
      for (int i = 0; i < body.length; i++) {
        db.saveIsMOexists(body[i], GOPANumber, airlineID, 1);
      }
    });
  }

  ISAnnexuresdraftedmodebsedrGOPAandAirlineID(airlineID, GOPANumber) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ApiService.get(
            "ISAnnexuresdraftedmodebsedrGOPAandAirlineID?GOPANumber=$GOPANumber&AirlineID=$airlineID",
            pref.getString('token'))
        .then((success) async {
      var body = jsonDecode(success.body);
      for (int i = 0; i < body.length; i++) {
        db.saveIsMOexists(body[i], GOPANumber, airlineID, 2);
      }
    });
  }
}

class GopaHomePage extends StatefulWidget {
  final String type;
  const GopaHomePage({Key? key, required this.type}) : super(key: key);

  @override
  State<GopaHomePage> createState() => _GopaHomePageState();
}

class _GopaHomePageState extends State<GopaHomePage> {
  DatabaseHelper db = DatabaseHelper();
  var isdraftAvail = [];
  var isGopaClosed;
  String Username = "";
  String employeid = "";
  String empRole = "";
  String airportSationId = "";
  bool visible = false;
  bool isvisible = false;
  String pluginImage = "";
  List stationList = [];
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    setUsername();
    //getGopaNumber();
    employeeidlogin();
    checkIsdarft();
    makeStationApiCall();
  }

  setUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading DPSNAD",
    );
    setState(() {
      Username = pref.getString("firstName").toString() +
          " " +
          pref.getString("lastName").toString();
    });
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
          Utilities.draftList = body;
          isdraftAvail = body;
        });
      });
    } else {
      var draftObjdb = await db.getGOPADraftAudits(empNumber);
      setState(() {
        isdraftAvail = draftObjdb;
      });
    }
  }

  makeStationApiCall() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading GOPA",
    );
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    var dataLength;
    if (isOnline) {
      ApiService.get(
              "GetGOPAStationsData?EMPNO=${pref.getString('employeeCode')}",
              pref.getString('token'))
          .then((success) {
        setState(() {
          if (success.statusCode == 200) {
            EasyLoading.addStatusCallback((status) {
              if (status == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });
            stationList = jsonDecode(success.body);
            Utilities.scheduledStations = stationList;
            if (stationList.length < 2) {
              airportSationId = stationList[0]['id'];
            }
            for (int i = 0; i < stationList.length; i++) {
              airportSationId = stationList[i]['id'];
            }
            checkIsGopaClosed(airportSationId);
            EasyLoading.showSuccess('Loading Success');
          } else {
            EasyLoading.showInfo("Data Loading Failed");
          }
        });
      });
    } else {
      var body = await db.getStation(pref.getString('employeeCode'));
      setState(() {
        var stationList = body;
        Utilities.scheduledStations = stationList;
        dataLength = stationList.length;

        if (dataLength != 0) {
          EasyLoading.addStatusCallback((dataLength) {
            if (dataLength == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          if (stationList.length < 2) {
            airportSationId = stationList[0]['id'];
          }
          for (int i = 0; i < stationList.length; i++) {
            airportSationId = stationList[i]['id'];
          }

          checkIsGopaClosed(airportSationId);
          EasyLoading.showSuccess('Loading Success');
        } else {
          EasyLoading.showInfo("Data Loading Failed");
        }
      });
    }
  }

  checkIsGopaClosed(airportSationId) async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/login_logo1.png',
              ),
              alignment: Alignment.center,
              opacity: 0.05)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Welcome " + Username,
                  style: TextStyle(
                      color: darkgrey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                  child: GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.type == 'mobile' ? 3 : 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: Utilities.dynMenudata.length,
                itemBuilder: (BuildContext context, index) {
                  var subNames = jsonDecode(Utilities.dynMenudata[index]);

                  setImage(subNames['subIds']);
                  return GestureDetector(
                    onTap: () async {
                      bool isOnline = await Utilities.CheckUserConnection();
                      var navId = subNames['subIds'];
                      if (navId == '427') {
                        Get.to(() => const GopaScheduleList());
                        // if (empRole == "APM") {
                        //   if (stationList.length < 2) {
                        //     if (isdraftAvail.isNotEmpty) {
                        //       CoolAlert.show(
                        //           context: context,
                        //           title: "A Draft Audit is Found",
                        //           text:
                        //               "Please Select And Edit From Draft List",
                        //           barrierDismissible: false,
                        //           flareAnimationName: "play",
                        //           type: CoolAlertType.confirm,
                        //           cancelBtnText: "",
                        //           confirmBtnText: "Cancel",
                        //           onCancelBtnTap: () {
                        //             Navigator.pop(context);
                        //           },
                        //           showCancelBtn: false,
                        //           confirmBtnColor: Colors.deepOrangeAccent);
                        //     } else if (isGopaClosed.isNotEmpty) {
                        //       CoolAlert.show(
                        //           context: context,
                        //           title: "GOPA not closed",
                        //           text: isGopaClosed.toString(),
                        //           barrierDismissible: false,
                        //           flareAnimationName: "play",
                        //           type: CoolAlertType.confirm,
                        //           cancelBtnText: "",
                        //           confirmBtnText: "Cancel",
                        //           onCancelBtnTap: () {
                        //             Navigator.pop(context);
                        //           },
                        //           showCancelBtn: false,
                        //           confirmBtnColor: Colors.deepOrangeAccent);
                        //     } else {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => Level1Form(
                        //               type: '',
                        //               groundHandler: '',
                        //               conductedBy: '',
                        //               stationName: '',
                        //               auditId: '',
                        //               auditDate: '',
                        //               airlineId: '',
                        //               auditNumber: '',
                        //             ),
                        //           ));
                        //     }
                        //   } else {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => Level1Form(
                        //             type: '',
                        //             groundHandler: '',
                        //             conductedBy: '',
                        //             stationName: '',
                        //             auditId: '',
                        //             auditDate: '',
                        //             airlineId: '',
                        //             auditNumber: '',
                        //           ),
                        //         ));
                        //   }
                        // } else {
                        //   GetGopaDraftList();
                        // }
                      } else if (navId == '433') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const Gopasearchortrack()));
                      } else if (navId == '435') {
                        Utilities.showAlert(
                            context, 'Development is in progress');
                      } else if (navId == '436') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DraftList()));
                      } else if (navId == '437') {
                        Utilities.showAlert(
                            context, 'Development is in progress');
                      } else if (navId == '452') {
                        Utilities.showAlert(
                            context, 'Development is in progress');
                      } else {
                        Utilities.showAlert(
                            context, 'Development is in progress');
                      }
                    },
                    child: SizedBox(
                      height: 60,
                      width: 30,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              pluginImage,
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              subNames['subMenuName'],
                              textAlign: TextAlign.center,
                              style: AppTextStyle.notosansRegular(
                                  color: Color(0xFF3a454b), size: 10.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  GetGopaDraftList() async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var empCode = pref.getString('employeeCode');

    if (isOnline) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Level1Form(
              type: '',
              groundHandler: '',
              conductedBy: '',
              stationName: '',
              auditId: '',
              auditDate: '',
              airlineId: '',
              auditNumber: '',
              gopaScheduleNo: '',
              gopaScheduledDate: '',
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
              builder: (context) => const Level1Form(
                type: '',
                groundHandler: '',
                conductedBy: '',
                stationName: '',
                auditId: '',
                auditDate: '',
                airlineId: '',
                auditNumber: '',
                gopaScheduleNo: '',
                gopaScheduledDate: '',
              ),
            ));
      }
    }
  }

  setImage(imageId) {
    if (imageId == '427') {
      pluginImage = 'assets/icons/newaudit_icon.png';
    } else if (imageId == '433') {
      pluginImage = 'assets/icons/searchtrack_icon.png';
    } else if (imageId == '435') {
      pluginImage = 'assets/icons/assignedtome_icon.png';
    } else if (imageId == '436') {
      pluginImage = 'assets/icons/draftaudit_icon.png';
    } else if (imageId == '437') {
      pluginImage = 'assets/icons/dashboard_icon.png';
    } else if (imageId == '452') {
      pluginImage = 'assets/icons/calender_icon.png';
    } else {
      pluginImage = 'assets/icons/draftaudit_icon.png';
    }
  }

////////userlogin//////////////
  employeeidlogin() async {
    SharedPreferences prefRole = await SharedPreferences.getInstance();
    SharedPreferences pref = await SharedPreferences.getInstance();
    empRole = prefRole.getString("user_role").toString();

    setState(() {
      employeid = pref.getString("employeeID").toString();

      setState(() {
        if (employeid == "106") {
          isvisible = true;
          visible = false;
        } else {
          isvisible = false;
          visible = true;
        }
      });
    });
  }
}

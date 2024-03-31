import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/restapi.dart';
import '../../../database/database_table.dart';
import '../../../widgets/constants.dart';

class GOPASync extends StatefulWidget {
  const GOPASync({Key? key}) : super(key: key);

  @override
  State<GOPASync> createState() => _GOPASyncState();
}

class _GOPASyncState extends State<GOPASync> {
  List checkList = [];
  List dbcheckList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdraftObj();
  }

  DatabaseHelper db = DatabaseHelper();
  List oflneCheckList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sync"),
        backgroundColor: red,
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
        child: oflneCheckList.isEmpty?Center(
          child: Text('No Data',style: TextStyle(color:blackColor,fontSize: 20,fontWeight: FontWeight.bold),),
        ):ListView.builder(
          itemCount: oflneCheckList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: darkgrey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(10),
                        1: FlexColumnWidth(15)
                      },
                      children: [
                        TableRow(children: [
                          TableCell(
                              child: Container(
                                  child: Text(
                            "Audit Id",
                            style: TextStyle(
                                fontSize: textSize, color: whiteColor),
                          ))),
                          TableCell(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                  child:
                                      Text(oflneCheckList[index]['auditID'],
                                        style: TextStyle(
                                            fontSize: textSize, color: whiteColor),))),
                        ]),
                        TableRow(children: [
                          TableCell(child: Text("Station",
                            style: TextStyle(
                                fontSize: textSize, color: whiteColor),)),
                          TableCell(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                    oflneCheckList[index]['stationAirport'],
                                  style: TextStyle(
                                      fontSize: textSize, color: whiteColor),),
                              )),
                        ]),
                        TableRow(children: [
                          TableCell(child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text("Groung Handler",
                              style: TextStyle(
                                  fontSize: textSize, color: whiteColor),),
                          )),
                          TableCell(
                              child:
                                  Text(oflneCheckList[index]['groundHandler'],
                                    style: TextStyle(
                                        fontSize: textSize, color: whiteColor),))
                        ]),
                        TableRow(
                          children: [
                            TableCell(child: Text("Status",
                              style: TextStyle(
                                  fontSize: textSize, color: whiteColor),)),
                            TableCell(child: Text(oflneCheckList[index]['isSynched']==1?"Offline":"--",
                              style: TextStyle(
                                  fontSize: textSize, color: whiteColor),))
                          ]
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, left: 180),
                    child: ElevatedButton(
                      onPressed: () {
                        synchOnline(oflneCheckList[index]['auditID']);
                      },
                      child: Text("Sync"),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          backgroundColor:
                              MaterialStateProperty.all(red)),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  getdraftObj() async {
    var draftObj = await db.getGOPADraftCheckList();
    // var draftList= {};
    // for(int i=0;i<draftObj.length;i++){
    //   draftList['auditID']= draftObj[i]['auditID'];
    //
    //   setState(() {
    //     oflneCheckList.add(draftList);
    //   });
    // }
    setState(() {
      oflneCheckList = draftObj;
    });

  }
  void synchOnline(auditId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var checkListObj = await db.getGOPACheckListByAuditId(auditId);

    for (int i = 0; i < checkListObj.length; i++) {
      var result = jsonEncode({
        "ObjectID": "",
        "ChecklistID": checkListObj[i]['id'],
        "checklistItemID": checkListObj[i]['chkId'],
        "ChecklistItemDataID": checkListObj[i]['ratingStatus'],
        // "status": checkListObj[i]['ratingStatus'],
        "Comments": checkListObj[i]['followUp']
      });
      var offlineResult = jsonEncode({
        "chkName":checkListObj[i]['chkName'],
        "chkId":checkListObj[i]['chkId'],
        "uploadFileName":checkListObj[i]['uploadFileName'],
        "followUp":checkListObj[i]['followUp'],
        "ratingStatus":checkListObj[i]['ratingStatus'],
        "id":checkListObj[i]['id'],
        "subHeading":checkListObj[i]['subHeading'],
        "auditNumber":checkListObj[i]['auditNumber'],
      });
      checkList.add(jsonDecode(result));
      dbcheckList.add(offlineResult);
    }

    var saveBody = jsonEncode({
      "StationID": checkListObj[0]['stationId'],
      "AuditID": auditId,
      "GGHID": checkListObj[0]['groundHandlerId'],
      "AuditDate": checkListObj[0]['auditDate'],
      "AuditDoneby": checkListObj[0]['conductedId'],
      "AirlineIDs": checkListObj[0]['airlineIds'],
      "Statusid": checkListObj[0]['Statusid'],
      "SubmittedBy": checkListObj[0]['conductedId'],
      "UserID": checkListObj[0]['userId'],
      "AuditNumber": "",
      "CCAChecklistsList": checkList
    });
    var saveBody1 = jsonEncode({
      "stationId": checkListObj[0]['stationId'],
      "auditId": auditId,
      "groundHandlerId": checkListObj[0]['groundHandlerId'],
      "groundHandler": checkListObj[0]['groundHandler'],
      "auditDate": checkListObj[0]['auditDate'],
      "AuditDoneby": checkListObj[0]['conductedId'],
      "airlineIds": checkListObj[0]['airlineIds'],
      "airlineCode": checkListObj[0]['airlineCode'],
      "stationId": checkListObj[0]['stationId'],
      "stationAirport": checkListObj[0]['stationAirport'],



    });

    var requestbody=jsonEncode({
      "isSynched":"0",
      "SubmittedBy": checkListObj[0]['userId'],
      "conductAudit": checkListObj[0]['conductAudit'],
      "Statusid": checkListObj[0]['Statusid'],

    });

    // print(dbcheckList);
    // print("---------");
    // print(requestbody);

     ApiService.post("NewGOPASave", saveBody, pref.getString('token'))
        .then((success) {
    //db.saveGOPAcheckList(saveBody1, dbcheckList, requestbody);

         // var body  = success.body;
          if(success.body.toString() !=""){
           // db.saveGOPAcheckList(saveBody1, dbcheckList, requestbody);
            print("--sucess");
          }else{
            print("--fail");
          }
     });
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/restapi.dart';
import '../../../database/database_table.dart';
import '../../../helpers/utilities.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/responsive.dart';
import '../overview/gopatrackoverview.dart';

// import '../annexurehome/annexureoverview.dart';
class Gopasearchortrack extends StatefulWidget {
  const Gopasearchortrack({Key? key}) : super(key: key);

  @override
  State<Gopasearchortrack> createState() => _GopasearchortrackState();
}

class _GopasearchortrackState extends State<Gopasearchortrack> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: searchortrack(),
      desktop: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: searchortrack(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class searchortrack extends StatefulWidget {
  const searchortrack({Key? key}) : super(key: key);

  @override
  State<searchortrack> createState() => _searchortrackState();
}

class _searchortrackState extends State<searchortrack> {
  List searchortracklist = [{"subject":"Drawing"}];
  List tempnocSearchList = [{"subject":"Drawing"}];
  DatabaseHelper db = DatabaseHelper();
  Timer? _timer;

  @override
  void initState() {
    // GetGopaSearchData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        title: Text("Daily Assignment List"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   height: 50,
            //   decoration: BoxDecoration(
            //       color: Color(0xFFdbdbdb),
            //       borderRadius: BorderRadius.circular(10)),
            //   margin: EdgeInsets.all(10),
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //         border: InputBorder.none,
            //         contentPadding: EdgeInsets.only(left: 10, top: 12),
            //         hintText: "Search by Subject",
            //         suffixIcon: Icon(Icons.search)),
            //     onChanged: (value) {
            //       // filterList(value.toString());
            //     },
            //   ),
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                child: searchortracklist.isNotEmpty
                    ? SafeArea(
                      bottom: true,
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
                                          padding:
                                              const EdgeInsets.all(5.0),
                                          child: Text("Subject",
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: textSize)),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding:
                                              const EdgeInsets.all(5.0),
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
                                          padding:
                                              const EdgeInsets.all(5.0),
                                          child: Text("Title",
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: textSize)),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding:
                                              const EdgeInsets.all(5.0),
                                          child: Text(
                                              "Standing Lines",
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: textSize)),
                                        )),
                                      ]),

                                      TableRow(children: [
                                        TableCell(
                                            child: Padding(
                                          padding:
                                              const EdgeInsets.all(5.0),
                                          child: Text("Homework Date",
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: textSize)),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding:
                                              const EdgeInsets.all(5.0),
                                          child: Text(
                                              "02-03-2024",
                                              style: TextStyle(
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
                                        padding: EdgeInsets.all(8),
                                        primary: red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Text(
                                        "Overview",
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontSize: textSize),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GopatrackOverview(
                                                      gopaAuditid:
                                                          "1",
                                                      gopaAuditnumber:
                                                          "1",
                                                      navType: 'overview',
                                                    )));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    )
                    : Center(
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
          ],
        ),
      ),
    );
  }

  GetGopaSearchData() async {
    var emplogin;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading Search/Track Data",
    );
    // _fetchData(context);
    var dataLength;
    emplogin = pref.getString("employeeCode").toString();

    bool isOnline = await Utilities.CheckUserConnection() as bool;
    if (isOnline) {
      ApiService.get("GetGOPAFUllAuditData?LoginEMPNumber=$emplogin",
              pref.getString('token'))
          .then((success) async {

        setState(() {
          if (success.statusCode == 200) {
            EasyLoading.addStatusCallback((status) {

              if (status == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });
            searchortracklist = jsonDecode(success.body);
            tempnocSearchList = jsonDecode(success.body);
            dataLength = searchortracklist.length;

            searchortracklist.isNotEmpty
                ? EasyLoading.showSuccess('Search/Track Data Loading Success')
                : EasyLoading.showInfo("No Records Found");
          } else {
            EasyLoading.showInfo("No Records Found");
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
          searchortracklist = body;
        });
        EasyLoading.showSuccess('Search/Track Data Loading Success');
      } else {
        EasyLoading.showInfo("No Records Found");
      }
    }
  }

  filterList(val) async {
    setState(() {
      searchortracklist = [];
      for (int i = 0; i < tempnocSearchList.length; i++) {
        String auditNo = tempnocSearchList[i]["auditNumber"].toString();
        String stationName = tempnocSearchList[i]["stationName"].toString();
        String enteredValue = val.toString();

        if (auditNo.toLowerCase() == enteredValue.toLowerCase()) {

          searchortracklist.add(tempnocSearchList[i]);
          break;
        } else if (auditNo.toLowerCase().contains(enteredValue.toLowerCase())) {

          searchortracklist.add(tempnocSearchList[i]);
        } else if (stationName
            .toLowerCase()
            .contains(enteredValue.toLowerCase())) {

          searchortracklist.add(tempnocSearchList[i]);
        }
      }
    });
  }
}

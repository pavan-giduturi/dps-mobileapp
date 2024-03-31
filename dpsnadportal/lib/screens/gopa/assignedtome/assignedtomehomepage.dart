import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/restapi.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/responsive.dart';
import '../overview/gopatrackoverview.dart';
class Assignedtome extends StatefulWidget {
  const Assignedtome({Key? key}) : super(key: key);

  @override
  State<Assignedtome> createState() => _AssignedtomeState();
}

class _AssignedtomeState extends State<Assignedtome> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Assignedtome1(),
      desktop: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*1,
                  child: Assignedtome1(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class Assignedtome1 extends StatefulWidget {
  const Assignedtome1({Key? key}) : super(key: key);

  @override
  State<Assignedtome1> createState() => _Assignedtome1State();
}

class _Assignedtome1State extends State<Assignedtome1> {
  List assignedtracklist=[];
  @override
  void initState(){
    GetGetAssignedSearchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        title: Text("Search/Track List"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              bottom: true,
              child: assignedtracklist.isEmpty
                  ? Container(
                margin: EdgeInsets.only(top: 50),

                child: Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
                  :
              ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: assignedtracklist.length,
                  itemBuilder: (BuildContext context, int index) {
                    // if (capaList[index]["status"] == "CAPA Closed") {
                    //   buttonname = "Overview ";
                    // } else {
                    //   buttonname = "Edit";
                    // }
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
                                      child: Text("Gopa Id",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                          assignedtracklist[index]["auditNumber"],
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)
                                      ),
                                    )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Gopa Number",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                          assignedtracklist[index]["auditNumber"],
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)
                                      ),
                                    )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Station/Airport",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                          assignedtracklist[index]["stationName"],
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)
                                      ),
                                    )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Name of the person conducting audit",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                          assignedtracklist[index]["gghName"],
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)
                                      ),
                                    )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Date of conducting audit",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text( assignedtracklist[index]["statusName"],
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)
                                      ),
                                    )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Forward To",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                          assignedtracklist[index]["auditDoneby"].toString(),
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)
                                      ),
                                    )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Status",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                          "",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)
                                      ),
                                    )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Ground Handler",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                         "",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)
                                      ),
                                    )),
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Submitted Date",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)),
                                    )),
                                TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                         "",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: textSize)
                                      ),
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
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                "Overview",
                                style: TextStyle(
                                    color: whiteColor, fontSize: textSize),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GopatrackOverview(gopaAuditid: assignedtracklist[index]["auditID"],
                                          gopaAuditnumber: assignedtracklist[index]["auditNumber"], navType: '1',)));
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  GetGetAssignedSearchData() async {
    var emplogin;
    SharedPreferences pref = await SharedPreferences.getInstance();
    emplogin=pref.getString("employeeCode").toString();
    ApiService.get("GetGOPAFUllAuditData?LoginEMPNumber=$emplogin", pref.getString('token')).then((success) {
      print(success);
      setState(() {
        assignedtracklist = jsonDecode(success.body);
        print(assignedtracklist);
      });
    });
  }
}


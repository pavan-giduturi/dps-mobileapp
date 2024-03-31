import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../../widgets/constants.dart';

import '../../database/database_table.dart';
import '../../widgets/responsive.dart';

class OfflineNotification extends StatefulWidget {
  const OfflineNotification({Key? key}) : super(key: key);

  @override
  State<OfflineNotification> createState() => _OfflineNotificationState();
}

class _OfflineNotificationState extends State<OfflineNotification> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: OfflineNotification1(),
        desktop: Row(
          children: [
            Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: OfflineNotification1(),
                    ),
                  ],
                )
            )
          ],
        ),
    );
  }
}

class OfflineNotification1 extends StatefulWidget {
  const OfflineNotification1({Key? key}) : super(key: key);

  @override
  State<OfflineNotification1> createState() => _OfflineNotification1State();
}

class _OfflineNotification1State extends State<OfflineNotification1> {
  DatabaseHelper db = DatabaseHelper();
  List searchtrackcapaList = [];
  List tempnocSearchList = [];
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        title: Text("Offline Sync Notifications"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: searchtrackcapaList.isNotEmpty
                  ? SafeArea(
                bottom: true,
                child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: searchtrackcapaList.length,
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
                                        child: Text("CAPA Number",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchtrackcapaList[index]
                                            ["number"] ==
                                                null
                                                ? "--"
                                                : searchtrackcapaList[index]
                                            ["number"],
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("CAPA Type",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchtrackcapaList[index]
                                            ["capaType"] ==
                                                null
                                                ? "--"
                                                : searchtrackcapaList[index]
                                            ["capaType"],
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("CAPA Title",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchtrackcapaList[index]
                                            ["capaTitle"]
                                                .toString() ==
                                                null
                                                ? "--"
                                                : searchtrackcapaList[index]
                                            ["capaTitle"]
                                                .toString(),
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("Submited Date",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchtrackcapaList[index]
                                            ["submittedDate"]
                                                .toString() ==
                                                null
                                                ? "--"
                                                : searchtrackcapaList[index]
                                            ["submittedDate"]
                                                .toString(),
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("Due Date",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchtrackcapaList[index]
                                            ["dueDate"]
                                                .toString() ==
                                                null
                                                ? "--"
                                                : searchtrackcapaList[index]
                                            ["dueDate"]
                                                .toString(),
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("Priority",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchtrackcapaList[index]
                                            ["priority"]
                                                .toString() ==
                                                null
                                                ? "--"
                                                : searchtrackcapaList[index]
                                            ["priority"]
                                                .toString(),
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
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
                                            searchtrackcapaList[index]["status"]
                                                .toString() ==
                                                null
                                                ? "--"
                                                : searchtrackcapaList[index]
                                            ["status"]
                                                .toString(),
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("Assigned From",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchtrackcapaList[index]
                                            ["assignedFrom"]
                                                .toString() ==
                                                null
                                                ? "--"
                                                : searchtrackcapaList[index]
                                            ["assignedFrom"]
                                                .toString(),
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("Assigned To",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: textSize)),
                                      )),
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            searchtrackcapaList[index]
                                            ["assignedTo"]
                                                .toString() ==
                                                null
                                                ? "--"
                                                : searchtrackcapaList[index]
                                            ["assignedTo"]
                                                .toString(),
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
                                    borderRadius: BorderRadius.circular(30),
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
                                              OfflineNotification()));
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
                  'No Records Found',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}


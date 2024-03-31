import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/restapi.dart';
import '../../../database/database_table.dart';
import '../../../helpers/utilities.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/responsive.dart';
import '../../home/homescreen.dart';
import '../home/gopahome.dart';
import '../overview/gopatrackoverview.dart';
import 'fileviewer.dart';
import 'package:expandable/expandable.dart';

class GopaAudit extends StatefulWidget {
  final String submitType;
  final String auditId;
  final String auditNumber;
  final String gopaNumberwithstationCode;
  GopaAudit(
      {Key? key,
      required this.submitType,
      required this.auditId,
      required this.auditNumber,
      required this.gopaNumberwithstationCode})
      : super(key: key);

  @override
  State<GopaAudit> createState() => _GopaAuditState();
}

class _GopaAuditState extends State<GopaAudit> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: GopaAudit1(
        type: "mobile",
        submitType: widget.submitType,
        auditId: widget.auditId,
        auditNumber: widget.auditNumber,
        gopaNumberwithstationCode: widget.gopaNumberwithstationCode,
      ),
      desktop: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: GopaAudit1(
                    type: "desktop",
                    submitType: widget.submitType,
                    auditId: widget.auditId,
                    auditNumber: widget.auditNumber,
                    gopaNumberwithstationCode: widget.gopaNumberwithstationCode,
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

class GopaAudit1 extends StatefulWidget {
  final String type;
  final String submitType;
  final String auditId;
  final String auditNumber;
  final String gopaNumberwithstationCode;
  GopaAudit1(
      {Key? key,
      required this.type,
      required this.submitType,
      required this.auditId,
      required this.auditNumber,
      required this.gopaNumberwithstationCode})
      : super(key: key);

  @override
  State<GopaAudit1> createState() => _GopaAudit1State();
}

class _GopaAudit1State extends State<GopaAudit1> {
  List auditList = [];
  List ratingList = [];
  List subratingList = [];
  late DateTime fromdate;
  String? acTypeValue;
  List<bool> isSelected = [];
  Color? selectedColor, fillColor, textColor, borderColor;
  String? checkListName = "";
  String? chkId = "";
  String? subHeading = "";
  String? selectedFile = "";
  List<bool> singleCheck = [];
  bool vertical = false;
  bool isSubHeading = false;
  Timer? _timer;

  bool isAttachments = true;

  String id = "", followUp = "", uploadFile = "", ratingStatus = "";

  TextEditingController followupController = new TextEditingController();
  int completion = 0;
  String? backButtonName = "";
  bool nextButton = false;
  DatabaseHelper db = DatabaseHelper();
  List checkObj = [];

  List names = [], paths = [], baseImg = [];
  String attachedBaseImg = "";
  List FileAttachements = [];
  File? image, selectedImage;
  FilePickerResult? result;
  bool _visible = false;
  final ImagePicker _picker = ImagePicker();
  List selectedToggle = [];
  int checkListIdp = 0;
  int loaderTimer = 0;
  bool isVisible = true;
  bool isInternetAvailable = false;
  var checknet = 0;
  String toolTip = "";
  List ratingDropdown = [
    {
      "id": "1",
      "name": 'Yes',
    },
    {
      "id": "2",
      "name": 'No',
    },
    {
      "id": "3",
      "name": 'Not Applicable',
    }
  ];
  List checklistRatingcommn = [];
  List checklistRatingIDbased = [];

  late int selectedQue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    GetChecklistRating();
  }

  @override
  Widget build(BuildContext context) {
    if (Utilities.dataState == "Connection lost") {
      setState(() {
        isInternetAvailable = false;
        checknet = 0;
        toolTip = "offline";
      });
    } else {
      setState(() {
        isInternetAvailable = true;

        toolTip = "Sync";
        checknet = 1;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('GOPA'),
            Text(
              widget.gopaNumberwithstationCode.toString().isEmpty
                  ? ""
                  : widget.gopaNumberwithstationCode.toString(),
              style: TextStyle(
                  color: whiteColor,
                  fontSize: headerSize,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        centerTitle: true,
        backgroundColor: red,
        actions: [
          IconButton(
              tooltip: "GOPA HOME",
              onPressed: () {
                Utilities.gopaCheckList = [];
                Utilities.gopaDraftOverviewCheckList = [];
                Utilities.finalgopaCheckList = [];
                Utilities.gopaQueposition = 0;
                Utilities.gopaDetails = {};
                Utilities.filledQues = 0;
                Utilities.countFilled = 0;
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => GopaHome()),
                    (Route<dynamic> route) => false);
              },
              icon: Icon(
                Icons.home,
                color: whiteColor,
                size: 30,
              ))
        ],
      ),
      backgroundColor: bgColor,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Container(
            color: bgColor,
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: Utilities.gopaList.length,
                    itemBuilder: (context, index) {
                      var res =
                          jsonDecode(Utilities.gopaList[index].toString());
                      return Padding(
                        padding:
                            EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: ExpandableNotifier(
                          initialExpanded: true,
                          child: Column(
                            children: [
                              ScrollOnExpand(
                                scrollOnExpand: true,
                                child: ExpandablePanel(
                                  theme: const ExpandableThemeData(
                                    iconSize: 30,
                                    expandIcon: Icons.arrow_drop_down,
                                    collapseIcon: Icons.arrow_drop_up_outlined,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                  ),
                                  header: Container(
                                    // alignment: Alignment.le,
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    // margin: EdgeInsets.only(left: 5),
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: darkgrey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),

                                    child: SingleChildScrollView(
                                      child: Text(
                                        res['title'].toString(),
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: subHeaderSize),
                                      ),
                                    ),
                                  ),
                                  collapsed: Container(),
                                  expanded: res['questions'].length == 0
                                      ? Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: ListView.builder(
                                              physics: const ScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  res['subquestions'].length,
                                              itemBuilder: (context, subIndex) {
                                                print("subdecodeResponse");
                                                print(res['subquestions']
                                                    [subIndex]);

                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 10),
                                                  child: ExpandableNotifier(
                                                    initialExpanded: true,
                                                    child: Column(
                                                      children: [
                                                        ScrollOnExpand(
                                                          scrollOnExpand: true,
                                                          child:
                                                              ExpandablePanel(
                                                            theme:
                                                                ExpandableThemeData(
                                                              iconSize: 30,
                                                              expandIcon: Icons
                                                                  .arrow_drop_down,
                                                              collapseIcon: Icons
                                                                  .arrow_drop_up_outlined,
                                                              headerAlignment:
                                                                  ExpandablePanelHeaderAlignment
                                                                      .center,
                                                            ),
                                                            header: Container(
                                                                // alignment: Alignment.le,

                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                // margin: EdgeInsets.only(left: 5),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            11),
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      darkgrey,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child:
                                                                    AutoSizeText(
                                                                  res['subquestions']
                                                                              [
                                                                              subIndex]
                                                                          [
                                                                          'title']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color:
                                                                          whiteColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          subHeaderSize),
                                                                )),
                                                            collapsed:
                                                                Container(),
                                                            expanded: ListView
                                                                .builder(
                                                                    physics:
                                                                        const ScrollPhysics(),
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: res['subquestions'][subIndex]['questions'].length ==
                                                                            0
                                                                        ? 0
                                                                        : res['subquestions'][subIndex]['questions']
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            subQueIndex) {
                                                                      var decodeSubResponse =
                                                                          jsonDecode(res['subquestions'][subIndex]['questions']
                                                                              [
                                                                              subQueIndex]);

                                                                      var attachmentNames =
                                                                          decodeSubResponse[
                                                                              'attachments_names'];
                                                                      var attachmentsPaths =
                                                                          decodeSubResponse[
                                                                              'attachments_paths'];
                                                                      var attachmentsBaseImg =
                                                                          decodeSubResponse[
                                                                              'attachments_baseImg'];

                                                                      List<bool>
                                                                          subratings =
                                                                          [];
                                                                      ratingDropdown =
                                                                          [];
                                                                      ratingDropdown =
                                                                          decodeSubResponse[
                                                                              'ratingList'];
                                                                      try {
                                                                        var arraySubRatings =
                                                                            decodeSubResponse['ratingStatus'];
                                                                        for (int i =
                                                                                0;
                                                                            i < arraySubRatings.length;
                                                                            i++) {
                                                                          subratings
                                                                              .add(arraySubRatings[i]);
                                                                        }

                                                                        if (arraySubRatings[0] ==
                                                                            true) {
                                                                          selectedColor =
                                                                              Color(0xFF216f82);
                                                                        } else if (arraySubRatings[1] ==
                                                                            true) {
                                                                          selectedColor =
                                                                              Color(0xFFf5003a);
                                                                        } else if (arraySubRatings[2] ==
                                                                            true) {
                                                                          selectedColor =
                                                                              Color(0xFF3a454b);
                                                                        }
                                                                      } catch (e) {
                                                                        print(
                                                                            e);
                                                                      }

                                                                      ///////////////////////////////////////subques/////////////////////////////////////////
                                                                      return Padding(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                10,
                                                                            left:
                                                                                0,
                                                                            right:
                                                                                10),
                                                                        child: Card(
                                                                            color: cardColor,
                                                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                                                                                child: Text(decodeSubResponse['s_no'].toString() + (". ") + decodeSubResponse['itemName'].toString()),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              /* toggle button */
                                                                              Container(
                                                                                margin: EdgeInsets.all(10),
                                                                                decoration: BoxDecoration(border: Border.all(color: darkgrey), color: cardColor, borderRadius: BorderRadius.circular(15)),
                                                                                child: DropdownButtonFormField(
                                                                                  isExpanded: true,
                                                                                  style: TextStyle(fontSize: textSize, color: blackColor),
                                                                                  hint: Text(
                                                                                    getCheckListRatingIdbyName(decodeSubResponse['ChecklistItemDataID'], decodeSubResponse['itemID']),
                                                                                    style: TextStyle(color: blackColor),
                                                                                  ),
                                                                                  decoration: InputDecoration(
                                                                                    contentPadding: EdgeInsets.only(left: 10, right: 20),
                                                                                    border: InputBorder.none,
                                                                                  ),
                                                                                  isDense: true,
                                                                                  icon: Icon(Icons.arrow_drop_down, color: blackColor),
                                                                                  iconSize: 30,
                                                                                  items: ratingDropdown.map((item) {
                                                                                    return new DropdownMenuItem(
                                                                                      // enabled: Utilities.checkListDisabledIdsList.contains(decodeSubResponse['itemID'].toString()) ? false : true,
                                                                                      child: Text(
                                                                                        item['ratingName'].toString(),
                                                                                        style: TextStyle(fontSize: textSize, color: blackColor),
                                                                                      ),
                                                                                      value: item['ratingID'],
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (value) {
                                                                                    var selectedQue = decodeSubResponse;
                                                                                    updateToggleData(selectedQue, value);
                                                                                  },
                                                                                  // value: stationAirportValue,
                                                                                ),
                                                                              ),
                                                                              /* toggle button */
                                                                              Padding(
                                                                                padding: EdgeInsets.all(10),
                                                                                child: TextFormField(
                                                                                  initialValue: decodeSubResponse['comments'] == null ? '' : decodeSubResponse['comments'],
                                                                                  // controller: TextEditingController(text: decodeSubResponse['comments'] == null ? '' : decodeSubResponse['comments']),
                                                                                  minLines: 3,
                                                                                  maxLines: null,
                                                                                  onChanged: (value) {
                                                                                    var selectedQue = decodeSubResponse;
                                                                                    updateCommentsData(selectedQue, value.toString());
                                                                                  },
                                                                                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Color(0xFFf5003a))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Color(0xFFf5003a))), hintText: "Enter Followup Points", hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                                                                ),
                                                                              ),
                                                                              Column(
                                                                                children: [
                                                                                  Padding(
                                                                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              var selectedQue = decodeSubResponse;
                                                                                              filePicker(selectedQue);
                                                                                            },
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Icon(
                                                                                                  Icons.folder_copy,
                                                                                                  color: Color(0xFFf5003a),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: defaultPadding,
                                                                                                ),
                                                                                                Container(
                                                                                                  child: Text(decodeSubResponse['attachfileManadatory'].toString() == "True" ? "Choose File * " : "Choose File "),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: defaultPadding * 2,
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              var selectedQue = decodeSubResponse;
                                                                                              imageDialog(selectedQue);
                                                                                            },
                                                                                            child: Icon(
                                                                                              Icons.camera_alt_rounded,
                                                                                              color: red,
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      )),
                                                                                  (decodeSubResponse['attachments_names'].toString().isEmpty || decodeSubResponse['attachments_names'].toString() == "null")
                                                                                      ? Container()
                                                                                      : Padding(
                                                                                          padding: const EdgeInsets.only(left: 10),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Row(
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                    width: defaultPadding,
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    width: MediaQuery.of(context).size.width / 1.8,
                                                                                                    child: Text(
                                                                                                      decodeSubResponse['attachments_names'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('', ''),
                                                                                                      style: TextStyle(fontSize: textSize, color: blackColor),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              IconButton(
                                                                                                  onPressed: () {
                                                                                                    getChecklistFileData(widget.auditId, widget.auditNumber, decodeSubResponse['checklistID'], decodeSubResponse['itemID'], decodeSubResponse['attachments_names'].toString());
                                                                                                  },
                                                                                                  icon: Icon(
                                                                                                    Icons.remove_red_eye_outlined,
                                                                                                    color: darkgrey,
                                                                                                  )),
                                                                                            ],
                                                                                          )),
                                                                                ],
                                                                              ),
                                                                            ])),
                                                                      );
                                                                      ///////////////////////////////////////subques/////////////////////////////////////////
                                                                    }),
                                                            builder: (_,
                                                                collapsed,
                                                                expanded) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0),
                                                                child:
                                                                    Expandable(
                                                                  collapsed:
                                                                      collapsed,
                                                                  expanded:
                                                                      expanded,
                                                                  theme: const ExpandableThemeData(
                                                                      crossFadePoint:
                                                                          0),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )
                                      : ListView.builder(
                                          physics: const ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              res['questions'].length == 0
                                                  ? 0
                                                  : res['questions'].length,
                                          itemBuilder:
                                              (context, questionsIndex) {
                                            var decodeResponse = jsonDecode(
                                                res['questions'][questionsIndex]
                                                    .toString());

                                            print("decodeResponse");
                                            print(decodeResponse);

                                            List<bool> ratings = [];
                                            List ratingDropdownList = [];
                                            ratingDropdown =
                                                decodeResponse['ratingList'];
                                            var attachmentNames =
                                                decodeResponse[
                                                    'attachments_names'];
                                            var attachmentsPaths =
                                                decodeResponse[
                                                    'attachments_paths'];
                                            var attachmentsBaseImg =
                                                decodeResponse[
                                                    'attachments_baseImg'];

                                            try {
                                              var arrayRatings = decodeResponse[
                                                  'ratingStatus'];
                                              for (int i = 0;
                                                  i < arrayRatings.length;
                                                  i++) {
                                                ratings.add(arrayRatings[i]);
                                              }

                                              if (arrayRatings[0] == true) {
                                                selectedColor =
                                                    Color(0xFF216f82);
                                              } else if (arrayRatings[1] ==
                                                  true) {
                                                selectedColor =
                                                    Color(0xFFf5003a);
                                              } else if (arrayRatings[2] ==
                                                  true) {
                                                selectedColor =
                                                    Color(0xFF3a454b);
                                              }
                                            } catch (e) {
                                              print(e);
                                            }
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 0,
                                                  right: 10),
                                              child: Card(
                                                  color: Color(0xFFdbdbdb),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  left: 10),
                                                          child: Text(decodeResponse[
                                                                      's_no']
                                                                  .toString() +
                                                              (". ") +
                                                              decodeResponse[
                                                                      'itemName']
                                                                  .toString()),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        /* toggle button */
                                                        Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      darkgrey),
                                                              color: Color(
                                                                  0xFFdbdbdb),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                          child:
                                                              DropdownButtonFormField(
                                                            isExpanded: true,
                                                            hint: Text(
                                                              getCheckListRatingIdbyName(
                                                                  decodeResponse[
                                                                      'ChecklistItemDataID'],
                                                                  decodeResponse[
                                                                      'itemID']),
                                                              style: TextStyle(
                                                                color:
                                                                    blackColor,
                                                                fontSize:
                                                                    textSize,
                                                              ),
                                                            ),
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      left: 10,
                                                                      right:
                                                                          20),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                            isDense: true,
                                                            icon: Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                            ),
                                                            iconSize: 30,
                                                            items:
                                                                ratingDropdown
                                                                    .map(
                                                                        (item) {
                                                              return new DropdownMenuItem(
                                                                // enabled: Utilities
                                                                //         .checkListDisabledIdsList
                                                                //         .contains(
                                                                //             decodeResponse['itemID']
                                                                //                 .toString())
                                                                //     ? false
                                                                //     : true,
                                                                child: Text(
                                                                  item['ratingName']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          textSize,
                                                                      color:
                                                                          blackColor),
                                                                ),
                                                                value: item[
                                                                    'ratingID'],
                                                              );
                                                            }).toList(),
                                                            onChanged: (value) {
                                                              var selectedQue =
                                                                  jsonDecode(res[
                                                                              'questions']
                                                                          [
                                                                          questionsIndex]
                                                                      .toString());
                                                              updateToggleData(
                                                                  selectedQue,
                                                                  value);
                                                              var ratingId;
                                                            },
                                                          ),
                                                        ),
                                                        /* toggle button */
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: TextFormField(
                                                            initialValue: decodeResponse[
                                                                        'comments'] ==
                                                                    null
                                                                ? ''
                                                                : decodeResponse[
                                                                    'comments'],
                                                            // controller: TextEditingController(text: decodeResponse['comments'] == null ? '' : decodeResponse['comments']),
                                                            minLines: 3,
                                                            maxLines: null,
                                                            onChanged: (value) {
                                                              var selectedQue =
                                                                  jsonDecode(res[
                                                                              'questions']
                                                                          [
                                                                          questionsIndex]
                                                                      .toString());
                                                              updateCommentsData(
                                                                  selectedQue,
                                                                  value
                                                                      .toString());
                                                              checkListName =
                                                                  selectedQue[
                                                                          "comments"]
                                                                      .toString();
                                                            },
                                                            decoration: InputDecoration(
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xFFf5003a))),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xFFf5003a))),
                                                                hintText:
                                                                    "Enter Followup Points",
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        var selectedQue =
                                                                            decodeResponse;
                                                                        filePicker(
                                                                            selectedQue);
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.folder_copy,
                                                                            color:
                                                                                Color(0xFFf5003a),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                defaultPadding,
                                                                          ),
                                                                          Container(
                                                                            child: Text(decodeResponse['attachfileManadatory'].toString() == "True"
                                                                                ? "Choose File * "
                                                                                : "Choose File "),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                defaultPadding * 2,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        var selectedQue =
                                                                            decodeResponse;
                                                                        imageDialog(
                                                                            selectedQue);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .camera_alt_rounded,
                                                                        color:
                                                                            red,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                            (decodeResponse['attachments_names']
                                                                        .toString()
                                                                        .isEmpty ||
                                                                    decodeResponse['attachments_names']
                                                                            .toString() ==
                                                                        "null")
                                                                ? Container()
                                                                : Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: defaultPadding,
                                                                            ),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width / 1.8,
                                                                              child: Text(
                                                                                decodeResponse['attachments_names'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('', ''),
                                                                                style: TextStyle(fontSize: textSize, color: blackColor),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              getChecklistFileData(widget.auditId, widget.auditNumber, decodeResponse['checklistID'], decodeResponse['itemID'], decodeResponse['attachments_names'].toString());
                                                                            },
                                                                            icon:
                                                                                Icon(
                                                                              Icons.remove_red_eye_outlined,
                                                                              color: darkgrey,
                                                                            )),
                                                                      ],
                                                                    )),
                                                          ],
                                                        ),
                                                      ])),
                                            );
                                          }),
                                  builder: (_, collapsed, expanded) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 0, bottom: 0),
                                      child: Expandable(
                                        collapsed: collapsed,
                                        expanded: expanded,
                                        theme: const ExpandableThemeData(
                                            crossFadePoint: 0),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color(0xFFe7e7e7),
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: isInternetAvailable == true
                  ? MediaQuery.of(context).size.width * 0.3
                  : MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  SaveApiCallByStatus(1);
                },
                child: Text(
                  'Save as draft',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Visibility(
              visible: isInternetAvailable == true ? true : false,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  color: darkgrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () {
                    finalSubmit();
                  },
                  child: Text(
                    'Final Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              width: isInternetAvailable == true
                  ? MediaQuery.of(context).size.width * 0.3
                  : MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                color: Color(0xFFf5003a),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  CoolAlert.show(
                      width: 300,
                      title: 'Do you want to continue without saving the data?',
                      flareAnimationName: "play",
                      backgroundColor: Color(0xFFe7e7e7),
                      barrierDismissible: false,
                      context: context,
                      type: CoolAlertType.confirm,
                      // text: ,
                      confirmBtnText: 'Yes',
                      cancelBtnText: 'No',
                      cancelBtnTextStyle: TextStyle(color: Colors.black),
                      confirmBtnColor: Color(0xFFf5003a),
                      onCancelBtnTap: () {
                        Navigator.pop(context);
                      },
                      onConfirmBtnTap: () {
                        Utilities.gopaCheckList = [];
                        Utilities.finalgopaCheckList = [];
                        Utilities.gopaQueposition = 0;
                        Utilities.gopaDetails = {};
                        Utilities.filledQues = 0;
                        Utilities.countFilled = 0;
                        Utilities.gopaList = [];
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => GopaHome()),
                            (Route<dynamic> route) => false);
                      });
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GetChecklistRating() async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading . . .",
    );

    checklistRatingcommn = [];
    checklistRatingIDbased = [];
    var dataLength;
    var arry = widget.auditNumber.toString().split("_");
    if (isOnline && !arry.contains("GOPA")) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      ApiService.get("GetChecklistRating", pref.getString('token'))
          .then((success) {
        setState(() {
          var checklistRating = jsonDecode(success.body);
          dataLength = checklistRating.length;
          if (dataLength != 0) {
            EasyLoading.addStatusCallback((dataLength) {
              if (dataLength == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });
            checklistRatingcommn = checklistRating['checklistRatingcommn'];
            checklistRatingIDbased = checklistRating['checklistRatingIDbased'];

            if (widget.submitType == 'draft') {
              makeDraftAuditCheckListData();
            } else {
              makeAuditCheckListApiCall();
            }
            EasyLoading.showSuccess('Loading Success');
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

        if (widget.submitType == 'draft') {
          makeDraftAuditCheckListData();
        } else {
          makeAuditCheckListApiCall();
        }
        EasyLoading.showSuccess('Loading Success');
      } else {
        EasyLoading.showInfo("Loading Failed");
      }
    }
  }

  finalSubmit() async {
    List pendingCheckList = [];
    List fileRequiredCheckList = [];
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    SharedPreferences pref = await SharedPreferences.getInstance();

    var emplogin = pref.getString("employeeCode").toString();
    var draftAudits = await db.getGOPAOfflineDraftAudits(emplogin);
    try {
      if (isOnline) {
        List gopaAllCheckListData = Utilities.gopaList;
        for (int i = 0; i < Utilities.gopaList.length; i++) {
          String itemDataId = '0';
          var checkObject = jsonDecode(Utilities.gopaList[i].toString());
          var singleHeadQues = jsonDecode(checkObject['questions'].toString());

          if (singleHeadQues.length > 0) {
            for (int j = 0; j < singleHeadQues.length; j++) {
              if (singleHeadQues[j]['ChecklistItemDataID'].toString() == '0') {
                var item = jsonEncode({
                  "s_no": singleHeadQues[j]['s_no'],
                  "checklistName": checkObject['title'],
                  "itemID": singleHeadQues[j]['itemID'],
                  "itemName": singleHeadQues[j]['itemName'],
                  "checklistID": singleHeadQues[j]['checklistID'],
                  "subchecklistID": singleHeadQues[j]['subchecklistID'],
                  "subchecklistname": singleHeadQues[j]['subchecklistname'],
                  "ChecklistItemDataID": singleHeadQues[j]
                      ['ChecklistItemDataID'],
                });
                if (pendingCheckList.isEmpty) {
                  pendingCheckList.add(item);
                }
              }

              if (singleHeadQues[j]['attachfileManadatory'].toString() ==
                      'True' &&
                  singleHeadQues[j]['attachments_names'].toString() == '') {
                var item = jsonEncode({
                  "s_no": singleHeadQues[j]['s_no'],
                  "checklistName": checkObject['title'],
                  "itemID": singleHeadQues[j]['itemID'],
                  "itemName": singleHeadQues[j]['itemName'],
                  "checklistID": singleHeadQues[j]['checklistID'],
                  "subchecklistID": singleHeadQues[j]['subchecklistID'],
                  "subchecklistname": singleHeadQues[j]['subchecklistname'],
                  "ChecklistItemDataID": singleHeadQues[j]
                      ['ChecklistItemDataID'],
                });
                if (fileRequiredCheckList.isEmpty) {
                  fileRequiredCheckList.add(item);
                }
              }
            }
          } else {
            var multipleHead = checkObject['subquestions'];
            for (int k = 0; k < multipleHead.length; k++) {
              var multipleHeadQues =
                  jsonDecode(multipleHead[k]['questions'].toString());

              for (int l = 0; l < multipleHeadQues.length; l++) {
                if (multipleHeadQues[l]['ChecklistItemDataID'].toString() ==
                    '0') {
                  var itemsqn = jsonEncode({
                    "s_no": multipleHeadQues[l]['s_no'],
                    "checklistName": checkObject['title'],
                    "itemID": multipleHeadQues[l]['itemID'],
                    "itemName": multipleHeadQues[l]['itemName'],
                    "checklistID": multipleHeadQues[l]['checklistID'],
                    "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                    "subchecklistname": multipleHead[k]['title'],
                    "ChecklistItemDataID": multipleHeadQues[l]
                        ['ChecklistItemDataID'],
                  });

                  if (pendingCheckList.isEmpty) {
                    pendingCheckList.add(itemsqn);
                  }
                }

                if (multipleHeadQues[l]['attachfileManadatory'].toString() ==
                        'True' &&
                    multipleHeadQues[l]['attachments_names'].toString() == '') {
                  var itemsqn = jsonEncode({
                    "s_no": multipleHeadQues[l]['s_no'],
                    "checklistName": checkObject['title'],
                    "itemID": multipleHeadQues[l]['itemID'],
                    "itemName": multipleHeadQues[l]['itemName'],
                    "checklistID": multipleHeadQues[l]['checklistID'],
                    "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                    "subchecklistname": multipleHead[k]['title'],
                    "ChecklistItemDataID": multipleHeadQues[l]
                        ['ChecklistItemDataID'],
                  });

                  if (fileRequiredCheckList.isEmpty) {
                    fileRequiredCheckList.add(itemsqn);
                  }
                }
              }
            }
          }
        }

        if (pendingCheckList.length > 0) {
          if (pendingCheckList.length > 0) {
            EasyLoading.addStatusCallback((status) {
              if (status == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });
            var a1 = jsonDecode(pendingCheckList[0].toString());
            CoolAlert.show(
                context: context,
                title: "Please fill",
                text:
                    "${a1['checklistName']}\n\n${a1['subchecklistname']}\n\n${a1['s_no']}.${a1['itemName']}",
                barrierDismissible: false,
                flareAnimationName: "play",
                type: CoolAlertType.confirm,
                cancelBtnText: "",
                confirmBtnText: "Ok",
                onConfirmBtnTap: () {
                  Navigator.pop(context);
                  makeSaveApiCall(1, 'pending');
                },
                onCancelBtnTap: () {
                  Navigator.pop(context);
                },
                showCancelBtn: false,
                confirmBtnColor: Colors.deepOrangeAccent);
          } else {
            EasyLoading.showInfo("Saving Failed");
          }
        } else {
          makeSaveApiCall(1, 'pending');
          getGOPAFinalStatus();
        }
      } else {
        CoolAlert.show(
            width: 300,
            text: '',
            title: 'You need Internet Connection for final submission',
            flareAnimationName: "play",
            backgroundColor: Color(0xFFe7e7e7),
            barrierDismissible: false,
            context: context,
            type: CoolAlertType.error,
            confirmBtnText: 'Ok',
            confirmBtnColor: Color(0xFF216f82),
            onConfirmBtnTap: () {
              makeSaveApiCall(1, 'pending');
              Navigator.pop(context);
            });
      }
    } catch (e) {
      print("Error Occured " + e.toString());
    }
  }

  getGOPAFinalStatus() async {
    var auditId;
    var auditNumber;

    setState(() {
      auditId = widget.auditId;
      auditNumber = widget.auditNumber;
    });

    bool isOnline = await Utilities.CheckUserConnection() as bool;

    if (isOnline) {
      var gopaDetailsBodyIn = jsonDecode(Utilities.gopaDetails);
      SharedPreferences pref = await SharedPreferences.getInstance();

      if (gopaDetailsBodyIn['restartOperations'].toString() == '2') {
        ApiService.get(
                "GOPAFinalStatus?GOPAID=$auditId&GOPANumber=$auditNumber",
                pref.getString('token'))
            .then((success) {
          if (success.statusCode == 200) {
            EasyLoading.addStatusCallback((status) {
              if (status == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });

            var body = jsonDecode(success.body);
            if (body[0]['returnValue'].toString() == '0') {
              CoolAlert.show(
                  width: 300,
                  text: '',
                  title:
                      'Please create Mandatory Observations for the Airlines',
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
                    Navigator.pop(context);

                    makeSaveApiCall(1, 'pending');
                  });
            } else {
              SaveApiCallByStatus(2);
            }
            EasyLoading.showSuccess('Saving Success');
          } else {
            EasyLoading.showInfo("Saving Failed");
          }
        });
      } else {
        SaveApiCallByStatus(2);
      }
    } else {}
  }

  imageDialog(selectedQue) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Add Photo!",
        ),
        content: Container(
          height: 130,
          width: 50,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              GestureDetector(
                  child: Card(
                    color: red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Take Photo",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () async {
                    takePhoto(ImageSource.camera, selectedQue);
                    Navigator.pop(context);
                  }),
              GestureDetector(
                child: Card(
                  color: red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Choose From Gallery",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  // filePicker(selectedQue);
                  takePhotoFromGallery(ImageSource.gallery, selectedQue);
                  Navigator.pop(context);
                },
              ),
              GestureDetector(
                child: Card(
                  color: red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  getChecklistFileData(
      AuditID, AuditNumber, ChecklistID, ChecklistItemID, FileName) async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    var arry = AuditNumber.toString().split("_");

    var dataLength;
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Opening File",
    );
    if (isOnline && !arry.contains("GOPA")) {
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

          attachedBaseImg = body.toString();

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
      // Utilities.showAlert(context, "Please check your internet connection.");
    }
  }

  takePhoto(ImageSource source, selectPosition) async {
    List tempCheckList = [];
    names = [];
    paths = [];
    baseImg = [];
    var dataLength;

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 20,
    );

    final File? file = File(image!.path);

    bool isOnline = await Utilities.CheckUserConnection() as bool;

    try {
      if (image != null) {
        Utilities.easyLoader();
        EasyLoading.show(
          status: "Uploading File",
        );
        // _uploadLoader(context);
        _visible = true;
        selectedImage = file;
        String fileName = image.path.toString().split('/').last;
        List<int> imageBytes = selectedImage!.readAsBytesSync();
        var imageB64 = base64Encode(imageBytes);
        baseImg.add(imageB64);
        names.add(fileName);
        paths.add(image.path.toString());
      }

      SharedPreferences pref = await SharedPreferences.getInstance();
      var emplogin = pref.getString("employeeCode").toString();

      var PluginID = 137;
      var AuditID = widget.auditId;
      var AuditNumber = widget.auditNumber;
      var featurID = 0;
      var ChecklistID = selectPosition['checklistID'];
      var ChecklistItemID = selectPosition['itemID'].toString();
      var SubchecklistID = selectPosition['subchecklistID'].toString();
      var FileName = names[0].toString();
      var AttachedBy = emplogin;
      var ImageBase64 = baseImg[0].toString();

      var FileAttachmentSaveBody = jsonEncode({
        "PluginID": PluginID,
        "AuditID": AuditID,
        "AuditNumber": AuditNumber,
        "featurID": featurID,
        "ChecklistID": ChecklistID,
        "ChecklistItemID": ChecklistItemID,
        "SubchecklistID": SubchecklistID,
        "FileName": "GOPA_${ChecklistItemID}.jpg",
        "AttachedBy": AttachedBy,
        "ImageBase64": ImageBase64,
      });
      names = [];
      names.add("GOPA_${ChecklistItemID}.jpg");

      var fileLoadPath =
          "${Utilities.attachmentFilePathLocal}${names[0].toString()}";
      image.saveTo(fileLoadPath.toString());

      if (isOnline) {
        var FileAttachmentSaveBody = jsonEncode({
          "PluginID": PluginID,
          "AuditID": AuditID,
          "AuditNumber": AuditNumber,
          "featurID": featurID,
          "ChecklistID": ChecklistID,
          "ChecklistItemID": ChecklistItemID,
          "SubchecklistID": SubchecklistID,
          "FileName": "GOPA_${ChecklistItemID}.jpg",
          "AttachedBy": AttachedBy,
          "ImageBase64": ImageBase64,
        });
        ApiService.post("SaveFileAttachmentforChecklist",
                FileAttachmentSaveBody, pref.getString('token'))
            .then((success) {
          if (success.statusCode == 200) {
            for (int i = 0; i < Utilities.gopaList.length; i++) {
              List items = [];
              List subitems = [];
              String itemDataId = '0';
              var checkObject = jsonDecode(Utilities.gopaList[i].toString());
              var singleHeadQues =
                  jsonDecode(checkObject['questions'].toString());

              if (singleHeadQues.length > 0) {
                for (int j = 0; j < singleHeadQues.length; j++) {
                  if (selectPosition['itemID'].toString() ==
                      singleHeadQues[j]['itemID'].toString()) {
                    // Selected Item Rating and data Appears with single heading

                    var item = jsonEncode({
                      "s_no": singleHeadQues[j]['s_no'],
                      "itemID": singleHeadQues[j]['itemID'],
                      "itemName": singleHeadQues[j]['itemName'],
                      "checklistorder": singleHeadQues[j]['checklistorder'],
                      "subChecklistorder": singleHeadQues[j]
                          ['subChecklistorder'],
                      "checklistID": singleHeadQues[j]['checklistID'],
                      "subchecklistID": singleHeadQues[j]['subchecklistID'],
                      "subchecklistname": singleHeadQues[j]['subchecklistname'],
                      "attachfileManadatory": singleHeadQues[j]
                          ['attachfileManadatory'],
                      "ratingStatus": singleHeadQues[j]['ratingStatus'],
                      "ChecklistItemDataID": singleHeadQues[j]
                          ['ChecklistItemDataID'],
                      "comments": singleHeadQues[j]['comments'],
                      "ratingList": singleHeadQues[j]['ratingList'],
                      "attachments_names":
                          "GOPA_${singleHeadQues[j]['itemID']}.jpg",
                      "attachments_paths": paths[0].toString(),
                      "attachments_baseImg": baseImg[0].toString(),
                    });

                    items.add(item);
                  } else {
                    var item = jsonEncode({
                      "s_no": singleHeadQues[j]['s_no'],
                      "itemID": singleHeadQues[j]['itemID'],
                      "itemName": singleHeadQues[j]['itemName'],
                      "checklistorder": singleHeadQues[j]['checklistorder'],
                      "subChecklistorder": singleHeadQues[j]
                          ['subChecklistorder'],
                      "checklistID": singleHeadQues[j]['checklistID'],
                      "subchecklistID": singleHeadQues[j]['subchecklistID'],
                      "subchecklistname": singleHeadQues[j]['subchecklistname'],
                      "attachfileManadatory": singleHeadQues[j]
                          ['attachfileManadatory'],
                      "ratingStatus": singleHeadQues[j]['ratingStatus'],
                      "ChecklistItemDataID": singleHeadQues[j]
                          ['ChecklistItemDataID'],
                      "comments": singleHeadQues[j]['comments'],
                      "ratingList": singleHeadQues[j]['ratingList'],
                      "attachments_names": singleHeadQues[j]
                          ['attachments_names'],
                      "attachments_paths": singleHeadQues[j]
                          ['attachments_paths'],
                      "attachments_baseImg": singleHeadQues[j]
                          ['attachments_baseImg'],
                    });
                    items.add(item);
                  }
                }
              } else {
                var multipleHead = checkObject['subquestions'];
                for (int k = 0; k < multipleHead.length; k++) {
                  var multipleHeadQues =
                      jsonDecode(multipleHead[k]['questions'].toString());
                  List itemsqns = [];
                  for (int l = 0; l < multipleHeadQues.length; l++) {
                    if (selectPosition['itemID'].toString() ==
                        multipleHeadQues[l]['itemID'].toString()) {
                      var itemsqn = jsonEncode({
                        "s_no": multipleHeadQues[l]['s_no'],
                        "itemID": multipleHeadQues[l]['itemID'],
                        "itemName": multipleHeadQues[l]['itemName'],
                        "checklistID": multipleHeadQues[l]['checklistID'],
                        "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                        "subchecklistname": multipleHeadQues[l]
                            ['subchecklistname'],
                        "attachfileManadatory": multipleHeadQues[l]
                            ['attachfileManadatory'],
                        "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                        "checklistorder": multipleHeadQues[l]['checklistorder'],
                        "subChecklistorder": multipleHeadQues[l]
                            ['subChecklistorder'],
                        "ChecklistItemDataID": multipleHeadQues[l]
                            ['ChecklistItemDataID'],
                        "comments": multipleHeadQues[l]['comments'],
                        "ratingList": multipleHeadQues[l]['ratingList'],
                        "attachments_names":
                            "GOPA_${multipleHeadQues[l]['itemID']}.jpg",
                        "attachments_paths": paths[0].toString(),
                        "attachments_baseImg": baseImg[0].toString(),
                      });

                      itemsqns.add(itemsqn);
                    } else {
                      var itemsqn = jsonEncode({
                        "s_no": multipleHeadQues[l]['s_no'],
                        "itemID": multipleHeadQues[l]['itemID'],
                        "itemName": multipleHeadQues[l]['itemName'],
                        "checklistID": multipleHeadQues[l]['checklistID'],
                        "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                        "subchecklistname": multipleHeadQues[l]
                            ['subchecklistname'],
                        "attachfileManadatory": multipleHeadQues[l]
                            ['attachfileManadatory'],
                        "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                        "checklistorder": multipleHeadQues[l]['checklistorder'],
                        "subChecklistorder": multipleHeadQues[l]
                            ['subChecklistorder'],
                        "ChecklistItemDataID": multipleHeadQues[l]
                            ['ChecklistItemDataID'],
                        "comments": multipleHeadQues[l]['comments'],
                        "ratingList": multipleHeadQues[l]['ratingList'],
                        "attachments_names": multipleHeadQues[l]
                            ['attachments_names'],
                        "attachments_paths": multipleHeadQues[l]
                            ['attachments_paths'],
                        "attachments_baseImg": multipleHeadQues[l]
                            ['attachments_baseImg'],
                      });
                      itemsqns.add(itemsqn);
                    }
                  }

                  var subitem = {
                    'id': multipleHead[k]['id'],
                    'title': multipleHead[k]['title'],
                    'questions': itemsqns
                  };
                  subitems.add(subitem);
                }
              }

              var checkList = jsonEncode({
                "id": checkObject['id'],
                "title": checkObject['title'],
                "subId":
                    checkObject['subId'] == null ? "" : checkObject['subId'],
                "subtitle": checkObject['subtitle'] == null
                    ? ""
                    : checkObject['subtitle'],
                "questions": items,
                "subquestions": subitems
              });

              tempCheckList.add(checkList);
            }

            setState(() {
              Utilities.gopaList = [];
              Utilities.gopaList = tempCheckList;
              tempCheckList = [];
            });
            EasyLoading.addStatusCallback((status) {
              if (status == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });

            EasyLoading.showSuccess('Uploading Success');
          } else {
            EasyLoading.showInfo("Uploading Failed");
          }
        });
      } else {
        var FileAttachmentSaveBody = jsonEncode({
          "PluginID": PluginID,
          "AuditID": AuditID,
          "AuditNumber": AuditNumber,
          "featurID": featurID,
          "ChecklistID": ChecklistID,
          "ChecklistItemID": ChecklistItemID,
          "SubchecklistID": SubchecklistID,
          "FileName": "GOPA_${ChecklistItemID}.jpg",
          "FilePath": fileLoadPath.toString(),
          "AttachedBy": AttachedBy,
          "ImageBase64": ImageBase64,
        });
        db.SaveFileAttachmentforChecklist(
            jsonDecode(FileAttachmentSaveBody), 0);

        for (int i = 0; i < Utilities.gopaList.length; i++) {
          List items = [];
          List subitems = [];
          String itemDataId = '0';
          var checkObject = jsonDecode(Utilities.gopaList[i].toString());
          var singleHeadQues = jsonDecode(checkObject['questions'].toString());

          if (singleHeadQues.length > 0) {
            for (int j = 0; j < singleHeadQues.length; j++) {
              if (selectPosition['itemID'].toString() ==
                  singleHeadQues[j]['itemID'].toString()) {
                // Selected Item Rating and data Appears with single heading

                var item = jsonEncode({
                  "s_no": singleHeadQues[j]['s_no'],
                  "itemID": singleHeadQues[j]['itemID'],
                  "itemName": singleHeadQues[j]['itemName'],
                  "checklistorder": singleHeadQues[j]['checklistorder'],
                  "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                  "checklistID": singleHeadQues[j]['checklistID'],
                  "subchecklistID": singleHeadQues[j]['subchecklistID'],
                  "subchecklistname": singleHeadQues[j]['subchecklistname'],
                  "attachfileManadatory": singleHeadQues[j]
                      ['attachfileManadatory'],
                  "ratingStatus": singleHeadQues[j]['ratingStatus'],
                  "ChecklistItemDataID": singleHeadQues[j]
                      ['ChecklistItemDataID'],
                  "comments": singleHeadQues[j]['comments'],
                  "ratingList": singleHeadQues[j]['ratingList'],
                  "attachments_names":
                      "GOPA_${singleHeadQues[j]['itemID']}.jpg",
                  "attachments_paths": paths[0].toString(),
                  "attachments_baseImg": baseImg[0].toString(),
                });

                items.add(item);
              } else {
                var item = jsonEncode({
                  "s_no": singleHeadQues[j]['s_no'],
                  "itemID": singleHeadQues[j]['itemID'],
                  "itemName": singleHeadQues[j]['itemName'],
                  "checklistorder": singleHeadQues[j]['checklistorder'],
                  "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                  "checklistID": singleHeadQues[j]['checklistID'],
                  "subchecklistID": singleHeadQues[j]['subchecklistID'],
                  "subchecklistname": singleHeadQues[j]['subchecklistname'],
                  "attachfileManadatory": singleHeadQues[j]
                      ['attachfileManadatory'],
                  "ratingStatus": singleHeadQues[j]['ratingStatus'],
                  "ChecklistItemDataID": singleHeadQues[j]
                      ['ChecklistItemDataID'],
                  "comments": singleHeadQues[j]['comments'],
                  "ratingList": singleHeadQues[j]['ratingList'],
                  "attachments_names": singleHeadQues[j]['attachments_names'],
                  "attachments_paths": singleHeadQues[j]['attachments_paths'],
                  "attachments_baseImg": singleHeadQues[j]
                      ['attachments_baseImg'],
                });
                items.add(item);
              }
            }
          } else {
            var multipleHead = checkObject['subquestions'];
            for (int k = 0; k < multipleHead.length; k++) {
              var multipleHeadQues =
                  jsonDecode(multipleHead[k]['questions'].toString());
              List itemsqns = [];
              for (int l = 0; l < multipleHeadQues.length; l++) {
                if (selectPosition['itemID'].toString() ==
                    multipleHeadQues[l]['itemID'].toString()) {
                  var itemsqn = jsonEncode({
                    "s_no": multipleHeadQues[l]['s_no'],
                    "itemID": multipleHeadQues[l]['itemID'],
                    "itemName": multipleHeadQues[l]['itemName'],
                    "checklistID": multipleHeadQues[l]['checklistID'],
                    "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                    "subchecklistname": multipleHeadQues[l]['subchecklistname'],
                    "attachfileManadatory": multipleHeadQues[l]
                        ['attachfileManadatory'],
                    "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                    "checklistorder": multipleHeadQues[l]['checklistorder'],
                    "subChecklistorder": multipleHeadQues[l]
                        ['subChecklistorder'],
                    "ChecklistItemDataID": multipleHeadQues[l]
                        ['ChecklistItemDataID'],
                    "comments": multipleHeadQues[l]['comments'],
                    "ratingList": multipleHeadQues[l]['ratingList'],
                    "attachments_names":
                        "GOPA_${multipleHeadQues[l]['itemID']}.jpg",
                    "attachments_paths": paths[0].toString(),
                    "attachments_baseImg": baseImg[0].toString(),
                  });

                  itemsqns.add(itemsqn);
                } else {
                  var itemsqn = jsonEncode({
                    "s_no": multipleHeadQues[l]['s_no'],
                    "itemID": multipleHeadQues[l]['itemID'],
                    "itemName": multipleHeadQues[l]['itemName'],
                    "checklistID": multipleHeadQues[l]['checklistID'],
                    "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                    "subchecklistname": multipleHeadQues[l]['subchecklistname'],
                    "attachfileManadatory": multipleHeadQues[l]
                        ['attachfileManadatory'],
                    "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                    "checklistorder": multipleHeadQues[l]['checklistorder'],
                    "subChecklistorder": multipleHeadQues[l]
                        ['subChecklistorder'],
                    "ChecklistItemDataID": multipleHeadQues[l]
                        ['ChecklistItemDataID'],
                    "comments": multipleHeadQues[l]['comments'],
                    "ratingList": multipleHeadQues[l]['ratingList'],
                    "attachments_names": multipleHeadQues[l]
                        ['attachments_names'],
                    "attachments_paths": multipleHeadQues[l]
                        ['attachments_paths'],
                    "attachments_baseImg": multipleHeadQues[l]
                        ['attachments_baseImg'],
                  });
                  itemsqns.add(itemsqn);
                }
              }

              var subitem = {
                'id': multipleHead[k]['id'],
                'title': multipleHead[k]['title'],
                'questions': itemsqns
              };
              subitems.add(subitem);
            }
          }

          var checkList = jsonEncode({
            "id": checkObject['id'],
            "title": checkObject['title'],
            "subId": checkObject['subId'] == null ? "" : checkObject['subId'],
            "subtitle":
                checkObject['subtitle'] == null ? "" : checkObject['subtitle'],
            "questions": items,
            "subquestions": subitems
          });

          tempCheckList.add(checkList);
        }

        setState(() {
          Utilities.gopaList = [];
          Utilities.gopaList = tempCheckList;
          tempCheckList = [];
        });

        _timer?.cancel();
        EasyLoading.showSuccess('Uploading Success');
      }

      // }
    } catch (e) {
      print("Error Occured " + e.toString());
    }
  }

  filePicker(selectPosition) async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    double _sizeKbs = 0;
    final int maxSizeKbs = 3072;
    List tempCheckList = [];
    names = [];
    paths = [];
    baseImg = [];
    var dataLength;

    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'xls', 'mp4', 'docx'],
      );

      if (result != null && names.isEmpty) {
        final size = result!.files.first.size;
        _sizeKbs = size / 1024;
        print('size should be less than $maxSizeKbs Kb $_sizeKbs');
        Utilities.easyLoader();
        EasyLoading.show(
          status: "Uploading File",
        );
        names = result!.names;
        var fileLoadPath =
            "${Utilities.attachmentFilePathLocal}${names[0].toString()}";
        paths = result!.paths;

        for (int i = 0; i < names.length; i++) {
          var bytes = File(paths[i]).readAsBytesSync();
          File(paths[i]).copy(fileLoadPath);
          baseImg.add(base64Encode(bytes));
          paths = [];
          paths.add(fileLoadPath.toString());
        }
      }

      if (names[0].length > 40) {
        dataLength = names[0].length;
        if (dataLength > 40) {
          EasyLoading.addStatusCallback((dataLength) {
            if (dataLength == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          Get.snackbar(
            'Alert', 'Filename length exceeds!!!',
            titleText: Text(
              'Alert',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: red),
            ),
            messageText: Text(
              'Filename length exceeds!!!',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: whiteColor,
            overlayBlur: 5,
            duration: Duration(seconds: 3),
            // snackPosition: SnackPosition.BOTTOM,
            // isDismissible: false
          );

          EasyLoading.showInfo('Uploading Failed');
        }
      } else if (_sizeKbs > maxSizeKbs) {
        _timer?.cancel();
        EasyLoading.showInfo('Uploading Failed');
        Get.snackbar(
          'Alert', 'File size should be less than 3Mb',
          titleText: Text(
            'Alert',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: red),
          ),
          messageText: Text(
            'File size should be less than 3Mb',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: whiteColor,
          overlayBlur: 5,
          duration: Duration(seconds: 3),
          // snackPosition: SnackPosition.BOTTOM,
          // isDismissible: false
        );
      } else {
        SharedPreferences pref = await SharedPreferences.getInstance();
        var emplogin = pref.getString("employeeCode").toString();

        var PluginID = 137;
        var AuditID = widget.auditId;
        var AuditNumber = widget.auditNumber;
        var featurID = 0;
        var ChecklistID = selectPosition['checklistID'];
        var ChecklistItemID = selectPosition['itemID'].toString();
        var SubchecklistID = selectPosition['subchecklistID'].toString();
        var FileName = names[0].toString();
        var AttachedBy = emplogin;
        var ImageBase64 = baseImg[0].toString();

        if (isOnline) {
          var FileAttachmentSaveBody = jsonEncode({
            "PluginID": PluginID,
            "AuditID": AuditID,
            "AuditNumber": AuditNumber,
            "featurID": featurID,
            "ChecklistID": ChecklistID,
            "ChecklistItemID": ChecklistItemID,
            "SubchecklistID": SubchecklistID,
            "FileName": FileName,
            "AttachedBy": AttachedBy,
            "ImageBase64": ImageBase64,
          });

          ApiService.post("SaveFileAttachmentforChecklist",
                  FileAttachmentSaveBody, pref.getString('token'))
              .then((success) {
            if (success.statusCode == 200) {
              for (int i = 0; i < Utilities.gopaList.length; i++) {
                List items = [];
                List subitems = [];
                String itemDataId = '0';
                var checkObject = jsonDecode(Utilities.gopaList[i].toString());
                var singleHeadQues =
                    jsonDecode(checkObject['questions'].toString());

                if (singleHeadQues.length > 0) {
                  for (int j = 0; j < singleHeadQues.length; j++) {
                    if (selectPosition['itemID'].toString() ==
                        singleHeadQues[j]['itemID'].toString()) {
                      // Selected Item Rating and data Appears with single heading

                      var item = jsonEncode({
                        "s_no": singleHeadQues[j]['s_no'],
                        "itemID": singleHeadQues[j]['itemID'],
                        "itemName": singleHeadQues[j]['itemName'],
                        "checklistorder": singleHeadQues[j]['checklistorder'],
                        "subChecklistorder": singleHeadQues[j]
                            ['subChecklistorder'],
                        "checklistID": singleHeadQues[j]['checklistID'],
                        "subchecklistID": singleHeadQues[j]['subchecklistID'],
                        "subchecklistname": singleHeadQues[j]
                            ['subchecklistname'],
                        "attachfileManadatory": singleHeadQues[j]
                            ['attachfileManadatory'],
                        "ratingStatus": singleHeadQues[j]['ratingStatus'],
                        "ChecklistItemDataID": singleHeadQues[j]
                            ['ChecklistItemDataID'],
                        "comments": singleHeadQues[j]['comments'],
                        "ratingList": singleHeadQues[j]['ratingList'],
                        "attachments_names": names[0],
                        "attachments_paths": paths[0],
                        "attachments_baseImg": singleHeadQues[j]
                            ['attachments_baseImg'],
                      });

                      items.add(item);
                    } else {
                      var item = jsonEncode({
                        "s_no": singleHeadQues[j]['s_no'],
                        "itemID": singleHeadQues[j]['itemID'],
                        "itemName": singleHeadQues[j]['itemName'],
                        "checklistorder": singleHeadQues[j]['checklistorder'],
                        "subChecklistorder": singleHeadQues[j]
                            ['subChecklistorder'],
                        "checklistID": singleHeadQues[j]['checklistID'],
                        "subchecklistID": singleHeadQues[j]['subchecklistID'],
                        "subchecklistname": singleHeadQues[j]
                            ['subchecklistname'],
                        "attachfileManadatory": singleHeadQues[j]
                            ['attachfileManadatory'],
                        "ratingStatus": singleHeadQues[j]['ratingStatus'],
                        "ChecklistItemDataID": singleHeadQues[j]
                            ['ChecklistItemDataID'],
                        "comments": singleHeadQues[j]['comments'],
                        "ratingList": singleHeadQues[j]['ratingList'],
                        "attachments_names": singleHeadQues[j]
                            ['attachments_names'],
                        "attachments_paths": singleHeadQues[j]
                            ['attachments_paths'],
                        "attachments_baseImg": singleHeadQues[j]
                            ['attachments_baseImg'],
                      });
                      items.add(item);
                    }
                  }
                } else {
                  var multipleHead = checkObject['subquestions'];
                  for (int k = 0; k < multipleHead.length; k++) {
                    var multipleHeadQues =
                        jsonDecode(multipleHead[k]['questions'].toString());
                    List itemsqns = [];
                    for (int l = 0; l < multipleHeadQues.length; l++) {
                      if (selectPosition['itemID'].toString() ==
                          multipleHeadQues[l]['itemID'].toString()) {
                        var itemsqn = jsonEncode({
                          "s_no": multipleHeadQues[l]['s_no'],
                          "itemID": multipleHeadQues[l]['itemID'],
                          "itemName": multipleHeadQues[l]['itemName'],
                          "checklistID": multipleHeadQues[l]['checklistID'],
                          "subchecklistID": multipleHeadQues[l]
                              ['subchecklistID'],
                          "subchecklistname": multipleHeadQues[l]
                              ['subchecklistname'],
                          "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                          "checklistorder": multipleHeadQues[l]
                              ['checklistorder'],
                          "subChecklistorder": multipleHeadQues[l]
                              ['subChecklistorder'],
                          "attachfileManadatory": multipleHeadQues[l]
                              ['attachfileManadatory'],
                          "ChecklistItemDataID": multipleHeadQues[l]
                              ['ChecklistItemDataID'],
                          "comments": multipleHeadQues[l]['comments'],
                          "ratingList": multipleHeadQues[l]['ratingList'],
                          "attachments_names": names[0],
                          "attachments_paths": paths[0],
                          "attachments_baseImg": multipleHeadQues[l]
                              ['attachments_baseImg'],
                        });

                        itemsqns.add(itemsqn);
                      } else {
                        var itemsqn = jsonEncode({
                          "s_no": multipleHeadQues[l]['s_no'],
                          "itemID": multipleHeadQues[l]['itemID'],
                          "itemName": multipleHeadQues[l]['itemName'],
                          "checklistID": multipleHeadQues[l]['checklistID'],
                          "subchecklistID": multipleHeadQues[l]
                              ['subchecklistID'],
                          "subchecklistname": multipleHeadQues[l]
                              ['subchecklistname'],
                          "attachfileManadatory": multipleHeadQues[l]
                              ['attachfileManadatory'],
                          "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                          "checklistorder": multipleHeadQues[l]
                              ['checklistorder'],
                          "subChecklistorder": multipleHeadQues[l]
                              ['subChecklistorder'],
                          "ChecklistItemDataID": multipleHeadQues[l]
                              ['ChecklistItemDataID'],
                          "comments": multipleHeadQues[l]['comments'],
                          "ratingList": multipleHeadQues[l]['ratingList'],
                          "attachments_names": multipleHeadQues[l]
                              ['attachments_names'],
                          "attachments_paths": multipleHeadQues[l]
                              ['attachments_paths'],
                          "attachments_baseImg": multipleHeadQues[l]
                              ['attachments_baseImg'],
                        });
                        itemsqns.add(itemsqn);
                      }
                    }

                    var subitem = {
                      'id': multipleHead[k]['id'],
                      'title': multipleHead[k]['title'],
                      'questions': itemsqns
                    };
                    subitems.add(subitem);
                  }
                }

                var checkList = jsonEncode({
                  "id": checkObject['id'],
                  "title": checkObject['title'],
                  "subId":
                      checkObject['subId'] == null ? "" : checkObject['subId'],
                  "subtitle": checkObject['subtitle'] == null
                      ? ""
                      : checkObject['subtitle'],
                  "questions": items,
                  "subquestions": subitems
                });

                tempCheckList.add(checkList);
              }

              setState(() {
                Utilities.gopaList = [];
                Utilities.gopaList = tempCheckList;
                tempCheckList = [];
              });
              EasyLoading.addStatusCallback((status) {
                if (status == EasyLoadingStatus.dismiss) {
                  _timer?.cancel();
                }
              });

              EasyLoading.showSuccess('Uploading Success');
            } else {
              EasyLoading.showInfo("Uploading Failed");
            }
          });
        } else {
          var FileAttachmentSaveBody = jsonEncode({
            "PluginID": PluginID,
            "AuditID": AuditID,
            "AuditNumber": AuditNumber,
            "featurID": featurID,
            "ChecklistID": ChecklistID,
            "ChecklistItemID": ChecklistItemID,
            "SubchecklistID": SubchecklistID,
            "FilePath": paths[0].toString(),
            "FileName": FileName,
            "AttachedBy": AttachedBy,
            "ImageBase64": ImageBase64,
          });
          db.SaveFileAttachmentforChecklist(
              jsonDecode(FileAttachmentSaveBody), 0);

          for (int i = 0; i < Utilities.gopaList.length; i++) {
            List items = [];
            List subitems = [];
            String itemDataId = '0';
            var checkObject = jsonDecode(Utilities.gopaList[i].toString());
            var singleHeadQues =
                jsonDecode(checkObject['questions'].toString());

            if (singleHeadQues.length > 0) {
              for (int j = 0; j < singleHeadQues.length; j++) {
                if (selectPosition['itemID'].toString() ==
                    singleHeadQues[j]['itemID'].toString()) {
                  // Selected Item Rating and data Appears with single heading

                  var item = jsonEncode({
                    "s_no": singleHeadQues[j]['s_no'],
                    "itemID": singleHeadQues[j]['itemID'],
                    "itemName": singleHeadQues[j]['itemName'],
                    "checklistorder": singleHeadQues[j]['checklistorder'],
                    "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                    "checklistID": singleHeadQues[j]['checklistID'],
                    "subchecklistID": singleHeadQues[j]['subchecklistID'],
                    "subchecklistname": singleHeadQues[j]['subchecklistname'],
                    "attachfileManadatory": singleHeadQues[j]
                        ['attachfileManadatory'],
                    "ratingStatus": singleHeadQues[j]['ratingStatus'],
                    "ChecklistItemDataID": singleHeadQues[j]
                        ['ChecklistItemDataID'],
                    "comments": singleHeadQues[j]['comments'],
                    "ratingList": singleHeadQues[j]['ratingList'],
                    "attachments_names": names[0],
                    "attachments_paths": paths[0],
                    "attachments_baseImg": singleHeadQues[j]
                        ['attachments_baseImg'],
                  });

                  items.add(item);
                } else {
                  var item = jsonEncode({
                    "s_no": singleHeadQues[j]['s_no'],
                    "itemID": singleHeadQues[j]['itemID'],
                    "itemName": singleHeadQues[j]['itemName'],
                    "checklistorder": singleHeadQues[j]['checklistorder'],
                    "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                    "checklistID": singleHeadQues[j]['checklistID'],
                    "subchecklistID": singleHeadQues[j]['subchecklistID'],
                    "subchecklistname": singleHeadQues[j]['subchecklistname'],
                    "attachfileManadatory": singleHeadQues[j]
                        ['attachfileManadatory'],
                    "ratingStatus": singleHeadQues[j]['ratingStatus'],
                    "ChecklistItemDataID": singleHeadQues[j]
                        ['ChecklistItemDataID'],
                    "comments": singleHeadQues[j]['comments'],
                    "ratingList": singleHeadQues[j]['ratingList'],
                    "attachments_names": singleHeadQues[j]['attachments_names'],
                    "attachments_paths": singleHeadQues[j]['attachments_paths'],
                    "attachments_baseImg": singleHeadQues[j]
                        ['attachments_baseImg'],
                  });
                  items.add(item);
                }
              }
            } else {
              var multipleHead = checkObject['subquestions'];
              for (int k = 0; k < multipleHead.length; k++) {
                var multipleHeadQues =
                    jsonDecode(multipleHead[k]['questions'].toString());
                List itemsqns = [];
                for (int l = 0; l < multipleHeadQues.length; l++) {
                  if (selectPosition['itemID'].toString() ==
                      multipleHeadQues[l]['itemID'].toString()) {
                    var itemsqn = jsonEncode({
                      "s_no": multipleHeadQues[l]['s_no'],
                      "itemID": multipleHeadQues[l]['itemID'],
                      "itemName": multipleHeadQues[l]['itemName'],
                      "checklistID": multipleHeadQues[l]['checklistID'],
                      "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                      "subchecklistname": multipleHeadQues[l]
                          ['subchecklistname'],
                      "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                      "checklistorder": multipleHeadQues[l]['checklistorder'],
                      "subChecklistorder": multipleHeadQues[l]
                          ['subChecklistorder'],
                      "attachfileManadatory": multipleHeadQues[l]
                          ['attachfileManadatory'],
                      "ChecklistItemDataID": multipleHeadQues[l]
                          ['ChecklistItemDataID'],
                      "comments": multipleHeadQues[l]['comments'],
                      "ratingList": multipleHeadQues[l]['ratingList'],
                      "attachments_names": names[0],
                      "attachments_paths": paths[0],
                      "attachments_baseImg": multipleHeadQues[l]
                          ['attachments_baseImg'],
                    });

                    itemsqns.add(itemsqn);
                  } else {
                    var itemsqn = jsonEncode({
                      "s_no": multipleHeadQues[l]['s_no'],
                      "itemID": multipleHeadQues[l]['itemID'],
                      "itemName": multipleHeadQues[l]['itemName'],
                      "checklistID": multipleHeadQues[l]['checklistID'],
                      "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                      "subchecklistname": multipleHeadQues[l]
                          ['subchecklistname'],
                      "attachfileManadatory": multipleHeadQues[l]
                          ['attachfileManadatory'],
                      "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                      "checklistorder": multipleHeadQues[l]['checklistorder'],
                      "subChecklistorder": multipleHeadQues[l]
                          ['subChecklistorder'],
                      "ChecklistItemDataID": multipleHeadQues[l]
                          ['ChecklistItemDataID'],
                      "comments": multipleHeadQues[l]['comments'],
                      "ratingList": multipleHeadQues[l]['ratingList'],
                      "attachments_names": multipleHeadQues[l]
                          ['attachments_names'],
                      "attachments_paths": multipleHeadQues[l]
                          ['attachments_paths'],
                      "attachments_baseImg": multipleHeadQues[l]
                          ['attachments_baseImg'],
                    });
                    itemsqns.add(itemsqn);
                  }
                }

                var subitem = {
                  'id': multipleHead[k]['id'],
                  'title': multipleHead[k]['title'],
                  'questions': itemsqns
                };
                subitems.add(subitem);
              }
            }

            var checkList = jsonEncode({
              "id": checkObject['id'],
              "title": checkObject['title'],
              "subId": checkObject['subId'] == null ? "" : checkObject['subId'],
              "subtitle": checkObject['subtitle'] == null
                  ? ""
                  : checkObject['subtitle'],
              "questions": items,
              "subquestions": subitems
            });

            tempCheckList.add(checkList);
          }

          setState(() {
            Utilities.gopaList = [];
            Utilities.gopaList = tempCheckList;
            tempCheckList = [];
          });

          _timer?.cancel();

          EasyLoading.showSuccess('Loading Success');
        }
      }
    } catch (e) {
      print("Error Occured " + e.toString());
    }
  }

  takePhotoFromGallery(ImageSource source, selectPosition) async {
    List tempCheckList = [];
    names = [];
    paths = [];
    baseImg = [];
    var dataLength;
    var maxFileSizeInBytes = 3 * 1048576;

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );
    final File? file = File(image!.path);

    bool isOnline = await Utilities.CheckUserConnection() as bool;
    List<int> imageBytes = [];
    try {
      if (image != null) {
        Utilities.easyLoader();
        EasyLoading.show(
          status: "Uploading File",
        );
        // _uploadLoader(context);
        _visible = true;
        selectedImage = file;
        String fileName = image.path.toString().split('/').last;
        imageBytes = selectedImage!.readAsBytesSync();
        var imageB64 = base64Encode(imageBytes);
        baseImg.add(imageB64);
        names.add(fileName);
        paths.add(image.path.toString());
      }

      SharedPreferences pref = await SharedPreferences.getInstance();
      var emplogin = pref.getString("employeeCode").toString();

      var PluginID = 137;
      var AuditID = widget.auditId;
      var AuditNumber = widget.auditNumber;
      var featurID = 0;
      var ChecklistID = selectPosition['checklistID'];
      var ChecklistItemID = selectPosition['itemID'].toString();
      var SubchecklistID = selectPosition['subchecklistID'].toString();
      var FileName = names[0].toString();
      var extensionFileName = FileName.toString().split('.');
      String? fileFormatName = extensionFileName[extensionFileName.length - 1];
      print(fileFormatName);
      var AttachedBy = emplogin;
      var ImageBase64 = baseImg[0].toString();
      print(FileName);
      print("FileName------------------>");
      names = [];
      names.add("GOPA_${ChecklistItemID}.$fileFormatName");

      var fileLoadPath =
          "${Utilities.attachmentFilePathLocal}${names[0].toString()}";
      image.saveTo(fileLoadPath.toString());
      var fileSize = imageBytes.length; // Get the file size in bytes

      print("-------------------------------->>>>>>$fileSize");
      print("-------------------------------->>>>>>>>$maxFileSizeInBytes");

      if (fileSize <= maxFileSizeInBytes) {
        if (isOnline) {
          var FileAttachmentSaveBody = jsonEncode({
            "PluginID": PluginID,
            "AuditID": AuditID,
            "AuditNumber": AuditNumber,
            "featurID": featurID,
            "ChecklistID": ChecklistID,
            "ChecklistItemID": ChecklistItemID,
            "SubchecklistID": SubchecklistID,
            "FileName": "GOPA_${ChecklistItemID}.$fileFormatName",
            "AttachedBy": AttachedBy,
            "ImageBase64": ImageBase64,
          });
          ApiService.post("SaveFileAttachmentforChecklist",
                  FileAttachmentSaveBody, pref.getString('token'))
              .then((success) {
            if (success.statusCode == 200) {
              for (int i = 0; i < Utilities.gopaList.length; i++) {
                List items = [];
                List subitems = [];
                String itemDataId = '0';
                var checkObject = jsonDecode(Utilities.gopaList[i].toString());
                var singleHeadQues =
                    jsonDecode(checkObject['questions'].toString());

                if (singleHeadQues.length > 0) {
                  for (int j = 0; j < singleHeadQues.length; j++) {
                    if (selectPosition['itemID'].toString() ==
                        singleHeadQues[j]['itemID'].toString()) {
                      // Selected Item Rating and data Appears with single heading

                      var item = jsonEncode({
                        "s_no": singleHeadQues[j]['s_no'],
                        "itemID": singleHeadQues[j]['itemID'],
                        "itemName": singleHeadQues[j]['itemName'],
                        "checklistorder": singleHeadQues[j]['checklistorder'],
                        "subChecklistorder": singleHeadQues[j]
                            ['subChecklistorder'],
                        "checklistID": singleHeadQues[j]['checklistID'],
                        "subchecklistID": singleHeadQues[j]['subchecklistID'],
                        "subchecklistname": singleHeadQues[j]
                            ['subchecklistname'],
                        "attachfileManadatory": singleHeadQues[j]
                            ['attachfileManadatory'],
                        "ratingStatus": singleHeadQues[j]['ratingStatus'],
                        "ChecklistItemDataID": singleHeadQues[j]
                            ['ChecklistItemDataID'],
                        "comments": singleHeadQues[j]['comments'],
                        "ratingList": singleHeadQues[j]['ratingList'],
                        "attachments_names":
                            "GOPA_${singleHeadQues[j]['itemID']}.$fileFormatName",
                        "attachments_paths": paths[0].toString(),
                        "attachments_baseImg": baseImg[0].toString(),
                      });

                      items.add(item);
                    } else {
                      var item = jsonEncode({
                        "s_no": singleHeadQues[j]['s_no'],
                        "itemID": singleHeadQues[j]['itemID'],
                        "itemName": singleHeadQues[j]['itemName'],
                        "checklistorder": singleHeadQues[j]['checklistorder'],
                        "subChecklistorder": singleHeadQues[j]
                            ['subChecklistorder'],
                        "checklistID": singleHeadQues[j]['checklistID'],
                        "subchecklistID": singleHeadQues[j]['subchecklistID'],
                        "subchecklistname": singleHeadQues[j]
                            ['subchecklistname'],
                        "attachfileManadatory": singleHeadQues[j]
                            ['attachfileManadatory'],
                        "ratingStatus": singleHeadQues[j]['ratingStatus'],
                        "ChecklistItemDataID": singleHeadQues[j]
                            ['ChecklistItemDataID'],
                        "comments": singleHeadQues[j]['comments'],
                        "ratingList": singleHeadQues[j]['ratingList'],
                        "attachments_names": singleHeadQues[j]
                            ['attachments_names'],
                        "attachments_paths": singleHeadQues[j]
                            ['attachments_paths'],
                        "attachments_baseImg": singleHeadQues[j]
                            ['attachments_baseImg'],
                      });
                      items.add(item);
                    }
                  }
                } else {
                  var multipleHead = checkObject['subquestions'];
                  for (int k = 0; k < multipleHead.length; k++) {
                    var multipleHeadQues =
                        jsonDecode(multipleHead[k]['questions'].toString());
                    List itemsqns = [];
                    for (int l = 0; l < multipleHeadQues.length; l++) {
                      if (selectPosition['itemID'].toString() ==
                          multipleHeadQues[l]['itemID'].toString()) {
                        var itemsqn = jsonEncode({
                          "s_no": multipleHeadQues[l]['s_no'],
                          "itemID": multipleHeadQues[l]['itemID'],
                          "itemName": multipleHeadQues[l]['itemName'],
                          "checklistID": multipleHeadQues[l]['checklistID'],
                          "subchecklistID": multipleHeadQues[l]
                              ['subchecklistID'],
                          "subchecklistname": multipleHeadQues[l]
                              ['subchecklistname'],
                          "attachfileManadatory": multipleHeadQues[l]
                              ['attachfileManadatory'],
                          "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                          "checklistorder": multipleHeadQues[l]
                              ['checklistorder'],
                          "subChecklistorder": multipleHeadQues[l]
                              ['subChecklistorder'],
                          "ChecklistItemDataID": multipleHeadQues[l]
                              ['ChecklistItemDataID'],
                          "comments": multipleHeadQues[l]['comments'],
                          "ratingList": multipleHeadQues[l]['ratingList'],
                          "attachments_names":
                              "GOPA_${multipleHeadQues[l]['itemID']}.$fileFormatName",
                          "attachments_paths": paths[0].toString(),
                          "attachments_baseImg": baseImg[0].toString(),
                        });

                        itemsqns.add(itemsqn);
                      } else {
                        var itemsqn = jsonEncode({
                          "s_no": multipleHeadQues[l]['s_no'],
                          "itemID": multipleHeadQues[l]['itemID'],
                          "itemName": multipleHeadQues[l]['itemName'],
                          "checklistID": multipleHeadQues[l]['checklistID'],
                          "subchecklistID": multipleHeadQues[l]
                              ['subchecklistID'],
                          "subchecklistname": multipleHeadQues[l]
                              ['subchecklistname'],
                          "attachfileManadatory": multipleHeadQues[l]
                              ['attachfileManadatory'],
                          "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                          "checklistorder": multipleHeadQues[l]
                              ['checklistorder'],
                          "subChecklistorder": multipleHeadQues[l]
                              ['subChecklistorder'],
                          "ChecklistItemDataID": multipleHeadQues[l]
                              ['ChecklistItemDataID'],
                          "comments": multipleHeadQues[l]['comments'],
                          "ratingList": multipleHeadQues[l]['ratingList'],
                          "attachments_names": multipleHeadQues[l]
                              ['attachments_names'],
                          "attachments_paths": multipleHeadQues[l]
                              ['attachments_paths'],
                          "attachments_baseImg": multipleHeadQues[l]
                              ['attachments_baseImg'],
                        });
                        itemsqns.add(itemsqn);
                      }
                    }

                    var subitem = {
                      'id': multipleHead[k]['id'],
                      'title': multipleHead[k]['title'],
                      'questions': itemsqns
                    };
                    subitems.add(subitem);
                  }
                }

                var checkList = jsonEncode({
                  "id": checkObject['id'],
                  "title": checkObject['title'],
                  "subId":
                      checkObject['subId'] == null ? "" : checkObject['subId'],
                  "subtitle": checkObject['subtitle'] == null
                      ? ""
                      : checkObject['subtitle'],
                  "questions": items,
                  "subquestions": subitems
                });

                tempCheckList.add(checkList);
              }

              setState(() {
                Utilities.gopaList = [];
                Utilities.gopaList = tempCheckList;
                tempCheckList = [];
              });
              EasyLoading.addStatusCallback((status) {
                if (status == EasyLoadingStatus.dismiss) {
                  _timer?.cancel();
                }
              });

              EasyLoading.showSuccess('Uploading Success');
            } else {
              EasyLoading.showInfo("Uploading Failed");
            }
          });
        } else {
          var FileAttachmentSaveBody = jsonEncode({
            "PluginID": PluginID,
            "AuditID": AuditID,
            "AuditNumber": AuditNumber,
            "featurID": featurID,
            "ChecklistID": ChecklistID,
            "ChecklistItemID": ChecklistItemID,
            "SubchecklistID": SubchecklistID,
            "FileName": "GOPA_${ChecklistItemID}.$fileFormatName",
            "FilePath": fileLoadPath.toString(),
            "AttachedBy": AttachedBy,
            "ImageBase64": ImageBase64,
          });
          db.SaveFileAttachmentforChecklist(
              jsonDecode(FileAttachmentSaveBody), 0);

          for (int i = 0; i < Utilities.gopaList.length; i++) {
            List items = [];
            List subitems = [];
            String itemDataId = '0';
            var checkObject = jsonDecode(Utilities.gopaList[i].toString());
            var singleHeadQues =
                jsonDecode(checkObject['questions'].toString());

            if (singleHeadQues.length > 0) {
              for (int j = 0; j < singleHeadQues.length; j++) {
                if (selectPosition['itemID'].toString() ==
                    singleHeadQues[j]['itemID'].toString()) {
                  // Selected Item Rating and data Appears with single heading

                  var item = jsonEncode({
                    "s_no": singleHeadQues[j]['s_no'],
                    "itemID": singleHeadQues[j]['itemID'],
                    "itemName": singleHeadQues[j]['itemName'],
                    "checklistorder": singleHeadQues[j]['checklistorder'],
                    "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                    "checklistID": singleHeadQues[j]['checklistID'],
                    "subchecklistID": singleHeadQues[j]['subchecklistID'],
                    "subchecklistname": singleHeadQues[j]['subchecklistname'],
                    "attachfileManadatory": singleHeadQues[j]
                        ['attachfileManadatory'],
                    "ratingStatus": singleHeadQues[j]['ratingStatus'],
                    "ChecklistItemDataID": singleHeadQues[j]
                        ['ChecklistItemDataID'],
                    "comments": singleHeadQues[j]['comments'],
                    "ratingList": singleHeadQues[j]['ratingList'],
                    "attachments_names":
                        "GOPA_${singleHeadQues[j]['itemID']}.$fileFormatName",
                    "attachments_paths": paths[0].toString(),
                    "attachments_baseImg": baseImg[0].toString(),
                  });

                  items.add(item);
                } else {
                  var item = jsonEncode({
                    "s_no": singleHeadQues[j]['s_no'],
                    "itemID": singleHeadQues[j]['itemID'],
                    "itemName": singleHeadQues[j]['itemName'],
                    "checklistorder": singleHeadQues[j]['checklistorder'],
                    "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                    "checklistID": singleHeadQues[j]['checklistID'],
                    "subchecklistID": singleHeadQues[j]['subchecklistID'],
                    "subchecklistname": singleHeadQues[j]['subchecklistname'],
                    "attachfileManadatory": singleHeadQues[j]
                        ['attachfileManadatory'],
                    "ratingStatus": singleHeadQues[j]['ratingStatus'],
                    "ChecklistItemDataID": singleHeadQues[j]
                        ['ChecklistItemDataID'],
                    "comments": singleHeadQues[j]['comments'],
                    "ratingList": singleHeadQues[j]['ratingList'],
                    "attachments_names": singleHeadQues[j]['attachments_names'],
                    "attachments_paths": singleHeadQues[j]['attachments_paths'],
                    "attachments_baseImg": singleHeadQues[j]
                        ['attachments_baseImg'],
                  });
                  items.add(item);
                }
              }
            } else {
              var multipleHead = checkObject['subquestions'];
              for (int k = 0; k < multipleHead.length; k++) {
                var multipleHeadQues =
                    jsonDecode(multipleHead[k]['questions'].toString());
                List itemsqns = [];
                for (int l = 0; l < multipleHeadQues.length; l++) {
                  if (selectPosition['itemID'].toString() ==
                      multipleHeadQues[l]['itemID'].toString()) {
                    var itemsqn = jsonEncode({
                      "s_no": multipleHeadQues[l]['s_no'],
                      "itemID": multipleHeadQues[l]['itemID'],
                      "itemName": multipleHeadQues[l]['itemName'],
                      "checklistID": multipleHeadQues[l]['checklistID'],
                      "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                      "subchecklistname": multipleHeadQues[l]
                          ['subchecklistname'],
                      "attachfileManadatory": multipleHeadQues[l]
                          ['attachfileManadatory'],
                      "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                      "checklistorder": multipleHeadQues[l]['checklistorder'],
                      "subChecklistorder": multipleHeadQues[l]
                          ['subChecklistorder'],
                      "ChecklistItemDataID": multipleHeadQues[l]
                          ['ChecklistItemDataID'],
                      "comments": multipleHeadQues[l]['comments'],
                      "ratingList": multipleHeadQues[l]['ratingList'],
                      "attachments_names":
                          "GOPA_${multipleHeadQues[l]['itemID']}.$fileFormatName",
                      "attachments_paths": paths[0].toString(),
                      "attachments_baseImg": baseImg[0].toString(),
                    });

                    itemsqns.add(itemsqn);
                  } else {
                    var itemsqn = jsonEncode({
                      "s_no": multipleHeadQues[l]['s_no'],
                      "itemID": multipleHeadQues[l]['itemID'],
                      "itemName": multipleHeadQues[l]['itemName'],
                      "checklistID": multipleHeadQues[l]['checklistID'],
                      "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                      "subchecklistname": multipleHeadQues[l]
                          ['subchecklistname'],
                      "attachfileManadatory": multipleHeadQues[l]
                          ['attachfileManadatory'],
                      "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                      "checklistorder": multipleHeadQues[l]['checklistorder'],
                      "subChecklistorder": multipleHeadQues[l]
                          ['subChecklistorder'],
                      "ChecklistItemDataID": multipleHeadQues[l]
                          ['ChecklistItemDataID'],
                      "comments": multipleHeadQues[l]['comments'],
                      "ratingList": multipleHeadQues[l]['ratingList'],
                      "attachments_names": multipleHeadQues[l]
                          ['attachments_names'],
                      "attachments_paths": multipleHeadQues[l]
                          ['attachments_paths'],
                      "attachments_baseImg": multipleHeadQues[l]
                          ['attachments_baseImg'],
                    });
                    itemsqns.add(itemsqn);
                  }
                }

                var subitem = {
                  'id': multipleHead[k]['id'],
                  'title': multipleHead[k]['title'],
                  'questions': itemsqns
                };
                subitems.add(subitem);
              }
            }

            var checkList = jsonEncode({
              "id": checkObject['id'],
              "title": checkObject['title'],
              "subId": checkObject['subId'] == null ? "" : checkObject['subId'],
              "subtitle": checkObject['subtitle'] == null
                  ? ""
                  : checkObject['subtitle'],
              "questions": items,
              "subquestions": subitems
            });

            tempCheckList.add(checkList);
          }

          setState(() {
            Utilities.gopaList = [];
            Utilities.gopaList = tempCheckList;
            tempCheckList = [];
          });

          _timer?.cancel();
          EasyLoading.showSuccess('Uploading Success');
        }
      } else {
        _timer?.cancel();
        EasyLoading.showInfo("Uploading Failed");
        Get.snackbar(
          'Alert', 'File size should be less than 3Mb',
          titleText: Text(
            'Alert',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: red),
          ),
          messageText: Text(
            'File size should be less than 3Mb',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: whiteColor,
          overlayBlur: 5,
          duration: Duration(seconds: 5),
          // snackPosition: SnackPosition.BOTTOM,
          // isDismissible: false
        );
      }
    } catch (e) {
      print("Error Occured " + e.toString());
    }
  }

  filePickerNew(selectPosition) async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    List tempCheckList = [];
    names = [];
    paths = [];
    baseImg = [];
    var fileLoadPath = "";
    var dataLength;
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Uploading File",
    );
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'xls', 'mp4', 'docx'],
      );

      if (result != null && names.isEmpty) {
        names = result!.names;
        fileLoadPath =
            "${Utilities.attachmentFilePathLocal}${names[0].toString()}";
        paths = result!.paths;

        for (int i = 0; i < names.length; i++) {
          var bytes = File(paths[i]).readAsBytesSync();
          File(paths[i]).copy(fileLoadPath);
          baseImg.add(base64Encode(bytes));
          paths = [];
          paths.add(fileLoadPath.toString());
        }
      }

      if (names[0].length > 40) {
        dataLength = names[0].length;
        if (dataLength > 40) {
          EasyLoading.addStatusCallback((dataLength) {
            if (dataLength == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          Get.snackbar(
            'Alert', 'Filename length exceeds!!!',
            titleText: Text(
              'Alert',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: red),
            ),
            messageText: Text(
              'Filename length exceeds!!!',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: whiteColor,
            overlayBlur: 5,
            duration: Duration(seconds: 3),
            // snackPosition: SnackPosition.BOTTOM,
            // isDismissible: false
          );

          EasyLoading.showInfo('Uploading Failed');
        }
      } else {
        for (int i = 0; i < Utilities.gopaList.length; i++) {
          List items = [];
          List subitems = [];
          String itemDataId = '0';
          var checkObject = jsonDecode(Utilities.gopaList[i].toString());
          var singleHeadQues = jsonDecode(checkObject['questions'].toString());

          if (singleHeadQues.length > 0) {
            for (int j = 0; j < singleHeadQues.length; j++) {
              print("selectPosition------------------------->");
              print(selectPosition);
              print(singleHeadQues[j]);
              if (selectPosition['itemID'].toString() ==
                  singleHeadQues[j]['itemID'].toString()) {
                // Selected Item Rating and data Appears with single heading

                var item = jsonEncode({
                  "s_no": singleHeadQues[j]['s_no'],
                  "itemID": singleHeadQues[j]['itemID'],
                  "itemName": singleHeadQues[j]['itemName'],
                  "checklistorder": singleHeadQues[j]['checklistorder'],
                  "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                  "checklistID": singleHeadQues[j]['checklistID'],
                  "subchecklistID": singleHeadQues[j]['subchecklistID'],
                  "subchecklistname": singleHeadQues[j]['subchecklistname'],
                  "attachfileManadatory": singleHeadQues[j]
                      ['attachfileManadatory'],
                  "ratingStatus": singleHeadQues[j]['ratingStatus'],
                  "ChecklistItemDataID": singleHeadQues[j]
                      ['ChecklistItemDataID'],
                  "comments": singleHeadQues[j]['comments'],
                  "ratingList": singleHeadQues[j]['ratingList'],
                  "attachments_names": names[0],
                  "attachments_paths": paths[0],
                  "attachments_baseImg": singleHeadQues[j]
                      ['attachments_baseImg'],
                });

                items.add(item);
              } else {
                var item = jsonEncode({
                  "s_no": singleHeadQues[j]['s_no'],
                  "itemID": singleHeadQues[j]['itemID'],
                  "itemName": singleHeadQues[j]['itemName'],
                  "checklistorder": singleHeadQues[j]['checklistorder'],
                  "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                  "checklistID": singleHeadQues[j]['checklistID'],
                  "subchecklistID": singleHeadQues[j]['subchecklistID'],
                  "subchecklistname": singleHeadQues[j]['subchecklistname'],
                  "attachfileManadatory": singleHeadQues[j]
                      ['attachfileManadatory'],
                  "ratingStatus": singleHeadQues[j]['ratingStatus'],
                  "ChecklistItemDataID": singleHeadQues[j]
                      ['ChecklistItemDataID'],
                  "comments": singleHeadQues[j]['comments'],
                  "ratingList": singleHeadQues[j]['ratingList'],
                  "attachments_names": singleHeadQues[j]['attachments_names'],
                  "attachments_paths": singleHeadQues[j]['attachments_paths'],
                  "attachments_baseImg": singleHeadQues[j]
                      ['attachments_baseImg'],
                });
                items.add(item);
              }
            }
          } else {
            var multipleHead = checkObject['subquestions'];
            // print(multipleHead.toString()+"");
            for (int k = 0; k < multipleHead.length; k++) {
              // print("Entered for loopp  " + multipleHead[k]['title']);
              var multipleHeadQues =
                  jsonDecode(multipleHead[k]['questions'].toString());
              //print("Entered for loopp  if " + multipleHeadQues[0]['itemID'].toString());
              List itemsqns = [];
              for (int l = 0; l < multipleHeadQues.length; l++) {
                //print(selectPosition['itemID'].toString() +"Entered for loopp  if " + multipleHeadQues[l]['itemID'].toString());
                // var questions = multipleHeadQues[l];
                print("selectPosition------------------------->");
                print(selectPosition);
                print(multipleHeadQues[l]);
                if (selectPosition['itemID'].toString() ==
                    multipleHeadQues[l]['itemID'].toString()) {
                  // Selected Item Rating and data Appears with multiple heading
                  // print("Entered for loopp  if " );

                  var itemsqn = jsonEncode({
                    "s_no": multipleHeadQues[l]['s_no'],
                    "itemID": multipleHeadQues[l]['itemID'],
                    "itemName": multipleHeadQues[l]['itemName'],
                    "checklistID": multipleHeadQues[l]['checklistID'],
                    "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                    "subchecklistname": multipleHeadQues[l]['subchecklistname'],
                    "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                    "checklistorder": multipleHeadQues[l]['checklistorder'],
                    "subChecklistorder": multipleHeadQues[l]
                        ['subChecklistorder'],
                    "attachfileManadatory": multipleHeadQues[l]
                        ['attachfileManadatory'],
                    "ChecklistItemDataID": multipleHeadQues[l]
                        ['ChecklistItemDataID'],
                    "comments": multipleHeadQues[l]['comments'],
                    "ratingList": multipleHeadQues[l]['ratingList'],
                    "attachments_names": names[0],
                    "attachments_paths": paths[0],
                    "attachments_baseImg": multipleHeadQues[l]
                        ['attachments_baseImg'],
                  });

                  itemsqns.add(itemsqn);
                } else {
                  // Not Selected Item Rating and data Appears with multiple heading
                  // print("Entered for loopp  else " );
                  // Not Selected Item Rating and data Appears with single heading
                  // print("Entered for loopp  else "+multipleHeadQues[l]['itemName'].toString());
                  var itemsqn = jsonEncode({
                    "s_no": multipleHeadQues[l]['s_no'],
                    "itemID": multipleHeadQues[l]['itemID'],
                    "itemName": multipleHeadQues[l]['itemName'],
                    "checklistID": multipleHeadQues[l]['checklistID'],
                    "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                    "subchecklistname": multipleHeadQues[l]['subchecklistname'],
                    "attachfileManadatory": multipleHeadQues[l]
                        ['attachfileManadatory'],
                    "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                    "checklistorder": multipleHeadQues[l]['checklistorder'],
                    "subChecklistorder": multipleHeadQues[l]
                        ['subChecklistorder'],
                    "ChecklistItemDataID": multipleHeadQues[l]
                        ['ChecklistItemDataID'],
                    "comments": multipleHeadQues[l]['comments'],
                    "ratingList": multipleHeadQues[l]['ratingList'],
                    "attachments_names": multipleHeadQues[l]
                        ['attachments_names'],
                    "attachments_paths": multipleHeadQues[l]
                        ['attachments_paths'],
                    "attachments_baseImg": multipleHeadQues[l]
                        ['attachments_baseImg'],
                  });
                  itemsqns.add(itemsqn);
                }
                // print("Entered for loopp  " + multipleHeadQues[l]['id']);
              }

              var subitem = {
                'id': multipleHead[k]['id'],
                'title': multipleHead[k]['title'],
                'questions': itemsqns
              };
              subitems.add(subitem);
            }
          }

          var checkList = jsonEncode({
            "id": checkObject['id'],
            "title": checkObject['title'],
            "subId": checkObject['subId'] == null ? "" : checkObject['subId'],
            "subtitle":
                checkObject['subtitle'] == null ? "" : checkObject['subtitle'],
            "questions": items,
            "subquestions": subitems
          });

          tempCheckList.add(checkList);
          // print("temp updated data");
          // print(tempCheckList);
        }

        SharedPreferences pref = await SharedPreferences.getInstance();
        var emplogin = pref.getString("employeeCode").toString();

        var PluginID = 137;
        var AuditID = widget.auditId;
        var AuditNumber = widget.auditNumber;
        var featurID = 0;
        var ChecklistID = selectPosition['checklistID'];
        var ChecklistItemID = selectPosition['itemID'].toString();
        var SubchecklistID = selectPosition['subchecklistID'].toString();
        var FileName = names[0].toString();
        var AttachedBy = emplogin;
        var ImageBase64 = baseImg[0].toString();

        if (isOnline) {
          var FileAttachmentSaveBody = jsonEncode({
            "PluginID": PluginID,
            "AuditID": AuditID,
            "AuditNumber": AuditNumber,
            "featurID": featurID,
            "ChecklistID": ChecklistID,
            "ChecklistItemID": ChecklistItemID,
            "SubchecklistID": SubchecklistID,
            "FileName": FileName,
            "AttachedBy": AttachedBy,
            "ImageBase64": "",
          });

          Map<String, dynamic> FinalFileAttachmentSaveBody = {
            "file": fileLoadPath,
            "SaveFileAttachmentsChecklistModelforAllModules":
                jsonDecode(FileAttachmentSaveBody),
          };
          print("FileAttachmentSaveBody");
          print(FinalFileAttachmentSaveBody);
          ApiService.post("FileAttachmentGOPA", FinalFileAttachmentSaveBody,
                  pref.getString('token'))
              .then((success) {
            if (success.statusCode == 200) {
              print('datalength----------------->');
              EasyLoading.addStatusCallback((status) {
                print('EasyLoading Status $status');
                if (status == EasyLoadingStatus.dismiss) {
                  _timer?.cancel();
                }
              });

              EasyLoading.showSuccess('Uploading Success');
            } else {
              EasyLoading.showInfo("Uploading Failed");
            }
            print(success.body);
          });
        } else {
          var FileAttachmentSaveBody = jsonEncode({
            "PluginID": PluginID,
            "AuditID": AuditID,
            "AuditNumber": AuditNumber,
            "featurID": featurID,
            "ChecklistID": ChecklistID,
            "ChecklistItemID": ChecklistItemID,
            "SubchecklistID": SubchecklistID,
            "FilePath": paths[0].toString(),
            "FileName": FileName,
            "AttachedBy": AttachedBy,
            "ImageBase64": ImageBase64,
          });
          db.SaveFileAttachmentforChecklist(
              jsonDecode(FileAttachmentSaveBody), 0);

          _timer?.cancel();

          EasyLoading.showSuccess('Loading Success');
        }
        print("tempCheckList");
        print(tempCheckList);

        setState(() {
          Utilities.gopaList = [];
          Utilities.gopaList = tempCheckList;
          tempCheckList = [];
        });
      }
    } catch (e) {
      print("Error Occured " + e.toString());
    }
  }

  updateImageData(selectedQue) async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'png'],
    );

    setState(() {
      _visible = true;
      names = result!.names;
      paths = result!.paths;
      int sizeInBytes = File(names[0]).lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > 2 && !isOnline) {
        CoolAlert.show(
            context: context,
            title: "File size exceeds!!!",
            barrierDismissible: false,
            flareAnimationName: "play",
            type: CoolAlertType.warning,
            cancelBtnText: "",
            confirmBtnText: "Ok",
            onCancelBtnTap: () {
              Navigator.pop(context);
            },
            showCancelBtn: false,
            confirmBtnColor: Colors.deepOrangeAccent);
      }

      for (int i = 0; i < names.length; i++) {
        var bytes = File(paths[i]).readAsBytesSync();
        baseImg.add(base64Encode(bytes));
      }

      List tempCheckListItems = [];
      List tempCheckList = [];
      String id = '0';
      try {
        for (int i = 0; i < auditList.length; i++) {
          tempCheckListItems = [];
          String itemDataId = '0';
          List items = [];
          if (id != auditList[i]['checkListID']) {
            for (int j = 0; j < auditList.length; j++) {
              if (auditList[j]['itemID'] == selectedQue['itemID']) {
                names = names;
              }
              if (auditList[j]['checkListID'] == auditList[i]['checkListID']) {
                List<bool> ratings = [];
                var rating = jsonEncode([
                  {
                    "id": "1",
                    "name": 'Yes',
                  },
                  {
                    "id": "2",
                    "name": 'No',
                  },
                  {
                    "id": "3",
                    "name": 'Not Applicable',
                  }
                ]);
                ratings.add(false);
                ratings.add(false);
                ratings.add(false);
                ratingList = jsonDecode(rating);

                var item = jsonEncode({
                  "itemID": auditList[j]['itemID'],
                  "itemName": auditList[j]['itemName'],
                  "ratingStatus": ratings,
                  "ratingList": ratingList,
                  "attachments": names
                });
                items.add(item);
              }
            }

            var checkList = jsonEncode({
              "id": auditList[i]['checkListID'],
              "title": auditList[i]['checkListName'],
              "questions": items
            });

            Utilities.gopaList.add(checkList);
            id = auditList[i]['checkListID'];
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  List<Widget> fruits = <Widget>[];

  makeAuditCheckListApiCall() async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    auditList = [];
    if (isOnline) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      SharedPreferences prefRole = await SharedPreferences.getInstance();
      String? auditType;

      var logRole = prefRole.getString('user_role');
      if (logRole == 'APM') {
        auditType = '1';
      } else if (logRole == 'RM') {
        auditType = '2';
      }
      ApiService.get("GetGOPAChecklists?PID=137&AuditType=$auditType",
              pref.getString('token'))
          .then((success) {
        setState(() {
          auditList = jsonDecode(success.body);
        });
        GopaNewChecklistData(auditList);
      });
    } else {
      List newchecklistBody = await db.getGOPAChecklistData();
      setState(() {
        auditList = newchecklistBody;
      });
      print("auditList");
      print(auditList);
      GopaNewChecklistData(auditList);
    }
  }

  makeDraftAuditCheckListData() async {
    //auditList = [];
    var draftAuditId = widget.auditId;
    var auditNumber = widget.auditNumber;
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    var arry = auditNumber.toString().split("_");

    if (isOnline && !arry.contains("GOPA")) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      ApiService.get(
              "GetGOPADataBasedonAuditID?AuditID=$draftAuditId&AuditNumber=$auditNumber",
              pref.getString('token'))
          .then((success) {
        setState(() {
          var body = jsonDecode(success.body);
          auditList = body['ccaChecklistsList'];
        });
        GopaDraftChecklistData(auditList);
      });
    } else {
      try {
        List editchecklistBody =
            await db.getGOPAChecklistDataByAuditId(draftAuditId);
        setState(() {
          auditList = editchecklistBody;
        });
        GopaDraftChecklistData(auditList);
      } catch (e) {
        print(e);
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
                children: [
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
                    'Loading Data. . .',
                    style: TextStyle(fontSize: headerSize),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Don't click back button or \nclose the app",
                      style: TextStyle(fontSize: headerSize),
                    ),
                  )
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(const Duration(seconds: 15));

    // Close the dialog programmatically
    // We use "mounted" variable to get rid of the "Do not use BuildContexts across async gaps" warning
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void draftLoader(BuildContext context, [bool mounted = true]) async {
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
                    'Saving. . .',
                    style: TextStyle(fontSize: headerSize),
                  )
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(Duration(seconds: loaderTimer));

    // Close the dialog programmatically
    // We use "mounted" variable to get rid of the "Do not use BuildContexts across async gaps" warning
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _uploadLoader(BuildContext context, [bool mounted = true]) async {
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SpinKitCircle(
                      color: red,
                      size: 60.0,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Uploading File. . .',
                      style: TextStyle(fontSize: headerSize),
                    ),
                  ],
                ),
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(const Duration(seconds: 15));

    // Close the dialog programmatically
    // We use "mounted" variable to get rid of the "Do not use BuildContexts across async gaps" warning
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _fileViewLoader(BuildContext context, [bool mounted = true]) async {
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SpinKitCircle(
                      color: red,
                      size: 60.0,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Opening File. . .',
                      style: TextStyle(fontSize: headerSize),
                    ),
                  ],
                ),
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

  GopaDraftChecklistData(auditList) {
    print("checkListDisabledIdsList");
    print(Utilities.checkListDisabledIdsList);
    List checkListDisabledIdsListData = Utilities.checkListDisabledIdsList;
    setState(() {
      if (auditList.length > 0) {
        String id = '0';
        fruits = [];

        Utilities.gopaList = [];
        for (int i = 0; i < auditList.length; i++) {
          var xj = 0;
          if (id != auditList[i]['checklistID'].toString()) {
            List items = [];
            List subitems = [];
            xj = 1;
            for (int j = 0; j < auditList.length; j++) {
              if (auditList[j]['checklistID'] == auditList[i]['checklistID'] &&
                  auditList[i]['subchecklistID'].toString() == "0") {
                if (auditList[i]['subchecklistID'].toString() == "0") {
                  List<bool> ratings = [];
                  List ratingControl = [];
                  List rating = [];
                  String? disabledSingleRatingId = '3';
                  String? defaultSingleRatingId =
                      auditList[j]['checklistItemDataID'].toString();
                  for (int i = 0; i < checklistRatingIDbased.length; i++) {
                    if (checklistRatingIDbased[i]['checklistID'].isNotEmpty &&
                        checklistRatingIDbased[i]['subChecklistID']
                            .isNotEmpty) {
                      if (checklistRatingIDbased[i]['checklistID'] ==
                              auditList[j]['checklistID'] &&
                          checklistRatingIDbased[i]['subChecklistID'] ==
                              auditList[j]['subchecklistID']) {
                        ratingControl.add(checklistRatingIDbased[i]);
                      }
                    }
                  }

                  if (ratingControl.isEmpty) {
                    rating = checklistRatingcommn;
                  } else {
                    rating = ratingControl;
                  }

                  if (auditList[j]['checklistID'].toString().isNotEmpty &&
                      auditList[i]['subchecklistID'].toString().isNotEmpty) {
                    for (int r = 0; r < rating.length; r++) {
                      if (rating[r]['checklistID'].toString() != '' &&
                          rating[r]['subChecklistID'].toString() != '') {
                        if (rating[r]['checklistID'] ==
                                auditList[j]['checklistID'] &&
                            rating[r]['subChecklistID'] ==
                                auditList[i]['subchecklistID']) {
                          if (rating[r]['ratingName'].toString() ==
                              'Not Applicable') {
                            disabledSingleRatingId =
                                rating[r]['ratingID'].toString();
                          }
                        }
                      } else {
                        if (rating[r]['ratingName'].toString() ==
                            'Not Applicable') {
                          disabledSingleRatingId =
                              rating[r]['ratingID'].toString();
                        }
                      }
                    }
                  }

                  if (auditList[j]['checklistItemDataID'].toString() != '' &&
                      auditList[j]['checklistItemDataID'].toString() != '0') {
                    disabledSingleRatingId =
                        auditList[j]['checklistItemDataID'].toString();
                  }

                  for (int i = 0;
                      i < checkListDisabledIdsListData.length;
                      i++) {
                    if (checkListDisabledIdsListData[i].toString() ==
                            auditList[j]['checklistItemID'].toString() &&
                        auditList[j]['checklistItemDataID'].toString() == '0') {
                      defaultSingleRatingId = disabledSingleRatingId;
                    }
                  }

                  var j_no = xj;
                  var item = jsonEncode({
                    "s_no": j_no,
                    "itemID": auditList[j]['checklistItemID'],
                    "itemName": auditList[j]['itemName'],
                    "checklistID": auditList[j]['checklistID'],
                    "subchecklistID": auditList[i]['subchecklistID'],
                    "subchecklistname": auditList[i]['subchecklistname'],
                    "ChecklistItemDataID": defaultSingleRatingId.toString(),
                    // "ChecklistItemDataID": Utilities.checkListDisabledIdsList.contains(auditList[j]['checklistItemID']) ? disabledSingleRatingId.toString() : auditList[j]['checklistItemDataID'],
                    "checklistorder": auditList[j]['checklistorder'],
                    "attachfileManadatory":
                        auditList[j]['attachfileManadatory'].toString(),
                    "subChecklistorder": auditList[j]['subChecklistorder'],
                    "comments": auditList[j]['comments'],
                    "ratingStatus": "",
                    "ratingList": rating,
                    "attachments_names": auditList[j]['imagename'],
                    "attachments_paths": "",
                    "attachments_baseImg": "",
                  });
                  items.add(item);
                  print("========================1");
                  print(item);
                }
                xj++;
              }
            }

            String subid = '0';
            for (int k = 0; k < auditList.length; k++) {
              if (auditList[k]['checklistID'] == auditList[i]['checklistID']) {
                if (subid != auditList[k]['subchecklistID'].toString()) {
                  List itemsqns = [];
                  var xl = 1;

                  for (int l = 0; l < auditList.length; l++) {
                    if (auditList[l]['subchecklistID'] ==
                        auditList[k]['subchecklistID']) {
                      List<bool> subratings = [];
                      List ratingSubControl = [];
                      for (int i = 0; i < checklistRatingIDbased.length; i++) {
                        if (checklistRatingIDbased[i]['checklistID']
                                .isNotEmpty &&
                            checklistRatingIDbased[i]['subChecklistID']
                                .isNotEmpty) {
                          if (checklistRatingIDbased[i]['checklistID'] ==
                                  auditList[l]['checklistID'].toString() &&
                              checklistRatingIDbased[i]['subChecklistID'] ==
                                  auditList[l]['subchecklistID']) {
                            ratingSubControl.add(checklistRatingIDbased[i]);
                          }
                        }
                      }

                      List ratingList = [];
                      String? disabledRatingId = '20';
                      String? defaultRatingId =
                          auditList[l]['checklistItemDataID'].toString();
                      if (ratingSubControl.isEmpty) {
                        ratingList = checklistRatingcommn;
                      } else {
                        ratingList = ratingSubControl;
                      }
                      print(
                          "ratingList--------------------------------------->");
                      print(auditList[l]['checklistID']);
                      print(auditList[l]['subchecklistID']);
                      print(ratingList);
                      if (auditList[l]['checklistID'].toString().isNotEmpty &&
                          auditList[l]['subchecklistID']
                              .toString()
                              .isNotEmpty) {
                        for (int r = 0; r < ratingList.length; r++) {
                          if (ratingList[r]['checklistID'].toString() != '' &&
                              ratingList[r]['subChecklistID'].toString() !=
                                  '') {
                            if (ratingList[r]['checklistID'] ==
                                    auditList[l]['checklistID'] &&
                                ratingList[r]['subChecklistID'] ==
                                    auditList[l]['subchecklistID']) {
                              if (ratingList[r]['ratingName'].toString() ==
                                  'Not Applicable') {
                                disabledRatingId =
                                    ratingList[r]['ratingID'].toString();
                              }
                            }
                          } else {
                            if (ratingList[r]['ratingName'].toString() ==
                                'Not Applicable') {
                              disabledRatingId =
                                  ratingList[r]['ratingID'].toString();
                            }
                          }
                        }
                      }
                      // if (auditList[l]['checklistItemDataID'].toString() !=
                      //         '' &&
                      //     auditList[l]['checklistItemDataID'].toString() !=
                      //         '0') {
                      //   disabledRatingId =
                      //       auditList[l]['checklistItemDataID'].toString();
                      // }
                      for (int i = 0;
                          i < checkListDisabledIdsListData.length;
                          i++) {
                        if (checkListDisabledIdsListData[i].toString() ==
                                auditList[l]['checklistItemID'].toString() &&
                            auditList[l]['checklistItemDataID'].toString() ==
                                '0') {
                          defaultRatingId = disabledRatingId;
                        }
                      }
                      // if(Utilities.checkListDisabledIdsList.contains(auditList[l]['checklistItemID'])){
                      //   print("defaultRatingId");
                      //   print(disabledRatingId);
                      //   defaultRatingId = disabledRatingId;
                      // }else{
                      //   defaultRatingId = auditList[l]['checklistItemDataID'].toString();
                      // }

                      var l_no = xl++;
                      var itemsqn = jsonEncode({
                        "s_no": l_no,
                        'itemID': auditList[l]['checklistItemID'],
                        'itemName': auditList[l]['itemName'],
                        'checklistID': auditList[l]['checklistID'],
                        'subchecklistID': auditList[i]['subchecklistID'],
                        'subchecklistname': auditList[i]['subchecklistname'],
                        "ratingStatus": subratings,
                        "ChecklistItemDataID": defaultRatingId.toString(),
                        // "ChecklistItemDataID": Utilities.checkListDisabledIdsList.contains(auditList[l]['checklistItemID']) ? disabledRatingId.toString() : auditList[l]['checklistItemDataID'],
                        "attachfileManadatory":
                            auditList[l]['attachfileManadatory'].toString(),
                        "checklistorder": auditList[l]['checklistorder'],
                        "subChecklistorder": auditList[l]['subChecklistorder'],
                        "comments": auditList[l]['comments'],
                        "ratingList": ratingList,
                        "attachments_names": auditList[l]['imagename'],
                        "attachments_paths": "",
                        "attachments_baseImg": "",
                      });
                      itemsqns.add(itemsqn);
                      print("========================2");
                      print(itemsqn);
                      print(defaultRatingId);
                    }
                  }

                  var subitem = {
                    'id': auditList[k]['subchecklistID'],
                    'title': auditList[k]['subchecklistname'],
                    'questions': itemsqns
                  };
                  subitems.add(subitem);
                  subid = auditList[k]['subchecklistID'].toString();
                }
              }
            }

            var checkList = jsonEncode({
              "id": auditList[i]['checklistID'],
              "title": auditList[i]['checkListName'],
              "subId": auditList[i]['subchecklistID'],
              "subtitle": auditList[i]['subchecklistname'],
              "questions": items,
              "subquestions": subitems
            });

            Utilities.gopaList.add(checkList);
            id = auditList[i]['checklistID'].toString();
          }
        }
      }
    });
  }

  GopaNewChecklistData(auditList) {
    print("n------->newauditList");
    print(auditList);
    Utilities.gopaList = [];
    setState(() {
      if (auditList.length > 0) {
        String id = '0';
        fruits = [];
        for (int i = 0; i < auditList.length; i++) {
          var xj = 0;
          if (id != auditList[i]['checkListID']) {
            List items = [];
            List subitems = [];
            xj = 1;
            for (int j = 0; j < auditList.length; j++) {
              if (auditList[j]['checkListID'] == auditList[i]['checkListID'] &&
                  auditList[i]['subchecklistID'].toString() == "0") {
                if (auditList[i]['subchecklistID'] == "0") {
                  List<bool> ratings = [];
                  List ratingControl = [];
                  List rating = [];
                  String? disabledSingleRatingId = '3';
                  for (int ic = 0; ic < checklistRatingIDbased.length; ic++) {
                    if (checklistRatingIDbased[ic]['checklistID'].isNotEmpty &&
                        checklistRatingIDbased[ic]['subChecklistID']
                            .isNotEmpty) {
                      if (checklistRatingIDbased[ic]['checklistID'] ==
                              auditList[j]['checkListID'] &&
                          checklistRatingIDbased[ic]['subChecklistID'] ==
                              auditList[j]['subchecklistID']) {
                        ratingControl.add(checklistRatingIDbased[ic]);
                      }
                    }
                  }

                  if (ratingControl.isEmpty) {
                    rating = checklistRatingcommn;
                  } else {
                    rating = ratingControl;
                  }

                  if (auditList[j]['checkListID'].toString().isNotEmpty &&
                      auditList[i]['subchecklistID'].toString().isNotEmpty) {
                    for (int r = 0; r < rating.length; r++) {
                      if (rating[r]['checklistID'].toString() != '' &&
                          rating[r]['subChecklistID'].toString() != '') {
                        if (rating[r]['checklistID'] ==
                                auditList[j]['checkListID'] &&
                            rating[r]['subChecklistID'] ==
                                auditList[i]['subchecklistID']) {
                          if (rating[r]['ratingName'].toString() ==
                              'Not Applicable') {
                            disabledSingleRatingId =
                                rating[r]['ratingID'].toString();
                          }
                        }
                      } else {
                        if (rating[r]['ratingName'].toString() ==
                            'Not Applicable') {
                          disabledSingleRatingId =
                              rating[r]['ratingID'].toString();
                        }
                      }
                    }
                  }

                  var j_no = xj;
                  var item = jsonEncode({
                    "s_no": j_no,
                    "itemID": auditList[j]['itemID'],
                    "itemName": auditList[j]['itemName'],
                    "checklistorder": auditList[j]['checklistorder'],
                    "subChecklistorder": auditList[j]['subChecklistorder'],
                    "checklistID": auditList[j]['checkListID'],
                    "subchecklistID": auditList[j]['subchecklistID'],
                    "subchecklistname": auditList[j]['subchecklistname'],
                    "attachfileManadatory":
                        auditList[j]['attachfileManadatory'].toString(),
                    "ChecklistItemDataID": Utilities.checkListDisabledIdsList
                            .contains(auditList[j]['itemID'].toString())
                        ? disabledSingleRatingId.toString()
                        : "0",
                    "comments": "",
                    "ratingStatus": ratings,
                    "ratingList": rating,
                    "attachments_names": "",
                    "attachments_paths": "",
                    "attachments_baseImg": "",
                  });
                  items.add(item);

                  if (auditList[j]['itemID'].toString() == '2127') {
                    print("--------step1");
                    print(disabledSingleRatingId.toString());
                  }
                }
                xj++;
              }
            }

            String subid = '0';
            for (int k = 0; k < auditList.length; k++) {
              if (auditList[k]['checkListID'] == auditList[i]['checkListID']) {
                if (subid != auditList[k]['subchecklistID']) {
                  List itemsqns = [];
                  var xl = 1;
                  for (int l = 0; l < auditList.length; l++) {
                    if (auditList[l]['subchecklistID'] ==
                        auditList[k]['subchecklistID']) {
                      List<bool> subratings = [];
                      List ratingSubControl = [];
                      String? disabledRatingId = '20';
                      for (int ics = 0;
                          ics < checklistRatingIDbased.length;
                          ics++) {
                        if (checklistRatingIDbased[ics]['checklistID']
                                .isNotEmpty &&
                            checklistRatingIDbased[ics]['subChecklistID']
                                .isNotEmpty) {
                          if (checklistRatingIDbased[ics]['checklistID'] ==
                                  auditList[l]['checkListID'].toString() &&
                              checklistRatingIDbased[ics]['subChecklistID'] ==
                                  auditList[l]['subchecklistID']) {
                            ratingSubControl.add(checklistRatingIDbased[ics]);
                          }
                        }
                      }

                      List ratingList = [];
                      if (ratingSubControl.isEmpty) {
                        ratingList = checklistRatingcommn;
                      } else {
                        ratingList = ratingSubControl;
                      }

                      if (auditList[l]['checkListID'].toString().isNotEmpty &&
                          auditList[l]['subchecklistID']
                              .toString()
                              .isNotEmpty) {
                        for (int r = 0; r < ratingList.length; r++) {
                          if (ratingList[r]['checklistID'].toString() != '' &&
                              ratingList[r]['subChecklistID'].toString() !=
                                  '') {
                            if (ratingList[r]['checklistID'] ==
                                    auditList[l]['checkListID'] &&
                                ratingList[r]['subChecklistID'] ==
                                    auditList[l]['subchecklistID']) {
                              if (ratingList[r]['ratingName'].toString() ==
                                  'Not Applicable') {
                                disabledRatingId =
                                    ratingList[r]['ratingID'].toString();
                              }
                            }
                          } else {
                            if (ratingList[r]['ratingName'].toString() ==
                                'Not Applicable') {
                              disabledRatingId =
                                  ratingList[r]['ratingID'].toString();
                            }
                          }
                        }
                      }

                      print("ratingList");
                      print(auditList[l]['checkListID']);
                      print(auditList[l]['subchecklistID']);
                      print(ratingList);

                      var l_no = xl++;
                      var itemsqn = jsonEncode({
                        "s_no": l_no,
                        "itemID": auditList[l]['itemID'],
                        "itemName": auditList[l]['itemName'],
                        "checklistID": auditList[l]['checkListID'],
                        "subchecklistID": auditList[l]['subchecklistID'],
                        "subchecklistname": auditList[l]['checkListName'],
                        "checklistorder": auditList[l]['checklistorder'],
                        "subChecklistorder": auditList[l]['subChecklistorder'],
                        "attachfileManadatory":
                            auditList[l]['attachfileManadatory'].toString(),
                        "ratingStatus": subratings,
                        "ChecklistItemDataID": Utilities
                                .checkListDisabledIdsList
                                .contains(auditList[l]['itemID'].toString())
                            ? disabledRatingId.toString()
                            : "0",
                        "comments": "",
                        "ratingList": ratingList,
                        "attachments_names": "",
                        "attachments_paths": "",
                        "attachments_baseImg": "",
                      });
                      itemsqns.add(itemsqn);

                      if (auditList[l]['itemID'].toString() == "2127") {
                        print("--------step2");
                        print(disabledRatingId.toString());
                      }
                    }
                  }

                  var subitem = {
                    'id': auditList[k]['subchecklistID'],
                    'title': auditList[k]['subchecklistname'],
                    'questions': itemsqns
                  };
                  subitems.add(subitem);
                  subid = auditList[k]['subchecklistID'];
                }
              }
            }

            var checkList = jsonEncode({
              "id": auditList[i]['checkListID'],
              "title": auditList[i]['checkListName'],
              "subId": auditList[i]['subchecklistID'],
              "subtitle": auditList[i]['subchecklistname'],
              "questions": items,
              "subquestions": subitems
            });

            Utilities.gopaList.add(checkList);
            id = auditList[i]['checkListID'].toString();
          }
        }
      }
    });
  }

  updateChecklistData(int quePosition) {
    if (Utilities.gopaQueposition == 0) {
      setState(() {
        backButtonName = 'Back';
      });
    } else {
      setState(() {
        backButtonName = 'Previous';
      });
    }

    if (Utilities.gopaQueposition == Utilities.gopaCheckList.length - 1) {
      setState(() {
        nextButton = false;
      });
    } else {
      setState(() {
        nextButton = true;
      });
    }
    setState(() {
      ratingList = [];
      fruits = [];
      singleCheck = [];
      var resp = jsonDecode(Utilities.gopaCheckList[quePosition]);
      subHeading = resp['subHeading'];
      checkListName = resp["chkName"];
      chkId = resp["chkId"];

      ratingList = resp['ratingList'];
      id = resp['id'].toString();
      followUp = resp['followUp'];
      followupController.text = resp['followUp'];
      ratingStatus = resp['ratingStatus'];
      for (int i = 0; i < ratingList.length; i++) {
        if (ratingStatus == "1" && ratingList[i]["name"] == "Yes") {
          singleCheck.add(true);
          selectedColor = Color(0xFF216f82);
        } else if (ratingStatus == "2" && ratingList[i]["name"] == "No") {
          singleCheck.add(true);
          selectedColor = Color(0xFFf5003a);
        } else if (ratingStatus == "3" &&
            ratingList[i]["name"] == "Not Applicable") {
          singleCheck.add(true);
          selectedColor = Color(0xFF3a454b);
        } else {
          singleCheck.add(false);
        }
        // fruits.add(
        //   Text(ratingList[i]['name']),
        // );
      }
    });
  }

  SaveApiCallByStatus(status) {
    var auditID;
    var auditNumber;
    if (widget.auditId != '') {
      auditID = widget.auditId;
      auditNumber = widget.auditNumber;
    } else {
      auditID = 0;
      auditNumber = 0;
    }

    if (status == 1) {
      makeSaveApiCall(status, 'pending');
    } else {
      makeSaveApiCall(1, 'pending');

      CoolAlert.show(
          width: 300,
          text: 'You want to submit',
          title: 'Are you sure ',
          flareAnimationName: "play",
          backgroundColor: Color(0xFFe7e7e7),
          barrierDismissible: false,
          context: context,
          type: CoolAlertType.confirm,
          confirmBtnText: 'Confirm',
          cancelBtnText: 'Cancel',
          cancelBtnTextStyle: TextStyle(color: red),
          onCancelBtnTap: () {
            Navigator.pop(context);
          },
          confirmBtnColor: Color(0xFF216f82),
          onConfirmBtnTap: () {
            Navigator.pop(context);
            // _fetchData(context);
            makeSaveApiCall(status, 'complete');
          });
    }
  }

  makeSaveApiCall(status, btnStatus) async {
    var airlinesIds;
    String? Username;
    var dataLength;

    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Saving",
    );
    var emplogin = pref.getString("employeeCode").toString();
    var draftAudits = await db.getGOPAOfflineDraftAudits(emplogin);
    Username = pref.getString("firstName").toString() +
        " " +
        pref.getString("lastName").toString();
    SharedPreferences prefRole = await SharedPreferences.getInstance();
    var logRole = prefRole.getString('user_role');
    var auditType;
    if (logRole == 'APM') {
      setState(() {
        auditType = '1';
      });
    } else if (logRole == 'RM') {
      setState(() {
        auditType = '2';
      });
    }
    print("Utilities.gopaDetails");
    print(Utilities.gopaDetails);
    var gopaDetailsBody = jsonDecode(Utilities.gopaDetails);
    var attachmentauditNumber = gopaDetailsBody['auditNumber'];
    var attachmentsBody =
        await db.getOfflineGOPAItemImageJsonData(attachmentauditNumber);

    print("gopaDetailsBody-----");
    print(attachmentsBody);

    var airId = gopaDetailsBody['airlineIds'].toString();
    var sationId = gopaDetailsBody['stationId'];
    var groundHandlerId = gopaDetailsBody['groundHandlerId'];
    var final_airlineIds = [];
    for (int i = 0; i < airId.length; i++) {
      if (airId[i].isNotEmpty && airId[i].toString() != 'null') {
        final_airlineIds.add(airId[i].trim());
      }
    }
    print("airId");
    print(airId);
    print("airId");

    List GopaDetailsBodyData = [];
    List GopaDraftDetailsBodyData = [];

    var auditID;
    var auditNumber;

    bool isOnline = await Utilities.CheckUserConnection() as bool;
    List CCAChecklistsList = [];
    var FileAttachmentSaveBody;

    var stationCode = gopaDetailsBody["stationCode"].toString();
    var GOPANumber = stationCode.toString() + "/" + widget.auditNumber;
    print(widget.auditNumber);
    print('audit number');
    if (isOnline) {
      if (widget.auditId != '') {
        auditID = widget.auditId;
        auditNumber = widget.auditNumber;
      } else {
        auditID = 0;
        auditNumber = 0;
      }

      if (status == 1) {
        var arry = gopaDetailsBody['auditId'].toString().split("_");
        if (arry.contains("GOPA") && btnStatus == 'pending') {
          ApiService.get(
                  "IsGOPAClosedbasedGH?StationID=${sationId.toString()}&EMPNO=${pref.getString('employeeCode')}&GHID=$groundHandlerId&AuditType=$auditType",
                  pref.getString('token'))
              .then((success) {
            if (success.statusCode == 200) {
              // EasyLoading.addStatusCallback((status) {
              //   print('EasyLoading Status $status');
              //   if (status == EasyLoadingStatus.dismiss) {
              //     _timer?.cancel();
              //   }
              // });
              setState(() {
                var checkbody = jsonDecode(success.body);
                print("--checkbody");
                print(checkbody);
                print("body");
                if (checkbody[0]['capaFullNumbers'] != "" ||
                    checkbody[0]['capaFullNumbers'].toString().isNotEmpty) {
                  CoolAlert.show(
                      context: context,
                      title: "A GOPA is found for this Ground handler",
                      barrierDismissible: false,
                      flareAnimationName: "play",
                      type: CoolAlertType.confirm,
                      cancelBtnText: "Cancel",
                      confirmBtnText: "",
                      onCancelBtnTap: () {
                        Navigator.pop(context);
                        deleteOfflineGOPAById(auditID, auditNumber);
                      },
                      showCancelBtn: false,
                      confirmBtnColor: Colors.deepOrangeAccent);
                } else {
                  print("New");
                  CCAChecklistsList = [];

                  for (int i = 0; i < Utilities.gopaList.length; i++) {
                    var checkObject =
                        jsonDecode(Utilities.gopaList[i].toString());
                    var singleHeadQues =
                        jsonDecode(checkObject['questions'].toString());
                    if (singleHeadQues.length > 0) {
                      for (int j = 0; j < singleHeadQues.length; j++) {
                        var checklistObj = jsonEncode({
                          "ObjectID": "0",
                          "ChecklistID": singleHeadQues[j]['checklistID'],
                          "ChecklistItemID": singleHeadQues[j]['itemID'],
                          "ChecklistItemDataID": singleHeadQues[j]
                                  ['ChecklistItemDataID']
                              .toString(),
                          "EmpID": pref.getString('employeeID'),
                          "Comments": singleHeadQues[j]['comments'].toString(),
                          "CheckListName": checkObject['title'],
                          "ItemName": singleHeadQues[j]['itemName'],
                          "SubchecklistID": checkObject['subId'],
                          "Subchecklistname": checkObject['subtitle'],
                          "Checklistorder": checkObject['checklistorder'],
                          "SubChecklistorder": checkObject['subChecklistorder'],
                          // "Imagename": singleHeadQues[j]['attachments_names'].toString(),
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
                            "ObjectID": "0",
                            "ChecklistID": multipleHeadQues[l]['checklistID'],
                            "ChecklistItemID": multipleHeadQues[l]['itemID'],
                            "ChecklistItemDataID": multipleHeadQues[l]
                                    ['ChecklistItemDataID']
                                .toString(),
                            "EmpID": pref.getString('employeeID'),
                            "Comments":
                                multipleHeadQues[l]['comments'].toString(),
                            "CheckListName": checkObject['title'],
                            "ItemName": multipleHeadQues[l]['itemName'],
                            "SubchecklistID": multipleHead[k]['id'],
                            "Subchecklistname": multipleHead[k]['title'],
                            "Checklistorder": multipleHeadQues[l]
                                ['checklistorder'],
                            "SubChecklistorder": multipleHeadQues[l]
                                ['subChecklistorder'],
                            // "Imagename": multipleHeadQues[l]['attachments_names'].toString(),
                          });

                          var ccachecklistbody = jsonDecode(checklistObj);
                          CCAChecklistsList.add(ccachecklistbody);
                        }
                      }
                    }
                  }

                  var GopaSaveBodyNew = jsonEncode({
                    "AuditID": "0",
                    "StationID": gopaDetailsBody['stationId'],
                    "AuditDoneby": pref.getString('employeeCode'),
                    "AirlineIDs": airId.toString(),
                    "StationCode": stationCode,
                    "Restartoperations": gopaDetailsBody['restartOperations'],
                    "GGHID": gopaDetailsBody['groundHandlerId'],
                    "UserID": pref.getString('userID'),
                    "CCAChecklistsList": CCAChecklistsList,
                  });

                  ApiService.post("NewGOPAPart1", GopaSaveBodyNew,
                          pref.getString('token'))
                      .then((success) {
                    var body = jsonDecode(success.body);

                    if (body['auditID'] > 0) {
                      print(body['auditID']);
                      print(body['auditNumber']);
                      var id = body['auditID'];
                      var gopaId = body['auditID'];
                      var gopaNum = body['auditNumber'];

                      var gopaDetails2 = jsonEncode({
                        "auditId": gopaId,
                        "auditNumber": gopaNum,
                        "airlineIds": airId.toString(),
                        "airlineCode": gopaDetailsBody['airlineCode'],
                        "stationId": gopaDetailsBody['stationId'],
                        "stationAirport": gopaDetailsBody['stationAirport'],
                        "stationCode": gopaDetailsBody['stationCode'],
                        "groundHandlerId": gopaDetailsBody['groundHandlerId'],
                        "groundHandler": gopaDetailsBody['groundHandler'],
                        "auditDate": gopaDetailsBody['auditDate'],
                        "conductedId": gopaDetailsBody['conductedId'],
                        "conductAudit": gopaDetailsBody['conductAudit'],
                        "restartOperations":
                            gopaDetailsBody['restartOperations'],
                        "allAirlinesSameServiceProvider":
                            gopaDetailsBody['allAirlinesSameServiceProvider'],
                        "isagocertified": gopaDetailsBody['isagocertified'],
                        "messages": gopaDetailsBody['messages'],
                        "submitteddate": gopaDetailsBody['submitteddate'],
                        "isauditduedate": gopaDetailsBody['isauditduedate'],
                        "Passengerbridge": gopaDetailsBody['Passengerbridge'],
                        "PassengerbridgeServiceProvider":
                            gopaDetailsBody['PassengerbridgeServiceProvider'],
                        "Ramphandling": gopaDetailsBody['Ramphandling'],
                        "RamphandlingServiceProvider":
                            gopaDetailsBody['RamphandlingServiceProvider'],
                        "Cargohandling": gopaDetailsBody['Cargohandling'],
                        "CargohandlingServiceProvider":
                            gopaDetailsBody['CargohandlingServiceProvider'],
                        "PBhandling":
                            gopaDetailsBody['CargohandlingServiceProvider'],
                        "PBhandlingServiceProvider":
                            gopaDetailsBody['PBhandlingServiceProvider'],
                        "AircraftMarshalling":
                            gopaDetailsBody['AircraftMarshalling'],
                        "AircraftMarshallingServiceProvider": gopaDetailsBody[
                            'AircraftMarshallingServiceProvider'],
                        "Loadcontrol": gopaDetailsBody['Loadcontrol'],
                        "LoadcontrolServiceProvider":
                            gopaDetailsBody['LoadcontrolServiceProvider'],
                        "Deicingoperations":
                            gopaDetailsBody['Deicingoperations'],
                        "DeicingoperationsServiceProvider":
                            gopaDetailsBody['DeicingoperationsServiceProvider'],
                        "Headsetcommunication":
                            gopaDetailsBody['Headsetcommunication'],
                        "HeadsetcommunicationServiceProvider": gopaDetailsBody[
                            'HeadsetcommunicationServiceProvider'],
                        "Aircraftmovement": gopaDetailsBody['Aircraftmovement'],
                        "AircraftmovementServiceProvider":
                            gopaDetailsBody['AircraftmovementServiceProvider'],
                        "restartOperationName":
                            gopaDetailsBody['restartOperationName'],
                        "allAirlinesSameServiceProviderName": gopaDetailsBody[
                            'allAirlinesSameServiceProviderName'],
                        "isagocertifiedName":
                            gopaDetailsBody['isagocertifiedName'],
                        "isauditduedateName":
                            gopaDetailsBody['isauditduedateName'],
                        "PBName": gopaDetailsBody['PBName'],
                        "RampName": gopaDetailsBody['RampName'],
                        "CargoName": gopaDetailsBody['CargoName'],
                        "LoadName": gopaDetailsBody['LoadName'],
                        "DeicingName": gopaDetailsBody['DeicingName'],
                        "HeadsetcomName": gopaDetailsBody['HeadsetcomName'],
                        "AircraftmovName": gopaDetailsBody['AircraftmovName'],
                        "PassbridgeName": gopaDetailsBody['PassbridgeName'],
                        "AircraftMarsName": gopaDetailsBody['AircraftMarsName'],
                        "HoNumber": gopaDetailsBody['HoNumber'],
                        "APMMAILID": gopaDetailsBody['APMMAILID'],
                        "RMMAILID": gopaDetailsBody['RMMAILID'],
                        "HOMAILID": gopaDetailsBody['HOMAILID'],
                      });
                      setState(() {
                        Utilities.gopaDetails = gopaDetails2;
                      });
                      CCAChecklistsList = [];
                      for (int i = 0; i < Utilities.gopaList.length; i++) {
                        var checkObject =
                            jsonDecode(Utilities.gopaList[i].toString());
                        var singleHeadQues =
                            jsonDecode(checkObject['questions'].toString());
                        if (singleHeadQues.length > 0) {
                          for (int j = 0; j < singleHeadQues.length; j++) {
                            var checklistObj = jsonEncode({
                              "ObjectID": gopaId,
                              "ChecklistID": singleHeadQues[j]['checklistID'],
                              "ChecklistItemID": singleHeadQues[j]['itemID'],
                              "ChecklistItemDataID": singleHeadQues[j]
                                      ['ChecklistItemDataID']
                                  .toString(),
                              "EmpID": pref.getString('employeeID'),
                              "Comments":
                                  singleHeadQues[j]['comments'].toString(),
                              "CheckListName": checkObject['title'],
                              "ItemName": singleHeadQues[j]['itemName'],
                              "SubchecklistID": checkObject['subId'],
                              "Subchecklistname": checkObject['subtitle'],
                              "Checklistorder": checkObject['checklistorder'],
                              "SubChecklistorder":
                                  checkObject['subChecklistorder'],
                              // "Imagename": singleHeadQues[j]['attachments_names'].toString(),
                            });

                            var gopachkbody1 = jsonDecode(checklistObj);
                            CCAChecklistsList.add(gopachkbody1);
                          }
                        } else {
                          var multipleHead = checkObject['subquestions'];

                          for (int k = 0; k < multipleHead.length; k++) {
                            var multipleHeadQues = jsonDecode(
                                multipleHead[k]['questions'].toString());

                            for (int l = 0; l < multipleHeadQues.length; l++) {
                              var checklistObj = jsonEncode({
                                "ObjectID": gopaId,
                                "ChecklistID": multipleHeadQues[l]
                                    ['checklistID'],
                                "ChecklistItemID": multipleHeadQues[l]
                                    ['itemID'],
                                "ChecklistItemDataID": multipleHeadQues[l]
                                        ['ChecklistItemDataID']
                                    .toString(),
                                "EmpID": pref.getString('employeeID'),
                                "Comments":
                                    multipleHeadQues[l]['comments'].toString(),
                                "CheckListName": checkObject['title'],
                                "ItemName": multipleHeadQues[l]['itemName'],
                                "SubchecklistID": multipleHead[k]['id'],
                                "Subchecklistname": multipleHead[k]['title'],
                                "Checklistorder": multipleHeadQues[l]
                                    ['checklistorder'],
                                "SubChecklistorder": multipleHeadQues[l]
                                    ['subChecklistorder'],
                                // "Imagename": multipleHeadQues[l]['attachments_names'].toString(),
                              });

                              var ccachecklistbody = jsonDecode(checklistObj);
                              CCAChecklistsList.add(ccachecklistbody);
                            }
                          }
                        }
                      }

                      var GopaSaveBody2 = jsonEncode({
                        "StationID": gopaDetailsBody['stationId'],
                        "HoNumber": gopaDetailsBody['HoNumber'],
                        "StationCode": stationCode.toString(),
                        "AuditID": gopaId,
                        "GGHID": gopaDetailsBody['groundHandlerId'],
                        "AuditDate": gopaDetailsBody['auditDate'],
                        "AuditDoneby": pref.getString('employeeCode'),
                        "AuditerName": Username,
                        "AirlineIDs": airId.toString(),
                        "Statusid": 1,
                        "SubmittedBy": pref.getString('employeeCode'),
                        "UserID": pref.getString('userID'),
                        "Msg": '',
                        "ImageBase64": '',
                        "ImageName": '',
                        "AttachedByName": '',
                        "SubmittedDate": gopaDetailsBody['submitteddate'],
                        "GOPANumber": auditNumber,
                        "AuditNumber": gopaNum,
                        "Restartoperations":
                            gopaDetailsBody['restartOperations'],
                        "Sameserviceprovider":
                            gopaDetailsBody['allAirlinesSameServiceProvider'],
                        "PBhandling": gopaDetailsBody['PBhandling'],
                        "Ramphandling": gopaDetailsBody['Ramphandling'],
                        "Cargohandling": gopaDetailsBody['Cargohandling'],
                        "Deicingoperations":
                            gopaDetailsBody['Deicingoperations'],
                        "AircraftMarshalling":
                            gopaDetailsBody['AircraftMarshalling'],
                        "Loadcontrol": gopaDetailsBody['Loadcontrol'],
                        "Aircraftmovement": gopaDetailsBody['Aircraftmovement'],
                        "Headsetcommunication":
                            gopaDetailsBody['Headsetcommunication'],
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
                        "AircraftMarshallingServiceProvider": gopaDetailsBody[
                            'AircraftMarshallingServiceProvider'],
                        "LoadcontrolServiceProvider":
                            gopaDetailsBody['LoadcontrolServiceProvider'],
                        "AircraftmovementServiceProvider":
                            gopaDetailsBody['AircraftmovementServiceProvider'],
                        "HeadsetcommunicationServiceProvider": gopaDetailsBody[
                            'HeadsetcommunicationServiceProvider'],
                        "PassengerbridgeServiceProvider":
                            gopaDetailsBody['PassengerbridgeServiceProvider'],
                        "APMMAILID": gopaDetailsBody['APMMAILID'],
                        "RMMAILID": gopaDetailsBody['RMMAILID'],
                        "HOMAILID": gopaDetailsBody['HOMAILID'],
                        "CCAChecklistsList": CCAChecklistsList,
                      });

                      ApiService.post("NewGOPASave", GopaSaveBody2,
                              pref.getString('token'))
                          .then((success) {
                        var finalsavebody = jsonDecode(success.body);
                        print(finalsavebody);
                        print("attachmentsBody_length");
                        print(attachmentsBody.length);
                        // Sync Attachment Data start
                        if (attachmentsBody.length > 0) {
                          var attachmentsBodyLength =
                              attachmentsBody.length - 1;
                          for (int i = 0; i < attachmentsBody.length; i++) {
                            var deletePath =
                                attachmentsBody[i]['FilePath'].toString();
                            var bytes = File(attachmentsBody[i]['FilePath'])
                                .readAsBytesSync();
                            String? finalImage = base64Encode(bytes);

                            FileAttachmentSaveBody = jsonEncode({
                              "PluginID": attachmentsBody[i]['PluginID'],
                              "AuditID": gopaId,
                              "AuditNumber": gopaNum,
                              "featurID": attachmentsBody[i]['featurID'],
                              "ChecklistID": attachmentsBody[i]['ChecklistID'],
                              "ChecklistItemID": attachmentsBody[i]
                                  ['ChecklistItemID'],
                              "SubchecklistID": attachmentsBody[i]
                                      ['SubchecklistID']
                                  .toString(),
                              "FileName":
                                  attachmentsBody[i]['FileName'].toString(),
                              "AttachedBy":
                                  attachmentsBody[i]['AttachedBy'].toString(),
                              "ImageBase64": finalImage.toString(),
                            });

                            print("FileAttachmentSaveBody online");
                            print(FileAttachmentSaveBody);
                            saveOffAttachmentForOnline(FileAttachmentSaveBody,
                                deletePath, i, attachmentsBodyLength);
                          }
                        }

                        print("NewGOPASave2222222222");

                        db.deleteGOPA(widget.auditId);

                        GOPAOfflineDB();
                        //end
                      });
                    }
                  });
                }
              });
              EasyLoading.showSuccess('Saving Success');
            } else {
              EasyLoading.showInfo("Saving Failed");
            }
          });
        } else if (arry.contains("GOPA") && btnStatus == 'complete') {
          ApiService.get(
                  "IsGOPAClosedbasedGH?StationID=${sationId.toString()}&EMPNO=${pref.getString('employeeCode')}&GHID=$groundHandlerId&AuditType=$auditType",
                  pref.getString('token'))
              .then((success) {
            if (success.statusCode == 200) {
              setState(() {
                var checkbody = jsonDecode(success.body);
                print("--checkbody");
                print(checkbody);
                print("body");
                if (checkbody[0]['capaFullNumbers'] != "" ||
                    checkbody[0]['capaFullNumbers'].toString().isNotEmpty) {
                  EasyLoading.addStatusCallback((status) {
                    print('EasyLoading Status $status');
                    if (status == EasyLoadingStatus.dismiss) {
                      _timer?.cancel();
                    }
                  });
                  CoolAlert.show(
                      context: context,
                      title: "A GOPA is found for this Ground handler",
                      barrierDismissible: false,
                      flareAnimationName: "play",
                      type: CoolAlertType.confirm,
                      cancelBtnText: "",
                      confirmBtnText: "Cancel",
                      onCancelBtnTap: () {
                        Navigator.pop(context);
                        deleteOfflineGOPAById(widget.auditId, auditNumber);
                      },
                      showCancelBtn: false,
                      confirmBtnColor: Colors.deepOrangeAccent);

                  EasyLoading.showInfo("Saving Failed");
                } else {
                  print("New");
                  CCAChecklistsList = [];

                  for (int i = 0; i < Utilities.gopaList.length; i++) {
                    var checkObject =
                        jsonDecode(Utilities.gopaList[i].toString());
                    var singleHeadQues =
                        jsonDecode(checkObject['questions'].toString());
                    if (singleHeadQues.length > 0) {
                      for (int j = 0; j < singleHeadQues.length; j++) {
                        var checklistObj = jsonEncode({
                          "ObjectID": "0",
                          "ChecklistID": singleHeadQues[j]['checklistID'],
                          "ChecklistItemID": singleHeadQues[j]['itemID'],
                          "ChecklistItemDataID": singleHeadQues[j]
                                  ['ChecklistItemDataID']
                              .toString(),
                          "EmpID": pref.getString('employeeID'),
                          "Comments": singleHeadQues[j]['comments'].toString(),
                          "CheckListName": checkObject['title'],
                          "ItemName": singleHeadQues[j]['itemName'],
                          "SubchecklistID": checkObject['subId'],
                          "Subchecklistname": checkObject['subtitle'],
                          "Checklistorder": checkObject['checklistorder'],
                          "SubChecklistorder": checkObject['subChecklistorder'],
                          // "Imagename": singleHeadQues[j]['attachments_names'].toString(),
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
                            "ObjectID": "0",
                            "ChecklistID": multipleHeadQues[l]['checklistID'],
                            "ChecklistItemID": multipleHeadQues[l]['itemID'],
                            "ChecklistItemDataID": multipleHeadQues[l]
                                    ['ChecklistItemDataID']
                                .toString(),
                            "EmpID": pref.getString('employeeID'),
                            "Comments":
                                multipleHeadQues[l]['comments'].toString(),
                            "CheckListName": checkObject['title'],
                            "ItemName": multipleHeadQues[l]['itemName'],
                            "SubchecklistID": multipleHead[k]['id'],
                            "Subchecklistname": multipleHead[k]['title'],
                            "Checklistorder": multipleHeadQues[l]
                                ['checklistorder'],
                            "SubChecklistorder": multipleHeadQues[l]
                                ['subChecklistorder'],
                            // "Imagename": multipleHeadQues[l]['attachments_names'].toString(),
                          });

                          var ccachecklistbody = jsonDecode(checklistObj);
                          CCAChecklistsList.add(ccachecklistbody);
                        }
                      }
                    }
                  }

                  var GopaSaveBodyNew = jsonEncode({
                    "AuditID": "0",
                    "StationID": gopaDetailsBody['stationId'],
                    "AuditDoneby": pref.getString('employeeCode'),
                    "AirlineIDs": airId.toString(),
                    "StationCode": stationCode,
                    "Restartoperations": gopaDetailsBody['restartOperations'],
                    "GGHID": gopaDetailsBody['groundHandlerId'],
                    "UserID": pref.getString('userID'),
                    "CCAChecklistsList": CCAChecklistsList,
                  });

                  ApiService.post("NewGOPAPart1", GopaSaveBodyNew,
                          pref.getString('token'))
                      .then((success) {
                    var body = jsonDecode(success.body);

                    if (body['auditID'] > 0) {
                      print(body['auditID']);
                      print(body['auditNumber']);
                      var id = body['auditID'];
                      var gopaId = body['auditID'];
                      var gopaNum = body['auditNumber'];

                      for (int i = 0; i < Utilities.gopaList.length; i++) {
                        var checkObject =
                            jsonDecode(Utilities.gopaList[i].toString());
                        var singleHeadQues =
                            jsonDecode(checkObject['questions'].toString());
                        if (singleHeadQues.length > 0) {
                          for (int j = 0; j < singleHeadQues.length; j++) {
                            var checklistObj = jsonEncode({
                              "ObjectID": gopaId,
                              "ChecklistID": singleHeadQues[j]['checklistID'],
                              "ChecklistItemID": singleHeadQues[j]['itemID'],
                              "ChecklistItemDataID": singleHeadQues[j]
                                      ['ChecklistItemDataID']
                                  .toString(),
                              "EmpID": pref.getString('employeeID'),
                              "Comments":
                                  singleHeadQues[j]['comments'].toString(),
                              "CheckListName": checkObject['title'],
                              "ItemName": singleHeadQues[j]['itemName'],
                              "SubchecklistID": checkObject['subId'],
                              "Subchecklistname": checkObject['subtitle'],
                              "Checklistorder": checkObject['checklistorder'],
                              "SubChecklistorder":
                                  checkObject['subChecklistorder'],
                              // "Imagename": singleHeadQues[j]['attachments_names'].toString(),
                            });

                            var gopachkbody1 = jsonDecode(checklistObj);
                            CCAChecklistsList.add(gopachkbody1);
                          }
                        } else {
                          var multipleHead = checkObject['subquestions'];

                          for (int k = 0; k < multipleHead.length; k++) {
                            var multipleHeadQues = jsonDecode(
                                multipleHead[k]['questions'].toString());

                            for (int l = 0; l < multipleHeadQues.length; l++) {
                              var checklistObj = jsonEncode({
                                "ObjectID": gopaId,
                                "ChecklistID": multipleHeadQues[l]
                                    ['checklistID'],
                                "ChecklistItemID": multipleHeadQues[l]
                                    ['itemID'],
                                "ChecklistItemDataID": multipleHeadQues[l]
                                        ['ChecklistItemDataID']
                                    .toString(),
                                "EmpID": pref.getString('employeeID'),
                                "Comments":
                                    multipleHeadQues[l]['comments'].toString(),
                                "CheckListName": checkObject['title'],
                                "ItemName": multipleHeadQues[l]['itemName'],
                                "SubchecklistID": multipleHead[k]['id'],
                                "Subchecklistname": multipleHead[k]['title'],
                                "Checklistorder": multipleHeadQues[l]
                                    ['checklistorder'],
                                "SubChecklistorder": multipleHeadQues[l]
                                    ['subChecklistorder'],
                                // "Imagename": multipleHeadQues[l]['attachments_names'].toString(),
                              });

                              var ccachecklistbody = jsonDecode(checklistObj);
                              CCAChecklistsList.add(ccachecklistbody);
                            }
                          }
                        }
                      }

                      var GopaSaveBody2 = jsonEncode({
                        "StationID": gopaDetailsBody['stationId'],
                        "HoNumber": gopaDetailsBody['HoNumber'],
                        "StationCode": stationCode.toString(),
                        "AuditID": gopaId,
                        "GGHID": gopaDetailsBody['groundHandlerId'],
                        "AuditDate": gopaDetailsBody['auditDate'],
                        "AuditDoneby": pref.getString('employeeCode'),
                        "AuditerName": Username,
                        "AirlineIDs": airId.toString(),
                        "Statusid": 1,
                        "SubmittedBy": pref.getString('employeeCode'),
                        "UserID": pref.getString('userID'),
                        "Msg": '',
                        "ImageBase64": '',
                        "ImageName": '',
                        "AttachedByName": '',
                        "SubmittedDate": gopaDetailsBody['submitteddate'],
                        "GOPANumber": auditNumber,
                        "AuditNumber": gopaNum,
                        "Restartoperations":
                            gopaDetailsBody['restartOperations'],
                        "Sameserviceprovider":
                            gopaDetailsBody['allAirlinesSameServiceProvider'],
                        "PBhandling": gopaDetailsBody['PBhandling'],
                        "Ramphandling": gopaDetailsBody['Ramphandling'],
                        "Cargohandling": gopaDetailsBody['Cargohandling'],
                        "Deicingoperations":
                            gopaDetailsBody['Deicingoperations'],
                        "AircraftMarshalling":
                            gopaDetailsBody['AircraftMarshalling'],
                        "Loadcontrol": gopaDetailsBody['Loadcontrol'],
                        "Aircraftmovement": gopaDetailsBody['Aircraftmovement'],
                        "Headsetcommunication":
                            gopaDetailsBody['Headsetcommunication'],
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
                        "AircraftMarshallingServiceProvider": gopaDetailsBody[
                            'AircraftMarshallingServiceProvider'],
                        "LoadcontrolServiceProvider":
                            gopaDetailsBody['LoadcontrolServiceProvider'],
                        "AircraftmovementServiceProvider":
                            gopaDetailsBody['AircraftmovementServiceProvider'],
                        "HeadsetcommunicationServiceProvider": gopaDetailsBody[
                            'HeadsetcommunicationServiceProvider'],
                        "PassengerbridgeServiceProvider":
                            gopaDetailsBody['PassengerbridgeServiceProvider'],
                        "APMMAILID": gopaDetailsBody['APMMAILID'],
                        "RMMAILID": gopaDetailsBody['RMMAILID'],
                        "HOMAILID": gopaDetailsBody['HOMAILID'],
                        "CCAChecklistsList": CCAChecklistsList,
                      });
                      var gopaDetails2 = jsonEncode({
                        "auditId": gopaId,
                        "auditNumber": gopaNum,
                        "airlineIds": airId.toString(),
                        "airlineCode": gopaDetailsBody['airlineCode'],
                        "stationId": gopaDetailsBody['stationId'],
                        "stationAirport": gopaDetailsBody['stationAirport'],
                        "stationCode": gopaDetailsBody['stationCode'],
                        "groundHandlerId": gopaDetailsBody['groundHandlerId'],
                        "groundHandler": gopaDetailsBody['groundHandler'],
                        "auditDate": gopaDetailsBody['auditDate'],
                        "conductedId": gopaDetailsBody['conductedId'],
                        "conductAudit": gopaDetailsBody['conductAudit'],
                        "restartOperations":
                            gopaDetailsBody['restartOperations'],
                        "allAirlinesSameServiceProvider":
                            gopaDetailsBody['allAirlinesSameServiceProvider'],
                        "isagocertified": gopaDetailsBody['isagocertified'],
                        "messages": gopaDetailsBody['messages'],
                        "submitteddate": gopaDetailsBody['submitteddate'],
                        "isauditduedate": gopaDetailsBody['isauditduedate'],
                        "Passengerbridge": gopaDetailsBody['Passengerbridge'],
                        "PassengerbridgeServiceProvider":
                            gopaDetailsBody['PassengerbridgeServiceProvider'],
                        "Ramphandling": gopaDetailsBody['Ramphandling'],
                        "RamphandlingServiceProvider":
                            gopaDetailsBody['RamphandlingServiceProvider'],
                        "Cargohandling": gopaDetailsBody['Cargohandling'],
                        "CargohandlingServiceProvider":
                            gopaDetailsBody['CargohandlingServiceProvider'],
                        "PBhandling":
                            gopaDetailsBody['CargohandlingServiceProvider'],
                        "PBhandlingServiceProvider":
                            gopaDetailsBody['PBhandlingServiceProvider'],
                        "AircraftMarshalling":
                            gopaDetailsBody['AircraftMarshalling'],
                        "AircraftMarshallingServiceProvider": gopaDetailsBody[
                            'AircraftMarshallingServiceProvider'],
                        "Loadcontrol": gopaDetailsBody['Loadcontrol'],
                        "LoadcontrolServiceProvider":
                            gopaDetailsBody['LoadcontrolServiceProvider'],
                        "Deicingoperations":
                            gopaDetailsBody['Deicingoperations'],
                        "DeicingoperationsServiceProvider":
                            gopaDetailsBody['DeicingoperationsServiceProvider'],
                        "Headsetcommunication":
                            gopaDetailsBody['Headsetcommunication'],
                        "HeadsetcommunicationServiceProvider": gopaDetailsBody[
                            'HeadsetcommunicationServiceProvider'],
                        "Aircraftmovement": gopaDetailsBody['Aircraftmovement'],
                        "AircraftmovementServiceProvider":
                            gopaDetailsBody['AircraftmovementServiceProvider'],
                        "restartOperationName":
                            gopaDetailsBody['restartOperationName'],
                        "allAirlinesSameServiceProviderName": gopaDetailsBody[
                            'allAirlinesSameServiceProviderName'],
                        "isagocertifiedName":
                            gopaDetailsBody['isagocertifiedName'],
                        "isauditduedateName":
                            gopaDetailsBody['isauditduedateName'],
                        "PBName": gopaDetailsBody['PBName'],
                        "RampName": gopaDetailsBody['RampName'],
                        "CargoName": gopaDetailsBody['CargoName'],
                        "LoadName": gopaDetailsBody['LoadName'],
                        "DeicingName": gopaDetailsBody['DeicingName'],
                        "HeadsetcomName": gopaDetailsBody['HeadsetcomName'],
                        "AircraftmovName": gopaDetailsBody['AircraftmovName'],
                        "PassbridgeName": gopaDetailsBody['PassbridgeName'],
                        "AircraftMarsName": gopaDetailsBody['AircraftMarsName'],
                        "HoNumber": gopaDetailsBody['HoNumber'],
                        "APMMAILID": gopaDetailsBody['APMMAILID'],
                        "RMMAILID": gopaDetailsBody['RMMAILID'],
                        "HOMAILID": gopaDetailsBody['HOMAILID'],
                      });
                      setState(() {
                        Utilities.gopaDetails = gopaDetails2;
                      });

                      print("GopaSaveBody2");
                      print(GopaSaveBody2);
                      ApiService.post("NewGOPASave", GopaSaveBody2,
                              pref.getString('token'))
                          .then((success) {
                        var finalsavebody = jsonDecode(success.body);
                        print("===finalNewGOPASave===");
                        print(finalsavebody);
                        CCAChecklistsList = [];
                        print("attachmentsBody_length");
                        print(attachmentsBody.length);
                        // Sync Attachment Data start
                        if (attachmentsBody.length > 0) {
                          var attachmentsBodyLength =
                              attachmentsBody.length - 1;
                          for (int i = 0; i < attachmentsBody.length; i++) {
                            var deletePath =
                                attachmentsBody[i]['FilePath'].toString();
                            var bytes = File(attachmentsBody[i]['FilePath'])
                                .readAsBytesSync();
                            String? finalImage = base64Encode(bytes);

                            FileAttachmentSaveBody = jsonEncode({
                              "PluginID": attachmentsBody[i]['PluginID'],
                              "AuditID": gopaId,
                              "AuditNumber": gopaNum,
                              "featurID": attachmentsBody[i]['featurID'],
                              "ChecklistID": attachmentsBody[i]['ChecklistID'],
                              "ChecklistItemID": attachmentsBody[i]
                                  ['ChecklistItemID'],
                              "SubchecklistID": attachmentsBody[i]
                                      ['SubchecklistID']
                                  .toString(),
                              "FileName":
                                  attachmentsBody[i]['FileName'].toString(),
                              "AttachedBy":
                                  attachmentsBody[i]['AttachedBy'].toString(),
                              "ImageBase64": finalImage.toString(),
                            });

                            saveOffAttachmentForOnline(FileAttachmentSaveBody,
                                deletePath, i, attachmentsBodyLength);
                          }
                        }

                        db.deleteGOPA(widget.auditId);

                        //end
                      });
                    }
                    db.deleteGOPA(widget.auditId);
                    if (success.statusCode == 200) {
                      EasyLoading.addStatusCallback((status) {
                        print('EasyLoading Status $status');
                        if (status == EasyLoadingStatus.dismiss) {
                          _timer?.cancel();
                        }
                      });
                      EasyLoading.showSuccess('Saving Success');
                    } else {
                      EasyLoading.showInfo("Saving Failed");
                    }
                  });
                  if (btnStatus == 'complete') {
                    db.deleteGOPA(widget.auditId);
                    GOPAOfflineDB();
                  }
                }
              });
            } else {
              EasyLoading.showInfo("Saving Failed");
            }
          });
        } else if (!arry.contains("GOPA") && btnStatus == 'complete' ||
            !arry.contains("GOPA") && btnStatus == 'pending') {
          CCAChecklistsList = [];
          print("Old");
          for (int i = 0; i < Utilities.gopaList.length; i++) {
            var checkObject = jsonDecode(Utilities.gopaList[i].toString());
            var singleHeadQues =
                jsonDecode(checkObject['questions'].toString());
            if (singleHeadQues.length > 0) {
              for (int j = 0; j < singleHeadQues.length; j++) {
                var checklistObj = jsonEncode({
                  "ObjectID": gopaDetailsBody['auditId'],
                  "ChecklistID": singleHeadQues[j]['checklistID'],
                  "ChecklistItemID": singleHeadQues[j]['itemID'],
                  "ChecklistItemDataID":
                      singleHeadQues[j]['ChecklistItemDataID'].toString(),
                  "EmpID": pref.getString('employeeID'),
                  "Comments": singleHeadQues[j]['comments'].toString(),
                  "CheckListName": checkObject['title'],
                  "ItemName": singleHeadQues[j]['itemName'],
                  "SubchecklistID": checkObject['subId'],
                  "Subchecklistname": checkObject['subtitle'],
                  "Checklistorder": checkObject['checklistorder'],
                  "SubChecklistorder": checkObject['subChecklistorder'],
                  // "Imagename": singleHeadQues[j]['attachments_names'].toString(),
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
                    "ObjectID": gopaDetailsBody['auditId'],
                    "ChecklistID": multipleHeadQues[l]['checklistID'],
                    "ChecklistItemID": multipleHeadQues[l]['itemID'],
                    "ChecklistItemDataID":
                        multipleHeadQues[l]['ChecklistItemDataID'].toString(),
                    "EmpID": pref.getString('employeeID'),
                    "Comments": multipleHeadQues[l]['comments'].toString(),
                    "CheckListName": checkObject['title'],
                    "ItemName": multipleHeadQues[l]['itemName'],
                    "SubchecklistID": multipleHead[k]['id'],
                    "Subchecklistname": multipleHead[k]['title'],
                    "Checklistorder": multipleHeadQues[l]['checklistorder'],
                    "SubChecklistorder": multipleHeadQues[l]
                        ['subChecklistorder'],
                    // "Imagename": multipleHeadQues[l]['attachments_names'].toString(),
                  });

                  var ccachecklistbody = jsonDecode(checklistObj);
                  CCAChecklistsList.add(ccachecklistbody);
                }
              }
            }
          }
          var GopaSaveBody = jsonEncode({
            "StationID": gopaDetailsBody['stationId'],
            "HoNumber": gopaDetailsBody['HoNumber'],
            "StationCode": stationCode.toString(),
            "AuditID": gopaDetailsBody['auditId'],
            "GGHID": gopaDetailsBody['groundHandlerId'],
            "AuditDate": gopaDetailsBody['auditDate'],
            "AuditDoneby": pref.getString('employeeCode'),
            "AuditerName": Username,
            "AirlineIDs": airId.toString(),
            "Statusid": status,
            "SubmittedBy": pref.getString('employeeCode'),
            "UserID": pref.getString('userID'),
            "Msg": '',
            "ImageBase64": '',
            "ImageName": '',
            "AttachedByName": '',
            "SubmittedDate": gopaDetailsBody['submitteddate'],
            "GOPANumber": gopaDetailsBody['auditNumber'],
            "AuditNumber": gopaDetailsBody['auditNumber'],
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
            "APMMAILID": gopaDetailsBody['APMMAILID'],
            "RMMAILID": gopaDetailsBody['RMMAILID'],
            "HOMAILID": gopaDetailsBody['HOMAILID'],
            "CCAChecklistsList": CCAChecklistsList,
          });

          print("GOPA_Id GopaSaveBody ===$btnStatus");
          print(GopaSaveBody);

          var id;

          ApiService.post("NewGOPASave", GopaSaveBody, pref.getString('token'))
              .then((success) {
            if (success.statusCode == 200) {
              // EasyLoading.addStatusCallback((status) {
              //   print('EasyLoading Status $status');
              //   if (status == EasyLoadingStatus.dismiss) {
              //     _timer?.cancel();
              //   }
              // });
              setState(() {
                var onlinebody = jsonDecode(success.body);

                print('2743------------------------------>>');

                print("attachmentsBody_length");
                print(attachmentsBody.length);

                if (onlinebody['auditID'] > 0) {
                  if (attachmentsBody.length > 0) {
                    var attachmentsBodyLength = attachmentsBody.length - 1;
                    for (int i = 0; i < attachmentsBody.length; i++) {
                      var deletePath =
                          attachmentsBody[i]['FilePath'].toString();
                      var bytes = File(attachmentsBody[i]['FilePath'])
                          .readAsBytesSync();
                      String? finalImage = base64Encode(bytes);

                      FileAttachmentSaveBody = jsonEncode({
                        "PluginID": attachmentsBody[i]['PluginID'],
                        "AuditID": onlinebody['auditID'],
                        "AuditNumber": onlinebody['auditNumber'],
                        "featurID": attachmentsBody[i]['featurID'],
                        "ChecklistID": attachmentsBody[i]['ChecklistID'],
                        "ChecklistItemID": attachmentsBody[i]
                            ['ChecklistItemID'],
                        "SubchecklistID":
                            attachmentsBody[i]['SubchecklistID'].toString(),
                        "FileName": attachmentsBody[i]['FileName'].toString(),
                        "AttachedBy":
                            attachmentsBody[i]['AttachedBy'].toString(),
                        "ImageBase64": finalImage.toString(),
                      });

                      saveOffAttachmentForOnline(FileAttachmentSaveBody,
                          deletePath, i, attachmentsBodyLength);
                    }
                  }
                }
                db.deleteGOPA(widget.auditId);
                GOPAOfflineDB();
              });
              EasyLoading.showSuccess('Saving Success');
            } else {
              EasyLoading.showInfo("Saving Failed");
            }
          });
        }
      } else {
        CCAChecklistsList = [];
        print("Old");
        for (int i = 0; i < Utilities.gopaList.length; i++) {
          var checkObject = jsonDecode(Utilities.gopaList[i].toString());
          var singleHeadQues = jsonDecode(checkObject['questions'].toString());
          if (singleHeadQues.length > 0) {
            for (int j = 0; j < singleHeadQues.length; j++) {
              var checklistObj = jsonEncode({
                "ObjectID": gopaDetailsBody['auditId'],
                "ChecklistID": singleHeadQues[j]['checklistID'],
                "ChecklistItemID": singleHeadQues[j]['itemID'],
                "ChecklistItemDataID":
                    singleHeadQues[j]['ChecklistItemDataID'].toString(),
                "EmpID": pref.getString('employeeID'),
                "Comments": singleHeadQues[j]['comments'].toString(),
                "CheckListName": checkObject['title'],
                "ItemName": singleHeadQues[j]['itemName'],
                "SubchecklistID": checkObject['subId'],
                "Subchecklistname": checkObject['subtitle'],
                "Checklistorder": checkObject['checklistorder'],
                "SubChecklistorder": checkObject['subChecklistorder'],
                // "Imagename": singleHeadQues[j]['attachments_names'].toString(),
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
                  "ObjectID": gopaDetailsBody['auditId'],
                  "ChecklistID": multipleHeadQues[l]['checklistID'],
                  "ChecklistItemID": multipleHeadQues[l]['itemID'],
                  "ChecklistItemDataID":
                      multipleHeadQues[l]['ChecklistItemDataID'].toString(),
                  "EmpID": pref.getString('employeeID'),
                  "Comments": multipleHeadQues[l]['comments'].toString(),
                  "CheckListName": checkObject['title'],
                  "ItemName": multipleHeadQues[l]['itemName'],
                  "SubchecklistID": multipleHead[k]['id'],
                  "Subchecklistname": multipleHead[k]['title'],
                  "Checklistorder": multipleHeadQues[l]['checklistorder'],
                  "SubChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                  // "Imagename": multipleHeadQues[l]['attachments_names'].toString(),
                });

                var ccachecklistbody = jsonDecode(checklistObj);
                CCAChecklistsList.add(ccachecklistbody);
              }
            }
          }
        }

        var GopaSaveBody = jsonEncode({
          "StationID": gopaDetailsBody['stationId'],
          "HoNumber": gopaDetailsBody['HoNumber'],
          "StationCode": stationCode.toString(),
          "AuditID": gopaDetailsBody['auditId'],
          "GGHID": gopaDetailsBody['groundHandlerId'],
          "AuditDate": gopaDetailsBody['auditDate'],
          "AuditDoneby": pref.getString('employeeCode'),
          "AuditerName": Username,
          "AirlineIDs": airId.toString(),
          "Statusid": status,
          "SubmittedBy": pref.getString('employeeCode'),
          "UserID": pref.getString('userID'),
          "Msg": '',
          "ImageBase64": '',
          "ImageName": '',
          "AttachedByName": '',
          "SubmittedDate": gopaDetailsBody['submitteddate'],
          "GOPANumber": auditNumber,
          "AuditNumber": gopaDetailsBody['auditNumber'],
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
          "APMMAILID": gopaDetailsBody['APMMAILID'],
          "RMMAILID": gopaDetailsBody['RMMAILID'],
          "HOMAILID": gopaDetailsBody['HOMAILID'],
          "CCAChecklistsList": CCAChecklistsList,
        });

        print("GopaSaveBody");
        print(GopaSaveBody);

        var id;

        ApiService.post("NewGOPASave", GopaSaveBody, pref.getString('token'))
            .then((success) {
          if (success.statusCode == 200) {
            // EasyLoading.addStatusCallback((status) {
            //   print('EasyLoading Status $status');
            //   if (status == EasyLoadingStatus.dismiss) {
            //     _timer?.cancel();
            //   }
            // });
            // setState(() {
            var onlinebody = jsonDecode(success.body);
            print("attachmentsBody_length");
            print(attachmentsBody.length);
            if (onlinebody['auditID'] > 0) {
              if (attachmentsBody.length > 0) {
                var attachmentsBodyLength = attachmentsBody.length - 1;
                for (int i = 0; i < attachmentsBody.length; i++) {
                  var deletePath = attachmentsBody[i]['FilePath'].toString();
                  var bytes =
                      File(attachmentsBody[i]['FilePath']).readAsBytesSync();
                  // var deletedFile = File(attachmentsBody[i]['FilePath']).delete();
                  String? finalImage = base64Encode(bytes);
                  FileAttachmentSaveBody = jsonEncode({
                    "PluginID": attachmentsBody[i]['PluginID'],
                    "AuditID": onlinebody['auditID'],
                    "AuditNumber": onlinebody['auditNumber'],
                    "featurID": attachmentsBody[i]['featurID'],
                    "ChecklistID": attachmentsBody[i]['ChecklistID'],
                    "ChecklistItemID": attachmentsBody[i]['ChecklistItemID'],
                    "SubchecklistID":
                        attachmentsBody[i]['SubchecklistID'].toString(),
                    "FileName": attachmentsBody[i]['FileName'].toString(),
                    "AttachedBy": attachmentsBody[i]['AttachedBy'].toString(),
                    "ImageBase64": finalImage.toString(),
                  });

                  saveOffAttachmentForOnline(FileAttachmentSaveBody, deletePath,
                      i, attachmentsBodyLength);
                }
              }
            }

            print("final_submit");
            print(id);

            db.deleteGOPA(widget.auditId);
            GOPAOfflineDB();

            if (status == 2) {
              print("final_submit");
              db.deleteDraftedGOPAS(auditID, auditNumber);
              Utilities.gopaDetails = {};
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GopatrackOverview(
                            gopaAuditid: auditID,
                            gopaAuditnumber: auditNumber,
                            navType: '1',
                          )));
            }
            // });
            EasyLoading.showSuccess('Saving Success');
          } else {
            EasyLoading.showInfo("Saving Failed");
          }
        });
      }
    } else {
      if (widget.auditId != '') {
        auditID = widget.auditId;
        auditNumber = widget.auditNumber;
        //var gopaData = await db.getGOPAOverviewDataByAuditId(auditID);
      } else {
        auditID = 0;
        auditNumber = 0;
      }

      // Saved in Gopa Draft Table

      var gopaDraftDataObj = jsonEncode({
        "stationName": gopaDetailsBody["stationAirport"],
        "gghName": gopaDetailsBody["groundHandler"],
        "airlineIDs": airId.toString(),
        "auditDate": gopaDetailsBody["auditDate"],
        "auditID": auditID,
        "auditDoneby": pref.getString("firstName").toString() +
            " " +
            pref.getString("lastName").toString() +
            "(" +
            pref.getString("employeeCode").toString() +
            ")",
        "statusid": status,
        "statusName": 'Draft',
        "auditNumber": auditNumber,
      });

      var gopaDataObj = jsonEncode({
        "stationName": gopaDetailsBody["stationAirport"],
        "auditID": auditID,
        "HoNumber": gopaDetailsBody['HoNumber'],
        "groundHandler": gopaDetailsBody["groundHandler"],
        "auditDate": gopaDetailsBody["auditDate"],
        "auditDoneby": pref.getString("firstName").toString() +
            " " +
            pref.getString("lastName").toString() +
            "(" +
            pref.getString("employeeCode").toString() +
            ")",
        "airlineIDs": airId.toString(),
        "statusName": 'Draft',
        "statusid": 1,
        "auditNumber": auditNumber,
        "allAirlinesSameServiceProvider":
            gopaDetailsBody["allAirlinesSameServiceProviderName"],
        "gghid": gopaDetailsBody['groundHandlerId'],
        "stationID": gopaDetailsBody['stationId'],
        "submittedBy": pref.getString('employeeCode'),
        "userID": pref.getString('userID'),
        "Msg": '',
        "submittedDate": gopaDetailsBody['submitteddate'],
        "restartoperations": gopaDetailsBody['restartOperationName'],
        "sameserviceprovider":
            gopaDetailsBody['allAirlinesSameServiceProviderName'],
        "gopaNumber": GOPANumber,
        "pBhandling": gopaDetailsBody['PBName'],
        "ramphandling": gopaDetailsBody['RampName'],
        "cargohandling": gopaDetailsBody['CargoName'],
        "deicingoperations": gopaDetailsBody['DeicingName'],
        "aircraftMarshalling": gopaDetailsBody['AircraftMarsName'],
        "loadcontrol": gopaDetailsBody['LoadName'],
        "aircraftmovement": gopaDetailsBody['AircraftmovName'],
        "headsetcommunication": gopaDetailsBody['HeadsetcomName'],
        "passengerbridge": gopaDetailsBody['PassbridgeName'],
        "isago": gopaDetailsBody['isagocertifiedName'],
        "duedate": gopaDetailsBody['isauditduedateName'],
        "pBhandlingID": gopaDetailsBody['PBhandling'],
        "ramphandlingID": gopaDetailsBody['Ramphandling'],
        "cargohandlingID": gopaDetailsBody['Cargohandling'],
        "deicingoperationsID": gopaDetailsBody['Deicingoperations'],
        "aircraftMarshallingID": gopaDetailsBody['AircraftMarshalling'],
        "loadcontrolID": gopaDetailsBody['Loadcontrol'],
        "aircraftmovementID": gopaDetailsBody['Aircraftmovement'],
        "headsetcommunicationID": gopaDetailsBody['Headsetcommunication'],
        "passengerbridgeID": gopaDetailsBody['Passengerbridge'],
        "isagoid": gopaDetailsBody['isagocertified'],
        "restartoperationsID": gopaDetailsBody['restartOperations'],
        "sameserviceproviderID":
            gopaDetailsBody['allAirlinesSameServiceProvider'],
        "duedateID": gopaDetailsBody['isauditduedate'],
        "reason": gopaDetailsBody['messages'],
        "pBhandlingServiceProvider":
            gopaDetailsBody['PBhandlingServiceProvider'],
        "ramphandlingServiceProvider":
            gopaDetailsBody['RamphandlingServiceProvider'],
        "cargohandlingServiceProvider":
            gopaDetailsBody['CargohandlingServiceProvider'],
        "deicingoperationsServiceProvider":
            gopaDetailsBody['DeicingoperationsServiceProvider'],
        "aircraftMarshallingServiceProvider":
            gopaDetailsBody['AircraftMarshallingServiceProvider'],
        "loadcontrolServiceProvider":
            gopaDetailsBody['LoadcontrolServiceProvider'],
        "aircraftmovementServiceProvider":
            gopaDetailsBody['AircraftmovementServiceProvider'],
        "headsetcommunicationServiceProvider":
            gopaDetailsBody['HeadsetcommunicationServiceProvider'],
        "passengerbridgeServiceProvider":
            gopaDetailsBody['PassengerbridgeServiceProvider'],
      });

      var gopaBody1 = jsonDecode(gopaDataObj);
      GopaDetailsBodyData.add(gopaBody1);

      var gopaBody11 = jsonDecode(gopaDraftDataObj);
      GopaDraftDetailsBodyData.add(gopaBody11);

      print("GopaDraftDetailsBodyData");
      print(GopaDetailsBodyData);

      for (int i = 0; i < GopaDetailsBodyData.length; i++) {
        db.saveGOPAOverviewDetails(GopaDetailsBodyData[i]);
      }

      for (int i = 0; i < GopaDraftDetailsBodyData.length; i++) {
        db.saveGOPADraftAudits(GopaDraftDetailsBodyData[i], 0);
      }

      List gopaChecklistBody = [];

      for (int i = 0; i < Utilities.gopaList.length; i++) {
        var checkObject = jsonDecode(Utilities.gopaList[i].toString());
        var singleHeadQues = jsonDecode(checkObject['questions'].toString());

        if (singleHeadQues.length > 0) {
          for (int j = 0; j < singleHeadQues.length; j++) {
            var checklistObj = jsonEncode({
              "objectID": auditID,
              "checklistID": checkObject['id'],
              "checklistItemID": singleHeadQues[j]['itemID'],
              "checklistItemDataID": singleHeadQues[j]['ChecklistItemDataID'],
              "empID": pref.getString('employeeID'),
              "comments": singleHeadQues[j]['comments'],
              "checkListName": checkObject['title'],
              "itemName": singleHeadQues[j]['itemName'],
              "subchecklistID": checkObject['subId'],
              "subchecklistname": checkObject['subtitle'],
              "checklistorder": checkObject['checklistorder'],
              "subChecklistorder": checkObject['subChecklistorder'],
              "imagename": singleHeadQues[j]['attachments_names'],
              "attachmentName": singleHeadQues[j]['attachments_names'],
              "attachmentBaseImg": "",
            });

            var gopachkbody1 = jsonDecode(checklistObj);
            gopaChecklistBody.add(gopachkbody1);
          }
        }
        var multipleHead = checkObject['subquestions'];
        if (multipleHead.length > 0) {
          for (int k = 0; k < multipleHead.length; k++) {
            var multipleHeadQues =
                jsonDecode(multipleHead[k]['questions'].toString());

            for (int l = 0; l < multipleHeadQues.length; l++) {
              var checklistObj = jsonEncode({
                "objectID": auditID,
                "checklistID": checkObject['id'],
                "checklistItemID": multipleHeadQues[l]['itemID'],
                "checklistItemDataID": multipleHeadQues[l]
                    ['ChecklistItemDataID'],
                "empID": pref.getString('employeeID'),
                "comments": multipleHeadQues[l]['comments'],
                "checkListName": checkObject['title'],
                "itemName": multipleHeadQues[l]['itemName'],
                "subchecklistID": multipleHead[k]['id'],
                "subchecklistname": multipleHead[k]['title'],
                "checklistorder": multipleHeadQues[l]['checklistorder'],
                "subChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                "imagename": multipleHeadQues[l]['attachments_names'],
                "attachmentName": multipleHeadQues[l]['attachments_names'],
                "attachmentBaseImg": "",
              });

              var gopachkbody1 = jsonDecode(checklistObj);
              gopaChecklistBody.add(gopachkbody1);
            }
          }
        }
      }

      print('gopaChecklistBody');
      print(gopaChecklistBody);

      for (int i = 0; i < gopaChecklistBody.length; i++) {
        db.saveGOPAOverviewChecklistData(
            gopaChecklistBody[i], auditID, widget.auditNumber, 0);
      }
      dataLength = gopaBody11.length;
      if (dataLength != 0) {
        print('datalength----------------->');
        EasyLoading.addStatusCallback((dataLength) {
          print('EasyLoading Status $dataLength');
          if (dataLength == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        EasyLoading.showSuccess('Saving Success');
      } else {
        EasyLoading.showInfo("Saving Failed");
      }
    }
  }

  deleteOfflineGOPAById(auditId, auditNumber) async {
    await db.deleteGOPAByID(auditId);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GopaHome()));
  }

  saveOffAttachmentForOnline(
      FileAttachmentSaveBody, deletePath, filepos, filecount) async {
    print(
        "FileAttachmentSaveBody------------------------------------------------------------------");
    print(FileAttachmentSaveBody);
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isOnline = await Utilities.CheckUserConnection() as bool;

    if (isOnline) {
      try {
        final response = await ApiService.post("SaveFileAttachmentforChecklist",
            FileAttachmentSaveBody, pref.getString('token'));

        if (response.statusCode != 200) {
          if (filepos == filecount) {
            EasyLoading.addStatusCallback((status) {
              print('EasyLoading Status $status');
              if (status == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });
          }
          throw HttpException('${response.statusCode}');
        } else {
          if (filepos == filecount) {
            EasyLoading.addStatusCallback((status) {
              print('EasyLoading Status $status');
              if (status == EasyLoadingStatus.dismiss) {
                _timer?.cancel();
              }
            });
          }
          print('Sucessfully file');
          print('${response.statusCode}');
          // File(deletePath).delete();
        }

        // ApiService.post("SaveFileAttachmentforChecklist", FileAttachmentSaveBody,
        //        pref.getString('token'))
        //        .then((success) {
        //      var output = jsonDecode(success.body);
        //      print("GOPA FileAttachmentSaveBody Saved...");
        //      print(output);
        //    });
      } catch (e) {
        print(e);
        print("failed");
      }
    }
  }

  SaveGopaCreation() async {
    var airlinesIds;
    String? Username;

    SharedPreferences pref = await SharedPreferences.getInstance();
    var emplogin = pref.getString("employeeCode").toString();
    var draftAudits = await db.getGOPAOfflineDraftAudits(emplogin);
    Username = pref.getString("firstName").toString() +
        " " +
        pref.getString("lastName").toString();
    print("Utilities.gopaDetails");
    print(Utilities.gopaDetails);
    var gopaDetailsBody = jsonDecode(Utilities.gopaDetails);
    print("gopaDetailsBody-----");
    print(gopaDetailsBody);

    var airId = gopaDetailsBody['airlineIds'].toString();
    var final_airlineIds = [];
    for (int i = 0; i < airId.length; i++) {
      if (airId[i].isNotEmpty && airId[i].toString() != 'null') {
        final_airlineIds.add(airId[i].trim());
      }
    }

    var auditID;
    var auditNumber;

    bool isOnline = await Utilities.CheckUserConnection() as bool;
    List CCAChecklistsList = [];
    var FileAttachmentSaveBody;

    var stationCode = gopaDetailsBody["stationCode"].toString();
    var GOPANumber = stationCode.toString() + "/" + widget.auditNumber;
    print(widget.auditNumber);
    print('audit number');
    var arry = gopaDetailsBody['auditId'].toString().split("_");
    if (arry.contains("GOPA")) {
      CCAChecklistsList = [];

      var attachmentsBody =
          await db.getOfflineGOPAItemImageJsonData(widget.auditNumber);

      for (int i = 0; i < Utilities.gopaList.length; i++) {
        var checkObject = jsonDecode(Utilities.gopaList[i].toString());
        var singleHeadQues = jsonDecode(checkObject['questions'].toString());
        if (singleHeadQues.length > 0) {
          for (int j = 0; j < singleHeadQues.length; j++) {
            var checklistObj = jsonEncode({
              "ObjectID": "0",
              "ChecklistID": singleHeadQues[j]['checklistID'],
              "ChecklistItemID": singleHeadQues[j]['itemID'],
              "ChecklistItemDataID":
                  singleHeadQues[j]['ChecklistItemDataID'].toString(),
              "EmpID": pref.getString('employeeID'),
              "Comments": singleHeadQues[j]['comments'].toString(),
              "CheckListName": checkObject['title'],
              "ItemName": singleHeadQues[j]['itemName'],
              "SubchecklistID": checkObject['subId'],
              "Subchecklistname": checkObject['subtitle'],
              "Checklistorder": checkObject['checklistorder'],
              "SubChecklistorder": checkObject['subChecklistorder'],
              // "Imagename": singleHeadQues[j]['attachments_names'].toString(),
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
                "ObjectID": "0",
                "ChecklistID": multipleHeadQues[l]['checklistID'],
                "ChecklistItemID": multipleHeadQues[l]['itemID'],
                "ChecklistItemDataID":
                    multipleHeadQues[l]['ChecklistItemDataID'].toString(),
                "EmpID": pref.getString('employeeID'),
                "Comments": multipleHeadQues[l]['comments'].toString(),
                "CheckListName": checkObject['title'],
                "ItemName": multipleHeadQues[l]['itemName'],
                "SubchecklistID": multipleHead[k]['id'],
                "Subchecklistname": multipleHead[k]['title'],
                "Checklistorder": multipleHeadQues[l]['checklistorder'],
                "SubChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                // "Imagename": multipleHeadQues[l]['attachments_names'].toString(),
              });

              var ccachecklistbody = jsonDecode(checklistObj);
              CCAChecklistsList.add(ccachecklistbody);
            }
          }
        }
      }

      var GopaSaveBodyNew = jsonEncode({
        "AuditID": "0",
        "StationID": gopaDetailsBody['stationId'],
        "AuditDoneby": pref.getString('employeeCode'),
        "AirlineIDs": airId.toString(),
        "StationCode": stationCode,
        "Restartoperations": gopaDetailsBody['restartOperations'],
        "GGHID": gopaDetailsBody['groundHandlerId'],
        "UserID": pref.getString('userID'),
        "CCAChecklistsList": CCAChecklistsList,
      });

      ApiService.post("NewGOPAPart1", GopaSaveBodyNew, pref.getString('token'))
          .then((success) {
        var body = jsonDecode(success.body);

        if (body['auditID'] > 0) {
          print(body['auditID']);
          print(body['auditNumber']);
          var id = body['auditID'];
          var gopaId = body['auditID'];
          var gopaNum = body['auditNumber'];

          for (int i = 0; i < Utilities.gopaList.length; i++) {
            var checkObject = jsonDecode(Utilities.gopaList[i].toString());
            var singleHeadQues =
                jsonDecode(checkObject['questions'].toString());
            if (singleHeadQues.length > 0) {
              for (int j = 0; j < singleHeadQues.length; j++) {
                var checklistObj = jsonEncode({
                  "ObjectID": gopaId,
                  "ChecklistID": singleHeadQues[j]['checklistID'],
                  "ChecklistItemID": singleHeadQues[j]['itemID'],
                  "ChecklistItemDataID":
                      singleHeadQues[j]['ChecklistItemDataID'].toString(),
                  "EmpID": pref.getString('employeeID'),
                  "Comments": singleHeadQues[j]['comments'].toString(),
                  "CheckListName": checkObject['title'],
                  "ItemName": singleHeadQues[j]['itemName'],
                  "SubchecklistID": checkObject['subId'],
                  "Subchecklistname": checkObject['subtitle'],
                  "Checklistorder": checkObject['checklistorder'],
                  "SubChecklistorder": checkObject['subChecklistorder'],
                  // "Imagename": singleHeadQues[j]['attachments_names'].toString(),
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
                    "ObjectID": gopaId,
                    "ChecklistID": multipleHeadQues[l]['checklistID'],
                    "ChecklistItemID": multipleHeadQues[l]['itemID'],
                    "ChecklistItemDataID":
                        multipleHeadQues[l]['ChecklistItemDataID'].toString(),
                    "EmpID": pref.getString('employeeID'),
                    "Comments": multipleHeadQues[l]['comments'].toString(),
                    "CheckListName": checkObject['title'],
                    "ItemName": multipleHeadQues[l]['itemName'],
                    "SubchecklistID": multipleHead[k]['id'],
                    "Subchecklistname": multipleHead[k]['title'],
                    "Checklistorder": multipleHeadQues[l]['checklistorder'],
                    "SubChecklistorder": multipleHeadQues[l]
                        ['subChecklistorder'],
                    // "Imagename": multipleHeadQues[l]['attachments_names'].toString(),
                  });

                  var ccachecklistbody = jsonDecode(checklistObj);
                  CCAChecklistsList.add(ccachecklistbody);
                }
              }
            }
          }

          var gopaDetails2 = jsonEncode({
            "auditId": gopaId,
            "auditNumber": gopaNum,
            "airlineIds": airId.toString(),
            "airlineCode": gopaDetailsBody['airlineCode'],
            "stationId": gopaDetailsBody['stationId'],
            "stationAirport": gopaDetailsBody['stationAirport'],
            "stationCode": gopaDetailsBody['stationCode'],
            "groundHandlerId": gopaDetailsBody['groundHandlerId'],
            "groundHandler": gopaDetailsBody['groundHandler'],
            "auditDate": gopaDetailsBody['auditDate'],
            "conductedId": gopaDetailsBody['conductedId'],
            "conductAudit": gopaDetailsBody['conductAudit'],
            "restartOperations": gopaDetailsBody['restartOperations'],
            "allAirlinesSameServiceProvider":
                gopaDetailsBody['allAirlinesSameServiceProvider'],
            "isagocertified": gopaDetailsBody['isagocertified'],
            "messages": gopaDetailsBody['messages'],
            "submitteddate": gopaDetailsBody['submitteddate'],
            "isauditduedate": gopaDetailsBody['isauditduedate'],
            "Passengerbridge": gopaDetailsBody['Passengerbridge'],
            "PassengerbridgeServiceProvider":
                gopaDetailsBody['PassengerbridgeServiceProvider'],
            "Ramphandling": gopaDetailsBody['Ramphandling'],
            "RamphandlingServiceProvider":
                gopaDetailsBody['RamphandlingServiceProvider'],
            "Cargohandling": gopaDetailsBody['Cargohandling'],
            "CargohandlingServiceProvider":
                gopaDetailsBody['CargohandlingServiceProvider'],
            "PBhandling": gopaDetailsBody['CargohandlingServiceProvider'],
            "PBhandlingServiceProvider":
                gopaDetailsBody['PBhandlingServiceProvider'],
            "AircraftMarshalling": gopaDetailsBody['AircraftMarshalling'],
            "AircraftMarshallingServiceProvider":
                gopaDetailsBody['AircraftMarshallingServiceProvider'],
            "Loadcontrol": gopaDetailsBody['Loadcontrol'],
            "LoadcontrolServiceProvider":
                gopaDetailsBody['LoadcontrolServiceProvider'],
            "Deicingoperations": gopaDetailsBody['Deicingoperations'],
            "DeicingoperationsServiceProvider":
                gopaDetailsBody['DeicingoperationsServiceProvider'],
            "Headsetcommunication": gopaDetailsBody['Headsetcommunication'],
            "HeadsetcommunicationServiceProvider":
                gopaDetailsBody['HeadsetcommunicationServiceProvider'],
            "Aircraftmovement": gopaDetailsBody['Aircraftmovement'],
            "AircraftmovementServiceProvider":
                gopaDetailsBody['AircraftmovementServiceProvider'],
            "restartOperationName": gopaDetailsBody['restartOperationName'],
            "allAirlinesSameServiceProviderName":
                gopaDetailsBody['allAirlinesSameServiceProviderName'],
            "isagocertifiedName": gopaDetailsBody['isagocertifiedName'],
            "isauditduedateName": gopaDetailsBody['isauditduedateName'],
            "PBName": gopaDetailsBody['PBName'],
            "RampName": gopaDetailsBody['RampName'],
            "CargoName": gopaDetailsBody['CargoName'],
            "LoadName": gopaDetailsBody['LoadName'],
            "DeicingName": gopaDetailsBody['DeicingName'],
            "HeadsetcomName": gopaDetailsBody['HeadsetcomName'],
            "AircraftmovName": gopaDetailsBody['AircraftmovName'],
            "PassbridgeName": gopaDetailsBody['PassbridgeName'],
            "AircraftMarsName": gopaDetailsBody['AircraftMarsName'],
            "HoNumber": gopaDetailsBody['HoNumber'],
            "APMMAILID": gopaDetailsBody['APMMAILID'],
            "RMMAILID": gopaDetailsBody['RMMAILID'],
            "HOMAILID": gopaDetailsBody['HOMAILID'],
          });
          setState(() {
            Utilities.gopaDetails = gopaDetails2;
          });

          if (attachmentsBody.length > 0) {
            for (int i = 0; i < attachmentsBody.length; i++) {
              FileAttachmentSaveBody = jsonEncode({
                "PluginID": attachmentsBody[i]['PluginID'].toString(),
                "AuditID": gopaId,
                "AuditNumber": gopaNum,
                "featurID": attachmentsBody[i]['featurID'].toString(),
                "ChecklistID": attachmentsBody[i]['ChecklistID'],
                "ChecklistItemID": attachmentsBody[i]['ChecklistItemID'],
                "SubchecklistID":
                    attachmentsBody[i]['SubchecklistID'].toString(),
                "FileName": attachmentsBody[i]['FileName'].toString(),
                "AttachedBy": attachmentsBody[i]['AttachedBy'].toString(),
                "ImageBase64": attachmentsBody[i]['ImageBase64'].toString(),
              });

              print("FileAttachmentSaveBody online22222222222");
              print(FileAttachmentSaveBody);
              ApiService.post("SaveFileAttachmentforChecklist",
                      FileAttachmentSaveBody, pref.getString('token'))
                  .then((success) {
                print("Gopa Attachment Saved...444");
              });
            }
          }

          print("Gopa creation");
          print(Utilities.gopaDetails);

          db.deleteGOPA(widget.auditId);

          GOPAOfflineDB();
        }
      });
    }
  }

  getOfflineDataSaveData() async {
    var airlinesIds;
    String? Username;

    SharedPreferences pref = await SharedPreferences.getInstance();
    var emplogin = pref.getString("employeeCode").toString();
    var draftAudits = await db.getGOPAOfflineDraftAudits(emplogin);
    Username = pref.getString("firstName").toString() +
        " " +
        pref.getString("lastName").toString();
    var gopaDetailsBody = jsonDecode(Utilities.gopaDetails);

    var airId = gopaDetailsBody['airlineIds'].toString();
    var final_airlineIds = [];
    for (int i = 0; i < airId.length; i++) {
      if (airId[i].isNotEmpty && airId[i].toString() != 'null') {
        final_airlineIds.add(airId[i].trim());
      }
    }
    print("airId");
    print(airId);
    print("airId");

    List GopaDetailsBodyData = [];
    List GopaDraftDetailsBodyData = [];

    var auditID;
    var auditNumber;

    bool isOnline = await Utilities.CheckUserConnection() as bool;
    List CCAChecklistsList = [];
    var FileAttachmentSaveBody;

    var stationCode = gopaDetailsBody["stationCode"].toString();
    var GOPANumber = stationCode.toString() + "/" + widget.auditNumber;
    print(widget.auditNumber);
    print('audit number');
    if (widget.auditId != '') {
      auditID = widget.auditId;
      auditNumber = widget.auditNumber;
      //var gopaData = await db.getGOPAOverviewDataByAuditId(auditID);
    } else {
      auditID = 0;
      auditNumber = 0;
    }

    // Saved in Gopa Draft Table

    var gopaDraftDataObj = jsonEncode({
      "stationName": gopaDetailsBody["stationAirport"],
      "gghName": gopaDetailsBody["groundHandler"],
      "airlineIDs": airId.toString(),
      "auditDate": gopaDetailsBody["auditDate"],
      "auditID": auditID,
      "auditDoneby": pref.getString("firstName").toString() +
          " " +
          pref.getString("lastName").toString() +
          "(" +
          pref.getString("employeeCode").toString() +
          ")",
      "statusid": "1",
      "statusName": 'Draft',
      "auditNumber": auditNumber,
    });

    var gopaDataObj = jsonEncode({
      "stationName": gopaDetailsBody["stationAirport"],
      "auditID": auditID,
      "HoNumber": gopaDetailsBody['HoNumber'],
      "groundHandler": gopaDetailsBody["groundHandler"],
      "auditDate": gopaDetailsBody["auditDate"],
      "auditDoneby": pref.getString("firstName").toString() +
          " " +
          pref.getString("lastName").toString() +
          "(" +
          pref.getString("employeeCode").toString() +
          ")",
      "airlineIDs": airId.toString(),
      "statusName": 'Draft',
      "statusid": 1,
      "auditNumber": auditNumber,
      "allAirlinesSameServiceProvider":
          gopaDetailsBody["allAirlinesSameServiceProviderName"],
      "gghid": gopaDetailsBody['groundHandlerId'],
      "stationID": gopaDetailsBody['stationId'],
      "submittedBy": pref.getString('employeeCode'),
      "userID": pref.getString('userID'),
      "Msg": '',
      "submittedDate": gopaDetailsBody['submitteddate'],
      "restartoperations": gopaDetailsBody['restartOperationName'],
      "sameserviceprovider":
          gopaDetailsBody['allAirlinesSameServiceProviderName'],
      "gopaNumber": GOPANumber,
      "pBhandling": gopaDetailsBody['PBName'],
      "ramphandling": gopaDetailsBody['RampName'],
      "cargohandling": gopaDetailsBody['CargoName'],
      "deicingoperations": gopaDetailsBody['DeicingName'],
      "aircraftMarshalling": gopaDetailsBody['AircraftMarsName'],
      "loadcontrol": gopaDetailsBody['LoadName'],
      "aircraftmovement": gopaDetailsBody['AircraftmovName'],
      "headsetcommunication": gopaDetailsBody['HeadsetcomName'],
      "passengerbridge": gopaDetailsBody['PassbridgeName'],
      "isago": gopaDetailsBody['isagocertifiedName'],
      "duedate": gopaDetailsBody['isauditduedateName'],
      "pBhandlingID": gopaDetailsBody['PBhandling'],
      "ramphandlingID": gopaDetailsBody['Ramphandling'],
      "cargohandlingID": gopaDetailsBody['Cargohandling'],
      "deicingoperationsID": gopaDetailsBody['Deicingoperations'],
      "aircraftMarshallingID": gopaDetailsBody['AircraftMarshalling'],
      "loadcontrolID": gopaDetailsBody['Loadcontrol'],
      "aircraftmovementID": gopaDetailsBody['Aircraftmovement'],
      "headsetcommunicationID": gopaDetailsBody['Headsetcommunication'],
      "passengerbridgeID": gopaDetailsBody['Passengerbridge'],
      "isagoid": gopaDetailsBody['isagocertified'],
      "restartoperationsID": gopaDetailsBody['restartOperations'],
      "sameserviceproviderID":
          gopaDetailsBody['allAirlinesSameServiceProvider'],
      "duedateID": gopaDetailsBody['isauditduedate'],
      "reason": gopaDetailsBody['messages'],
      "pBhandlingServiceProvider": gopaDetailsBody['PBhandlingServiceProvider'],
      "ramphandlingServiceProvider":
          gopaDetailsBody['RamphandlingServiceProvider'],
      "cargohandlingServiceProvider":
          gopaDetailsBody['CargohandlingServiceProvider'],
      "deicingoperationsServiceProvider":
          gopaDetailsBody['DeicingoperationsServiceProvider'],
      "aircraftMarshallingServiceProvider":
          gopaDetailsBody['AircraftMarshallingServiceProvider'],
      "loadcontrolServiceProvider":
          gopaDetailsBody['LoadcontrolServiceProvider'],
      "aircraftmovementServiceProvider":
          gopaDetailsBody['AircraftmovementServiceProvider'],
      "headsetcommunicationServiceProvider":
          gopaDetailsBody['HeadsetcommunicationServiceProvider'],
      "passengerbridgeServiceProvider":
          gopaDetailsBody['PassengerbridgeServiceProvider'],
    });

    var gopaBody1 = jsonDecode(gopaDataObj);
    GopaDetailsBodyData.add(gopaBody1);

    var gopaBody11 = jsonDecode(gopaDraftDataObj);
    GopaDraftDetailsBodyData.add(gopaBody11);

    print("GopaDraftDetailsBodyData");
    print(GopaDetailsBodyData);

    for (int i = 0; i < GopaDetailsBodyData.length; i++) {
      db.saveGOPAOverviewDetails(GopaDetailsBodyData[i]);
    }

    for (int i = 0; i < GopaDraftDetailsBodyData.length; i++) {
      db.saveGOPADraftAudits(GopaDraftDetailsBodyData[i], 0);
    }

    List gopaChecklistBody = [];

    for (int i = 0; i < Utilities.gopaList.length; i++) {
      var checkObject = jsonDecode(Utilities.gopaList[i].toString());
      var singleHeadQues = jsonDecode(checkObject['questions'].toString());

      if (singleHeadQues.length > 0) {
        for (int j = 0; j < singleHeadQues.length; j++) {
          var checklistObj = jsonEncode({
            "objectID": auditID,
            "checklistID": checkObject['id'],
            "checklistItemID": singleHeadQues[j]['itemID'],
            "checklistItemDataID": singleHeadQues[j]['ChecklistItemDataID'],
            "empID": pref.getString('employeeID'),
            "comments": singleHeadQues[j]['comments'],
            "checkListName": checkObject['title'],
            "itemName": singleHeadQues[j]['itemName'],
            "subchecklistID": checkObject['subId'],
            "subchecklistname": checkObject['subtitle'],
            "checklistorder": checkObject['checklistorder'],
            "subChecklistorder": checkObject['subChecklistorder'],
            "imagename": singleHeadQues[j]['attachments_names'],
            "attachmentName": singleHeadQues[j]['attachments_names'],
            "attachmentBaseImg": "",
          });

          var gopachkbody1 = jsonDecode(checklistObj);
          gopaChecklistBody.add(gopachkbody1);
        }
      }
      var multipleHead = checkObject['subquestions'];
      if (multipleHead.length > 0) {
        for (int k = 0; k < multipleHead.length; k++) {
          var multipleHeadQues =
              jsonDecode(multipleHead[k]['questions'].toString());

          for (int l = 0; l < multipleHeadQues.length; l++) {
            var checklistObj = jsonEncode({
              "objectID": auditID,
              "checklistID": checkObject['id'],
              "checklistItemID": multipleHeadQues[l]['itemID'],
              "checklistItemDataID": multipleHeadQues[l]['ChecklistItemDataID'],
              "empID": pref.getString('employeeID'),
              "comments": multipleHeadQues[l]['comments'],
              "checkListName": checkObject['title'],
              "itemName": multipleHeadQues[l]['itemName'],
              "subchecklistID": multipleHead[k]['id'],
              "subchecklistname": multipleHead[k]['title'],
              "checklistorder": multipleHeadQues[l]['checklistorder'],
              "subChecklistorder": multipleHeadQues[l]['subChecklistorder'],
              "imagename": multipleHeadQues[l]['attachments_names'],
              "attachmentName": multipleHeadQues[l]['attachments_names'],
              "attachmentBaseImg": "",
            });

            var gopachkbody1 = jsonDecode(checklistObj);
            gopaChecklistBody.add(gopachkbody1);
          }
        }
      }
    }

    print('gopaChecklistBody');
    print(gopaChecklistBody);

    for (int i = 0; i < gopaChecklistBody.length; i++) {
      db.saveGOPAOverviewChecklistData(
          gopaChecklistBody[i], auditID, widget.auditNumber, 0);
    }
  }

  GOPAOfflineDB() async {
    print("APIs 11");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var emplogin = pref.getString("employeeCode").toString();

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
        // GetGOPADraftAudits(auditId,auditNumber);

        ApiService.get(
                "GetGOPADataBasedonAuditID?AuditID=$auditId&AuditNumber=$auditNumber",
                pref.getString('token'))
            .then((success) async {
          var data = jsonDecode(success.body);
          var gopaoverviewdata1;
          var gopaoverviewchecklistdata1;
          var annexuresOverviewDataforgopa;
          var PluginID = 137;

          setState(() {
            gopaoverviewdata1 = data["auditGOPAOverviewMaindata"];
            gopaoverviewchecklistdata1 = data["ccaChecklistsList"];
            annexuresOverviewDataforgopa = data["annexuresOverviewDataforgopa"];
          });

          GetGOPANumberforMOApi(gopaoverviewdata1[0]['stationID'], emplogin);
          GetMOAirlinesDataByStationGopaNumber(
              gopaoverviewdata1[0]['stationID'], auditNumber);
          IsMOExists(gopaoverviewdata1[0]['airlineIDs'], auditNumber);
          ISAnnexuresdraftedmodebsedrGOPAandAirlineID(
              gopaoverviewdata1[0]['airlineIDs'], auditNumber);
          GetMOMasterData(auditNumber);

          for (int i = 0; i < gopaoverviewdata1.length; i++) {
            await db.saveGOPAOverviewDetails(gopaoverviewdata1[i]);
          }

          if (gopaoverviewchecklistdata1.length > 0) {
            for (int i = 0; i < gopaoverviewchecklistdata1.length; i++) {
              await db.saveGOPAOverviewChecklistData(
                  gopaoverviewchecklistdata1[i], auditId, auditNumber, 1);

              if (gopaoverviewchecklistdata1[i]['imagename']
                  .toString()
                  .isNotEmpty) {
                saveGOPAItemImageData(
                    gopaoverviewchecklistdata1[i], auditNumber, PluginID);
              }
            }
          }

          if (annexuresOverviewDataforgopa.length > 0) {
            for (int l = 0; l < annexuresOverviewDataforgopa.length; l++) {
              await db.saveAnnexuresOverviewDataforgopa(
                  annexuresOverviewDataforgopa[l], auditId);
            }
          }
        });
      }
      //});
    });
    GetDraftGOPANumberbasedonEMPStation();
  }

  GetGOPADraftAudits(auditId, auditNumber) async {
    print("APIs 11");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var emplogin = pref.getString("employeeCode").toString();
    ApiService.get(
            "GetGOPADataBasedonAuditID?AuditID=$auditId&AuditNumber=$auditNumber",
            pref.getString('token'))
        .then((success) async {
      var data = jsonDecode(success.body);
      var gopaoverviewdata1;
      var gopaoverviewchecklistdata1;
      var annexuresOverviewDataforgopa;
      var PluginID = 137;

      setState(() {
        gopaoverviewdata1 = data["auditGOPAOverviewMaindata"];
        gopaoverviewchecklistdata1 = data["ccaChecklistsList"];
        annexuresOverviewDataforgopa = data["annexuresOverviewDataforgopa"];
      });

      GetGOPANumberforMOApi(gopaoverviewdata1[0]['stationID'], emplogin);
      GetMOAirlinesDataByStationGopaNumber(
          gopaoverviewdata1[0]['stationID'], auditNumber);
      IsMOExists(gopaoverviewdata1[0]['airlineIDs'], auditNumber);
      ISAnnexuresdraftedmodebsedrGOPAandAirlineID(
          gopaoverviewdata1[0]['airlineIDs'], auditNumber);
      GetMOMasterData(auditNumber);

      for (int i = 0; i < gopaoverviewdata1.length; i++) {
        await db.saveGOPAOverviewDetails(gopaoverviewdata1[i]);
      }

      if (gopaoverviewchecklistdata1.length > 0) {
        for (int i = 0; i < gopaoverviewchecklistdata1.length; i++) {
          await db.saveGOPAOverviewChecklistData(
              gopaoverviewchecklistdata1[i], auditId, auditNumber, 1);

          if (gopaoverviewchecklistdata1[i]['imagename']
              .toString()
              .isNotEmpty) {
            saveGOPAItemImageData(
                gopaoverviewchecklistdata1[i], auditNumber, PluginID);
          }
        }
      }

      if (annexuresOverviewDataforgopa.length > 0) {
        for (int l = 0; l < annexuresOverviewDataforgopa.length; l++) {
          await db.saveAnnexuresOverviewDataforgopa(
              annexuresOverviewDataforgopa[l], auditId);
        }
      }
    });
  }

  GetDraftGOPANumberbasedonEMPStation() async {
    print("APIs 10");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var emplogin = pref.getString("employeeCode").toString();
    // GopaNumbersList Api
    ApiService.get(
            "GetDraftGOPANumberbasedonEMPStation?LoginEMPNumber=$emplogin",
            pref.getString('token'))
        .then((success) async {
      //setState(() {
      var gopanumList = json.decode(success.body);

      for (int i = 0; i < gopanumList.length; i++) {
        await db.saveGopaNumber(gopanumList[i]);
      }
      //});
    });
  }

  GetGOPANumberforMOApi(stationId, auditorNo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    ApiService.get(
            "GetGOPANumberforMO?StationID=$stationId&AuditerNo=$auditorNo",
            pref.getString('token'))
        .then((success) async {
      setState(() {
        var draftObj = jsonDecode(success.body);

        for (int i = 0; i < draftObj.length; i++) {
          db.saveGOPANumberforMO(draftObj[i], stationId, auditorNo);
        }
      });
    });
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
        }
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

  GetMOMasterData(auditNumber) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ApiService.get(
            "GetMOMasterData?GOPANo=$auditNumber", pref.getString('token'))
        .then((success) async {
      var body = jsonDecode(success.body);

      var moIntrelinks = body['mointerlinksforchecklist'][0]['moIntrelinks'];
      var loadControl = body['mointerlinksforloadcontrols'][0]['loadControl'];
      var passengerBoardingBridge =
          body['mointerlinksforPassengerBoardingBridge'][0]
              ['passengerBoardingBridge'];

      await db.saveMOMasterData(
          auditNumber, moIntrelinks, loadControl, passengerBoardingBridge);
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

  makeAutoSaveApiCall(status) async {
    var airlinesIds;
    String? Username;

    SharedPreferences pref = await SharedPreferences.getInstance();
    Username = pref.getString("firstName").toString() +
        " " +
        pref.getString("lastName").toString();
    var gopaDetailsBody = jsonDecode(Utilities.gopaDetails);
    var airId = gopaDetailsBody['airlineIds'].toString();
    var final_airlineIds = [];
    for (int i = 0; i < airId.length; i++) {
      if (airId[i].isNotEmpty && airId[i].toString() != 'null') {
        final_airlineIds.add(airId[i].trim());
      }
    }

    List GopaDetailsBodyData = [];
    List GopaDraftDetailsBodyData = [];

    var auditID;
    var auditNumber;

    bool isOnline = await Utilities.CheckUserConnection() as bool;
    List CCAChecklistsList = [];

    var stationCode = gopaDetailsBody["stationCode"].toString();
    var GOPANumber = widget.gopaNumberwithstationCode.toString();
    // var GOPANumber = stationCode.toString() + "/" + widget.auditNumber;
    print(widget.auditNumber);
    print('audit number');
    if (isOnline) {
      if (widget.auditId != '') {
        auditID = widget.auditId;
        auditNumber = widget.auditNumber;
      } else {
        auditID = 0;
        auditNumber = 0;
      }

      for (int i = 0; i < Utilities.gopaList.length; i++) {
        var checkObject = jsonDecode(Utilities.gopaList[i].toString());
        var singleHeadQues = jsonDecode(checkObject['questions'].toString());
        if (singleHeadQues.length > 0) {
          for (int j = 0; j < singleHeadQues.length; j++) {
            var checklistObj = jsonEncode({
              "ObjectID": auditID,
              "ChecklistID": singleHeadQues[j]['checklistID'],
              "ChecklistItemID": singleHeadQues[j]['itemID'],
              "ChecklistItemDataID":
                  singleHeadQues[j]['ChecklistItemDataID'].toString(),
              "EmpID": pref.getString('employeeID'),
              "Comments": singleHeadQues[j]['comments'].toString(),
              "CheckListName": checkObject['title'],
              "ItemName": singleHeadQues[j]['itemName'],
              "SubchecklistID": checkObject['subId'],
              "Subchecklistname": checkObject['subtitle'],
              "Checklistorder": checkObject['checklistorder'],
              "SubChecklistorder": checkObject['subChecklistorder'],
              // "Imagename": singleHeadQues[j]['attachments_names'].toString(),
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
                "ChecklistID": multipleHeadQues[l]['checklistID'],
                "ChecklistItemID": multipleHeadQues[l]['itemID'],
                "ChecklistItemDataID":
                    multipleHeadQues[l]['ChecklistItemDataID'].toString(),
                "EmpID": pref.getString('employeeID'),
                "Comments": multipleHeadQues[l]['comments'].toString(),
                "CheckListName": checkObject['title'],
                "ItemName": multipleHeadQues[l]['itemName'],
                "SubchecklistID": multipleHead[k]['id'],
                "Subchecklistname": multipleHead[k]['title'],
                "Checklistorder": multipleHeadQues[l]['checklistorder'],
                "SubChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                // "Imagename": multipleHeadQues[l]['attachments_names'].toString(),
              });

              var ccachecklistbody = jsonDecode(checklistObj);
              CCAChecklistsList.add(ccachecklistbody);
            }
          }
        }
      }

      var GopaSaveBody = jsonEncode({
        "StationID": gopaDetailsBody['stationId'],
        "HoNumber": gopaDetailsBody['HoNumber'],
        "StationCode": stationCode.toString(),
        "AuditID": auditID,
        "GGHID": gopaDetailsBody['groundHandlerId'],
        "AuditDate": gopaDetailsBody['auditDate'],
        "AuditDoneby": pref.getString('employeeCode'),
        "AuditerName": Username,
        "AirlineIDs": airId.toString(),
        "Statusid": status,
        "SubmittedBy": pref.getString('employeeCode'),
        "UserID": pref.getString('userID'),
        "Msg": '',
        "ImageBase64": '',
        "ImageName": '',
        "AttachedByName": '',
        "SubmittedDate": gopaDetailsBody['submitteddate'],
        "GOPANumber": auditNumber,
        "AuditNumber": auditNumber,
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
        "APMMAILID": gopaDetailsBody['APMMAILID'],
        "RMMAILID": gopaDetailsBody['RMMAILID'],
        "HOMAILID": gopaDetailsBody['HOMAILID'],
        "CCAChecklistsList": CCAChecklistsList,
      });

      print("GopaSaveBody");
      print(GopaSaveBody);

      var id = 0;

      ApiService.post("NewGOPASave", GopaSaveBody, pref.getString('token'))
          .then((success) {
        setState(() {
          var body = jsonDecode(success.body);
          print(body);

          if (body['auditID'] > 0) {
            id = body['auditID'];
          } else {
            id = 0;
          }
        });
      });
    } else {
      if (widget.auditId != '') {
        auditID = widget.auditId;
        auditNumber = widget.auditNumber;
        //var gopaData = await db.getGOPAOverviewDataByAuditId(auditID);
      } else {
        auditID = 0;
        auditNumber = 0;
      }

      // Saved in Gopa Draft Table

      var gopaDraftDataObj = jsonEncode({
        "stationName": gopaDetailsBody["stationAirport"],
        "gghName": gopaDetailsBody["groundHandler"],
        "airlineIDs": airId.toString(),
        "auditDate": gopaDetailsBody["auditDate"],
        "auditID": auditID,
        "auditDoneby": pref.getString("firstName").toString() +
            " " +
            pref.getString("lastName").toString() +
            "(" +
            pref.getString("employeeCode").toString() +
            ")",
        "statusid": status,
        "statusName": 'Draft',
        "auditNumber": auditNumber,
      });

      var gopaDataObj = jsonEncode({
        "stationName": gopaDetailsBody["stationAirport"],
        "auditID": auditNumber,
        "HoNumber": gopaDetailsBody['HoNumber'],
        "groundHandler": gopaDetailsBody["groundHandler"],
        "auditDoneby": pref.getString("firstName").toString() +
            " " +
            pref.getString("lastName").toString() +
            "(" +
            pref.getString("employeeCode").toString() +
            ")",
        "airlineIDs": airId.toString(),
        "statusName": 'Draft',
        "statusid": 1,
        "auditNumber": auditNumber,
        "allAirlinesSameServiceProvider":
            gopaDetailsBody["allAirlinesSameServiceProviderName"],
        "gghid": gopaDetailsBody['groundHandlerId'],
        "stationID": gopaDetailsBody['stationId'],
        "submittedBy": pref.getString('employeeCode'),
        "userID": pref.getString('userID'),
        "Msg": '',
        "submittedDate": gopaDetailsBody['submitteddate'],
        "restartoperations": gopaDetailsBody['restartOperationName'],
        "sameserviceprovider":
            gopaDetailsBody['allAirlinesSameServiceProviderName'],
        "gopaNumber": GOPANumber,
        "pBhandling": gopaDetailsBody['PBName'],
        "ramphandling": gopaDetailsBody['RampName'],
        "cargohandling": gopaDetailsBody['CargoName'],
        "deicingoperations": gopaDetailsBody['DeicingName'],
        "aircraftMarshalling": gopaDetailsBody['AircraftMarsName'],
        "loadcontrol": gopaDetailsBody['LoadName'],
        "aircraftmovement": gopaDetailsBody['AircraftmovName'],
        "headsetcommunication": gopaDetailsBody['HeadsetcomName'],
        "passengerbridge": gopaDetailsBody['PassbridgeName'],
        "isago": gopaDetailsBody['isagocertifiedName'],
        "duedate": gopaDetailsBody['isauditduedateName'],
        "pBhandlingID": gopaDetailsBody['PBhandling'],
        "ramphandlingID": gopaDetailsBody['Ramphandling'],
        "cargohandlingID": gopaDetailsBody['Cargohandling'],
        "deicingoperationsID": gopaDetailsBody['Deicingoperations'],
        "aircraftMarshallingID": gopaDetailsBody['AircraftMarshalling'],
        "loadcontrolID": gopaDetailsBody['Loadcontrol'],
        "aircraftmovementID": gopaDetailsBody['Aircraftmovement'],
        "headsetcommunicationID": gopaDetailsBody['Headsetcommunication'],
        "passengerbridgeID": gopaDetailsBody['Passengerbridge'],
        "isagoid": gopaDetailsBody['isagocertified'],
        "restartoperationsID": gopaDetailsBody['restartOperations'],
        "sameserviceproviderID":
            gopaDetailsBody['allAirlinesSameServiceProvider'],
        "duedateID": gopaDetailsBody['isauditduedate'],
        "reason": gopaDetailsBody['messages'],
        "pBhandlingServiceProvider":
            gopaDetailsBody['PBhandlingServiceProvider'],
        "ramphandlingServiceProvider":
            gopaDetailsBody['RamphandlingServiceProvider'],
        "cargohandlingServiceProvider":
            gopaDetailsBody['CargohandlingServiceProvider'],
        "deicingoperationsServiceProvider":
            gopaDetailsBody['DeicingoperationsServiceProvider'],
        "aircraftMarshallingServiceProvider":
            gopaDetailsBody['AircraftMarshallingServiceProvider'],
        "loadcontrolServiceProvider":
            gopaDetailsBody['LoadcontrolServiceProvider'],
        "aircraftmovementServiceProvider":
            gopaDetailsBody['AircraftmovementServiceProvider'],
        "headsetcommunicationServiceProvider":
            gopaDetailsBody['HeadsetcommunicationServiceProvider'],
        "passengerbridgeServiceProvider":
            gopaDetailsBody['PassengerbridgeServiceProvider'],
      });

      var gopaBody1 = jsonDecode(gopaDataObj);
      GopaDetailsBodyData.add(gopaBody1);

      var gopaBody11 = jsonDecode(gopaDraftDataObj);
      GopaDraftDetailsBodyData.add(gopaBody11);

      for (int i = 0; i < GopaDetailsBodyData.length; i++) {
        db.saveGOPAOverviewDetails(GopaDetailsBodyData[i]);
      }

      for (int i = 0; i < GopaDraftDetailsBodyData.length; i++) {
        db.saveGOPADraftAudits(GopaDraftDetailsBodyData[i], 0);
      }

      List gopaChecklistBody = [];

      for (int i = 0; i < Utilities.gopaList.length; i++) {
        var checkObject = jsonDecode(Utilities.gopaList[i].toString());
        var singleHeadQues = jsonDecode(checkObject['questions'].toString());

        if (singleHeadQues.length > 0) {
          for (int j = 0; j < singleHeadQues.length; j++) {
            var checklistObj = jsonEncode({
              "objectID": auditID,
              "checklistID": checkObject['id'],
              "checklistItemID": singleHeadQues[j]['itemID'],
              "checklistItemDataID": singleHeadQues[j]['ChecklistItemDataID'],
              "empID": pref.getString('employeeID'),
              "comments": singleHeadQues[j]['comments'],
              "checkListName": checkObject['title'],
              "itemName": singleHeadQues[j]['itemName'],
              "subchecklistID": checkObject['subId'],
              "subchecklistname": checkObject['subtitle'],
              "checklistorder": checkObject['checklistorder'],
              "subChecklistorder": checkObject['subChecklistorder'],
              "imagename": singleHeadQues[j]['attachments_names'],
              "attachmentName": singleHeadQues[j]['attachments_names'],
              "attachmentBaseImg": "",
            });

            var gopachkbody1 = jsonDecode(checklistObj);
            gopaChecklistBody.add(gopachkbody1);
          }
        }
        var multipleHead = checkObject['subquestions'];
        if (multipleHead.length > 0) {
          for (int k = 0; k < multipleHead.length; k++) {
            var multipleHeadQues =
                jsonDecode(multipleHead[k]['questions'].toString());

            for (int l = 0; l < multipleHeadQues.length; l++) {
              var checklistObj = jsonEncode({
                "objectID": auditID,
                "checklistID": checkObject['id'],
                "checklistItemID": multipleHeadQues[l]['itemID'],
                "checklistItemDataID": multipleHeadQues[l]
                    ['ChecklistItemDataID'],
                "empID": pref.getString('employeeID'),
                "comments": multipleHeadQues[l]['comments'],
                "checkListName": checkObject['title'],
                "itemName": multipleHeadQues[l]['itemName'],
                "subchecklistID": multipleHead[k]['id'],
                "subchecklistname": multipleHead[k]['title'],
                "checklistorder": multipleHeadQues[l]['checklistorder'],
                "subChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                "imagename": multipleHeadQues[l]['attachments_names'],
                "attachmentName": multipleHeadQues[l]['attachments_names'],
                "attachmentBaseImg": "",
              });

              var gopachkbody1 = jsonDecode(checklistObj);
              gopaChecklistBody.add(gopachkbody1);
            }
          }
        }
      }

      print('gopaChecklistBody');
      print(gopaChecklistBody);

      for (int i = 0; i < gopaChecklistBody.length; i++) {
        db.saveGOPAOverviewChecklistData(
            gopaChecklistBody[i], auditID, widget.auditNumber, 0);
      }
    }
  }

  updateToggleData(selectPosition, ratings) async {
    List tempCheckList = [];
    try {
      for (int i = 0; i < Utilities.gopaList.length; i++) {
        List items = [];
        List subitems = [];
        String itemDataId = '0';
        var checkObject = jsonDecode(Utilities.gopaList[i].toString());
        var singleHeadQues = jsonDecode(checkObject['questions'].toString());

        if (singleHeadQues.length > 0) {
          for (int j = 0; j < singleHeadQues.length; j++) {
            if (selectPosition['itemID'].toString() ==
                singleHeadQues[j]['itemID'].toString()) {
              // Selected Item Rating and data Appears with single heading

              var item = jsonEncode({
                "s_no": singleHeadQues[j]['s_no'],
                "itemID": singleHeadQues[j]['itemID'],
                "itemName": singleHeadQues[j]['itemName'],
                "checklistorder": singleHeadQues[j]['checklistorder'],
                "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                "checklistID": singleHeadQues[j]['checklistID'],
                "subchecklistID": singleHeadQues[j]['subchecklistID'],
                "subchecklistname": singleHeadQues[j]['subchecklistname'],
                "attachfileManadatory": singleHeadQues[j]
                    ['attachfileManadatory'],
                "ratingStatus": singleHeadQues[j]['ratingStatus'],
                "ChecklistItemDataID": ratings,
                "comments": singleHeadQues[j]['comments'],
                "ratingList": singleHeadQues[j]['ratingList'],
                "attachments_names": singleHeadQues[j]['attachments_names'],
                "attachments_paths": singleHeadQues[j]['attachments_paths'],
                "attachments_baseImg": singleHeadQues[j]['attachments_baseImg'],
              });

              items.add(item);
            } else {
              var item = jsonEncode({
                "s_no": singleHeadQues[j]['s_no'],
                "itemID": singleHeadQues[j]['itemID'],
                "itemName": singleHeadQues[j]['itemName'],
                "checklistorder": singleHeadQues[j]['checklistorder'],
                "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                "checklistID": singleHeadQues[j]['checklistID'],
                "subchecklistID": singleHeadQues[j]['subchecklistID'],
                "subchecklistname": singleHeadQues[j]['subchecklistname'],
                "attachfileManadatory": singleHeadQues[j]
                    ['attachfileManadatory'],
                "ratingStatus": singleHeadQues[j]['ratingStatus'],
                "ChecklistItemDataID": singleHeadQues[j]['ChecklistItemDataID'],
                "comments": singleHeadQues[j]['comments'],
                "ratingList": singleHeadQues[j]['ratingList'],
                "attachments_names": singleHeadQues[j]['attachments_names'],
                "attachments_paths": singleHeadQues[j]['attachments_paths'],
                "attachments_baseImg": singleHeadQues[j]['attachments_baseImg'],
              });
              items.add(item);
            }
          }
        } else {
          var multipleHead = checkObject['subquestions'];
          // print(multipleHead.toString()+"");
          for (int k = 0; k < multipleHead.length; k++) {
            // print("Entered for loopp  " + multipleHead[k]['title']);
            var multipleHeadQues =
                jsonDecode(multipleHead[k]['questions'].toString());
            //print("Entered for loopp  if " + multipleHeadQues[0]['itemID'].toString());
            List itemsqns = [];
            for (int l = 0; l < multipleHeadQues.length; l++) {
              //print(selectPosition['itemID'].toString() +"Entered for loopp  if " + multipleHeadQues[l]['itemID'].toString());
              // var questions = multipleHeadQues[l];
              if (selectPosition['itemID'].toString() ==
                  multipleHeadQues[l]['itemID'].toString()) {
                // Selected Item Rating and data Appears with multiple heading
                // print("Entered for loopp  if " );

                var itemsqn = jsonEncode({
                  "s_no": multipleHeadQues[l]['s_no'],
                  "itemID": multipleHeadQues[l]['itemID'],
                  "itemName": multipleHeadQues[l]['itemName'],
                  "checklistID": multipleHeadQues[l]['checklistID'],
                  "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                  "subchecklistname": multipleHeadQues[l]['subchecklistname'],
                  "attachfileManadatory": multipleHeadQues[l]
                      ['attachfileManadatory'],
                  "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                  "checklistorder": multipleHeadQues[l]['checklistorder'],
                  "subChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                  "ChecklistItemDataID": ratings,
                  "comments": multipleHeadQues[l]['comments'],
                  "ratingList": multipleHeadQues[l]['ratingList'],
                  "attachments_names": multipleHeadQues[l]['attachments_names'],
                  "attachments_paths": multipleHeadQues[l]['attachments_paths'],
                  "attachments_baseImg": multipleHeadQues[l]
                      ['attachments_baseImg'],
                });

                itemsqns.add(itemsqn);
              } else {
                // Not Selected Item Rating and data Appears with multiple heading
                // print("Entered for loopp  else " );
                // Not Selected Item Rating and data Appears with single heading
                // print("Entered for loopp  else "+multipleHeadQues[l]['itemName'].toString());
                var itemsqn = jsonEncode({
                  "s_no": multipleHeadQues[l]['s_no'],
                  "itemID": multipleHeadQues[l]['itemID'],
                  "itemName": multipleHeadQues[l]['itemName'],
                  "checklistID": multipleHeadQues[l]['checklistID'],
                  "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                  "subchecklistname": multipleHeadQues[l]['subchecklistname'],
                  "attachfileManadatory": multipleHeadQues[l]
                      ['attachfileManadatory'],
                  "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                  "checklistorder": multipleHeadQues[l]['checklistorder'],
                  "subChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                  "ChecklistItemDataID": multipleHeadQues[l]
                      ['ChecklistItemDataID'],
                  "comments": multipleHeadQues[l]['comments'],
                  "ratingList": multipleHeadQues[l]['ratingList'],
                  "attachments_names": multipleHeadQues[l]['attachments_names'],
                  "attachments_paths": multipleHeadQues[l]['attachments_paths'],
                  "attachments_baseImg": multipleHeadQues[l]
                      ['attachments_baseImg'],
                });
                itemsqns.add(itemsqn);
              }
              // print("Entered for loopp  " + multipleHeadQues[l]['id']);
            }

            var subitem = {
              'id': multipleHead[k]['id'],
              'title': multipleHead[k]['title'],
              'questions': itemsqns
            };
            subitems.add(subitem);
          }
        }

        var checkList = jsonEncode({
          "id": checkObject['id'],
          "title": checkObject['title'],
          "subId": checkObject['subId'] == null ? "" : checkObject['subId'],
          "subtitle":
              checkObject['subtitle'] == null ? "" : checkObject['subtitle'],
          "questions": items,
          "subquestions": subitems
        });

        tempCheckList.add(checkList);
        // print("temp updated data");
        // print(tempCheckList);
      }

      setState(() {
        Utilities.gopaList = [];
        Utilities.gopaList = tempCheckList;
        tempCheckList = [];
      });

      // updateDisabledRatingData();

      // print("Selected VALUE DETAILS "+selectPosition.toString());
      // print("----------------------------------------------------------------");
    } catch (e) {
      print("Error Occured " + e.toString());
    }
  }

  updateDisabledRatingData() async {
    List tempCheckList = [];
    try {
      for (int i = 0; i < Utilities.gopaList.length; i++) {
        List items = [];
        List subitems = [];
        String itemDataId = '0';
        var checkObject = jsonDecode(Utilities.gopaList[i].toString());
        var singleHeadQues = jsonDecode(checkObject['questions'].toString());

        if (singleHeadQues.length > 0) {
          for (int j = 0; j < singleHeadQues.length; j++) {
            var ratingList = singleHeadQues[j]['ratingList'];
            if (Utilities.checkListDisabledIdsList
                .contains(singleHeadQues[j]['itemID'].toString())) {
              var disabledRatingId = 3;
              for (int r = 0; r < ratingList.length; r++) {
                if (ratingList[r]['ratingName'] == 'Not Applicable') {
                  disabledRatingId = ratingList[r]['ratingID'];
                }
              }

              var item = jsonEncode({
                "s_no": singleHeadQues[j]['s_no'],
                "itemID": singleHeadQues[j]['itemID'],
                "itemName": singleHeadQues[j]['itemName'],
                "checklistorder": singleHeadQues[j]['checklistorder'],
                "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                "checklistID": singleHeadQues[j]['checklistID'],
                "subchecklistID": singleHeadQues[j]['subchecklistID'],
                "subchecklistname": singleHeadQues[j]['subchecklistname'],
                "attachfileManadatory": singleHeadQues[j]
                    ['attachfileManadatory'],
                "ratingStatus": singleHeadQues[j]['ratingStatus'],
                "ChecklistItemDataID": disabledRatingId,
                "comments": singleHeadQues[j]['comments'],
                "ratingList": singleHeadQues[j]['ratingList'],
                "attachments_names": singleHeadQues[j]['attachments_names'],
                "attachments_paths": singleHeadQues[j]['attachments_paths'],
                "attachments_baseImg": singleHeadQues[j]['attachments_baseImg'],
              });

              items.add(item);
            } else {
              var item = jsonEncode({
                "s_no": singleHeadQues[j]['s_no'],
                "itemID": singleHeadQues[j]['itemID'],
                "itemName": singleHeadQues[j]['itemName'],
                "checklistorder": singleHeadQues[j]['checklistorder'],
                "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                "checklistID": singleHeadQues[j]['checklistID'],
                "subchecklistID": singleHeadQues[j]['subchecklistID'],
                "subchecklistname": singleHeadQues[j]['subchecklistname'],
                "attachfileManadatory": singleHeadQues[j]
                    ['attachfileManadatory'],
                "ratingStatus": singleHeadQues[j]['ratingStatus'],
                "ChecklistItemDataID": singleHeadQues[j]['ChecklistItemDataID'],
                "comments": singleHeadQues[j]['comments'],
                "ratingList": singleHeadQues[j]['ratingList'],
                "attachments_names": singleHeadQues[j]['attachments_names'],
                "attachments_paths": singleHeadQues[j]['attachments_paths'],
                "attachments_baseImg": singleHeadQues[j]['attachments_baseImg'],
              });

              items.add(item);
            }
            // Selected Item Rating and data Appears with single heading
          }
        } else {
          var multipleHead = checkObject['subquestions'];
          // print(multipleHead.toString()+"");
          for (int k = 0; k < multipleHead.length; k++) {
            // print("Entered for loopp  " + multipleHead[k]['title']);
            var multipleHeadQues =
                jsonDecode(multipleHead[k]['questions'].toString());
            //print("Entered for loopp  if " + multipleHeadQues[0]['itemID'].toString());
            List itemsqns = [];
            for (int l = 0; l < multipleHeadQues.length; l++) {
              if (Utilities.checkListDisabledIdsList
                  .contains(multipleHeadQues[l]['itemID'].toString())) {
                var disabledRatingId = 3;
                for (int r = 0; r < ratingList.length; r++) {
                  if (ratingList[r]['ratingName'] == 'Not Applicable') {
                    disabledRatingId = ratingList[r]['ratingID'];
                  }
                }

                var itemsqn = jsonEncode({
                  "s_no": multipleHeadQues[l]['s_no'],
                  "itemID": multipleHeadQues[l]['itemID'],
                  "itemName": multipleHeadQues[l]['itemName'],
                  "checklistID": multipleHeadQues[l]['checklistID'],
                  "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                  "subchecklistname": multipleHeadQues[l]['subchecklistname'],
                  "attachfileManadatory": multipleHeadQues[l]
                      ['attachfileManadatory'],
                  "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                  "checklistorder": multipleHeadQues[l]['checklistorder'],
                  "subChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                  "ChecklistItemDataID": disabledRatingId.toString(),
                  "comments": multipleHeadQues[l]['comments'],
                  "ratingList": multipleHeadQues[l]['ratingList'],
                  "attachments_names": multipleHeadQues[l]['attachments_names'],
                  "attachments_paths": multipleHeadQues[l]['attachments_paths'],
                  "attachments_baseImg": multipleHeadQues[l]
                      ['attachments_baseImg'],
                });

                itemsqns.add(itemsqn);
              } else {
                var itemsqn = jsonEncode({
                  "s_no": multipleHeadQues[l]['s_no'],
                  "itemID": multipleHeadQues[l]['itemID'],
                  "itemName": multipleHeadQues[l]['itemName'],
                  "checklistID": multipleHeadQues[l]['checklistID'],
                  "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                  "subchecklistname": multipleHeadQues[l]['subchecklistname'],
                  "attachfileManadatory": multipleHeadQues[l]
                      ['attachfileManadatory'],
                  "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                  "checklistorder": multipleHeadQues[l]['checklistorder'],
                  "subChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                  "ChecklistItemDataID": multipleHeadQues[l]
                      ['ChecklistItemDataID'],
                  "comments": multipleHeadQues[l]['comments'],
                  "ratingList": multipleHeadQues[l]['ratingList'],
                  "attachments_names": multipleHeadQues[l]['attachments_names'],
                  "attachments_paths": multipleHeadQues[l]['attachments_paths'],
                  "attachments_baseImg": multipleHeadQues[l]
                      ['attachments_baseImg'],
                });

                itemsqns.add(itemsqn);
              }

              // print("Entered for loopp  " + multipleHeadQues[l]['id']);
            }

            var subitem = {
              'id': multipleHead[k]['id'],
              'title': multipleHead[k]['title'],
              'questions': itemsqns
            };
            subitems.add(subitem);
          }
        }

        var checkList = jsonEncode({
          "id": checkObject['id'],
          "title": checkObject['title'],
          "subId": checkObject['subId'] == null ? "" : checkObject['subId'],
          "subtitle":
              checkObject['subtitle'] == null ? "" : checkObject['subtitle'],
          "questions": items,
          "subquestions": subitems
        });

        tempCheckList.add(checkList);
        // print("temp updated data");
        // print(tempCheckList);
      }

      setState(() {
        Utilities.gopaList = [];
        Utilities.gopaList = tempCheckList;
        tempCheckList = [];
      });

      // print("Selected VALUE DETAILS "+selectPosition.toString());
      // print("----------------------------------------------------------------");
    } catch (e) {
      print("Error Occured " + e.toString());
    }
  }

  updateCommentsData(selectPosition, comments) async {
    List tempCheckList = [];
    try {
      for (int i = 0; i < Utilities.gopaList.length; i++) {
        List items = [];
        List subitems = [];
        String itemDataId = '0';
        var checkObject = jsonDecode(Utilities.gopaList[i].toString());
        var singleHeadQues = jsonDecode(checkObject['questions'].toString());

        if (singleHeadQues.length > 0) {
          // print("Entered Line 1573 ");
          for (int j = 0; j < singleHeadQues.length; j++) {
            // print(selectPosition['itemID'].toString() +"Entered for loopp  if " + singleHeadQues[j]['itemID'].toString());
            // var questions = singleHeadQues[j];
            List ratingControl = [];
            for (int i = 0; i < checklistRatingIDbased.length; i++) {
              if (checklistRatingIDbased[i]['checklistID'].isNotEmpty &&
                  checklistRatingIDbased[i]['subChecklistID'].isNotEmpty) {
                if (checklistRatingIDbased[i]['checklistID'] ==
                        singleHeadQues[j]['checklistID'].toString() &&
                    checklistRatingIDbased[i]['subChecklistID'] ==
                        singleHeadQues[j]['subchecklistID']) {
                  ratingControl.add(checklistRatingIDbased[i]);
                }
              }
            }

            List ratingList = [];
            if (ratingControl.isEmpty) {
              ratingList = checklistRatingcommn;
            } else {
              ratingList = ratingControl;
            }

            if (selectPosition['itemID'].toString() ==
                singleHeadQues[j]['itemID'].toString()) {
              // Selected Item Rating and data Appears with single heading

              var item = jsonEncode({
                "s_no": singleHeadQues[j]['s_no'],
                "itemID": singleHeadQues[j]['itemID'],
                "itemName": singleHeadQues[j]['itemName'],
                "checklistorder": singleHeadQues[j]['checklistorder'],
                "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                "checklistID": singleHeadQues[j]['checklistID'],
                "subchecklistID": singleHeadQues[j]['subchecklistID'],
                "subchecklistname": singleHeadQues[j]['subchecklistname'],
                "attachfileManadatory": singleHeadQues[j]
                    ['attachfileManadatory'],
                "ratingStatus": singleHeadQues[j]['ratingStatus'],
                "ChecklistItemDataID": singleHeadQues[j]['ChecklistItemDataID'],
                "comments": comments,
                "ratingList": singleHeadQues[j]['ratingList'],
                "attachments_names": singleHeadQues[j]['attachments_names'],
                "attachments_paths": singleHeadQues[j]['attachments_paths'],
                "attachments_baseImg": singleHeadQues[j]['attachments_baseImg'],
              });

              items.add(item);
              // print("----if updated");
            } else {
              // print("else---------");
              // Not Selected Item Rating and data Appears with single heading
              // print("Entered for loopp  else "+singleHeadQues[j]['itemName'].toString());
              var item = jsonEncode({
                "s_no": singleHeadQues[j]['s_no'],
                "itemID": singleHeadQues[j]['itemID'],
                "itemName": singleHeadQues[j]['itemName'],
                "checklistorder": singleHeadQues[j]['checklistorder'],
                "subChecklistorder": singleHeadQues[j]['subChecklistorder'],
                "checklistID": singleHeadQues[j]['checklistID'],
                "subchecklistID": singleHeadQues[j]['subchecklistID'],
                "subchecklistname": singleHeadQues[j]['subchecklistname'],
                "attachfileManadatory": singleHeadQues[j]
                    ['attachfileManadatory'],
                "ratingStatus": singleHeadQues[j]['ratingStatus'],
                "ChecklistItemDataID": singleHeadQues[j]['ChecklistItemDataID'],
                "comments": singleHeadQues[j]['comments'],
                "ratingList": singleHeadQues[j]['ratingList'],
                "attachments_names": singleHeadQues[j]['attachments_names'],
                "attachments_paths": singleHeadQues[j]['attachments_paths'],
                "attachments_baseImg": singleHeadQues[j]['attachments_baseImg'],
              });
              items.add(item);
            }
            // print("Entered for loopp  " + singleHeadQues[j]['id']);
          }
        } else {
          // print("Entered Line 1578  ");
          var multipleHead = checkObject['subquestions'];

          // print(multipleHead.toString()+"");
          for (int k = 0; k < multipleHead.length; k++) {
            // print("Entered for loopp  " + multipleHead[k]['title']);
            var multipleHeadQues =
                jsonDecode(multipleHead[k]['questions'].toString());
            //print("Entered for loopp  if " + multipleHeadQues[0]['itemID'].toString());
            List itemsqns = [];
            for (int l = 0; l < multipleHeadQues.length; l++) {
              //print(selectPosition['itemID'].toString() +"Entered for loopp  if " + multipleHeadQues[l]['itemID'].toString());
              // var questions = multipleHeadQues[l];
              List ratingSubControl = [];
              for (int i = 0; i < checklistRatingIDbased.length; i++) {
                if (checklistRatingIDbased[i]['checklistID'].isNotEmpty &&
                    checklistRatingIDbased[i]['subChecklistID'].isNotEmpty) {
                  if (checklistRatingIDbased[i]['checklistID'] ==
                          multipleHeadQues[l]['checklistID'].toString() &&
                      checklistRatingIDbased[i]['subChecklistID'] ==
                          multipleHeadQues[l]['subchecklistID']) {
                    ratingSubControl.add(checklistRatingIDbased[i]);
                  }
                }
              }

              List ratingSubList = [];
              if (ratingSubControl.isEmpty) {
                ratingSubList = checklistRatingcommn;
              } else {
                ratingSubList = ratingSubControl;
              }
              if (selectPosition['itemID'].toString() ==
                  multipleHeadQues[l]['itemID'].toString()) {
                // Selected Item Rating and data Appears with multiple heading
                // print("Entered for loopp  if " );

                itemDataId = "0";

                var itemsqn = jsonEncode({
                  "s_no": multipleHeadQues[l]['s_no'],
                  "itemID": multipleHeadQues[l]['itemID'],
                  "itemName": multipleHeadQues[l]['itemName'],
                  "checklistID": multipleHeadQues[l]['checklistID'],
                  "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                  "subchecklistname": multipleHeadQues[l]['subchecklistname'],
                  "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                  "checklistorder": multipleHeadQues[l]['checklistorder'],
                  "subChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                  "attachfileManadatory": multipleHeadQues[l]
                      ['attachfileManadatory'],
                  "ChecklistItemDataID": multipleHeadQues[l]
                      ['ChecklistItemDataID'],
                  "comments": comments,
                  "ratingList": multipleHeadQues[l]['ratingList'],
                  "attachments_names": multipleHeadQues[l]['attachments_names'],
                  "attachments_paths": multipleHeadQues[l]['attachments_paths'],
                  "attachments_baseImg": multipleHeadQues[l]
                      ['attachments_baseImg'],
                });
                itemsqns.add(itemsqn);
              } else {
                // Not Selected Item Rating and data Appears with multiple heading
                // print("Entered for loopp  else " );
                // Not Selected Item Rating and data Appears with single heading
                // print("Entered for loopp  else "+multipleHeadQues[l]['itemName'].toString());
                var itemsqn = jsonEncode({
                  "s_no": multipleHeadQues[l]['s_no'],
                  "itemID": multipleHeadQues[l]['itemID'],
                  "itemName": multipleHeadQues[l]['itemName'],
                  "checklistID": multipleHeadQues[l]['checklistID'],
                  "subchecklistID": multipleHeadQues[l]['subchecklistID'],
                  "subchecklistname": multipleHeadQues[l]['subchecklistname'],
                  "attachfileManadatory": multipleHeadQues[l]
                      ['attachfileManadatory'],
                  "ratingStatus": multipleHeadQues[l]['ratingStatus'],
                  "checklistorder": multipleHeadQues[l]['checklistorder'],
                  "subChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                  "ChecklistItemDataID": multipleHeadQues[l]
                      ['ChecklistItemDataID'],
                  "comments": multipleHeadQues[l]['comments'],
                  "ratingList": multipleHeadQues[l]['ratingList'],
                  "attachments_names": multipleHeadQues[l]['attachments_names'],
                  "attachments_paths": multipleHeadQues[l]['attachments_paths'],
                  "attachments_baseImg": multipleHeadQues[l]
                      ['attachments_baseImg'],
                });
                itemsqns.add(itemsqn);
              }
              // print("Entered for loopp  " + multipleHeadQues[l]['id']);
            }

            var subitem = {
              'id': multipleHead[k]['id'],
              'title': multipleHead[k]['title'],
              'questions': itemsqns
            };
            subitems.add(subitem);
          }
        }

        var checkList = jsonEncode({
          "id": checkObject['id'],
          "title": checkObject['title'],
          "subId": checkObject['subId'] == null ? "" : checkObject['subId'],
          "subtitle":
              checkObject['subtitle'] == null ? "" : checkObject['subtitle'],
          "questions": items,
          "subquestions": subitems
        });

        tempCheckList.add(checkList);
        // print("temp updated data");
        // print(tempCheckList);
      }

      setState(() {
        Utilities.gopaList = [];
        Utilities.gopaList = tempCheckList;
        tempCheckList = [];
      });
    } catch (e) {
      print("Error Occured " + e.toString());
    }

    // for(int i=0;i<Utilities.gopaList.length;i++){
    //   print("----------"+i.toString());
    //   print(Utilities.gopaList[i].toString());
    //   print("----------end");
    // }
  }

  getCheckListRatingIdbyName(ratingId, itemId) {
    print("ratingId");
    print(ratingId);
    // print(checklistRatingcommn);
    // print(checklistRatingIDbased);
    String? ratingName = 'Select';
    // if(Utilities.checkListDisabledIdsList.contains(itemId) && (ratingId.toString() == '3' || ratingId.toString() == '20')){
    //   ratingName = "Not Applicable";
    //   print("welcome");
    // }else{
    //   ratingName = "Select";
    // }

    for (int i = 0; i < checklistRatingcommn.length; i++) {
      if (ratingId.toString() ==
          checklistRatingcommn[i]['ratingID'].toString()) {
        ratingName = checklistRatingcommn[i]['ratingName'].toString();
      }
    }
    for (int j = 0; j < checklistRatingIDbased.length; j++) {
      if (ratingId.toString() ==
          checklistRatingIDbased[j]['ratingID'].toString()) {
        ratingName = checklistRatingIDbased[j]['ratingName'].toString();
      }
    }
    return ratingName;
  }
}



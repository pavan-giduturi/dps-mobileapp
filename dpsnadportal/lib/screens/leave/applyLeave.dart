import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cool_alert/cool_alert.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/restapi.dart';
import '../../../database/database_table.dart';
import '../../../helpers/utilities.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/responsive.dart';
import '../gopa/new/newhome.dart';


class ApplyLeave extends StatefulWidget {

  const ApplyLeave({Key? key}) : super(key: key);

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: ApplyLeavePage(),
      desktop: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: bgColor,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: ApplyLeavePage(),
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

class ApplyLeavePage extends StatefulWidget {


  const ApplyLeavePage({Key? key}) : super(key: key);

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  late DateTime fromdate;
  final TextEditingController auditIdController = TextEditingController();
  final TextEditingController _conductedByController = TextEditingController();
  String? gender;
  List searchResult = [];
  FocusNode focusnode = FocusNode();
  FocusNode focusnode1 = FocusNode();
  FocusNode focusnode2 = FocusNode();
  String splitString = '';
  List submittedByEmployees = [];
  List conductedByEmployees = [];
  List forwardToEmployees = [];
  String? selectedGroundHandler = "Select";
  String? restartOperations = "No";
  bool buttonTap = true;
  String? isagocertified = "";
  String? isauditdueDate = "";
  String? restartoperationsId = "";
  String? serviceProviderId = "";
  String? selectedStation = "Select";
  String? hoNumber = "";
  List auditList = [];
  List stationList = [];
  List airlineList = [];
  bool commentVisible = false, overviewVisible = false;
  String? airportSationId = '';
  String? sationId = '';
  String? sationName = '';
  String? APMMAILID = '';
  String? RMMAILID = '';
  String? HOMAILID = '';
  String? stationCode = '';
  String? groundHandlerId = '';
  String? auditConductedId = '';
  List auditStatus = [];
  List airLineIds = [];
  List airLineCodes = [];
  List groundHandlers = [];
  Timer? _timer;
  List restartOperationsList = [
    {"id": "1", "name": "Yes"},
    {"id": "2", "name": "No"}
  ];
  List serviceproviderList = [
    {"id": "1", "name": "Yes"},
    {"id": "2", "name": "No"}
  ];
  List dropList = ['No', 'Yes'];
  List isagoList = [
    {"id": "1", "name": "Yes"},
    {"id": "2", "name": "No"}
  ];
  List dueDates = [
    {"id": "2", "name": "No"},
    {"id": "3", "name": "Not Applicable"},
    {"id": "1", "name": "Yes"}
  ];
  List selectedAirlines = [];

  String? stationAirportValue;
  String? duedateValue;
  String? isagoValue = "Yes";
  String? serviceProviderValue = "No";
  String? statusValue;
  String? groundHandlerValue;
  String? gopaNumber;

  bool auditConduct = false;
  bool airlines = true;
  bool submittedBy = false;
  bool isAuditId = false;
  int datatableIndex = 0;
  String appTitle = "Apply Leave";
  var saveBody;
  List checkList = [];
  bool isOnline = false;
  List draftList = [];
  late int auditSatusid;
  bool isDtaftAvailble = true;
  DatabaseHelper db = DatabaseHelper();
  TextEditingController commentController = TextEditingController();

  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusnode.dispose();
    focusnode1.dispose();
    focusnode2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // makeStationApiCall();
    // makeAuditCheckListApiCall();

  }

  // getStationAndAirlines(auditId) async{
  //   db.get
  // }
  onSelectedRow(bool selected, airlines) {
    setState(() {
      if (selected == true) {
        airLineIds = [];
        airLineCodes = [];
        selectedAirlines.add(airlines['id']);
        // for (int i = 0; i < selectedAirlines.length; i++) {
        //   airLineCodes.add(selectedAirlines[i]['airlineCode'].toString());
        //   airLineIds.add(selectedAirlines[i]['id'].toString());
        // }
      } else if (selected == false) {
        selectedAirlines.remove(airlines['id']);
        // for (int i = 0; i < selectedAirlines.length; i++) {
        //   airLineIds.removeAt(i);
        //   airLineCodes.removeAt(i);
        // }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        centerTitle: true,
        backgroundColor: red,
      ),
      backgroundColor: bgColor,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Visibility(
                  visible: isAuditId,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'GOPA ID',
                          style: TextStyle(fontSize: labelSize),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          style:
                          TextStyle(fontSize: textSize, color: blackColor),
                          enabled: false,
                          controller: auditIdController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: InputBorder.none,
                            hintText: "",
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'GOPA Number',
                          style: TextStyle(fontSize: labelSize),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          enabled: false,
                          onSaved: (email) {},
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: InputBorder.none,
                            hintText: stationCode.toString() +
                                "/" +
                                "1",
                            hintStyle: TextStyle(
                                fontSize: textSize, color: blackColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),


                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    '1.3 Name of person conducting audit *',
                    style: TextStyle(fontSize: labelSize, color: blackColor),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                      enabled: auditConduct,
                      /*trailing: IconButton(
                        tooltip: 'search',
                        icon: Icon(
                          Icons.search,
                          color: blackColor,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            focusnode.requestFocus();
                          });
                        },
                      ),*/
                      title: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          style:
                          TextStyle(fontSize: textSize, color: blackColor),
                          enabled: auditConduct,
                          focusNode: focusnode,
                          controller: _conductedByController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: " Employee Name",
                            hintStyle: TextStyle(
                                fontSize: textSize, color: blackColor),
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          return await searchResult.where((suggestion) =>
                              suggestion
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()));
                        },
                        itemBuilder: (
                            context,
                            suggestion,
                            ) {
                          return ListTile(
                            leading: const Icon(
                              Icons.person_add,
                              color: blackColor,
                              size: 20.0,
                            ),
                            title: Text(
                              suggestion.toString(),
                              style: const TextStyle(
                                  fontSize: textSize, color: blackColor),
                            ),
                          );
                        },
                        onSuggestionSelected: (value) {
                          setState(() {
                            _conductedByController.text = value.toString();
                            splitString = _conductedByController.text.substring(
                                _conductedByController.text.indexOf("(") + 1,
                                _conductedByController.text.indexOf(")"));
                          });
                        },
                      )),
                ),

                const SizedBox(height: 5),

                const SizedBox(height: 15),

                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Leave Date',
                    style: TextStyle(fontSize: labelSize),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    onTap: () {
                      submittedDatepicker(context);
                    },
                    trailing: IconButton(
                      onPressed: () {
                        submittedDatepicker(context);
                      },
                      icon: Image.asset("assets/images/datepicker.png"),
                    ),
                    title: Text(
                      "",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: textSize),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Leave Type',
                    style: TextStyle(fontSize: labelSize),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 20),
                      border: InputBorder.none,
                    ),
                    isDense: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: blackColor,
                    ),
                    iconSize: 30,
                    items: restartOperationsList.map((item) {
                      return new DropdownMenuItem(
                        child: Text(
                          item['name'].toString(),
                          style: TextStyle(fontSize: 12, color: blackColor),
                        ),
                        value: item['name'],
                      );
                    }).toList(),
                    onChanged: (value) {
                      for (int i = 0; i < restartOperationsList.length; i++) {
                        if (restartOperationsList[i]['name'] ==
                            value.toString()) {
                          restartoperationsId =
                              restartOperationsList[i]['id'].toString();
                          restartOperations =
                              restartOperationsList[i]['name'].toString();
                        }
                      }
                      if (restartOperations.toString() == "No") {
                        setState(() {
                          airlines = true;
                        });
                      } else {
                        setState(() {
                          selectedAirlines = [];
                          airlines = false;
                        });
                      }
                      if (restartOperations.toString() == "Yes") {
                        setState(() {
                          duedateValue = "Not Applicable";
                          isauditdueDate = "3";
                          commentVisible = false;
                        });
                      } else {
                        setState(() {
                          duedateValue = "No";
                          isauditdueDate = "2";
                        });
                      }
                    },
                    value: restartOperations,
                  ),
                ),
                SizedBox(height: 15),

                SizedBox(height: 30),
                Center(
                    child: Visibility(
                      visible: isDtaftAvailble,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(8),
                              backgroundColor:
                              buttonTap == false ? Colors.black26 : red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: headerSize, color: whiteColor),
                            ),
                            onPressed: buttonTap == false
                                ? null
                                : () {

                            },
                          )),
                    )),
                SizedBox(height: defaultPadding * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _datePicker(BuildContext context) async {
    fromdate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ))!;


  }

  Future<void> submittedDatepicker(BuildContext context) async {
    fromdate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ))!;

  }

  stationChangeApiCalls(stationId) {
    selectedAirlines = [];
    makeAirlinesApiCall(stationId);
    makeGroundHandlerApiCall(stationId);
  }



  makeAirlinesApiCall(id) async {
    airlineList = [];
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    if (isOnline) {
      ApiService.get(
          "GetGOPAAirlinesData?StationID=$id", pref.getString('token'))
          .then((success) {
        var body = jsonDecode(success.body);
        setState(() {
          airlineList = body;
        });
      });
    } else {
      List body = await db.getAirlines(id);
      setState(() {
        for (int i = 0; i < body.length; i++) {
          airlineList.add(jsonDecode(body[i]));
        }
      });
    }
  }

  makeGroundHandlerApiCall(id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isOnline = await Utilities.CheckUserConnection();
    if (isOnline) {
      ApiService.get(
          "GetGOPAGroundhandlerData?StationID=$id", pref.getString('token'))
          .then((success) {
        var body = jsonDecode(success.body);

        setState(() {
          groundHandlers = body;
          log('ground handlers api call');
          log(groundHandlers.toString());
          if (groundHandlers.isNotEmpty) {
            selectedGroundHandler = groundHandlers[0]['groundhandlerName'];
            groundHandlerId = groundHandlers[0]['id'];
          } else {
            selectedGroundHandler = "";
            groundHandlerId = "";
          }

          log('groundhandler');
          log(groundHandlerId.toString());
        });
      });
    } else {
      var body = await db.getGroundHandler(id);
      setState(() {
        groundHandlers = body;
        if (groundHandlers.isNotEmpty) {
          selectedGroundHandler = groundHandlers[0]['groundhandlerName'];
          groundHandlerId = groundHandlers[0]['id'];
        } else {
          selectedGroundHandler = "";
          groundHandlerId = "";
        }
      });
    }
  }

  getGOPAauditById(auditId) async {
    var auditObj = await db.getGOPACheckListByAuditId(auditId);
    // var airlines = auditObj[0]['airlineIds'];
    //  onSelectedRow(true, airlines);
    // calling from database
    if (auditObj.length > 0) {
      for (int i = 0; i < auditObj.length; i++) {
        List ratingList = [];
        var rating = jsonEncode([
          {
            "id": 1,
            "name": 'Yes',
          },
          {
            "id": 2,
            "name": 'No',
          },
          {
            "id": 3,
            "name": 'Not Applicable',
          }
        ]);

        ratingList = jsonDecode(rating);
        if (auditObj[i]['ratingStatus'] == "1" ||
            auditObj[i]['ratingStatus'] == "2" ||
            auditObj[i]['ratingStatus'] == "3") {
          Utilities.filledQues += 1;
          Utilities.countFilled += 1;
        }

        var body = jsonEncode({
          "chkName": auditObj[i]['chkName'].toString(),
          "chkId": auditObj[i]['chkId'].toString(),
          "auditNumber": auditObj[i]['auditNumber'].toString(),
          "uploadFileName": "",
          "followUp": auditObj[i]['followUp'].toString(),
          "ratingStatus": auditObj[i]['ratingStatus'].toString(),
          "id": auditObj[i]['id'].toString(),
          "ratingList": ratingList,
          "subHeading": auditObj[i]['subHeading'].toString(),
        });
        setState(() {
          Utilities.gopaCheckList.add(body);
        });
      }
    }
  }

  makeAuditCheckListApiCall() async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading. . .",
    );
    auditList = [];
    var dataLength;
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
        if (success.statusCode == 200) {
          EasyLoading.addStatusCallback((status) {
            if (status == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          setState(() {
            auditList = jsonDecode(success.body);
          });
          GopaNewChecklistData(auditList);
          EasyLoading.showSuccess('Data Loading Success');
        } else {
          EasyLoading.showInfo("Data Loading Failed");
        }
      });
    } else {
      List newchecklistBody = await db.getGOPAChecklistData();

      dataLength = newchecklistBody.length;

      if (dataLength != 0) {
        EasyLoading.addStatusCallback((dataLength) {
          if (dataLength == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        setState(() {
          auditList = newchecklistBody;
        });

        GopaNewChecklistData(auditList);
        EasyLoading.showSuccess('Data Loading Success');
      } else {
        EasyLoading.showInfo("Data Loading Failed");
      }
    }
  }

  GopaNewChecklistData(auditList) {
    Utilities.gopaList = [];
    setState(() {
      if (auditList.length > 0) {
        String id = '0';

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

                  if (ratingControl.isEmpty) {
                    rating = [];
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
                    "ChecklistItemDataID": Utilities.checkListDisabledIdsList
                        .contains(auditList[j]['itemID'].toString())
                        ? disabledSingleRatingId
                        : "0",
                    "comments": "",
                    "ratingStatus": ratings,
                    "ratingList": rating,
                    "attachments_names": "",
                    "attachments_paths": "",
                    "attachments_baseImg": "",
                  });
                  items.add(item);
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

                      List ratingList = [];
                      if (ratingSubControl.isEmpty) {
                        ratingList = [];
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
                        "ratingStatus": subratings,
                        "ChecklistItemDataID": Utilities
                            .checkListDisabledIdsList
                            .contains(auditList[l]['itemID'].toString())
                            ? disabledRatingId
                            : "0",
                        "comments": "",
                        "ratingList": ratingList,
                        "attachments_names": "",
                        "attachments_paths": "",
                        "attachments_baseImg": "",
                      });
                      itemsqns.add(itemsqn);
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

  makeSaveApiCall(status) async {
    SharedPreferences prefRole = await SharedPreferences.getInstance();
    var logRole = prefRole.getString('user_role');
    var AuditType;
    if (logRole == 'APM') {
      setState(() {
        AuditType = '1';
      });
    } else if (logRole == 'RM') {
      setState(() {
        AuditType = '2';
      });
    }
    var airlinesIds;
    String? Username;
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Saving...",
    );
    var dataLength;

    SharedPreferences pref = await SharedPreferences.getInstance();
    Username = pref.getString("firstName").toString() +
        " " +
        pref.getString("lastName").toString();
    List GopaDetailsBodyData = [];
    List GopaDraftDetailsBodyData = [];

    var auditID;
    var auditNumber;

    bool isOnline = await Utilities.CheckUserConnection() as bool;
    List CCAChecklistsList = [];
    var id;
    var gopaId;
    var gopaNum;
    var airlineIds;
    var stationIds;
    var gghIds;

    if (isOnline) {
      auditID = 0;
      auditNumber = 0;

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
        "ScheduleNO":"",
        "AuditID": "0",
        "AuditType": AuditType.toString(),
        "StationID": sationId.toString().isEmpty
            ? airportSationId.toString()
            : sationId.toString(),
        "AuditDoneby": pref.getString('employeeCode'),
        "AirlineIDs": selectedAirlines.isEmpty
            ? ""
            : selectedAirlines
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('', '')
            .replaceAll(' ', ''),
        "StationCode": stationCode.toString(),
        "Restartoperations":
        restartOperations == 'No' ? '2' : restartoperationsId,
        "GGHID": groundHandlerId,
        "UserID": pref.getString('userID'),
        "CCAChecklistsList": CCAChecklistsList,
      });

      print('body----------------->>$GopaSaveBody');

      ApiService.post("NewGOPAPart1", GopaSaveBody, pref.getString('token'))
          .then((success) {
        print('body----------------->>${success.statusCode}');
        if (success.statusCode == 200) {
          EasyLoading.addStatusCallback((status) {
            if (status == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          var body = jsonDecode(success.body);
          print('response body----------------->>$body');
          if (body['auditID'] > 0) {
            id = body['auditID'];
            gopaId = body['auditID'];
            gopaNum = body['auditNumber'];

            setState(() {
              Utilities.gopaDetails = jsonEncode({
                "APMMAILID": APMMAILID.toString(),
                "RMMAILID": RMMAILID.toString(),
                "HOMAILID": HOMAILID.toString(),
                "auditId": gopaId.toString(),
                "auditNumber": gopaNum.toString(),
                "airlineIds": selectedAirlines.isEmpty
                    ? ""
                    : selectedAirlines
                    .toString()
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                    .replaceAll('', '')
                    .replaceAll(' ', ''),
                "airlineCode": airLineCodes.isEmpty
                    ? ""
                    : airLineCodes
                    .toString()
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                    .replaceAll('', ''),
                "stationId": sationId.toString().isEmpty
                    ? airportSationId.toString()
                    : sationId.toString(),
                "stationAirport": selectedStation == "Select"
                    ? sationName.toString()
                    : selectedStation.toString(),
                "stationCode": stationCode.toString().isEmpty
                    ? ""
                    : stationCode.toString(),
                "groundHandlerId": groundHandlerId,
                "groundHandler": groundHandlerValue == null
                    ? selectedGroundHandler
                    : groundHandlerValue,
                "auditDate": "",
                "conductedId": auditConductedId,
                "conductAudit": _conductedByController.text,
                "restartOperations":
                restartOperations == 'No' ? '2' : restartoperationsId,
                "restartOperationName": restartOperations,
                "allAirlinesSameServiceProvider":
                serviceProviderValue == 'No' ? '2' : serviceProviderId,
                "allAirlinesSameServiceProviderName": serviceProviderValue,
                "isagocertified": isagoValue == "Yes" ? '1' : isagocertified,
                "isagocertifiedName": isagoValue,
                "isauditduedate": isauditdueDate,
                "isauditduedateName": duedateValue,
                "submitteddate": "_submittedDate",
                "HoNumber": hoNumber,
                "messages": commentVisible == false
                    ? ""
                    : commentController.text.toString(),
              });
            });

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GopaAuditHomePage(
                      type: 'level1',
                      auditId: gopaId.toString(),
                      auditNumber: gopaNum.toString(),
                      stationName: '',
                      groundHandler: '',
                      auditDate: '',
                      conductedBy: '',
                      airlineId: body['airlineIDs']),
                ));
          } else {}
          EasyLoading.showSuccess('Saving... Success');
        } else {
          EasyLoading.showInfo("Saving Failed");
        }
      });
    } else {
      var stationID = sationId.toString().isEmpty
          ? airportSationId.toString()
          : sationId.toString();

      auditID = 'GOPA_$stationID';
      auditNumber = 'GOPA_$stationID';

      for (int i = 0; i < Utilities.gopaList.length; i++) {
        var checkObject = jsonDecode(Utilities.gopaList[i].toString());
        var singleHeadQues = jsonDecode(checkObject['questions'].toString());
        if (singleHeadQues.length > 0) {
          for (int j = 0; j < singleHeadQues.length; j++) {
            var checklistObj = jsonEncode({
              "objectID": auditID,
              "checklistID": singleHeadQues[j]['checklistID'],
              "checklistItemID": singleHeadQues[j]['itemID'],
              "checklistItemDataID":
              singleHeadQues[j]['ChecklistItemDataID'].toString(),
              "empID": pref.getString('employeeID'),
              "comments": singleHeadQues[j]['comments'].toString(),
              "checkListName": checkObject['title'],
              "itemName": singleHeadQues[j]['itemName'],
              "subchecklistID": checkObject['subId'],
              "subchecklistname": checkObject['subtitle'],
              "checklistorder": checkObject['checklistorder'],
              "subChecklistorder": checkObject['subChecklistorder'],
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
                "objectID": auditID,
                "checklistID": multipleHeadQues[l]['checklistID'],
                "checklistItemID": multipleHeadQues[l]['itemID'],
                "checklistItemDataID":
                multipleHeadQues[l]['ChecklistItemDataID'].toString(),
                "empID": pref.getString('employeeID'),
                "comments": multipleHeadQues[l]['comments'].toString(),
                "checkListName": checkObject['title'],
                "itemName": multipleHeadQues[l]['itemName'],
                "subchecklistID": multipleHead[k]['id'],
                "subchecklistname": multipleHead[k]['title'],
                "checklistorder": multipleHeadQues[l]['checklistorder'],
                "subChecklistorder": multipleHeadQues[l]['subChecklistorder'],
                // "Imagename": multipleHeadQues[l]['attachments_names'].toString(),
              });

              var ccachecklistbody = jsonDecode(checklistObj);
              CCAChecklistsList.add(ccachecklistbody);
            }
          }
        }
      }

      for (int i = 0; i < CCAChecklistsList.length; i++) {
        db.saveGOPAOverviewChecklistData(
            CCAChecklistsList[i], auditID, auditNumber, 0);
      }

      var gopaDraftDataObj = jsonEncode({
        "stationName":
        sationName.toString().isEmpty ? selectedStation : sationName,
        "gghName": "",
        "airlineIDs": selectedAirlines.isEmpty
            ? ""
            : selectedAirlines
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('', '')
            .replaceAll(' ', ''),
        "auditDate": "_selectedFromDate",
        "auditID": auditID,
        "auditDoneby": pref.getString("firstName").toString() +
            " " +
            pref.getString("lastName").toString() +
            "(" +
            pref.getString("employeeCode").toString() +
            ")",
        "statusid": 1,
        "statusName": 'Draft',
        "auditNumber": auditNumber,
      });

      var gopaBody11 = jsonDecode(gopaDraftDataObj);
      GopaDraftDetailsBodyData.add(gopaBody11);

      for (int i = 0; i < GopaDraftDetailsBodyData.length; i++) {
        db.saveGOPADraftAudits(GopaDraftDetailsBodyData[i], 0);
      }

      var gopaDataObj = jsonEncode({
        "stationName":
        sationName.toString().isEmpty ? selectedStation : sationName,
        "auditID": auditID,
        "auditDate": "_selectedFromDate",
        "HoNumber": "",
        "groundHandler": "",
        "auditDoneby": pref.getString("firstName").toString() +
            " " +
            pref.getString("lastName").toString() +
            "(" +
            pref.getString("employeeCode").toString() +
            ")",
        "airlineIDs": selectedAirlines.isEmpty
            ? ""
            : selectedAirlines
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('', '')
            .replaceAll(' ', ''),
        "statusName": 'Draft',
        "statusid": 1,
        "auditNumber": auditNumber,
        "allAirlinesSameServiceProvider": "",
        "gghid": groundHandlerId,
        "stationID": sationId.toString().isEmpty
            ? airportSationId.toString()
            : sationId.toString(),
        "submittedBy": pref.getString('employeeCode'),
        "userID": pref.getString('userID'),
        "Msg": '',
        "submittedDate": "_submittedDate",
        "restartoperations": restartOperations,
        "sameserviceprovider": "",
        "gopaNumber": stationCode.toString().isEmpty
            ? ""
            : stationCode.toString() + "/" + auditID,
        "pBhandling": "",
        "ramphandling": "",
        "cargohandling": "",
        "deicingoperations": "",
        "aircraftMarshalling": "",
        "loadcontrol": "",
        "aircraftmovement": "",
        "headsetcommunication": "",
        "passengerbridge": "",
        "isago": isagoValue == "Yes" ? 'Yes' : isagoValue.toString(),
        "duedate": "",
        "pBhandlingID": "",
        "ramphandlingID": "",
        "cargohandlingID": "",
        "deicingoperationsID": "",
        "aircraftMarshallingID": "",
        "loadcontrolID": "",
        "aircraftmovementID": "",
        "headsetcommunicationID": "",
        "passengerbridgeID": "",
        "isagoid": isagoValue == "Yes" ? '1' : isagocertified,
        "restartoperationsID":
        restartOperations == 'No' ? '2' : restartoperationsId,
        "sameserviceproviderID": "",
        "duedateID": "",
        "reason": "",
        "pBhandlingServiceProvider": "",
        "ramphandlingServiceProvider": "",
        "cargohandlingServiceProvider": "",
        "deicingoperationsServiceProvider": "",
        "aircraftMarshallingServiceProvider": "",
        "loadcontrolServiceProvider": "",
        "aircraftmovementServiceProvider": "",
        "headsetcommunicationServiceProvider": "",
        "passengerbridgeServiceProvider": "",
      });

      var gopaBody1 = jsonDecode(gopaDataObj);
      GopaDetailsBodyData.add(gopaBody1);

      for (int i = 0; i < GopaDetailsBodyData.length; i++) {
        db.saveGOPAOverviewDetails(GopaDetailsBodyData[i]);
        var sationIdOff = sationId.toString().isEmpty
            ? airportSationId.toString()
            : sationId.toString();
        var auditorNo = pref.getString("employeeCode").toString();
        var gopano = auditNumber;
        db.saveGOPANumberforMOCreate(gopano, sationIdOff, auditorNo);
      }

      dynamic data1 = await db.getGOPAData(
          pref.getString('userID'), pref.getString('employeeCode'), stationID);

      dynamic data = await db.getGOPAData(
          pref.getString('userID'), pref.getString('employeeCode'), stationID);

      dataLength = data.length;
      if (dataLength != 0) {
        EasyLoading.addStatusCallback((dataLength) {
          if (dataLength == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        for (int i = 0; i < data.length; i++) {
          setState(() {
            id = data[i]['auditID'];
            gopaId = data[i]['auditID'];
            gopaNum = data[i]['auditNumber'];
            airlineIds = data[i]['airlineIDs'].toString();
            stationIds = data[i]['stationID'];
            gghIds = data[i]['gghid'];
          });
        }

        if (gopaId.toString() != '0') {
          setState(() {
            Utilities.gopaDetails = jsonEncode({
              "APMMAILID": APMMAILID.toString(),
              "RMMAILID": RMMAILID.toString(),
              "HOMAILID": HOMAILID.toString(),
              "auditId": gopaId.toString(),
              "auditNumber": gopaNum.toString(),
              "airlineIds": selectedAirlines.isEmpty
                  ? ""
                  : selectedAirlines
                  .toString()
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .replaceAll('', '')
                  .replaceAll(' ', ''),
              "airlineCode": airLineCodes.isEmpty
                  ? ""
                  : airLineCodes
                  .toString()
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .replaceAll('', ''),
              "stationId": sationId.toString().isEmpty
                  ? airportSationId.toString()
                  : sationId.toString(),
              "stationAirport": selectedStation == "Select"
                  ? sationName.toString()
                  : selectedStation.toString(),
              "stationCode":
              stationCode.toString().isEmpty ? "" : stationCode.toString(),
              "groundHandlerId": groundHandlerId,
              "groundHandler": groundHandlerValue == null
                  ? selectedGroundHandler
                  : groundHandlerValue,
              "auditDate": "_selectedFromDate",
              "conductedId": auditConductedId,
              "conductAudit": _conductedByController.text,
              "restartOperations":
              restartOperations == 'No' ? '2' : restartoperationsId,
              "restartOperationName": restartOperations,
              "allAirlinesSameServiceProvider":
              serviceProviderValue == 'No' ? '2' : serviceProviderId,
              "allAirlinesSameServiceProviderName": serviceProviderValue,
              "isagocertified": isagoValue == "Yes" ? '1' : isagocertified,
              "isagocertifiedName": isagoValue,
              "isauditduedate": isauditdueDate,
              "isauditduedateName": duedateValue,
              "submitteddate": "_submittedDate",
              "HoNumber": hoNumber,
              "messages": commentVisible == false
                  ? ""
                  : commentController.text.toString(),
            });
          });

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GopaAuditHomePage(
                    type: 'level1',
                    auditId: gopaId.toString(),
                    auditNumber: gopaNum.toString(),
                    stationName: stationIds.toString(),
                    groundHandler: gghIds.toString(),
                    auditDate:"",
                    conductedBy: '',
                    airlineId: airlineIds),
              ));
        } else {}
        EasyLoading.showSuccess('Saving... Success');
      } else {
        EasyLoading.showInfo("Saving Failed");
      }
    }
  }
}

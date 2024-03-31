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
import 'newhome.dart';

class Level1Form extends StatefulWidget {
  final String type,
      auditId,
      auditNumber,
      stationName,
      groundHandler,
      auditDate,
      conductedBy,
      airlineId,
      gopaScheduleNo,
      gopaScheduledDate;

  const Level1Form({
    Key? key,
    required this.type,
    required this.auditId,
    required this.auditNumber,
    required this.stationName,
    required this.groundHandler,
    required this.auditDate,
    required this.conductedBy,
    required this.airlineId,
    required this.gopaScheduleNo,
    required this.gopaScheduledDate,
  }) : super(key: key);

  @override
  State<Level1Form> createState() => _Level1FormState();
}

class _Level1FormState extends State<Level1Form> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Level1FormPage(
        type: widget.type,
        auditId: widget.auditId,
        auditNumber: widget.auditNumber,
        conductedBy: widget.conductedBy,
        auditDate: widget.auditDate,
        stationName: widget.stationName,
        groundHandler: widget.groundHandler,
        airlineId: widget.airlineId,
        gopaScheduleNo: widget.gopaScheduleNo,
        gopaScheduledDate: widget.gopaScheduledDate,
      ),
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
                    child: Level1FormPage(
                      type: widget.type,
                      auditId: widget.auditId,
                      auditNumber: widget.auditNumber,
                      conductedBy: widget.conductedBy,
                      auditDate: widget.auditDate,
                      stationName: widget.stationName,
                      groundHandler: widget.groundHandler,
                      airlineId: widget.airlineId,
                      gopaScheduleNo: widget.gopaScheduleNo,
                      gopaScheduledDate: widget.gopaScheduledDate,
                    ),
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

class Level1FormPage extends StatefulWidget {
  final String type,
      auditId,
      auditNumber,
      stationName,
      groundHandler,
      auditDate,
      conductedBy,
      airlineId,
      gopaScheduleNo,
      gopaScheduledDate;

  Level1FormPage({
    Key? key,
    required this.type,
    required this.auditId,
    required this.auditNumber,
    required this.stationName,
    required this.groundHandler,
    required this.auditDate,
    required this.conductedBy,
    required this.airlineId,
    required this.gopaScheduleNo,
    required this.gopaScheduledDate,
  }) : super(key: key);

  @override
  State<Level1FormPage> createState() => _Level1FormPageState();
}

class _Level1FormPageState extends State<Level1FormPage> {
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
  String appTitle = "New";
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
    makeStationApiCall();
    makeAuditCheckListApiCall();
    log(widget.gopaScheduleNo.toString());
    log(widget.gopaScheduledDate.toString());
    log(widget.groundHandler.toString());
    log(widget.stationName.toString());
    if (widget.type == "draft") {
      setDropdownValues();
      setState(() {
        overviewVisible = true;
      });
    } else {
      setState(() {
        overviewVisible = false;
      });
    }
    setState(() {
      if (widget.type == "draft") {
        setDropdownValues();
        selectedAirlines = [];
        setState(() {
          var str = widget.airlineId.toString().split(',');
          for (int i = 0; i < str.length; i++) {
            if (str[i].toString() != 'null') {
              selectedAirlines.add(str[i].trim());
            }
          }
          appTitle = "Draft";
          auditSatusid = 1;
          isAuditId = true;
          selectedStation = widget.stationName;
          selectedGroundHandler = widget.groundHandler;
          auditIdController.text = widget.auditNumber;
          _conductedByController.text = widget.conductedBy;
        });
      } else {
        setState(() {
          isAuditId = false;
        });
      }
    });
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
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: darkgrey),
                  child: Center(
                      child: Text("1. STATION SYNOPSIS",
                          style: TextStyle(color: whiteColor))),
                ),
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
                                widget.auditNumber,
                            hintStyle: TextStyle(
                                fontSize: textSize, color: blackColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    '1.1 Station/Airport *',
                    style: TextStyle(fontSize: labelSize),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    hint: Text(
                      selectedStation.toString(),
                      style: const TextStyle(
                          fontSize: textSize, color: blackColor),
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 20),
                      border: InputBorder.none,
                    ),
                    isDense: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black26,
                    ),
                    iconSize: 30,
                    items: stationList.map((item) {
                      return DropdownMenuItem(
                        enabled: false,
                        child: Text(
                          item['stationName'].toString(),
                          style:
                              const TextStyle(fontSize: 12, color: blackColor),
                        ),
                        value: item['stationName'],
                      );
                    }).toList(),
                    onChanged: widget.stationName.isNotEmpty
                        ? null
                        : stationList.length > 1
                            ? (value) {
                                for (int i = 0; i < stationList.length; i++) {
                                  if (stationList[i]['stationName'] == value) {
                                    sationId = stationList[i]['id'];
                                    sationName = stationList[i]['stationName'];
                                    stationCode = stationList[i]['stationCode'];

                                    APMMAILID = stationList[i]['apmmailid'];
                                    RMMAILID = stationList[i]['rmmailid'];
                                    HOMAILID = stationList[i]['homailid'];
                                  }
                                }
                                stationChangeApiCalls(sationId);
                              }
                            : null,
                    value: stationAirportValue,
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    '1.2 Ground Handler *',
                    style: TextStyle(fontSize: labelSize),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      color: widget.type == "draft"
                          ? Colors.black26
                          : groundHandlers.length < 2
                              ? Colors.black26
                              : cardColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    hint: Text(
                      selectedGroundHandler.toString(),
                      style: TextStyle(fontSize: textSize, color: blackColor),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 20),
                      border: InputBorder.none,
                    ),
                    isDense: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: widget.type == "draft"
                          ? Colors.black26
                          : groundHandlers.length < 2
                              ? Colors.black26
                              : blackColor,
                    ),
                    iconSize: 30,
                    items: groundHandlers.map((item) {
                      return new DropdownMenuItem(
                        enabled: groundHandlers.length < 2 ? false : true,
                        child: Text(
                          item['groundhandlerName'].toString(),
                          style: TextStyle(fontSize: textSize),
                        ),
                        value: item['groundhandlerName'],
                      );
                    }).toList(),
                    onChanged: groundHandlers.length < 2
                        ? null
                        : (value) {
                            for (int i = 0; i < groundHandlers.length; i++) {
                              if (groundHandlers[i]['groundhandlerName'] ==
                                  value) {
                                groundHandlerId = groundHandlers[i]['id'];
                              }
                            }
                          },
                    value: groundHandlerValue,
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
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    '1.5 Date of conducting audit *',
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
                      // _datePicker(context);
                    },
                    // trailing: IconButton(
                    //   onPressed: () {
                    //     // _datePicker(context);
                    //   },
                    //   icon: Image.asset("assets/images/datepicker.png"),
                    // ),
                    title: Text(
                      widget.gopaScheduledDate.toString(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: textSize),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    '1.6 Are all airlines operating to station are handled by the same service provider ?*',
                    style: TextStyle(fontSize: labelSize),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFdbdbdb),
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
                      color: Colors.black,
                    ),
                    iconSize: 30,
                    items: serviceproviderList.map((item) {
                      return new DropdownMenuItem(
                        child: Text(
                          item['name'].toString(),
                          style: TextStyle(fontSize: 12, color: blackColor),
                        ),
                        value: item['name'],
                      );
                    }).toList(),
                    onChanged: (value) {
                      for (int i = 0; i < serviceproviderList.length; i++) {
                        if (serviceproviderList[i]['name'] ==
                            value.toString()) {
                          serviceProviderId =
                              serviceproviderList[i]['id'].toString();
                          serviceProviderValue =
                              serviceproviderList[i]['name'].toString();
                        }
                      }
                    },
                    value: serviceProviderValue,
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Submitted Date',
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
                    '1.7 Is this GOPA being conducted with restart of operations ?*',
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
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Airlines',
                    style: TextStyle(fontSize: labelSize),
                  ),
                ),
                SizedBox(height: 5),
                airlineList.isEmpty
                    ? Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'No Data',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: DataTable(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          showCheckboxColumn: true,
                          border: TableBorder.all(color: bgColor),
                          columns: [
                            DataColumn(
                                label: Text('Id', textAlign: TextAlign.center)),
                            DataColumn(
                                label:
                                    Text('Code', textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text(
                              'Airline Name',
                              textAlign: TextAlign.center,
                            )),
                          ],
                          rows: airlineList
                              .map(
                                (item) => DataRow(
                                    selected: airlines == true
                                        ? selectedAirlines.contains(item['id'])
                                        : false,
                                    onSelectChanged: airlines == true
                                        ? (value) {
                                            onSelectedRow(value!, item);
                                          }
                                        : null,
                                    cells: [
                                      DataCell(
                                        Text(
                                          item['id'],
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          item['airlineCode'],
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: Text(
                                            item['airlineName'],
                                          ),
                                        ),
                                      ),
                                    ]),
                              )
                              .toList(),
                        ),
                      ),
                SizedBox(height: 5),
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
                          'Save & Continue',
                          style: TextStyle(
                              fontSize: headerSize, color: whiteColor),
                        ),
                        onPressed: buttonTap == false
                            ? null
                            : () {
                                setState(() {
                                  if ((restartOperations == "No") &&
                                      (selectedAirlines.isEmpty)) {
                                    Utilities.showAlert(
                                        context, "Please select Airlines");
                                  } else if (isagoValue == "") {
                                    setState(() {
                                      Utilities.showAlert(context,
                                          "Please select ISAGO Certified");
                                    });
                                  } else if (selectedGroundHandler
                                          .toString()
                                          .isEmpty ||
                                      selectedGroundHandler == "Select") {
                                    setState(() {
                                      Utilities.showAlert(context,
                                          "1.2 Ground handlers Required");
                                    });
                                  } else {
                                    if (widget.type == "draft") {

                                    } else {
                                      setState(() {
                                        buttonTap = false;
                                      });
                                      Future.delayed(const Duration(seconds: 5),
                                          () {
                                        setState(() {
                                          buttonTap = true;
                                        });
                                      });
                                      gopaclosedbasedonGroundHandler();
                                    }
                                  }
                                });
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

  setDropdownValues() async {
    var gopaId = widget.auditId;
    var gopaNumber = widget.auditNumber;
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    if (isOnline) {
      ApiService.get(
              "GetGOPADataBasedonAuditID?AuditID=$gopaId&AuditNumber=$gopaNumber",
              pref.getString('token'))
          .then((success) {
        var body = jsonDecode(success.body);
        var data = body['auditGOPAOverviewMaindata'];

        setState(() {
          restartOperations = data[0]['restartoperations'];
          duedateValue = data[0]['duedate'];
          isagoValue = data[0]['isago'];
          serviceProviderValue = data[0]['sameserviceprovider'];
          restartoperationsId = data[0]['restartoperationsID'];

          if (data[0]['sameserviceproviderID'] == null) {
            serviceProviderId = '2';
          } else {
            serviceProviderId = data[0]['sameserviceproviderID'];
          }
          isagocertified = data[0]['isagoid'];
          isauditdueDate = data[0]['duedateID'];
          if (duedateValue == "No") {
            commentVisible = true;
            commentController.text = data[0]['reason'];
          }

          if (restartOperations == "No") {
            setState(() {
              airlines = true;
            });
          } else {
            setState(() {
              selectedAirlines = [];
              airlines = false;
            });
          }
        });
      });
    } else {
      List overviewBody =
          await db.getGOPAOverviewDataByAuditId(widget.auditNumber);
      setState(() {
        var data = overviewBody;
        for (int i = 0; i < data.length; i++) {
          restartOperations = data[i]['restartoperations'];
          duedateValue = data[i]['duedate'];
          isagoValue = data[i]['isago'];
          serviceProviderValue = data[i]['sameserviceprovider'];
          restartoperationsId = data[i]['restartoperationsID'];
          serviceProviderId = data[i]['sameserviceproviderID'];
          isagocertified = data[i]['isagoid'];
          isauditdueDate = data[i]['duedateID'];
          if (duedateValue == "No") {
            commentVisible = true;
            commentController.text = data[i]['reason'];
          }
        }
        if (restartOperations == "No") {
          setState(() {
            airlines = true;
          });
        } else {
          setState(() {
            selectedAirlines = [];
            airlines = false;
          });
        }
      });
    }
  }

  gopaclosedbasedonGroundHandler() async {
    bool isdraftExist = false;
    var draftObj = Utilities.draftList;
    for (int i = 0; i < draftObj.length; i++) {
      if (draftObj[i]['stationName'] == widget.stationName.toString()) {
        setState(() {
          isdraftExist = true;
        });
      }
    }

    SharedPreferences prefRole = await SharedPreferences.getInstance();
    SharedPreferences pref = await SharedPreferences.getInstance();
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

    bool isOnline = await Utilities.CheckUserConnection();

    if (isOnline) {
      if (isdraftExist == true) {
        CoolAlert.show(
            context: context,
            title: "Drafted GOPA is found for this Station",
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
        log('IsGOPAClosedbasedGH');
        log(groundHandlerId.toString());
        ApiService.get(
                "IsGOPAClosedbasedGH?StationID=${sationId.toString().isEmpty ? airportSationId.toString() : sationId.toString()}&EMPNO=${pref.getString('employeeCode')}&GHID=$groundHandlerId&AuditType=$auditType",
                pref.getString('token'))
            .then((success) {
          setState(() {
            var body = jsonDecode(success.body);

            print("IsGOPAClosedbasedGH");
            print(body);

            if (body.length > 0 &&
                (body[0]['capaFullNumbers'] != "" ||
                    body[0]['capaFullNumbers'].toString().isNotEmpty)) {
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
                  },
                  showCancelBtn: false,
                  confirmBtnColor: Colors.deepOrangeAccent);
            } else {
              makeSaveApiCall(1);
            }
          });
        });
      }
    } else {
      if (isdraftExist == true) {
        CoolAlert.show(
            context: context,
            title: "Drafted GOPA is found for this Station",
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
        var StationID = sationId.toString().isEmpty
            ? airportSationId.toString()
            : sationId.toString();
        var EMPNO = pref.getString('employeeCode');
        var GHID = groundHandlerId;
        var AuditType = auditType;
        List body =
            await db.GetIsGOPAClosedbasedGH(StationID, EMPNO, GHID, AuditType);
        if (body[0]['capaFullNumbers'] != "" ||
            body[0]['capaFullNumbers'].toString().isNotEmpty) {
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
              },
              showCancelBtn: false,
              confirmBtnColor: Colors.deepOrangeAccent);
        } else {
          makeSaveApiCall(1);
        }
      }
    }
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

  makeStationApiCall() async {
    stationList = [];
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading. . .",
    );
    // _fetchData(context);
    var dataLength;
    setState(() {
      auditConductedId = pref.getString("employeeCode").toString();
      _conductedByController.text = pref.getString("firstName").toString() +
          " " +
          pref.getString("lastName").toString() +
          " (" +
          pref.getString("employeeCode").toString() +
          ")";
    });
    bool isOnline = await Utilities.CheckUserConnection() as bool;

    if (isOnline) {
      ApiService.get(
              "GetGOPAStationsData?EMPNO=${pref.getString('employeeCode')}",
              pref.getString('token'))
          .then((success) {
        if (success.statusCode == 200) {
          EasyLoading.addStatusCallback((status) {
            if (status == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          setState(() {
            var body = jsonDecode(success.body);

            stationList = body;
            setStationData(stationList);
          });
          // EasyLoading.showSuccess('Data Loading Success');
        } else {
          EasyLoading.showInfo("Station Data Loading Failed");
        }
      });
    } else {
      var body = await db.getStation(pref.getString('employeeCode'));
      setState(() {
        dataLength = body.length;

        if (dataLength != 0) {
          EasyLoading.addStatusCallback((dataLength) {
            if (dataLength == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          stationList = body;
          setStationData(stationList);
          // EasyLoading.showSuccess('Data Loading Success');
        } else {
          EasyLoading.showInfo("Station Data Loading Failed");
        }
      });
    }
  }

  setStationData(stationList) {
    if (stationList.length < 2) {
      airportSationId = stationList[0]['id'];

      selectedStation = stationList[0]['stationName'];
      stationCode = stationList[0]['stationCode'];
      hoNumber = stationList[0]['ho'];
      Utilities.apmNumber = stationList[0]['apm'];
      Utilities.rmNumber = stationList[0]['rm'];
    } else {
      for (int i = 0; i < stationList.length; i++) {
        if (stationList[i]['stationName'] == widget.stationName) {
          airportSationId = stationList[i]['id'];
          selectedStation = stationList[i]['stationName'];
          stationCode = stationList[i]['stationCode'];
          hoNumber = stationList[i]['ho'];
          Utilities.apmNumber = stationList[i]['apm'];
          Utilities.rmNumber = stationList[i]['rm'];
        } else {
          hoNumber = stationList[i]['ho'];
          Utilities.apmNumber = stationList[i]['apm'];
          Utilities.rmNumber = stationList[i]['rm'];
        }
      }
    }

    makeAirlinesApiCall(airportSationId);
    makeGroundHandlerApiCall(airportSationId);
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
        "ScheduleNO":widget.gopaScheduleNo.toString(),
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

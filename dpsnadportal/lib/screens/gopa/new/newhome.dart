import 'dart:async';
import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiservice/restapi.dart';
import '../../../database/database_table.dart';
import '../../../helpers/utilities.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/responsive.dart';
import '../home/gopahome.dart';

class GopaAuditHomePage extends StatefulWidget {
  final String type,
      auditId,
      auditNumber,
      stationName,
      groundHandler,
      auditDate,
      conductedBy,
      airlineId;

  const GopaAuditHomePage({
    Key? key,
    required this.type,
    required this.auditId,
    required this.auditNumber,
    required this.stationName,
    required this.groundHandler,
    required this.auditDate,
    required this.conductedBy,
    required this.airlineId,
  }) : super(key: key);

  @override
  State<GopaAuditHomePage> createState() => _GopaAuditHomePageState();
}

class _GopaAuditHomePageState extends State<GopaAuditHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: GopaAuditHomePage1(
        type: widget.type,
        auditId: widget.auditId,
        auditNumber: widget.auditNumber,
        conductedBy: widget.conductedBy,
        auditDate: widget.auditDate,
        stationName: widget.stationName,
        groundHandler: widget.groundHandler,
        airlineId: widget.airlineId,
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
                    child: GopaAuditHomePage1(
                      type: widget.type,
                      auditId: widget.auditId,
                      auditNumber: widget.auditNumber,
                      conductedBy: widget.conductedBy,
                      auditDate: widget.auditDate,
                      stationName: widget.stationName,
                      groundHandler: widget.groundHandler,
                      airlineId: widget.airlineId,
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

class GopaAuditHomePage1 extends StatefulWidget {
  final String type,
      auditId,
      auditNumber,
      stationName,
      groundHandler,
      auditDate,
      conductedBy,
      airlineId;

  const GopaAuditHomePage1({
    Key? key,
    required this.type,
    required this.auditId,
    required this.auditNumber,
    required this.stationName,
    required this.groundHandler,
    required this.auditDate,
    required this.conductedBy,
    required this.airlineId,
  }) : super(key: key);

  @override
  State<GopaAuditHomePage1> createState() => _GopaAuditHomePage1State();
}

class _GopaAuditHomePage1State extends State<GopaAuditHomePage1> {
  late DateTime fromdate;
  String _selectedFromDate = "";
  String _submittedDate = "";
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
  String? isagocertified = "";
  String? isauditdueDate = "";
  String? restartoperationsId = "";
  String? serviceProviderId = "";
  String? selectedStation = "Select";
  String? hoNumber = "";
  List auditList = [];
  List stationList = [];
  List airlineList = [];
  bool commentVisible = false;
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
  String? gopaNumberwithstationCode = "";
  Timer? _timer;
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
  bool isDtaftAvailble = true;
  DatabaseHelper db = DatabaseHelper();
  TextEditingController commentController = TextEditingController();

  @override
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

    if (widget.type == 'level1') {
      makeStationApiCall();
      setLevel1DropdownValues();
      setState(() {
        isAuditId = true;
        selectedAirlines = [];
        var str = widget.airlineId.toString().split(',');
        for (int i = 0; i < str.length; i++) {
          if (str[i].toString() != 'null') {
            selectedAirlines.add(str[i].trim());
          }
        }
        auditIdController.text = widget.auditNumber;
      });
    } else if (widget.type == 'draft') {
      makeStationApiCall();
      setDropdownValues();
      setState(() {
        selectedAirlines = [];
        var str = widget.airlineId.toString().split(',');
        for (int i = 0; i < str.length; i++) {
          if (str[i].toString() != 'null') {
            selectedAirlines.add(str[i].trim());
          }
        }
      });
    } else {
      makeStationApiCall();
      setState(() {
        isAuditId = false;
      });
    }
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
      } else if (selected == false) {
        selectedAirlines.remove(airlines['id']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.type == 'draft' ? true : false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          centerTitle: true,
          backgroundColor: red,
          actions: [
            IconButton(
                tooltip: "GOPA HOME",
                onPressed: () {
                  Utilities.gopaDetails = {};
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const GopaHome()),
                      (Route<dynamic> route) => false);
                },
                icon: const Icon(
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: darkgrey),
                    child: const Center(
                        child: Text("1. STATION SYNOPSIS",
                            style: TextStyle(color: whiteColor))),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: isAuditId,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            'GOPA ID',
                            style: TextStyle(fontSize: labelSize),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            style: const TextStyle(
                                fontSize: textSize, color: blackColor),
                            enabled: false,
                            controller: auditIdController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                              hintText: "",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            'GOPA Number',
                            style: TextStyle(fontSize: labelSize),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            enabled: false,
                            onSaved: (email) {},
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                              hintText: gopaNumberwithstationCode.toString(),
                              hintStyle: const TextStyle(
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
                        color:
                            widget.type == "draft" ? Colors.black26 : cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      hint: Text(
                        selectedStation.toString(),
                        style: const TextStyle(fontSize: textSize, color: blackColor),
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 20),
                        border: InputBorder.none,
                      ),
                      isDense: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: widget.type == "draft"
                            ? Colors.black26
                            : blackColor,
                      ),
                      iconSize: 30,
                      items: stationList.map((item) {
                        return DropdownMenuItem(
                          enabled: widget.type == "draft" ? false : true,
                          child: Text(
                            item['stationName'].toString(),
                            style: const TextStyle(fontSize: 12, color: blackColor),
                          ),
                          value: item['stationName'],
                        );
                      }).toList(),
                      onChanged: widget.type == "draft" ||
                              widget.type == "level1"
                          ? null
                          : stationList.length > 1
                              ? (value) {
                                  for (int i = 0; i < stationList.length; i++) {
                                    if (stationList[i]['stationName'] ==
                                        value) {
                                      sationId = stationList[i]['id'];
                                      sationName =
                                          stationList[i]['stationName'];
                                      stationCode =
                                          stationList[i]['stationCode'];
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
                        style: const TextStyle(fontSize: textSize, color: blackColor),
                      ),
                      decoration: const InputDecoration(
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
                        return DropdownMenuItem(
                          enabled: widget.type == "draft"
                              ? false
                              : groundHandlers.length < 2
                                  ? false
                                  : true,
                          child: Text(
                            item['groundhandlerName'].toString(),
                            style: const TextStyle(fontSize: textSize),
                          ),
                          value: item['groundhandlerName'],
                        );
                      }).toList(),
                      onChanged: widget.type == "draft"
                          ? null
                          : groundHandlers.length < 2
                              ? null
                              : (value) {
                                  for (int i = 0;
                                      i < groundHandlers.length;
                                      i++) {
                                    if (groundHandlers[i]
                                            ['groundhandlerName'] ==
                                        value) {
                                      groundHandlerId = groundHandlers[i]['id'];
                                    }
                                  }
                                },
                      value: groundHandlerValue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      '1.3 Name of person conducting audit *',
                      style: TextStyle(fontSize: labelSize),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                        enabled: auditConduct,
                        title: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            style: const TextStyle(
                                fontSize: textSize, color: blackColor),
                            enabled: auditConduct,
                            focusNode: focusnode,
                            controller: _conductedByController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: " Employee Name",
                              hintStyle: TextStyle(fontSize: textSize),
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
                                style: const TextStyle(fontSize: textSize),
                              ),
                            );
                          },
                          onSuggestionSelected: (value) {
                            setState(() {
                              _conductedByController.text = value.toString();
                              splitString = _conductedByController.text
                                  .substring(
                                      _conductedByController.text.indexOf("(") +
                                          1,
                                      _conductedByController.text.indexOf(")"));
                            });
                          },
                        )),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      '1.4 Is the Ground Handler ISAGO certified ?',
                      style: TextStyle(fontSize: labelSize),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFdbdbdb),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      hint: Text(
                        isagoValue.toString(),
                        style: const TextStyle(fontSize: textSize, color: blackColor),
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 20),
                        border: InputBorder.none,
                      ),
                      isDense: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      iconSize: 30,
                      items: isagoList.map((item) {
                        return DropdownMenuItem(
                          child: Text(
                            item['name'].toString(),
                            style: const TextStyle(fontSize: 12, color: blackColor),
                          ),
                          value: item['name'],
                        );
                      }).toList(),
                      onChanged: isagoList.length < 0
                          ? null
                          : (value) {
                              for (int i = 0; i < isagoList.length; i++) {
                                if (isagoList[i]['name'] == value.toString()) {
                                  isagocertified =
                                      isagoList[i]['id'].toString();
                                  isagoValue = isagoList[i]['name'].toString();
                                }
                              }
                            },
                      value: isagoValue,
                    ),
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
                        _datePicker(context);
                      },
                      // trailing: IconButton(
                      //   onPressed: () {
                      //     _datePicker(context);
                      //   },
                      //   icon: Image.asset("assets/images/datepicker.png"),
                      // ),
                      title: Text(
                        _selectedFromDate,
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
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFdbdbdb),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 20),
                        border: InputBorder.none,
                      ),
                      isDense: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      iconSize: 30,
                      items: serviceproviderList.map((item) {
                        return DropdownMenuItem(
                          child: Text(
                            item['name'].toString(),
                            style: const TextStyle(fontSize: 12, color: blackColor),
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
                        _submittedDate,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: textSize),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      '1.7 Is this GOPA being conducted with restart of operations ?*',
                      style: TextStyle(fontSize: labelSize),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 20),
                        border: InputBorder.none,
                      ),
                      isDense: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: blackColor,
                      ),
                      iconSize: 30,
                      items: restartOperationsList.map((item) {
                        return DropdownMenuItem(
                          child: Text(
                            item['name'].toString(),
                            style: const TextStyle(fontSize: 12, color: blackColor),
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
                          });
                        } else {
                          setState(() {
                            duedateValue = "Yes";
                            isauditdueDate = "1";
                          });
                        }
                      },
                      value: restartOperations,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Airlines',
                      style: TextStyle(fontSize: labelSize),
                    ),
                  ),
                  const SizedBox(height: 5),
                  airlineList.isEmpty
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          alignment: Alignment.centerLeft,
                          child: const Text(
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
                            columns: const [
                              DataColumn(
                                  label:
                                      Text('Id', textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Code',
                                      textAlign: TextAlign.center)),
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
                                          ? selectedAirlines
                                              .contains(item['id'])
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
                  const SizedBox(height: 5),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      '1.8 Is audit conducted within due date *',
                      style: TextStyle(fontSize: labelSize),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 20),
                        border: InputBorder.none,
                      ),
                      isDense: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: restartOperations == "Yes"
                            ? Colors.black26
                            : blackColor,
                      ),
                      iconSize: 30,
                      items: dueDates.map((item) {
                        return DropdownMenuItem(
                          child: Text(
                            item['name'].toString(),
                            style: const TextStyle(fontSize: 12, color: blackColor),
                          ),
                          value: item['name'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        for (int i = 0; i < dueDates.length; i++) {
                          if (dueDates[i]['name'] == value.toString()) {
                            isauditdueDate = dueDates[i]['id'].toString();
                            duedateValue = dueDates[i]['name'].toString();
                          }
                        }

                        if (isauditdueDate == '2') {
                          setState(() {
                            commentVisible = true;
                          });
                        } else {
                          setState(() {
                            commentVisible = false;
                            commentController.text = "";
                          });
                        }
                      },
                      value: duedateValue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: commentVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Reason if No is selected',
                            style: TextStyle(fontSize: labelSize),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFdbdbdb),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            style: const TextStyle(
                                fontSize: textSize, color: blackColor),
                            controller: commentController,
                            minLines: 3,
                            maxLines: null,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 10, top: 10),
                                border: InputBorder.none,
                                hintText: "Allow 3000 characters only",
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                      child: Visibility(
                    visible: isDtaftAvailble,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(8), backgroundColor: red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: headerSize, color: whiteColor),
                          ),
                          onPressed: () {
                            setState(() {
                              if ((restartOperations == "No") &&
                                  (selectedAirlines.isEmpty)) {
                                Utilities.showAlert(
                                    context, "Please select Airlines");
                              } else if (isagoValue == "") {
                                setState(() {
                                  Utilities.showAlert(
                                      context, "Please select ISAGO Certified");
                                });
                              } else if (isauditdueDate.toString().isEmpty &&
                                  restartOperations == "No") {
                                setState(() {
                                  Utilities.showAlert(context,
                                      "Please select Is audit being conducting with in due dates");
                                });
                              } else if (selectedGroundHandler
                                      .toString()
                                      .isEmpty ||
                                  selectedGroundHandler == "Select") {
                                setState(() {
                                  Utilities.showAlert(
                                      context, "1.2 Ground handlers Required");
                                });
                              } else {
                                if (widget.type == "draft" ||
                                    widget.type == "level1") {

                                } else {
                                  gopaclosedbasedonGroundHandler();
                                }
                              }
                              Utilities.gopaDetails = jsonEncode({
                                "APMMAILID": APMMAILID.toString(),
                                "RMMAILID": RMMAILID.toString(),
                                "HOMAILID": HOMAILID.toString(),
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
                                "auditId": widget.auditId,
                                "auditNumber": widget.auditNumber,
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
                                "groundHandler": groundHandlerValue ?? selectedGroundHandler,
                                "auditDate": _selectedFromDate,
                                "conductedId": auditConductedId,
                                "conductAudit": _conductedByController.text,
                                "restartOperations": restartOperations == 'No'
                                    ? '2'
                                    : restartoperationsId,
                                "restartOperationName": restartOperations,
                                "allAirlinesSameServiceProvider":
                                    serviceProviderValue == 'No'
                                        ? '2'
                                        : serviceProviderId,
                                "allAirlinesSameServiceProviderName":
                                    serviceProviderValue,
                                "isagocertified":
                                    isagoValue == "Yes" ? '1' : isagocertified,
                                "isagocertifiedName": isagoValue,
                                "isauditduedate": isauditdueDate,
                                "isauditduedateName": duedateValue,
                                "submitteddate": _submittedDate,
                                "HoNumber": hoNumber,
                                "messages": commentVisible == false
                                    ? ""
                                    : commentController.text.toString(),
                              });
                            });
                          },
                        )),
                  )),
                  const SizedBox(height: defaultPadding * 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  setDropdownValues() async {
    var gopaId = widget.auditId;
    var gopaNumber = widget.auditNumber;
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading. . .",
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    var dataLength;
    bool isOnline = await Utilities.CheckUserConnection();
    var arry = gopaNumber.toString().split("_");
    if (isOnline && !arry.contains("GOPA")) {
      ApiService.get(
              "GetGOPADataBasedonAuditID?AuditID=$gopaId&AuditNumber=$gopaNumber",
              pref.getString('token'))
          .then((success) {
        if (success.statusCode == 200) {
          EasyLoading.addStatusCallback((status) {
            if (status == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          var body = jsonDecode(success.body);
          var data = body['auditGOPAOverviewMaindata'];
          setState(() {
            appTitle = "Draft";
            isAuditId = true;
            auditIdController.text = widget.auditNumber;
            gopaNumberwithstationCode = data[0]['gopaNumber'];
            _selectedFromDate = widget.auditDate.toString().isEmpty
                ? data[0]['auditDate']
                : widget.auditDate.toString();
            selectedStation = data[0]['stationName'];
            selectedGroundHandler = data[0]['groundHandler'];
            restartOperations = data[0]['restartoperations'];
            restartoperationsId = data[0]['restartoperationsID'];
            _conductedByController.text = data[0]['auditDoneby'];
            restartOperations = data[0]['restartoperations'];
            if (data[0]['duedate'].toString() == "") {
              duedateValue = "Yes";
              isauditdueDate = "1";
            } else {
              duedateValue = data[0]['duedate'].toString();
              isauditdueDate = data[0]['duedateID'].toString();
            }

            if (data[0]['isago'].toString() == "") {
              isagoValue = "No";
              isagocertified = "2";
            } else {
              isagoValue = data[0]['isago'].toString();
              isagocertified = data[0]['isagoid'].toString();
            }

            if (data[0]['sameserviceprovider'].toString() == "") {
              serviceProviderValue = "No";
              serviceProviderId = '2';
            } else {
              serviceProviderValue = data[0]['sameserviceprovider'].toString();
              serviceProviderId = data[0]['sameserviceproviderID'];
            }

            restartoperationsId = data[0]['restartoperationsID'];

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
                duedateValue = "Not Applicable";
                isauditdueDate = "3";
              });
            }
          });
          EasyLoading.showSuccess('Data Loading Success');
        } else {
          EasyLoading.showInfo("Data Loading Failed");
        }
      });
    } else {
      List data = await db.getGOPAOverviewDataByAuditId(widget.auditId);

      dataLength = data.length;

      if (dataLength != 0) {
        EasyLoading.addStatusCallback((dataLength) {
          if (dataLength == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        setState(() {
          appTitle = "Draft";
          isAuditId = true;
          auditIdController.text = widget.auditNumber;
          gopaNumberwithstationCode = data[0]['gopaNumber'];
          _selectedFromDate = widget.auditDate.toString().isEmpty
              ? data[0]['auditDate']
              : widget.auditDate.toString();
          selectedStation = data[0]['stationName'];
          selectedGroundHandler = data[0]['groundHandler'];
          restartOperations = data[0]['restartoperations'];
          restartoperationsId = data[0]['restartoperationsID'];
          _conductedByController.text = data[0]['auditDoneby'];
          restartOperations = data[0]['restartoperations'];
          if (data[0]['duedate'].toString() == "") {
            duedateValue = "Yes";
            isauditdueDate = "1";
          } else {
            duedateValue = data[0]['duedate'].toString();
            isauditdueDate = data[0]['duedateID'].toString();
          }

          if (data[0]['isago'].toString() == "") {
            isagoValue = "No";
            isagocertified = "2";
          } else {
            isagoValue = data[0]['isago'].toString();
            isagocertified = data[0]['isagoid'].toString();
          }

          if (data[0]['sameserviceprovider'].toString() == "") {
            serviceProviderValue = "No";
            serviceProviderId = '2';
          } else {
            serviceProviderValue = data[0]['sameserviceprovider'].toString();
            serviceProviderId = data[0]['sameserviceproviderID'];
          }

          restartoperationsId = data[0]['restartoperationsID'];

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
              duedateValue = "Not Applicable";
              isauditdueDate = "3";
            });
          }
        });

        EasyLoading.showSuccess('Data Loading Success');
      } else {
        EasyLoading.showInfo("Data Loading Failed");
      }

      // setState(() {
      //   isAuditId = true;
      //   var data = overviewBody;
      //   for (int i = 0; i < data.length; i++) {
      //     auditIdController.text = widget.auditNumber;
      //     gopaNumberwithstationCode = data[i]['gopaNumber'];
      //     restartOperations = data[i]['restartoperations'];
      //     duedateValue = data[i]['duedate'];
      //     isagoValue = data[i]['isago'];
      //     serviceProviderValue = data[i]['sameserviceprovider'];
      //     restartoperationsId = data[i]['restartoperationsID'];
      //     serviceProviderId = data[i]['sameserviceproviderID'];
      //     isagocertified = data[i]['isagoid'];
      //     isauditdueDate = data[i]['duedateID'];
      //     if (duedateValue == "No") {
      //       commentVisible = true;
      //       commentController.text = data[i]['reason'];
      //     }
      //   }
      //   if (restartOperations == "No") {
      //     setState(() {
      //       airlines = true;
      //     });
      //   } else {
      //     setState(() {
      //       selectedAirlines = [];
      //       airlines = false;
      //     });
      //   }
      // });
    }
  }

  setLevel1DropdownValues() async {
    var gopaId = widget.auditId;
    var gopaNumber = widget.auditNumber;
    var station_Id;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading. . .",
    );
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    var dataLength;
    if (isOnline) {
      ApiService.get(
              "GetGOPADataBasedonAuditID?AuditID=$gopaId&AuditNumber=$gopaNumber",
              pref.getString('token'))
          .then((success) {
        if (success.statusCode == 200) {
          EasyLoading.addStatusCallback((status) {
            if (status == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          var body = jsonDecode(success.body);
          var data = body['auditGOPAOverviewMaindata'];
          setState(() {
            auditIdController.text = widget.auditNumber;
            gopaNumberwithstationCode = data[0]['gopaNumber'];
            selectedStation = data[0]['stationName'];
            selectedGroundHandler = data[0]['groundHandler'];
            restartOperations = data[0]['restartoperations'];
            restartoperationsId = data[0]['restartoperationsID'];
            _conductedByController.text = data[0]['auditDoneby'];
            if (data[0]['duedate'].toString() == "") {
              duedateValue = "Yes";
              isauditdueDate = "1";
            } else {
              duedateValue = data[0]['duedate'].toString();
              isauditdueDate = data[0]['duedateID'].toString();
            }
            station_Id = data[0]['stationID'];
            sationId = data[0]['stationID'];

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
          EasyLoading.showSuccess('Data Loading Success');
        } else {
          EasyLoading.showInfo("Data Loading Failed");
        }
      });
    } else {
      List data = await db.getGOPAOverviewDataByAuditId(widget.auditId);

      dataLength = data.length;

      if (dataLength != 0) {
        EasyLoading.addStatusCallback((dataLength) {
          if (dataLength == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        setState(() {
          auditIdController.text = widget.auditNumber;
          gopaNumberwithstationCode = data[0]['gopaNumber'];
          selectedStation = data[0]['stationName'];
          selectedGroundHandler = data[0]['groundHandler'];
          restartOperations = data[0]['restartoperations'];
          restartoperationsId = data[0]['restartoperationsID'];
          _conductedByController.text = data[0]['auditDoneby'];
          if (data[0]['duedate'].toString() == "") {
            duedateValue = "Yes";
            isauditdueDate = "1";
          } else {
            duedateValue = data[0]['duedate'].toString();
            isauditdueDate = data[0]['duedateID'].toString();
          }
          station_Id = data[0]['stationID'];
          sationId = data[0]['stationID'];
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
        EasyLoading.showSuccess('Data Loading Success');
      } else {
        EasyLoading.showInfo("Data Loading Failed");
      }
    }
    Future.delayed(const Duration(seconds: 2), () {
      makeAirlinesApiCall(station_Id);
      makeGroundHandlerApiCall(station_Id);
    });
  }

  gopaclosedbasedonGroundHandler() async {
    bool isdraftExist = false;
    var draftObj = Utilities.draftList;
    for (int i = 0; i < draftObj.length; i++) {
      if (draftObj[i]['stationName'] == sationName) {
        setState(() {
          isdraftExist = true;
        });
      }
    }
    SharedPreferences prefRole = await SharedPreferences.getInstance();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var logRole = prefRole.getString('user_role');
    print("logRole");
    print(logRole);
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

    bool isOnline = await Utilities.CheckUserConnection() as bool;

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
        ApiService.get(
                "IsGOPAClosedbasedGH?StationID=${sationId.toString().isEmpty ? airportSationId.toString() : sationId.toString()}&EMPNO=${pref.getString('employeeCode')}&GHID=$groundHandlerId&AuditType=$auditType",
                pref.getString('token'))
            .then((success) {
          setState(() {
            var body = jsonDecode(success.body);

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

        List dataList =
            await db.GetIsGOPAClosedbasedGH(StationID, EMPNO, GHID, AuditType);

        if (dataList[0]['capaFullNumbers'].toString().isNotEmpty) {
          CoolAlert.show(
              context: context,
              title: "A GOPA is found for this Ground handler",
              text: "GOPA not closed",
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
    if (fromdate != null) {
      //if the user has selected a date
      setState(() {
        _selectedFromDate = "";
      });
    }
  }

  Future<void> submittedDatepicker(BuildContext context) async {
    fromdate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ))!;
    if (fromdate != null) {
      //if the user has selected a date
      setState(() {
        _submittedDate = "";
      });
    }
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

    var dataLength;
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
      APMMAILID = stationList[0]['apmmailid'];
      RMMAILID = stationList[0]['rmmailid'];
      HOMAILID = stationList[0]['homailid'];
      hoNumber = stationList[0]['ho'];
      Utilities.apmNumber = stationList[0]['apm'];
      Utilities.rmNumber = stationList[0]['rm'];
    } else {
      for (int i = 0; i < stationList.length; i++) {
        if (widget.type == 'level1') {
          hoNumber = stationList[i]['ho'];
          Utilities.apmNumber = stationList[i]['apm'];
          Utilities.rmNumber = stationList[i]['rm'];
          APMMAILID = stationList[i]['apmmailid'];
          RMMAILID = stationList[i]['rmmailid'];
          HOMAILID = stationList[i]['homailid'];
        } else if (stationList[i]['stationName'] == widget.stationName) {
          airportSationId = stationList[i]['id'];
          selectedStation = stationList[i]['stationName'];
          hoNumber = stationList[i]['ho'];
          Utilities.apmNumber = stationList[i]['apm'];
          Utilities.rmNumber = stationList[i]['rm'];
          APMMAILID = stationList[i]['apmmailid'];
          RMMAILID = stationList[i]['rmmailid'];
          HOMAILID = stationList[i]['homailid'];
        } else {
          hoNumber = stationList[i]['ho'];
          Utilities.apmNumber = stationList[i]['apm'];
          Utilities.rmNumber = stationList[i]['rm'];
        }
      }
    }

    if (widget.type == "level1") {
    } else {
      makeAirlinesApiCall(airportSationId);
      makeGroundHandlerApiCall(airportSationId);
    }
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
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    if (isOnline) {
      ApiService.get(
              "GetGOPAGroundhandlerData?StationID=$id", pref.getString('token'))
          .then((success) {
        var body = jsonDecode(success.body);

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
      });
    } else {
      var body1 = await db.getGroundHandler(id);

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
}

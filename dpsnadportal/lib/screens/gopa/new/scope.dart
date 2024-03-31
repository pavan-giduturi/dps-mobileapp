import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../database/database_table.dart';
import '../../../helpers/utilities.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/responsive.dart';
import '../home/gopahome.dart';
import 'gopaaudit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiservice/restapi.dart';

class Scope extends StatefulWidget {
  final String submitType;
  final String auditId;
  final String auditNumber;
  final String gopaNumberwithstationCode;

  const Scope({
    Key? key,
    required this.submitType,
    required this.auditId,
    required this.auditNumber,
    required this.gopaNumberwithstationCode,
  }) : super(key: key);

  @override
  State<Scope> createState() => _ScopeState();
}

class _ScopeState extends State<Scope> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scope1(
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
                Container(
                  color: bgColor,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Scope1(
                      submitType: widget.submitType,
                      auditId: widget.auditId,
                      auditNumber: widget.auditNumber,
                      gopaNumberwithstationCode:
                          widget.gopaNumberwithstationCode,
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

class Scope1 extends StatefulWidget {
  final String auditId;
  final String auditNumber;
  final String gopaNumberwithstationCode;
  final submitType;
  const Scope1(
      {Key? key,
      this.submitType,
      required this.auditId,
      required this.auditNumber,
      required this.gopaNumberwithstationCode})
      : super(key: key);

  @override
  State<Scope1> createState() => _Scope1State();
}

class _Scope1State extends State<Scope1> {
  List data = [];
  String? dropdownValue;
  String? dropdownValue2;
  List dropdownData = [
    {
      "id": "1",
      "name": "Yes",
    },
    {
      "id": "2",
      "name": "No",
    },
  ];

  List dropdownData2 = [
    {
      "id": "1",
      "name": 'LOCAL',
    },
    {
      "id": "2",
      "name": 'CLC',
    },
  ];

  List marshallingdatalist = [];
  List ratingStatusList = [
    {
      "id": "0",
      "name": 'Yes',
    },
    {
      "id": "1",
      "name": 'No',
    },
    {
      "id": "2",
      "name": 'NotApplicable',
    }
  ];

  // List Marshallinglist = [];
  String? passengerboardingValue;
  String? dropdownvale = "Yes";

  String auditId = "";
  String auditNumber = "";
  String airlineIds = "";
  String airlineCode = "";
  String stationId = "";
  String stationCode = "";
  String APMMAILID = "";
  String RMMAILID = "";
  String HOMAILID = "";
  String stationAirport = "";
  String groundHandlerId = "";
  String groundHandler = "";
  String auditDate = "";
  String conductedId = "";
  String conductAudit = "";
  String HoNumber = "";
  String restartOperations = "";
  String allAirlinesSameServiceProvider = "";
  String isagocertified = "";
  String submitType = "";
  String appTitle = " ";
  String messages = "";
  String submitteddate = "";
  String isauditduedate = "";
  String? Passengerbridge;
  String? PassengerbridgeName = "";
  String? Ramphandling;
  String? RamphandlingName = "";
  String? Cargohandling;
  String? CargohandlingName = "";
  String? PBhandling;
  String? PBhandlingName = "";
  String? AircraftMarshalling;
  String? AircraftMarshallingName = "";
  String? Loadcontrol;
  String? LoadcontrolName = "";
  String? Deicingoperations;
  String? DeicingoperationsName = "";
  String? Headsetcommunication;
  String? HeadsetcommunicationName = "";
  String? Aircraftmovement;
  String? AircraftmovementName = "";
  String? dropdownvalue = '';
  List scopeodaudit = [];
  List draftDropdowns = [];
  List disabledScopeServiceProviders = [];
  DatabaseHelper db = DatabaseHelper();

  TextEditingController PBhandlingtext = TextEditingController();

  TextEditingController Ramphandlingtext = TextEditingController();

  TextEditingController Cargohandlingtext = TextEditingController();

  TextEditingController Deicingoperationstext = TextEditingController();

  TextEditingController AircraftMarshallingtext = TextEditingController();

  TextEditingController Loadcontroltext = TextEditingController();

  TextEditingController Aircraftmovementtext = TextEditingController();

  TextEditingController Headsetcommunicationtext = TextEditingController();

  TextEditingController Passengerbridgetext = TextEditingController();

  // bool dropdownbutton=true;
  /*toggle button */

  String? restartOperationName = '';
  String? allAirlinesSameServiceProviderName = '';
  String? isagocertifiedName = '';
  String? isauditduedateName = '';

  String? PBName = '';
  String? RampName = '';
  String? CargoName = '';
  String? AircraftMarsName = '';
  String? LoadName = '';
  String? DeicingName = '';
  String? HeadsetcomName = '';
  String? AircraftmovName = '';
  String? PassbridgeName = '';
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var body = jsonDecode(Utilities.gopaDetails);
    setState(() {
      APMMAILID = body['APMMAILID'].toString();
      RMMAILID = body['RMMAILID'].toString();
      HOMAILID = body['HOMAILID'].toString();
      auditId = body['auditId'].toString();
      auditNumber = body['auditNumber'].toString();
      HoNumber = body['HoNumber'].toString();
      airlineIds = body['airlineIds'].toString();
      airlineCode = body['airlineCode'].toString();
      stationId = body['stationId'].toString();
      stationAirport = body['stationAirport'].toString();
      stationCode = body['stationCode'].toString();
      groundHandlerId = body['groundHandlerId'].toString();
      groundHandler = body['groundHandler'].toString();
      auditDate = body['auditDate'].toString();
      conductedId = body['conductedId'].toString();
      conductAudit = body['conductAudit'].toString();
      restartOperations = body['restartOperations'].toString();
      allAirlinesSameServiceProvider =
          body['allAirlinesSameServiceProvider'].toString();
      isagocertified = body['isagocertified'].toString();
      messages = body['messages'].toString();
      submitteddate = body['submitteddate'].toString();
      isauditduedate = body['isauditduedate'].toString();

      restartOperationName = body['restartOperationName'].toString();
      allAirlinesSameServiceProviderName =
          body['allAirlinesSameServiceProviderName'].toString();
      isagocertifiedName = body['isagocertifiedName'].toString();
      isauditduedateName = body['isauditduedateName'].toString();
    });
    if (widget.submitType == "draft") {
      appTitle = "Draft";
      makeScopeAuditCheckListApiCall();
      getScopeOfAudit();
    } else {
      appTitle = "New";
      makeScopeAuditCheckListApiCall();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(appTitle),
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
                  Utilities.gopaDetails = {};
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
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: darkgrey),
                    child: Center(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text("2. Scope of Audit",
                            style: TextStyle(
                                color: whiteColor, fontSize: headerSize)),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                              "(Please enter service provider name if it is different than the name of Ground Handler as above mentioned in section 1.2)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: whiteColor, fontSize: subHeaderSize)),
                        ),
                      ],
                    )),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount:
                          scopeodaudit.length == 0 ? 0 : scopeodaudit.length,
                      itemBuilder: (context, index) {
                        var currentObj = jsonDecode(scopeodaudit[index]);
                        List controlObj = currentObj['controls'];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "${currentObj['title']}*",
                                style: TextStyle(fontSize: labelSize),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: DropdownButtonFormField(
                                hint: Text(
                                  getDropDownValueForScope(
                                      currentObj['scopeName']),
                                  style: TextStyle(
                                      fontSize: textSize, color: blackColor),
                                ),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 20),
                                  border: InputBorder.none,
                                ),
                                isDense: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: blackColor,
                                ),
                                iconSize: 30,
                                items: controlObj.map((item) {
                                  var itemData = item;
                                  return new DropdownMenuItem(
                                    child: Text(
                                      itemData['name'],
                                      style: TextStyle(
                                          fontSize: 12, color: blackColor),
                                    ),
                                    value: itemData['name'],
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  for (int i = 0; i < controlObj.length; i++) {
                                    if (controlObj[i]['name'].toString() ==
                                        value.toString()) {
                                      var ratingStatusId =
                                          controlObj[i]['id'].toString();

                                      updateStatusData(
                                          currentObj, ratingStatusId);

                                      setState(() {
                                        if (currentObj['scopeName']
                                                .toString() ==
                                            "PBhandling") {
                                          PBhandling =
                                              ratingStatusId.toString();
                                          PBName = value.toString();
                                          var scName = currentObj['scopeName']
                                              .toString();

                                          disabledScopeServiceTextBlocks(
                                              value.toString(), scName);
                                        } else if (currentObj['scopeName']
                                                .toString() ==
                                            "Ramphandling") {
                                          Ramphandling = ratingStatusId;
                                          RampName = value.toString();
                                          var scName = currentObj['scopeName']
                                              .toString();

                                          disabledScopeServiceTextBlocks(
                                              value.toString(), scName);
                                        } else if (currentObj['scopeName']
                                                .toString() ==
                                            "Cargohandling") {
                                          Cargohandling = ratingStatusId;
                                          CargoName = value.toString();
                                          var scName = currentObj['scopeName']
                                              .toString();

                                          disabledScopeServiceTextBlocks(
                                              value.toString(), scName);
                                        } else if (currentObj['scopeName']
                                                .toString() ==
                                            "Deicingoperations") {
                                          Deicingoperations = ratingStatusId;
                                          DeicingName = value.toString();
                                          var scName = currentObj['scopeName']
                                              .toString();

                                          disabledScopeServiceTextBlocks(
                                              value.toString(), scName);
                                        } else if (currentObj['scopeName']
                                                .toString() ==
                                            "AircraftMarshalling") {
                                          AircraftMarshalling = ratingStatusId;
                                          AircraftMarsName = value.toString();
                                          var scName = currentObj['scopeName']
                                              .toString();

                                          disabledScopeServiceTextBlocks(
                                              value.toString(), scName);
                                        } else if (currentObj['scopeName']
                                                .toString() ==
                                            "Loadcontrol") {
                                          Loadcontrol = ratingStatusId;
                                          LoadName = value.toString();
                                          var scName = currentObj['scopeName']
                                              .toString();

                                          disabledScopeServiceTextBlocks(
                                              value.toString(), scName);
                                        } else if (currentObj['scopeName']
                                                .toString() ==
                                            "Aircraftmovement") {
                                          Aircraftmovement = ratingStatusId;
                                          AircraftmovName = value.toString();
                                          var scName = currentObj['scopeName']
                                              .toString();

                                          disabledScopeServiceTextBlocks(
                                              value.toString(), scName);
                                        } else if (currentObj['scopeName']
                                                .toString() ==
                                            "Headsetcommunication") {
                                          Headsetcommunication = ratingStatusId;
                                          HeadsetcomName = value.toString();
                                          var scName = currentObj['scopeName']
                                              .toString();

                                          disabledScopeServiceTextBlocks(
                                              value.toString(), scName);
                                        } else if (currentObj['scopeName']
                                                .toString() ==
                                            "Passengerbridge") {
                                          Passengerbridge = ratingStatusId;
                                          PassbridgeName = value.toString();
                                          var scName = currentObj['scopeName']
                                              .toString();

                                          disabledScopeServiceTextBlocks(
                                              value.toString(), scName);
                                        }
                                      });
                                    }
                                  }

                                  // var interlinksData = currentObj['interlinks'] == null ? "" : currentObj['interlinks'];
                                  // basedOnScopeCheckListControls(value,interlinksData);
                                },
                                // value: PBhandling,
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Service Provider Name(Handled by)',
                                style: TextStyle(fontSize: labelSize),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: disabledScopeServiceProviders
                                          .contains(currentObj['scopeName'])
                                      ? Colors.black26
                                      : cardColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: TextFormField(
                                enabled: disabledScopeServiceProviders
                                        .contains(currentObj['scopeName'])
                                    ? false
                                    : true,
                                // initialValue: currentObj['seviceProviderBy'].toString() == "" ? "" : currentObj['seviceProviderBy'].toString(),
                                style: TextStyle(color: blackColor),
                                controller:
                                    getControllerName(currentObj['scopeName']),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                                onChanged: (value) {
                                  updateServiceProviderName(
                                      currentObj, value.toString());
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        );
                      }),
                  SizedBox(height: 15),
                  Center(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(8),
                            primary: red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: headerSize, color: whiteColor),
                          ),
                          onPressed: () {
                            disabledCheckListIds();

                            Utilities.gopaDetails = jsonEncode({
                              "auditId": auditId,
                              "auditNumber": auditNumber,
                              "airlineIds": airlineIds,
                              "airlineCode": airlineCode,
                              "stationId": stationId,
                              "stationAirport": stationAirport,
                              "stationCode": stationCode,
                              "groundHandlerId": groundHandlerId,
                              "groundHandler": groundHandler,
                              "auditDate": auditDate,
                              "conductedId": conductedId,
                              "conductAudit": conductAudit,
                              "restartOperations": restartOperations,
                              "allAirlinesSameServiceProvider":
                                  allAirlinesSameServiceProvider,
                              "isagocertified": isagocertified,
                              "messages": messages,
                              "submitteddate": submitteddate,
                              "isauditduedate": isauditduedate,
                              "Passengerbridge": Passengerbridge,
                              "PassengerbridgeServiceProvider":
                                  Passengerbridge.toString() == 'No' ||
                                          Passengerbridge.toString() == '2' ||
                                          Passengerbridge.toString() == 'CLC'
                                      ? ""
                                      : Passengerbridgetext.text,
                              "Ramphandling": Ramphandling,
                              "RamphandlingServiceProvider":
                                  Ramphandling.toString() == 'No' ||
                                          Ramphandling.toString() == '2' ||
                                          Ramphandling.toString() == 'CLC'
                                      ? ""
                                      : Ramphandlingtext.text,
                              "Cargohandling": Cargohandling,
                              "CargohandlingServiceProvider":
                                  Cargohandling.toString() == 'No' ||
                                          Cargohandling.toString() == '2' ||
                                          Cargohandling.toString() == 'CLC'
                                      ? ""
                                      : Cargohandlingtext.text,
                              "PBhandling": PBhandling,
                              "PBhandlingServiceProvider":
                                  PBhandling.toString() == 'No' ||
                                          PBhandling.toString() == '2' ||
                                          PBhandling.toString() == 'CLC'
                                      ? ""
                                      : PBhandlingtext.text,
                              "AircraftMarshalling": AircraftMarshalling,
                              "AircraftMarshallingServiceProvider":
                                  AircraftMarshalling.toString() == 'No' ||
                                          AircraftMarshalling.toString() ==
                                              '2' ||
                                          AircraftMarshalling.toString() ==
                                              'CLC'
                                      ? ""
                                      : AircraftMarshallingtext.text,
                              "Loadcontrol": Loadcontrol,
                              "LoadcontrolServiceProvider":
                                  Loadcontrol.toString() == 'No' ||
                                          Loadcontrol.toString() == '2' ||
                                          Loadcontrol.toString() == 'CLC'
                                      ? ""
                                      : Loadcontroltext.text,
                              "Deicingoperations": Deicingoperations,
                              "DeicingoperationsServiceProvider":
                                  Deicingoperations.toString() == 'No' ||
                                          Deicingoperations.toString() == '2' ||
                                          Deicingoperations.toString() == 'CLC'
                                      ? ""
                                      : Deicingoperationstext.text,
                              "Headsetcommunication": Headsetcommunication,
                              "HeadsetcommunicationServiceProvider":
                                  Headsetcommunication.toString() == 'No' ||
                                          Headsetcommunication.toString() ==
                                              '2' ||
                                          Headsetcommunication.toString() ==
                                              'CLC'
                                      ? ""
                                      : Headsetcommunicationtext.text,
                              "Aircraftmovement": Aircraftmovement,
                              "AircraftmovementServiceProvider":
                                  Aircraftmovement.toString() == 'No' ||
                                          Aircraftmovement.toString() == '2' ||
                                          Aircraftmovement.toString() == 'CLC'
                                      ? ""
                                      : Aircraftmovementtext.text,
                              "restartOperationName": restartOperationName,
                              "allAirlinesSameServiceProviderName":
                                  allAirlinesSameServiceProviderName,
                              "isagocertifiedName": isagocertifiedName,
                              "isauditduedateName": isauditduedateName,
                              "PBName": PBName,
                              "RampName": RampName,
                              "CargoName": CargoName,
                              "LoadName": LoadName,
                              "DeicingName": DeicingName,
                              "HeadsetcomName": HeadsetcomName,
                              "AircraftmovName": AircraftmovName,
                              "PassbridgeName": PassbridgeName,
                              "AircraftMarsName": AircraftMarsName,
                              "HoNumber": HoNumber,
                              "APMMAILID": APMMAILID.toString(),
                              "RMMAILID": RMMAILID.toString(),
                              "HOMAILID": HOMAILID.toString(),
                            });

                            if (PBhandling.toString().isEmpty ||
                                PBhandling == null) {
                              Utilities.showAlert(context,
                                  'Please Select 2.1 Passenger and Baggage handling');
                            } else if (Ramphandling.toString().isEmpty ||
                                Ramphandling == null) {
                              Utilities.showAlert(
                                  context, 'Please Select 2.2 Ramp handling ');
                            } else if (Cargohandling.toString().isEmpty ||
                                Cargohandling == null) {
                              Utilities.showAlert(context,
                                  'Please Select 2.3 Cargo/ Mail handling');
                            } else if (Deicingoperations.toString().isEmpty ||
                                Deicingoperations == null) {
                              Utilities.showAlert(context,
                                  'Please Select 2.4 Deicing/ Anti icing operations');
                            } else if (AircraftMarshalling.toString().isEmpty ||
                                AircraftMarshalling == null) {
                              Utilities.showAlert(context,
                                  'Please Select 2.5 Aircraft Marshalling ');
                            } else if (Loadcontrol.toString().isEmpty ||
                                Loadcontrol == null) {
                              Utilities.showAlert(context,
                                  'Please Select 2.6 Load planning and load control');
                            } else if (Aircraftmovement.toString().isEmpty ||
                                Aircraftmovement == null) {
                              Utilities.showAlert(context,
                                  'Please Select 2.7 Aircraft ground movement (pushback and towing)');
                            } else if (Headsetcommunication.toString()
                                    .isEmpty ||
                                Headsetcommunication == null) {
                              Utilities.showAlert(context,
                                  'Please Select 2.8 Headset communication');
                            } else if (Passengerbridge.toString().isEmpty ||
                                Passengerbridge == null) {
                              Utilities.showAlert(context,
                                  'Please Select 2.9 Passenger boarding bridge');
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GopaAudit(
                                      submitType: widget.submitType,
                                      auditId: widget.auditId,
                                      auditNumber: widget.auditNumber,
                                      gopaNumberwithstationCode:
                                          widget.gopaNumberwithstationCode,
                                    ),
                                  ));
                            }
                          },
                        )),
                  ),
                ])),
          )),
        ));
  }

  getServiceProviderForScope(scopeName) {
    if (scopeName.toString() == "PBhandling") {
      return PBhandlingtext.text;
    } else if (scopeName.toString() == "Ramphandling") {
      return Ramphandlingtext;
      // } else if (scopeName.toString() == "Cargohandling") {
      //   return Cargohandlingtext;
      // } else if (scopeName.toString() == "Deicingoperations") {
      //   return Deicingoperationstext;
      // } else if (scopeName.toString() == "AircraftMarshalling") {
      //   return AircraftMarshallingtext;
      // } else if (scopeName.toString() == "Loadcontrol") {
      //   return Loadcontroltext;
      // } else if (scopeName.toString() == "Aircraftmovement") {
      //   return Aircraftmovementtext;
      // } else if (scopeName.toString() == "Headsetcommunication") {
      //   return Headsetcommunicationtext;
      // } else if (scopeName.toString() == "Passengerbridge") {
      return Passengerbridgetext;
    } else {
      return "";
    }
  }

  getScopeOfAudit() async {
    var gopaId = widget.auditId;
    var gopaNumber = widget.auditNumber;
    var arry = gopaNumber.toString().split("_");
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading. . .",
    );
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    var dataLength;
    if (isOnline && !arry.contains("GOPA")) {
      ApiService.get(
              "GetGOPADataBasedonAuditID?AuditID=$gopaId&AuditNumber=$gopaNumber",
              pref.getString('token'))
          .then((success) {
        var body = jsonDecode(success.body);
        var data = body['auditGOPAOverviewMaindata'];

        if (dataLength != 0) {
          EasyLoading.addStatusCallback((dataLength) {
            if (dataLength == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });

          setState(() {
            if (data[0]['pBhandlingID'] != '') {
              PBhandling = data[0]['pBhandlingID'];
              PBhandlingName = data[0]['pBhandling'].toString();
              disabledScopeServiceTextBlocks(PBhandlingName, 'PBhandling');
              PBhandlingtext.text =
                  data[0]['pBhandlingServiceProvider'].toString();
            }
            if (data[0]['ramphandlingID'] != '') {
              Ramphandling = data[0]['ramphandlingID'];
              RamphandlingName = data[0]['ramphandling'].toString();
              disabledScopeServiceTextBlocks(RamphandlingName, 'Ramphandling');
              Ramphandlingtext.text =
                  data[0]['ramphandlingServiceProvider'].toString();
            }
            if (data[0]['cargohandlingID'] != '') {
              Cargohandling = data[0]['cargohandlingID'];
              CargohandlingName = data[0]['cargohandling'].toString();
              disabledScopeServiceTextBlocks(
                  CargohandlingName, 'Cargohandling');
              Cargohandlingtext.text =
                  data[0]['cargohandlingServiceProvider'].toString();
            }
            if (data[0]['deicingoperationsID'] != '') {
              Deicingoperations = data[0]['deicingoperationsID'];
              DeicingoperationsName = data[0]['deicingoperations'].toString();
              disabledScopeServiceTextBlocks(
                  DeicingoperationsName, 'Deicingoperations');
              Deicingoperationstext.text =
                  data[0]['deicingoperationsServiceProvider'].toString();
            }
            if (data[0]['aircraftMarshallingID'] != '') {
              AircraftMarshalling = data[0]['aircraftMarshallingID'];
              AircraftMarshallingName =
                  data[0]['aircraftMarshalling'].toString();
              disabledScopeServiceTextBlocks(
                  AircraftMarshallingName, 'AircraftMarshalling');
              AircraftMarshallingtext.text =
                  data[0]['aircraftMarshallingServiceProvider'].toString();
            }
            if (data[0]['loadcontrolID'] != '') {
              Loadcontrol = data[0]['loadcontrolID'];
              LoadcontrolName = data[0]['loadcontrol'].toString();
              disabledScopeServiceTextBlocks(LoadcontrolName, 'Loadcontrol');
              Loadcontroltext.text =
                  data[0]['loadcontrolServiceProvider'].toString();
            }
            if (data[0]['aircraftmovementID'] != '') {
              Aircraftmovement = data[0]['aircraftmovementID'];
              AircraftmovementName = data[0]['aircraftmovement'].toString();
              disabledScopeServiceTextBlocks(
                  AircraftmovementName, 'Aircraftmovement');
              Aircraftmovementtext.text =
                  data[0]['aircraftmovementServiceProvider'].toString();
            }
            if (data[0]['headsetcommunicationID'] != '') {
              Headsetcommunication = data[0]['headsetcommunicationID'];
              HeadsetcommunicationName =
                  data[0]['headsetcommunication'].toString();
              disabledScopeServiceTextBlocks(
                  HeadsetcommunicationName, 'Headsetcommunication');
              Headsetcommunicationtext.text =
                  data[0]['headsetcommunicationServiceProvider'].toString();
            }
            if (data[0]['passengerbridgeID'] != '') {
              Passengerbridge = data[0]['passengerbridgeID'];
              PassengerbridgeName = data[0]['passengerbridge'].toString();
              disabledScopeServiceTextBlocks(
                  PassengerbridgeName, 'Passengerbridge');
              Passengerbridgetext.text =
                  data[0]['passengerbridgeServiceProvider'].toString();
            }
          });
          // EasyLoading.showSuccess('Data Loading Success');
        } else {
          EasyLoading.showInfo("Data Loading Failed");
        }

        //setScopeOfAudit(scopeName,data);
      });
    } else {
      var overviewBody = await db.getGOPAOverviewDataByAuditId(widget.auditId);

      dataLength = overviewBody.length;
      if (dataLength != 0) {
        EasyLoading.addStatusCallback((dataLength) {
          if (dataLength == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        setState(() {
          List data = overviewBody;
          for (int i = 0; i < data.length; i++) {
            if (data[i]['pBhandlingID'] != 0) {
              PBhandling = data[i]['pBhandlingID'];
              PBhandlingName = data[i]['pBhandling'].toString();
              PBName = data[i]['pBhandling'].toString();
              disabledScopeServiceTextBlocks(PBhandlingName, 'PBhandling');
              PBhandlingtext.text =
                  data[i]['pBhandlingServiceProvider'].toString();
            }
            if (data[i]['ramphandlingID'] != 0) {
              Ramphandling = data[i]['ramphandlingID'];
              RamphandlingName = data[i]['ramphandling'].toString();
              RampName = data[i]['ramphandling'].toString();
              disabledScopeServiceTextBlocks(RamphandlingName, 'Ramphandling');
              Ramphandlingtext.text =
                  data[i]['ramphandlingServiceProvider'].toString();
            }
            if (data[i]['cargohandlingID'] != 0) {
              Cargohandling = data[i]['cargohandlingID'];
              CargohandlingName = data[i]['cargohandling'].toString();
              CargoName = data[i]['cargohandling'].toString();
              disabledScopeServiceTextBlocks(
                  CargohandlingName, 'Cargohandling');
              Cargohandlingtext.text =
                  data[i]['cargohandlingServiceProvider'].toString();
            }
            if (data[i]['deicingoperationsID'] != 0) {
              Deicingoperations = data[i]['deicingoperationsID'];
              DeicingoperationsName = data[i]['deicingoperations'].toString();
              DeicingName = data[i]['deicingoperations'].toString();
              disabledScopeServiceTextBlocks(
                  DeicingoperationsName, 'Deicingoperations');
              Deicingoperationstext.text =
                  data[i]['deicingoperationsServiceProvider'].toString();
            }
            if (data[i]['aircraftMarshallingID'] != 0) {
              AircraftMarshalling = data[i]['aircraftMarshallingID'];
              AircraftMarshallingName =
                  data[i]['aircraftMarshalling'].toString();
              AircraftMarsName = data[i]['aircraftMarshalling'].toString();
              disabledScopeServiceTextBlocks(
                  AircraftMarshallingName, 'AircraftMarshalling');
              AircraftMarshallingtext.text =
                  data[i]['aircraftMarshallingServiceProvider'].toString();
            }
            if (data[i]['loadcontrolID'] != 0) {
              Loadcontrol = data[i]['loadcontrolID'];
              LoadcontrolName = data[i]['loadcontrol'].toString();
              LoadName = data[i]['loadcontrol'].toString();
              disabledScopeServiceTextBlocks(LoadcontrolName, 'Loadcontrol');
              Loadcontroltext.text =
                  data[i]['loadcontrolServiceProvider'].toString();
            }
            if (data[i]['aircraftmovementID'] != 0) {
              Aircraftmovement = data[i]['aircraftmovementID'];
              AircraftmovementName = data[i]['aircraftmovement'].toString();
              AircraftmovName = data[i]['aircraftmovement'].toString();
              disabledScopeServiceTextBlocks(
                  AircraftmovementName, 'Aircraftmovement');
              Aircraftmovementtext.text =
                  data[i]['aircraftmovementServiceProvider'].toString();
            }
            if (data[i]['headsetcommunicationID'] != 0) {
              Headsetcommunication = data[i]['headsetcommunicationID'];
              HeadsetcommunicationName =
                  data[i]['headsetcommunication'].toString();
              HeadsetcomName = data[i]['headsetcommunication'].toString();
              disabledScopeServiceTextBlocks(
                  HeadsetcommunicationName, 'Headsetcommunication');
              Headsetcommunicationtext.text =
                  data[i]['headsetcommunicationServiceProvider'].toString();
            }
            if (data[i]['passengerbridgeID'] != 0) {
              Passengerbridge = data[i]['passengerbridgeID'];
              PassengerbridgeName = data[i]['passengerbridge'].toString();
              PassbridgeName = data[i]['passengerbridge'].toString();
              disabledScopeServiceTextBlocks(
                  PassengerbridgeName, 'Passengerbridge');
              Passengerbridgetext.text =
                  data[i]['passengerbridgeServiceProvider'].toString();
            }
          }
        });

        EasyLoading.showSuccess('Data Loading Success');
      } else {
        EasyLoading.showInfo("Data Loading Failed");
      }
    }
  }

  getDropDownValueForScope(scopeName) {
    if (scopeName.toString() == "PBhandling") {
      return PBhandlingName;
    } else if (scopeName.toString() == "Ramphandling") {
      return RamphandlingName;
    } else if (scopeName.toString() == "Cargohandling") {
      return CargohandlingName;
    } else if (scopeName.toString() == "Deicingoperations") {
      return DeicingoperationsName;
    } else if (scopeName.toString() == "AircraftMarshalling") {
      return AircraftMarshallingName;
    } else if (scopeName.toString() == "Loadcontrol") {
      return LoadcontrolName;
    } else if (scopeName.toString() == "Aircraftmovement") {
      return AircraftmovementName;
    } else if (scopeName.toString() == "Headsetcommunication") {
      return HeadsetcommunicationName;
    } else if (scopeName.toString() == "Passengerbridge") {
      return PassengerbridgeName;
    } else {
      return "";
    }
  }

  makeScopeAuditCheckListApiCall() async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    Utilities.easyLoader();
    EasyLoading.show(
      status: "Loading. . .",
    );
    var arry = auditNumber.toString().split("_");
    var dataLength;
    if (isOnline && !arry.contains("GOPA")) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      ApiService.get("GetGOPAScopeMasterData", pref.getString('token'))
          .then((success) {
        var body = jsonDecode(success.body);
        var scopeBody = body['getGOPAScopeMasterData'];

        dataLength = body.length;
        if (dataLength != 0) {
          EasyLoading.addStatusCallback((dataLength) {
            if (dataLength == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });
          makeScopeAuditCheckListAget(scopeBody);
          EasyLoading.showSuccess('Data Loading Success');
        } else {
          EasyLoading.showInfo("Data Loading Failed");
        }
      });
    } else {
      List scopeBody = await db.getGOPAScopeAuditData();
      dataLength = scopeBody.length;

      if (dataLength != 0) {
        EasyLoading.addStatusCallback((dataLength) {
          if (dataLength == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        makeScopeAuditCheckListAget(scopeBody);
        EasyLoading.showSuccess('Data Loading Success');
      } else {
        EasyLoading.showInfo("Data Loading Failed");
      }
    }
  }

  makeScopeAuditCheckListAget(scopeBody) {
    // _fetchData(context);

    scopeodaudit = [];

    setState(() {
      var scopeId = "0";
      List items = [];
      for (int i = 0; i < scopeBody.length; i++) {
        if (scopeBody[i]['dropdownID'] != scopeId) {
          var item = jsonEncode({
            "id": scopeBody[i]['dropdownID'],
            "title": scopeBody[i]['dropdownName'].toString(),
            "scopeName": scopeBody[i]['scopeName'].toString(),
            "controls": [],
            "status": "0",
            "seviceProviderBy": "",
            "interlinks": "",
          });
          items.add(item);
          scopeId = scopeBody[i]['dropdownID'];
        }
      }

      for (int j = 0; j < items.length; j++) {
        var curItem = jsonDecode(items[j]);
        List ratingControls = [];
        var interlinksData = "";
        for (int k = 0; k < scopeBody.length; k++) {
          if (scopeBody[k]['dropdownID'] == curItem['id']) {
            ratingControls.add({
              "name": scopeBody[k]['name'].toString(),
              "id": scopeBody[k]['id']
            });
            interlinksData = scopeBody[k]['interlinks'];
          }
        }
        var scopeItem = jsonEncode({
          "id": curItem['id'],
          "title": curItem['title'].toString(),
          "scopeName": curItem['scopeName'].toString(),
          "controls": ratingControls,
          "status": "0",
          "seviceProviderBy": "",
          "interlinks": interlinksData,
        });
        scopeodaudit.add(scopeItem);
      }
    });
  }

  updateStatusData(selectPosition, ratings) async {
    List tempScopeodaudit = [];

    try {
      for (int i = 0; i < scopeodaudit.length; i++) {
        var singleObj = jsonDecode(scopeodaudit[i]);
        if (selectPosition['id'] == singleObj['id']) {
          if (ratings == 2) {
            var scopeItem = jsonEncode({
              "id": singleObj['id'],
              "title": singleObj['title'].toString(),
              "scopeName": singleObj['scopeName'].toString(),
              "controls": singleObj['controls'],
              "status": ratings.toString(),
              "seviceProviderBy": "",
              "interlinks": singleObj['interlinks'],
            });
            tempScopeodaudit.add(scopeItem);
          } else {
            var scopeItem = jsonEncode({
              "id": singleObj['id'],
              "title": singleObj['title'].toString(),
              "scopeName": singleObj['scopeName'].toString(),
              "controls": singleObj['controls'],
              "status": ratings.toString(),
              "seviceProviderBy": singleObj['seviceProviderBy'].toString(),
              "interlinks": singleObj['interlinks'],
            });
            tempScopeodaudit.add(scopeItem);
          }
        } else {
          var scopeItem = jsonEncode({
            "id": singleObj['id'],
            "title": singleObj['title'].toString(),
            "scopeName": singleObj['scopeName'].toString(),
            "controls": singleObj['controls'],
            "status": singleObj['status'],
            "seviceProviderBy": singleObj['seviceProviderBy'].toString(),
            "interlinks": singleObj['interlinks'],
          });
          tempScopeodaudit.add(scopeItem);
        }
        ;
      }

      setState(() {
        scopeodaudit = [];
        scopeodaudit = tempScopeodaudit;
        tempScopeodaudit = [];
      });
    } catch (e) {
      print("Error Occured " + e.toString());
    }
  }

  updateServiceProviderName(selectPosition, serviceName) async {
    List tempScopeodaudit = [];

    try {
      for (int i = 0; i < scopeodaudit.length; i++) {
        var singleObj = jsonDecode(scopeodaudit[i]);
        if (selectPosition['id'] == singleObj['id']) {
          if (singleObj['status'] == 2) {
            var scopeItem = jsonEncode({
              "id": singleObj['id'],
              "title": singleObj['title'].toString(),
              "scopeName": singleObj['scopeName'].toString(),
              "controls": singleObj['controls'],
              "status": singleObj['status'],
              "seviceProviderBy": "",
              "interlinks": singleObj['interlinks'],
            });
            tempScopeodaudit.add(scopeItem);
          } else {
            var scopeItem = jsonEncode({
              "id": singleObj['id'],
              "title": singleObj['title'].toString(),
              "scopeName": singleObj['scopeName'].toString(),
              "controls": singleObj['controls'],
              "status": singleObj['status'],
              "seviceProviderBy": serviceName,
              "interlinks": singleObj['interlinks'],
            });
            tempScopeodaudit.add(scopeItem);
          }
        } else {
          var scopeItem = jsonEncode({
            "id": singleObj['id'],
            "title": singleObj['title'].toString(),
            "scopeName": singleObj['scopeName'].toString(),
            "controls": singleObj['controls'],
            "status": singleObj['status'],
            "seviceProviderBy": singleObj['seviceProviderBy'],
            "interlinks": singleObj['interlinks'],
          });
          tempScopeodaudit.add(scopeItem);
        }
      }

      setState(() {
        scopeodaudit = [];
        scopeodaudit = tempScopeodaudit;
        tempScopeodaudit = [];
      });
    } catch (e) {
      print("Error Occured " + e.toString());
    }
  }

  void basedOnScopeCheckListControls(status, interlinks) {
    if (status.toString() == 'No' || status.toString() == 'CLC') {
      if (interlinks.toString() != "") {
      } else {}
    } else {}
  }

  void disabledCheckListIds() {
    Utilities.checkListDisabledIdsList = [];

    for (int i = 0; i < scopeodaudit.length; i++) {
      var curObj = jsonDecode(scopeodaudit[i]);
      if (curObj['scopeName'].toString() == "PBhandling") {
        if (PBhandling.toString() == "2") {
          var PBhandlingArr = curObj['interlinks'].toString().split(",");

          for (int i = 0; i < PBhandlingArr.length; i++) {
            Utilities.checkListDisabledIdsList.add(PBhandlingArr[i]);
          }
        }
      } else if (curObj['scopeName'].toString() == "Ramphandling") {
        if (Ramphandling.toString() == "2" && curObj['interlinks'] != "") {
          var RamphandlingArr = curObj['interlinks'].toString().split(",");

          for (int i = 0; i < RamphandlingArr.length; i++) {
            Utilities.checkListDisabledIdsList.add(RamphandlingArr[i]);
          }
        }
      } else if (curObj['scopeName'].toString() == "Cargohandling") {
        if (Cargohandling.toString() == "2" && curObj['interlinks'] != "") {
          var CargohandlingArr = curObj['interlinks'].toString().split(",");

          for (int i = 0; i < CargohandlingArr.length; i++) {
            Utilities.checkListDisabledIdsList.add(CargohandlingArr[i]);
          }
        }
      } else if (curObj['scopeName'].toString() == "Deicingoperations") {
        if (Deicingoperations.toString() == "2" && curObj['interlinks'] != "") {
          var DeicingoperationsArr = curObj['interlinks'].toString().split(",");

          for (int i = 0; i < DeicingoperationsArr.length; i++) {
            Utilities.checkListDisabledIdsList.add(DeicingoperationsArr[i]);
          }
        }
      } else if (curObj['scopeName'].toString() == "AircraftMarshalling") {
        if (AircraftMarshalling.toString() == "2" &&
            curObj['interlinks'] != "") {
          var AircraftMarshallingArr =
              curObj['interlinks'].toString().split(",");

          for (int i = 0; i < AircraftMarshallingArr.length; i++) {
            Utilities.checkListDisabledIdsList.add(AircraftMarshallingArr[i]);
          }
        }
      } else if (curObj['scopeName'].toString() == "Loadcontrol") {
        if (Loadcontrol.toString() == "2" && curObj['interlinks'] != "") {
          var LoadcontrolArr = curObj['interlinks'].toString().split(",");

          for (int i = 0; i < LoadcontrolArr.length; i++) {
            Utilities.checkListDisabledIdsList.add(LoadcontrolArr[i]);
          }
        }
      } else if (curObj['scopeName'].toString() == "Aircraftmovement") {
        if (Aircraftmovement.toString() == "2" && curObj['interlinks'] != "") {
          var AircraftmovementArr = curObj['interlinks'].toString().split(",");

          for (int i = 0; i < AircraftmovementArr.length; i++) {
            Utilities.checkListDisabledIdsList.add(AircraftmovementArr[i]);
          }
        }
      } else if (curObj['scopeName'].toString() == "Headsetcommunication") {
        if (Headsetcommunication.toString() == "2" &&
            curObj['interlinks'] != "") {
          var HeadsetcommunicationArr =
              curObj['interlinks'].toString().split(",");

          for (int i = 0; i < HeadsetcommunicationArr.length; i++) {
            Utilities.checkListDisabledIdsList.add(HeadsetcommunicationArr[i]);
          }
        }
      } else if (curObj['scopeName'].toString() == "Passengerbridge") {
        if (Passengerbridge.toString() == "2" && curObj['interlinks'] != "") {
          var PassengerbridgeArr = curObj['interlinks'].toString().split(",");

          for (int i = 0; i < PassengerbridgeArr.length; i++) {
            Utilities.checkListDisabledIdsList.add(PassengerbridgeArr[i]);
          }
        }
      }
    }
  }

  disabledScopeServiceTextBlocks(value, scName) {
    if (value.toString() == 'No' ||
        value.toString() == '2' ||
        value.toString() == 'CLC') {
      if (!disabledScopeServiceProviders.contains(scName)) {
        disabledScopeServiceProviders.add(scName);
      }
      if (scName.toString() == "PBhandling") {
        PBhandlingtext.clear();
      } else if (scName.toString() == "Ramphandling") {
        Ramphandlingtext.clear();
      } else if (scName.toString() == "Cargohandling") {
        Cargohandlingtext.clear();
      } else if (scName.toString() == "Deicingoperations") {
        Deicingoperationstext.clear();
      } else if (scName.toString() == "AircraftMarshalling") {
        AircraftMarshallingtext.clear();
      } else if (scName.toString() == "Loadcontrol") {
        Loadcontroltext.clear();
      } else if (scName.toString() == "Aircraftmovement") {
        Aircraftmovementtext.clear();
      } else if (scName.toString() == "Headsetcommunication") {
        Headsetcommunicationtext.clear();
      } else if (scName.toString() == "Passengerbridge") {
        Passengerbridgetext.clear();
      }
    } else {
      if (disabledScopeServiceProviders.contains(scName)) {
        disabledScopeServiceProviders.remove(scName);
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
                    'Loading. . .',
                    style: TextStyle(fontSize: headerSize),
                  )
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(const Duration(seconds: 5));

    // Close the dialog programmatically
    // We use "mounted" variable to get rid of the "Do not use BuildContexts across async gaps" warning
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  getControllerName(scopeName) {
    if (scopeName.toString() == "PBhandling") {
      return PBhandlingtext;
    } else if (scopeName.toString() == "Ramphandling") {
      return Ramphandlingtext;
    } else if (scopeName.toString() == "Cargohandling") {
      return Cargohandlingtext;
    } else if (scopeName.toString() == "Deicingoperations") {
      return Deicingoperationstext;
    } else if (scopeName.toString() == "AircraftMarshalling") {
      return AircraftMarshallingtext;
    } else if (scopeName.toString() == "Loadcontrol") {
      return Loadcontroltext;
    } else if (scopeName.toString() == "Aircraftmovement") {
      return Aircraftmovementtext;
    } else if (scopeName.toString() == "Headsetcommunication") {
      return Headsetcommunicationtext;
    } else if (scopeName.toString() == "Passengerbridge") {
      return Passengerbridgetext;
    }
  }
}

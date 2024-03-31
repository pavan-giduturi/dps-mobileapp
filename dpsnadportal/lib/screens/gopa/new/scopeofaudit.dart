import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../database/database_table.dart';
import '../../../helpers/utilities.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/responsive.dart';
import 'gopaaudit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiservice/restapi.dart';

class ScopeofAudit extends StatefulWidget {
  final String submitType;
  final String auditId;
  final String auditNumber;

  const ScopeofAudit({
    Key? key,
    required this.submitType,
    required this.auditId,
    required this.auditNumber,
  }) : super(key: key);

  @override
  State<ScopeofAudit> createState() => _ScopeofAuditState();
}

class _ScopeofAuditState extends State<ScopeofAudit> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: ScopeofAudit1(
        submitType: widget.submitType,
        auditId: widget.auditId,
        auditNumber: widget.auditNumber,
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
                    child: ScopeofAudit1(
                      submitType: widget.submitType,
                      auditId: widget.auditId,
                      auditNumber: widget.auditNumber,
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

class ScopeofAudit1 extends StatefulWidget {
  final String auditId;
  final String auditNumber;
  final submitType;
  const ScopeofAudit1(
      {Key? key,
      this.submitType,
      required this.auditId,
      required this.auditNumber})
      : super(key: key);

  @override
  State<ScopeofAudit1> createState() => _ScopeofAudit1State();
}

class _ScopeofAudit1State extends State<ScopeofAudit1> {
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
  String? Passengerbridgetext = "";
  String? Ramphandling;
  String? RamphandlingName = "";
  String? Ramphandlingtext = "";
  String? Cargohandling;
  String? CargohandlingName = "";
  String? Cargohandlingtext = "";
  String? PBhandling;
  String? PBhandlingName = "";
  String? PBhandlingtext = "";
  String? AircraftMarshalling;
  String? AircraftMarshallingName = "";
  String? AircraftMarshallingtext = "";
  String? Loadcontrol;
  String? LoadcontrolName = "";
  String? Loadcontroltext = "";
  String? Deicingoperations;
  String? DeicingoperationsName = "";
  String? Deicingoperationstext = "";
  String? Headsetcommunication;
  String? HeadsetcommunicationName = "";
  String? Headsetcommunicationtext = "";
  String? Aircraftmovement;
  String? AircraftmovementName = "";
  String? Aircraftmovementtext = "";
  String? dropdownvalue = '';
  List scopeodaudit = [];
  List draftDropdowns = [];
  List disabledScopeServiceProviders = [];
  DatabaseHelper db = DatabaseHelper();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //scopeOfAuditData();
    // loadFormData();
    // MarshallingFormData();
    var body = jsonDecode(Utilities.gopaDetails);

    setState(() {
      auditId = body['auditId'].toString();
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
          title: Text(appTitle),
          centerTitle: true,
          backgroundColor: red,
        ),
        backgroundColor: bgColor,
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: darkgrey),
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
                    itemCount: scopeodaudit.length == 0 ? 0 : scopeodaudit.length,
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

                                    setState(() {
                                      if (currentObj['scopeName'].toString() ==
                                          "PBhandling") {
                                        PBhandling = ratingStatusId.toString();
                                        PBName = value.toString();
                                        var scName =
                                            currentObj['scopeName'].toString();

                                        disabledScopeServiceTextBlocks(
                                            value.toString(), scName);
                                      } else if (currentObj['scopeName']
                                              .toString() ==
                                          "Ramphandling") {
                                        Ramphandling = ratingStatusId;
                                        RampName = value.toString();
                                        var scName =
                                            currentObj['scopeName'].toString();

                                        disabledScopeServiceTextBlocks(
                                            value.toString(), scName);
                                      } else if (currentObj['scopeName']
                                              .toString() ==
                                          "Cargohandling") {
                                        Cargohandling = ratingStatusId;
                                        CargoName = value.toString();
                                        var scName =
                                            currentObj['scopeName'].toString();

                                        disabledScopeServiceTextBlocks(
                                            value.toString(), scName);
                                      } else if (currentObj['scopeName']
                                              .toString() ==
                                          "Deicingoperations") {
                                        Deicingoperations = ratingStatusId;
                                        DeicingName = value.toString();
                                        var scName =
                                            currentObj['scopeName'].toString();

                                        disabledScopeServiceTextBlocks(
                                            value.toString(), scName);
                                      } else if (currentObj['scopeName']
                                              .toString() ==
                                          "AircraftMarshalling") {
                                        AircraftMarshalling = ratingStatusId;
                                        AircraftMarsName = value.toString();
                                        var scName =
                                            currentObj['scopeName'].toString();

                                        disabledScopeServiceTextBlocks(
                                            value.toString(), scName);
                                      } else if (currentObj['scopeName']
                                              .toString() ==
                                          "Loadcontrol") {
                                        Loadcontrol = ratingStatusId;
                                        LoadName = value.toString();
                                        var scName =
                                            currentObj['scopeName'].toString();

                                        disabledScopeServiceTextBlocks(
                                            value.toString(), scName);
                                      } else if (currentObj['scopeName']
                                              .toString() ==
                                          "Aircraftmovement") {
                                        Aircraftmovement = ratingStatusId;
                                        AircraftmovName = value.toString();
                                        var scName =
                                            currentObj['scopeName'].toString();

                                        disabledScopeServiceTextBlocks(
                                            value.toString(), scName);
                                      } else if (currentObj['scopeName']
                                              .toString() ==
                                          "Headsetcommunication") {
                                        Headsetcommunication = ratingStatusId;
                                        HeadsetcomName = value.toString();
                                        var scName =
                                            currentObj['scopeName'].toString();

                                        disabledScopeServiceTextBlocks(
                                            value.toString(), scName);
                                      } else if (currentObj['scopeName']
                                              .toString() ==
                                          "Passengerbridge") {
                                        Passengerbridge = ratingStatusId;
                                        PassbridgeName = value.toString();
                                        var scName =
                                            currentObj['scopeName'].toString();

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
                              initialValue: getServiceProviderForScope(
                                  currentObj['scopeName']),
                              style: TextStyle(color: blackColor),
                              // controller: PBhandlingController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (currentObj['scopeName'].toString() ==
                                      "PBhandling") {
                                    PBhandlingtext = value.toString();
                                  } else if (currentObj['scopeName']
                                          .toString() ==
                                      "Ramphandling") {
                                    Ramphandlingtext = value;
                                  } else if (currentObj['scopeName']
                                          .toString() ==
                                      "Cargohandling") {
                                    Cargohandlingtext = value;
                                  } else if (currentObj['scopeName']
                                          .toString() ==
                                      "Deicingoperations") {
                                    Deicingoperationstext = value;
                                  } else if (currentObj['scopeName']
                                          .toString() ==
                                      "AircraftMarshalling") {
                                    AircraftMarshallingtext = value;
                                  } else if (currentObj['scopeName']
                                          .toString() ==
                                      "Loadcontrol") {
                                    Loadcontroltext = value;
                                  } else if (currentObj['scopeName']
                                          .toString() ==
                                      "Aircraftmovement") {
                                    Aircraftmovementtext = value;
                                  } else if (currentObj['scopeName']
                                          .toString() ==
                                      "Headsetcommunication") {
                                    Headsetcommunicationtext = value;
                                  } else if (currentObj['scopeName']
                                          .toString() ==
                                      "Passengerbridge") {
                                    Passengerbridgetext = value;
                                  }
                                });
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
                            "PassengerbridgeServiceProvider": Passengerbridge.toString() == 'No' ||
                                Passengerbridge.toString() == '2' ||
                                Passengerbridge.toString() == 'CLC' ? "" : Passengerbridgetext,
                            "Ramphandling": Ramphandling,
                            "RamphandlingServiceProvider": Ramphandling.toString() == 'No' ||
                                Ramphandling.toString() == '2' ||
                                Ramphandling.toString() == 'CLC' ? "" : Ramphandlingtext,
                            "Cargohandling": Cargohandling,
                            "CargohandlingServiceProvider": Cargohandling.toString() == 'No' ||
                                Cargohandling.toString() == '2' ||
                                Cargohandling.toString() == 'CLC' ? "" : Cargohandlingtext,
                            "PBhandling": PBhandling,
                            "PBhandlingServiceProvider": PBhandling.toString() == 'No' ||
                                PBhandling.toString() == '2' ||
                                PBhandling.toString() == 'CLC' ? "" : PBhandlingtext,
                            "AircraftMarshalling": AircraftMarshalling,
                            "AircraftMarshallingServiceProvider":
                            AircraftMarshalling.toString() == 'No' ||
                                AircraftMarshalling.toString() == '2' ||
                                AircraftMarshalling.toString() == 'CLC' ? "" : AircraftMarshallingtext,
                            "Loadcontrol": Loadcontrol,
                            "LoadcontrolServiceProvider": Loadcontrol.toString() == 'No' ||
                                Loadcontrol.toString() == '2' ||
                                Loadcontrol.toString() == 'CLC' ? "" : Loadcontroltext,
                            "Deicingoperations": Deicingoperations,
                            "DeicingoperationsServiceProvider":
                            Deicingoperations.toString() == 'No' ||
                                Deicingoperations.toString() == '2' ||
                                Deicingoperations.toString() == 'CLC' ? "" : Deicingoperationstext,
                            "Headsetcommunication": Headsetcommunication,
                            "HeadsetcommunicationServiceProvider":
                            Headsetcommunication.toString() == 'No' ||
                                Headsetcommunication.toString() == '2' ||
                                Headsetcommunication.toString() == 'CLC' ? "" : Headsetcommunicationtext,
                            "Aircraftmovement": Aircraftmovement,
                            "AircraftmovementServiceProvider" :
                            Aircraftmovement.toString() == 'No' ||
                                Aircraftmovement.toString() == '2' ||
                                Aircraftmovement.toString() == 'CLC' ? "" : Aircraftmovementtext,
                            "restartOperationName": restartOperationName,
                            "allAirlinesSameServiceProviderName":
                            restartOperationName.toString() == 'No' ||
                                restartOperationName.toString() == '2' ||
                                restartOperationName.toString() == 'CLC' ? "" : allAirlinesSameServiceProviderName,
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
                          } else if (Headsetcommunication.toString().isEmpty ||
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
                                    auditNumber: widget.auditNumber, gopaNumberwithstationCode: '',
                                  ),
                                ));
                          }
                        },
                      )),
                ),
              ])),
        )));
  }

  getServiceProviderForScope(scopeName) {
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
    } else {
      return "";
    }
  }

  getScopeOfAudit() async {
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
          if (data[0]['pBhandlingID'] != '') {
            PBhandling = data[0]['pBhandlingID'];
            PBhandlingName = data[0]['pBhandling'].toString();
            disabledScopeServiceTextBlocks(PBhandlingName, 'PBhandling');
            PBhandlingtext = data[0]['pBhandlingServiceProvider'].toString();

         }
          if (data[0]['ramphandlingID'] != '') {
            Ramphandling = data[0]['ramphandlingID'];
            RamphandlingName = data[0]['ramphandling'].toString();
            disabledScopeServiceTextBlocks(RamphandlingName, 'Ramphandling');
            Ramphandlingtext = data[0]['ramphandlingServiceProvider'].toString();
          }
          if (data[0]['cargohandlingID'] != '') {
            Cargohandling = data[0]['cargohandlingID'];
            CargohandlingName = data[0]['cargohandling'].toString();
            disabledScopeServiceTextBlocks(CargohandlingName, 'Cargohandling');
            Cargohandlingtext = data[0]['cargohandlingServiceProvider'].toString();
          }
          if (data[0]['deicingoperationsID'] != '') {
            Deicingoperations = data[0]['deicingoperationsID'];
            DeicingoperationsName = data[0]['deicingoperations'].toString();
            disabledScopeServiceTextBlocks(DeicingoperationsName, 'Deicingoperations');
            Deicingoperationstext = data[0]['deicingoperationsServiceProvider'].toString();
          }
          if (data[0]['aircraftMarshallingID'] != '') {
            AircraftMarshalling = data[0]['aircraftMarshallingID'];
            AircraftMarshallingName = data[0]['aircraftMarshalling'].toString();
            disabledScopeServiceTextBlocks(AircraftMarshallingName, 'AircraftMarshalling');
            AircraftMarshallingtext = data[0]['aircraftMarshallingServiceProvider'].toString();
          }
          if (data[0]['loadcontrolID'] != '') {
            Loadcontrol = data[0]['loadcontrolID'];
            LoadcontrolName = data[0]['loadcontrol'].toString();
            disabledScopeServiceTextBlocks(LoadcontrolName, 'Loadcontrol');
            Loadcontroltext = data[0]['loadcontrolServiceProvider'].toString();
          }
          if (data[0]['aircraftmovementID'] != '') {
            Aircraftmovement = data[0]['aircraftmovementID'];
            AircraftmovementName = data[0]['aircraftmovement'].toString();
            disabledScopeServiceTextBlocks(AircraftmovementName, 'Aircraftmovement');
            Aircraftmovementtext = data[0]['aircraftmovementServiceProvider'].toString();
          }
          if (data[0]['headsetcommunicationID'] != '') {
            Headsetcommunication = data[0]['headsetcommunicationID'];
            HeadsetcommunicationName = data[0]['headsetcommunication'].toString();
            disabledScopeServiceTextBlocks(HeadsetcommunicationName, 'Headsetcommunication');
            Headsetcommunicationtext = data[0]['headsetcommunicationServiceProvider'].toString();
          }
          if (data[0]['passengerbridgeID'] != '') {
            Passengerbridge = data[0]['passengerbridgeID'];
            PassengerbridgeName = data[0]['passengerbridge'].toString();
            disabledScopeServiceTextBlocks(PassengerbridgeName, 'Passengerbridge');
            Passengerbridgetext = data[0]['passengerbridgeServiceProvider'].toString();
          }
        });

        //setScopeOfAudit(scopeName,data);
      });
    } else {
      var overviewBody =
          await db.getGOPAOverviewDataByAuditId(widget.auditNumber);
      setState(() {
        List data = overviewBody;
        for (int i = 0; i < data.length; i++) {
          if (data[i]['pBhandlingID'] != 0) {
            PBhandling = data[i]['pBhandlingID'];
            PBhandlingName = data[i]['pBhandling'].toString();
            PBName = data[i]['pBhandling'].toString();
            disabledScopeServiceTextBlocks(PBhandlingName, 'PBhandling');
            PBhandlingtext = data[i]['pBhandlingServiceProvider'].toString();
          }
          if (data[i]['ramphandlingID'] != 0) {
            Ramphandling = data[i]['ramphandlingID'];
            RamphandlingName = data[i]['ramphandling'].toString();
            RampName = data[i]['ramphandling'].toString();
            disabledScopeServiceTextBlocks(RamphandlingName, 'Ramphandling');
            Ramphandlingtext =
                data[i]['ramphandlingServiceProvider'].toString();
          }
          if (data[i]['cargohandlingID'] != 0) {
            Cargohandling = data[i]['cargohandlingID'];
            CargohandlingName = data[i]['cargohandling'].toString();
            CargoName = data[i]['cargohandling'].toString();
            disabledScopeServiceTextBlocks(CargohandlingName, 'Cargohandling');
            Cargohandlingtext =
                data[i]['cargohandlingServiceProvider'].toString();
          }
          if (data[i]['deicingoperationsID'] != 0) {
            Deicingoperations = data[i]['deicingoperationsID'];
            DeicingoperationsName = data[i]['deicingoperations'].toString();
            DeicingName = data[i]['deicingoperations'].toString();
            disabledScopeServiceTextBlocks(
                DeicingoperationsName, 'Deicingoperations');
            Deicingoperationstext =
                data[i]['deicingoperationsServiceProvider'].toString();
          }
          if (data[i]['aircraftMarshallingID'] != 0) {
            AircraftMarshalling = data[i]['aircraftMarshallingID'];
            AircraftMarshallingName = data[i]['aircraftMarshalling'].toString();
            AircraftMarsName = data[i]['aircraftMarshalling'].toString();
            disabledScopeServiceTextBlocks(
                AircraftMarshallingName, 'AircraftMarshalling');
            AircraftMarshallingtext =
                data[i]['aircraftMarshallingServiceProvider'].toString();
          }
          if (data[i]['loadcontrolID'] != 0) {
            Loadcontrol = data[i]['loadcontrolID'];
            LoadcontrolName = data[i]['loadcontrol'].toString();
            LoadName = data[i]['loadcontrol'].toString();
            disabledScopeServiceTextBlocks(LoadcontrolName, 'Loadcontrol');
            Loadcontroltext = data[i]['loadcontrolServiceProvider'].toString();
          }
          if (data[i]['aircraftmovementID'] != 0) {
            Aircraftmovement = data[i]['aircraftmovementID'];
            AircraftmovementName = data[i]['aircraftmovement'].toString();
            AircraftmovName = data[i]['aircraftmovement'].toString();
            disabledScopeServiceTextBlocks(
                AircraftmovementName, 'Aircraftmovement');
            Aircraftmovementtext =
                data[i]['aircraftmovementServiceProvider'].toString();
          }
          if (data[i]['headsetcommunicationID'] != 0) {
            Headsetcommunication = data[i]['headsetcommunicationID'];
            HeadsetcommunicationName =
                data[i]['headsetcommunication'].toString();
            HeadsetcomName = data[i]['headsetcommunication'].toString();
            disabledScopeServiceTextBlocks(
                HeadsetcommunicationName, 'Headsetcommunication');
            Headsetcommunicationtext =
                data[i]['headsetcommunicationServiceProvider'].toString();
          }
          if (data[i]['passengerbridgeID'] != 0) {
            Passengerbridge = data[i]['passengerbridgeID'];
            PassengerbridgeName = data[i]['passengerbridge'].toString();
            PassbridgeName = data[i]['passengerbridge'].toString();
            disabledScopeServiceTextBlocks(
                PassengerbridgeName, 'Passengerbridge');
            Passengerbridgetext =
                data[i]['passengerbridgeServiceProvider'].toString();
          }
        }
      });
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

    if (isOnline) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      ApiService.get("GetGOPAScopeMasterData", pref.getString('token'))
          .then((success) {
        var body = jsonDecode(success.body);
        var scopeBody = body['getGOPAScopeMasterData'];
        makeScopeAuditCheckListAget(scopeBody);
      });
    } else {
      List scopeBody = await db.getGOPAScopeAuditData();

      makeScopeAuditCheckListAget(scopeBody);
    }
  }

  makeScopeAuditCheckListAget(scopeBody) async {
    _fetchData(context);
    // CoolAlert.show(
    //   width: 300,
    //   text: 'Loading. . .',
    //   flareAnimationName: "play",
    //   backgroundColor: bgColor,
    //   barrierDismissible: false,
    //   context: context,
    //   type: CoolAlertType.loading,
    //   autoCloseDuration: Duration(seconds: 3),
    // );
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

  void basedOnScopeCheckListControls(status, interlinks) {


    if (status.toString() == 'No' || status.toString() == 'CLC') {
      if (interlinks.toString() != "") {

      } else {
      }
    } else {

    }
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
}

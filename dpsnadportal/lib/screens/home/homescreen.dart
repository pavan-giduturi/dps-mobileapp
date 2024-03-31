import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cool_alert/cool_alert.dart';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/restapi.dart';
import '../../database/database_table.dart';
import '../../helpers/utilities.dart';
import '../../widgets/constants.dart';
import '../../widgets/responsive.dart';
import '../../widgets/textstyle.dart';
import '../classtimetable/classtimetables.dart';
import '../gopa/searchortrack/gopa_searchortrack.dart';
import '../leave/leavehistory.dart';
import '../login/loginscreen.dart';
import '../notifications/notifications.dart';
import '../profile/profileinfo.dart';

class AuditHome extends StatefulWidget {
  final String fromType;
  const AuditHome({Key? key, required this.fromType}) : super(key: key);

  @override
  State<AuditHome> createState() => _AuditHomeState();
}

class _AuditHomeState extends State<AuditHome> {
  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: AuditHomePage(
        type: "mobile",
        fromType: widget.fromType,
      ),
      desktop: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: AuditHomePage(
                    type: "desktop",
                    fromType: widget.fromType,
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

class AuditHomePage extends StatefulWidget {
  final String type;
  final String fromType;
  const AuditHomePage({Key? key, required this.type, required this.fromType})
      : super(key: key);

  @override
  State<AuditHomePage> createState() => _AuditHomePageState();
}

class _AuditHomePageState extends State<AuditHomePage> {
  DatabaseHelper db = DatabaseHelper();
  var isdraftAvail = [];
  String profileimge = "assets/images/profilepick.png";

  List imageList = [
    'assets/icons/draftaudit_icon.png',
  ];
  List menuList = [
    "OSPC",
  ];

  String Username = "";
  String empRole = "";
  String empCode = "";
  List pluginName = ["Assignments","Class Timetable","Leave"];
  // List pluginName = ["Assignments","Class Timetable","Apply Leave","Attendance","Notice Board","Library","Activities"];
  List pluginIds = [1,2,3];
  // List pluginIds = [1,2,3,4,5,6,7];
  String pluginImage = "";
  var menuData;
  List stationList = [];
  Timer? _timer;
  String? airportSationId = '';
  String? selectedStation = "";
  List airlineList = [];
  List groundHandlers = [];
  String? selectedGroundHandler = "";
  String? groundHandlerId = '';
  List checkList = [];
  // List overviewdata = [];
  // List overviewchecklistdata = [];
  var saveBody;
  bool isInternetAvailable = false;
  bool syncSymbol = true;
  var checknet = 0;
  late Icon netIcon = Icon(Icons.wifi);
  late Icon belIcon = Icon(Icons.notifications_outlined);

  String attachedBaseImgData = "";
  var UserRole;
  String toolTip = "";
  String loaderMessage = "";
  String alertMsg = "";
  late Icon wifiIcon = const Icon(Icons.wifi);
  final _advancedDrawerController = AdvancedDrawerController();
  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.fromType == 'login') {
      setState(() {
        loaderMessage = 'Loading data please wait. . .';
      });
    } else {
      setState(() {
        loaderMessage = 'Please wait. . .';
      });
    }

    // getmainmenuApi();
    setUsername();
    // AllAPICalls();
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }


  @override
  Widget build(BuildContext context) {
    if (Utilities.dataState == "Connection lost") {
      setState(() {
        isInternetAvailable = false;
        checknet = 0;
        netIcon = Icon(
          Icons.sync_disabled,
          size: 30,
        );
        toolTip = "offline";
        alertMsg = "You are offline";
        wifiIcon = Icon(
          Icons.wifi_off,
          size: 30,
        );
      });
    } else {
      setState(() {
        isInternetAvailable = true;
        netIcon = Icon(
          Icons.sync,
          size: 30,
        );
        toolTip = "Refresh";
        alertMsg = "You are online";
        wifiIcon = Icon(
          Icons.wifi,
          size: 30,
        );
        checknet = 1;
        if (checknet == 1) {
          checknet++;
          // AllAPICalls();
        }
      });
    }

    return AdvancedDrawer(
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: red,
          ),
        ),
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        // openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: SafeArea(
          child: ListTileTheme(
            textColor: Colors.black,
            iconColor: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200.0,
                        height: 100.0,
                        margin: const EdgeInsets.only(
                          top: 24.0,
                          bottom: 24.0,
                          // bottom: 64.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          // color: Colors.black26,
                          // shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/images/login_logo.jpg",
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: Text(
                          Username.toString() + empCode.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: whiteColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        child: Text(
                          empRole.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: whiteColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: whiteColor,
                  thickness: 2,
                ),
                ListTile(
                  onTap: () => Get.to(() => const Profileinfopage(),
                      arguments: profileimge.toString()),
                  leading: const Icon(Icons.account_box_outlined),
                  title: const Text('My Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                ListTile(
                  onTap: () {
                    clearData(context);
                    Get.offAll(() => const LoginScreen());
                  },
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      size: 30,
                      color: value.visible ? whiteColor : whiteColor,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            ),
            // leading: GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => Profileinfopage(
            //                     profilepic: profileimge,
            //                   )));
            //     },
            //     child: Container(
            //       margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
            //       decoration: BoxDecoration(
            //           image: DecorationImage(
            //               image: AssetImage(
            //                 'assets/images/profilepick.png',
            //               ),
            //               fit: BoxFit.fill),
            //           borderRadius: BorderRadius.all(Radius.circular(45.0)),
            //           boxShadow: [BoxShadow(blurRadius: 7.0, color: red)]),
            //     )),
            title: Container(
                height: 50,
                width: 150,
                padding: const EdgeInsets.all(10),
                color: red,
                child: Image.asset(
                  "assets/images/login_logo.jpg",
                )),
            centerTitle: true,
            backgroundColor: red,
            actions: [
              // IconButton(
              //   onPressed: () {
              //     Get.snackbar(
              //       'Alert',
              //       alertMsg,
              //       titleText: const Text(
              //         'Alert',
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 18,
              //             color: red),
              //       ),
              //       messageText: Text(
              //         alertMsg,
              //         style: const TextStyle(fontWeight: FontWeight.w400),
              //       ),
              //       backgroundColor: whiteColor,
              //       overlayBlur: 3,
              //     );
              //   },
              //   icon: wifiIcon,
              // ),
              // IconButton(
              //   disabledColor: Colors.black26,
              //   onPressed: syncSymbol == false
              //       ? null
              //       : () {
              //           //checkInternetConnection();
              //           if (isInternetAvailable == true) {
              //             CoolAlert.show(
              //                 width: 300,
              //                 title: 'Refreshing Data',
              //                 text: 'Click Yes to refresh master data',
              //                 flareAnimationName: "play",
              //                 backgroundColor: const Color(0xFFe7e7e7),
              //                 barrierDismissible: false,
              //                 context: context,
              //                 type: CoolAlertType.confirm,
              //                 confirmBtnText: 'Yes',
              //                 cancelBtnText: 'No',
              //                 cancelBtnTextStyle: const TextStyle(
              //                     color: red, fontWeight: FontWeight.bold),
              //                 confirmBtnColor: const Color(0xFF216f82),
              //                 onCancelBtnTap: () {
              //                   Navigator.pop(context);
              //                 },
              //                 onConfirmBtnTap: () {
              //                   setState(() {
              //                     syncSymbol = false;
              //                     loaderMessage =
              //                         'Please wait loading data. . .';
              //                     Future.delayed(const Duration(seconds: 40),
              //                         () {
              //                       setState(() {
              //                         syncSymbol = true;
              //                       });
              //                     });
              //                   });
              //                   Navigator.pop(context);
              //                   AllAPICalls();
              //                 });
              //           } else {
              //             Utilities.showAlert(context,
              //                 'Please connect to Internet for Loading data');
              //           }
              //         },
              //   icon: netIcon,
              //   tooltip: toolTip,
              // ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Notifications()));
                },
                icon: const Icon(
                  Icons.notifications,
                  size: 30,
                ),
                tooltip: 'Exit',
              )
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/login_logo.jpg',
                    ),
                    alignment: Alignment.center,
                    opacity: 0.05)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Welcome " + Username,
                        style: const TextStyle(
                            color: darkgrey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                        child: GridView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.type == 'mobile' ? 3 : 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: pluginIds.length,
                      itemBuilder: (BuildContext context, int index) {
                        setImage(pluginIds[index]);
                        return GestureDetector(
                          onTap: () {
                            var navId;
                            navId = pluginIds[index];
                            // getFilteredmenu(navId);
                            // Utilities.mainNavigateUrl(navId, context);
                            if(navId == 1){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Gopasearchortrack()));
                            }else if(navId == 2){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Classtimetable()));
                            }else if(navId == 3){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Leavehistory()));
                            }else if(navId == 4){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Classtimetable()));
                            }else if(navId == 5){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Classtimetable()));
                            }else if(navId == 6){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Classtimetable()));
                            }else if(navId == 7){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Classtimetable()));
                            }else{
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Gopasearchortrack()));
                            }

                          },
                          child: SizedBox(
                            height: 60,
                            width: 30,
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset(
                                    pluginImage,
                                    height: 50,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    pluginName[index],
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.notosansRegular(
                                        color: darkgrey, size: 10.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(10),
                  //   child: SizedBox(
                  //       child: GridView.builder(
                  //     physics: const ScrollPhysics(),
                  //     shrinkWrap: true,
                  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: widget.type == 'mobile' ? 3 : 5,
                  //       crossAxisSpacing: 10,
                  //       mainAxisSpacing: 10,
                  //     ),
                  //     itemCount: 1,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return GestureDetector(
                  //         onTap: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => const LoginScreen()));
                  //         },
                  //         child: SizedBox(
                  //           height: 60,
                  //           width: 30,
                  //           child: Card(
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 const SizedBox(
                  //                   height: 10,
                  //                 ),
                  //                 Image.asset(
                  //                   imageList[index],
                  //                   height: 50,
                  //                   width: 50,
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 10,
                  //                 ),
                  //                 Text(
                  //                   menuList[index],
                  //                   textAlign: TextAlign.center,
                  //                   style: AppTextStyle.notosansRegular(
                  //                       color: darkgrey, size: 10.0),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   )),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }

  setUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      Username = pref.getString("firstName").toString();
      empCode = "  ( " + pref.getString("employeeCode").toString() + " )";
    });
  }

  checkIsdarft() async {
    var draftAvai = await db.getGOPACheckList();
    setState(() {
      isdraftAvail = draftAvai;
    });
  }

  getmainmenuApi() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    // EasyLoading.show(
    //   status: loaderMessage.toString(),
    // );
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    profileimge = pref.getString("imageBase64").toString();
    if (isOnline) {
      ApiService.get(
              "GetMenubasedonLoginEMPNo?EMPNumber=${pref.getString("employeeCode")}&UserID=${pref.getString("userID")}",
              pref.getString('token'))
          .then((success) {
        if (success.statusCode == 200) {
          var data = jsonDecode(success.body)['dyMenuPlugin'];
          menuData = jsonDecode(success.body)['dyMenuFeature'];

          print(data);
          print("menuData=======");
          print(menuData);
          setState(() {
            for (int i = 0; i < data.length; i++) {
              if (data[i]['pModuleID'] == '3') {
                pluginName.add(data[i]['pDisplayName']);
                pluginIds.add(data[i]['pPluginID']);
              }
            }
          });
        } else {
          EasyLoading.showInfo("Menu Loading Failed");
        }
      });
    }
  }

  AllAPICalls() async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    if (isOnline) {
      // syncCAPAWorkflowData('sync');
      // SyncGOPAData('sync');
      // makeStationApiCall();
      // GetGOPAScopeMasterData();
      // GetMenubasedonLoginEMPNo();
      // GetChecklistRating();
      // GetCAPAModules();
      // // GetCAPAStatus();
      // GetDraftGOPANumberbasedonEMPStation();
      //
      // GOPAOfflineDB();
    } else {
      // _fetchData(context);
    }
  }

  setImage(imageId) {
    if (imageId == '105' || imageId == '109') {
      pluginImage = 'assets/icons/capa_icon.png';
    } else if (imageId == '137') {
      pluginImage = 'assets/icons/newaudit_icon.png';
    } else if (imageId == '145') {
      pluginImage = 'assets/icons/newaudit_icon.png';
    } else if (imageId == '156') {
      pluginImage = 'assets/icons/newaudit_icon.png';
    } else {
      pluginImage = 'assets/icons/newaudit_icon.png';
    }
  }

  getFilteredmenu(id) {
    Utilities.dynMenudata = [];
    for (int i = 0; i < menuData.length; i++) {
      if (id == menuData[i]['fPluginID']) {
        var body = jsonEncode({
          "subMenuName": menuData[i]['fDisplayName'].toString(),
          "subIds": menuData[i]['fMenuID'],
          "mainIds": menuData[i]['fPluginID']
        });
        Utilities.dynMenudata.add(body);
      }
    }
  }

  makeStationApiCall() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    // EasyLoading.show(
    //   status: loaderMessage.toString(),
    // );
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
        var body = jsonDecode(success.body);
        stationList = body;
        Utilities.scheduledStations = stationList;
        for (int i = 0; i < stationList.length; i++) {
          db.saveorupdateStation(
              stationList[i], pref.getString('employeeCode'));
          makeAirlinesApiCall(stationList[i]['id']);
          makeGroundHandlerApiCall(stationList[i]['id']);
          IsGOPAClosedbasedonStation(stationList[i]['id']);
          GetGOPANumberforMOApi(
              stationList[i]['id'], pref.getString('employeeCode'));
        }
      } else {
        EasyLoading.showInfo("Data Loading Failed");
      }
    });
  }



  SaveCheckListByRole(type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    ApiService.get("GetGOPAChecklists?PID=145&AuditType=$type",
            pref.getString('token'))
        .then((success) async {
      //setState(() {
      var annexureChecklist = json.decode(success.body);
      //List mochecklist = await db.getAnnexureChecklists();

      // if (annexureChecklist.length != mochecklist.length) {
      for (int i = 0; i < annexureChecklist.length; i++) {
        await db.saveAnnexureChecklist(annexureChecklist[i]);
      }
      // }
      //});
    });

    ApiService.get("GetGOPAChecklists?PID=137&AuditType=$type",
            pref.getString('token'))
        .then((success) async {
      //setState(() {
      var gopaChecklist = json.decode(success.body);
      // List gopaOfflineChecklist = await db.getGOPAChecklistData();

      // if (gopaChecklist.length != gopaOfflineChecklist.length) {
      for (int i = 0; i < gopaChecklist.length; i++) {
        await db.saveGOPAChecklistData(gopaChecklist[i]);
        // }
      }

      //});
    });
  }

  getUserRoleData(response) async {
    SharedPreferences prefRole = await SharedPreferences.getInstance();
    prefRole.setString("user_role", response.toString());
  }

  SyncGOPAData(type) async {
    saveGOPAData();
    SyncMOData();
  }

  syncCAPAWorkflowData(type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var capaWorkflowData = await db.getOfflineCAPAWorkflowData();

    String dueDate = "";
    var AssignedTo;
    var finalImage = "";
    try {
      if (capaWorkflowData.length > 0) {
        for (int i = 0; i < capaWorkflowData.length; i++) {
          var capaAssignedData = await db
              .getOfflineAssignedCapas(capaWorkflowData[i]['capaNumber']);
          var capaOverviewData = await db
              .getCAPAMainDataoverview(capaWorkflowData[i]['capaNumber']);

          var str = capaWorkflowData[i]['assignedFrom'].toString().split('(');
          var split = str[1];
          var split2 = split.toString().split(')');
          var AssignedFrom = split2[0];

          if (capaWorkflowData[i]['assignedTo'].toString() != '') {
            var str1 = capaWorkflowData[i]['assignedTo'].toString().split('(');

            var split1 = str1[1];
            var split22 = split1.toString().split(')');
            AssignedTo = split22[0];
          } else {
            AssignedTo = pref.getString("employeeCode").toString();
          }

          if (capaWorkflowData[i]['FilePath'].toString() != "null") {
            var bytes = File(capaWorkflowData[i]['FilePath'].toString())
                .readAsBytesSync();
            finalImage = base64Encode(bytes).toString();
          } else {
            finalImage = "";
          }

          var body = json.encode({
            "PluginID": "109",
            "ObjectNumber": capaWorkflowData[i]['capaNumber'],
            "Level": capaOverviewData[0]['level'],
            "CAPADetails": capaWorkflowData[i]['capaDetails'],
            "CAPAComments": capaWorkflowData[i]['capaComments'],
            "Status": capaWorkflowData[i]['statusID'],
            "AssignedFrom": AssignedFrom,
            "AssignedTo": AssignedTo,
            "UserID": pref.getString('userID'),
            "DateTime.Now": capaWorkflowData[i]['capaCreationDate'],
            "CAPAID": capaAssignedData[0]['id'],
            "RejectionComments": capaWorkflowData[i]['rejectionComments'],
            "DueDate": dueDate,
            "Comments": capaWorkflowData[i]['comments'],
            "ImageName": capaWorkflowData[i]['fileName'],
            "AttachedByName": capaWorkflowData[i]['attachedBy'],
            "ImageBase64": finalImage,
          });

          var datal = capaWorkflowData.length - 1;

          await saveOfflineDatetoOnline(
              body, i, datal, capaWorkflowData[i]['capaNumber']);
        }
      } else {
        _timer?.cancel();
        type == "logout"
            ? EasyLoading.showSuccess("Logged out successfully")
            : EasyLoading.showSuccess("Data Loading success");
      }

      if (type == "sync") {
        CAPAOfflineDB();
        db.deleteOfflineDatabaseOnlineData();
      }

      if (type == "logout") {
        db.deleteOfflineDatabaseData();
        clearData(context);
      }
    } catch (e) {
      print(e);
    }
  }

  saveOfflineDatetoOnline(body, i, datal, capanumber) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    // EasyLoading.show(
    //   status: loaderMessage.toString(),
    // );
    try {
      ApiService.post("NewCAPASaveandWorkflow", body, pref.getString('token'))
          .then((success) {
        if (success.statusCode == 200) {
          EasyLoading.addStatusCallback((status) {
            if (status == EasyLoadingStatus.dismiss) {
              _timer?.cancel();
            }
          });

          if (i.toString() == datal.toString()) {
            db.deleteOfflineCAPAWorkflowRecord(capanumber);
          }
        } else {
          EasyLoading.showInfo("Data Loading Failed");
        }
      });
    } catch (e) {
      print(e);
    }
  }

  saveGOPAData() async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var emplogin = pref.getString("employeeCode").toString();
    var draftAudits = await db.getGOPAOfflineDraftAudits(emplogin);

    List CCAChecklistsList = [];
    var FileAttachmentSaveBody;

    for (int i = 0; i < draftAudits.length; i++) {
      var arry = draftAudits[i]['auditID'].toString().split("_");
      if (!arry.contains("GOPA")) {
        var auditNumber = draftAudits[i]['auditNumber'];
        var deleteauditNumber = draftAudits[i]['auditNumber'];
        var auditID = draftAudits[i]['auditID'];
        CCAChecklistsList = [];
        var gopaDetailsBody = await db.getGOPAOverviewDataByAuditId(auditID);

        var attachmentsBody = await db.getOfflineGOPAItemImageData(auditNumber);

        var GopaChecklistBody = await db.getGOPAChecklistDataByAuditId(auditID);

        for (int j = 0; j < gopaDetailsBody.length; j++) {
          var code = gopaDetailsBody[j]['gopaNumber'].toString().split('/');
          var stationCode = code[0];

          for (int k = 0; k < GopaChecklistBody.length; k++) {
            var checklistObj = jsonEncode({
              "ObjectID": draftAudits[i]['auditID'],
              "ChecklistID": GopaChecklistBody[k]['checklistID'],
              "ChecklistItemID": GopaChecklistBody[k]['checklistItemID'],
              "ChecklistItemDataID":
                  GopaChecklistBody[k]['checklistItemDataID'].toString(),
              "EmpID": GopaChecklistBody[k]['empID'].toString(),
              "Comments": GopaChecklistBody[k]['comments'].toString(),
              "CheckListName": GopaChecklistBody[k]['checkListName'].toString(),
              "ItemName": GopaChecklistBody[k]['itemName'],
              "SubchecklistID":
                  GopaChecklistBody[k]['subchecklistID'].toString(),
              "Subchecklistname":
                  GopaChecklistBody[k]['subchecklistname'].toString(),
              "Checklistorder":
                  GopaChecklistBody[k]['checklistorder'].toString(),
              "SubChecklistorder":
                  GopaChecklistBody[k]['subChecklistorder'].toString(),
            });

            var gopachkbody1 = jsonDecode(checklistObj);
            CCAChecklistsList.add(gopachkbody1);
          }

          var GopaSaveBody2 = jsonEncode({
            "StationID": gopaDetailsBody[j]['stationID'],
            "StationCode": stationCode,
            "AuditID": draftAudits[i]['auditID'],
            "HoNumber": gopaDetailsBody[j]['HoNumber'],
            "GGHID": gopaDetailsBody[j]['gghid'],
            "AuditDate": '',
            "AuditDoneby": emplogin,
            "AirlineIDs": gopaDetailsBody[j]['airlineIDs'],
            "Statusid": gopaDetailsBody[j]['statusid'],
            "SubmittedBy": emplogin,
            "UserID": gopaDetailsBody[j]['userID'],
            "Msg": '',
            "ImageBase64": '',
            "ImageName": '',
            "AttachedByName": '',
            "SubmittedDate": gopaDetailsBody[j]['submittedDate'],
            "GOPANumber": draftAudits[i]['auditNumber'],
            "Restartoperations": gopaDetailsBody[j]['restartoperationsID'],
            "Sameserviceprovider": gopaDetailsBody[j]['sameserviceproviderID'],
            "PBhandling": gopaDetailsBody[j]['pBhandlingID'],
            "Ramphandling": gopaDetailsBody[j]['ramphandlingID'],
            "Cargohandling": gopaDetailsBody[j]['cargohandlingID'],
            "Deicingoperations": gopaDetailsBody[j]['deicingoperationsID'],
            "AircraftMarshalling": gopaDetailsBody[j]['aircraftMarshallingID'],
            "Loadcontrol": gopaDetailsBody[j]['loadcontrolID'],
            "Aircraftmovement": gopaDetailsBody[j]['aircraftmovementID'],
            "Headsetcommunication": gopaDetailsBody[j]
                ['headsetcommunicationID'],
            "Passengerbridge": gopaDetailsBody[j]['passengerbridgeID'],
            "ISAGO": gopaDetailsBody[j]['isagoid'],
            "Duedate": gopaDetailsBody[j]['duedateID'],
            "Reason": gopaDetailsBody[j]['reason'],
            "PBhandlingServiceProvider": gopaDetailsBody[j]
                ['pBhandlingServiceProvider'],
            "RamphandlingServiceProvider": gopaDetailsBody[j]
                ['ramphandlingServiceProvider'],
            "CargohandlingServiceProvider": gopaDetailsBody[j]
                ['cargohandlingServiceProvider'],
            "DeicingoperationsServiceProvider": gopaDetailsBody[j]
                ['deicingoperationsServiceProvider'],
            "AircraftMarshallingServiceProvider": gopaDetailsBody[j]
                ['aircraftMarshallingServiceProvider'],
            "LoadcontrolServiceProvider": gopaDetailsBody[j]
                ['loadcontrolServiceProvider'],
            "AircraftmovementServiceProvider": gopaDetailsBody[j]
                ['aircraftmovementServiceProvider'],
            "HeadsetcommunicationServiceProvider": gopaDetailsBody[j]
                ['headsetcommunicationServiceProvider'],
            "PassengerbridgeServiceProvider": gopaDetailsBody[j]
                ['passengerbridgeServiceProvider'],
            "CCAChecklistsList": CCAChecklistsList,
          });
          ApiService.post("NewGOPASave", GopaSaveBody2, pref.getString('token'))
              .then((success) {
            var finalsavebody = jsonDecode(success.body);
            // Sync Attachment Data start
            if (attachmentsBody.length > 0) {
              for (int j = 0; j < attachmentsBody.length; j++) {
                FileAttachmentSaveBody = jsonEncode({
                  "PluginID": attachmentsBody[j]['PluginID'],
                  "AuditID": draftAudits[i]['auditID'],
                  "AuditNumber": draftAudits[i]['auditNumber'],
                  "featurID": attachmentsBody[j]['featurID'],
                  "ChecklistID": attachmentsBody[j]['ChecklistID'],
                  "ChecklistItemID": attachmentsBody[j]['ChecklistItemID'],
                  "SubchecklistID":
                      attachmentsBody[j]['SubchecklistID'].toString(),
                  "FileName": attachmentsBody[j]['FileName'].toString(),
                  "AttachedBy": attachmentsBody[j]['AttachedBy'].toString(),
                  "ImageBase64": attachmentsBody[j]['ImageBase64'].toString(),
                });
                ApiService.post("SaveFileAttachmentforChecklist",
                        FileAttachmentSaveBody, pref.getString('token'))
                    .then((success) {});
              }
            }
            //end
          });
        }
        if (isOnline) {
          deleteDB(deleteauditNumber);
        }
      }
    }
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => AuditHome()),
    //         (Route<dynamic> route) => false);
  }

  SyncMOData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var emplogin = pref.getString("employeeCode").toString();
    var draftMos = await db.getAnnexureOfflineDraftAudits(emplogin);

    if (draftMos.length > 0) {
      for (int i = 0; i < draftMos.length; i++) {
        var arry = draftMos[i]['annexureID'].toString().split("_");
        if (!arry.contains("MO")) {
          List MOChecklistsList = [];
          var FileAttachmentSaveBody;
          var AnnexuresID = draftMos[i]['annexureID'];
          var deleteannextureId = draftMos[i]['annexureID'];
          var AnnexuresNumber = draftMos[i]['annexureNumber'];

          var MOChecklistBody = await db.getAnnexureOverviewChecklists(
              AnnexuresID, AnnexuresNumber);
          var MoDetailsBody =
              await db.getAnnexureOverviewDetails(AnnexuresID, AnnexuresNumber);

          var attachmentsBody =
              await db.getOfflineGOPAItemImageData(AnnexuresNumber);
          var annexureSaveBody;

          for (int k = 0; k < MOChecklistBody.length; k++) {
            var checklistObj = jsonEncode({
              "ObjectID": AnnexuresID,
              "ChecklistID": MOChecklistBody[k]['checklistID'],
              "ChecklistItemID": MOChecklistBody[k]['checklistItemID'],
              "ChecklistItemDataID":
                  MOChecklistBody[k]['checklistItemDataID'].toString(),
              "EmpID": MOChecklistBody[k]['empID'].toString(),
              "Comments": MOChecklistBody[k]['comments'].toString(),
              "CheckListName": MOChecklistBody[k]['checkListName'].toString(),
              "ItemName": MOChecklistBody[k]['itemName'],
              "SubchecklistID": MOChecklistBody[k]['subchecklistID'].toString(),
              "Subchecklistname":
                  MOChecklistBody[k]['subchecklistname'].toString(),
              "Checklistorder": MOChecklistBody[k]['checklistorder'].toString(),
              "SubChecklistorder":
                  MOChecklistBody[k]['subChecklistorder'].toString(),
            });

            var mochkbody1 = jsonDecode(checklistObj);
            MOChecklistsList.add(mochkbody1);
          }

          for (int j = 0; j < MoDetailsBody.length; j++) {
            annexureSaveBody = jsonEncode({
              "StationID": MoDetailsBody[j]['stationID'],
              "AnnexuresID": AnnexuresID,
              "FlightNo": MoDetailsBody[j]['flightNo'],
              "AuditDate": MoDetailsBody[j]['auditDate'],
              "AuditDoneby": pref.getString('employeeCode'),
              "Statusid": MoDetailsBody[j]['statusid'],
              "AirlineID": MoDetailsBody[j]['airlineID'],
              "SubmittedBy": pref.getString('employeeCode'),
              "UserID": pref.getString('userID'),
              "GOPANumber": MoDetailsBody[j]['gopaNumber'],
              "AnnexuresNumber": AnnexuresNumber,
              "PreviousAuditFlightNo": MoDetailsBody[j]
                  ['previousAuditFlightNo'],
              "Marshallingaircraftdoneby":
                  MoDetailsBody[j]['marshallingaircraftdonebyId'] == ''
                      ? '0'
                      : MoDetailsBody[j]['marshallingaircraftdonebyId'],
              "PassengerHandlingstaff": MoDetailsBody[j]
                  ['passengerHandlingstaff'],
              "LoadControlstaff": MoDetailsBody[j]['loadControlstaff'] == ''
                  ? '0'
                  : MoDetailsBody[j]['loadControlstaff'],
              "RampHandlingstaff": MoDetailsBody[j]['rampHandlingstaff'] == ''
                  ? '0'
                  : MoDetailsBody[j]['rampHandlingstaff'],
              "EquipmentOperators": MoDetailsBody[j]['equipmentOperators'] == ''
                  ? '0'
                  : MoDetailsBody[j]['equipmentOperators'],
              "PassengerBoardingBridge":
                  MoDetailsBody[j]['passengerBoardingBridge'] == ''
                      ? '3'
                      : MoDetailsBody[j]['passengerBoardingBridgeId'],
              "CCAChecklistsList": MOChecklistsList,
            });
          }

          ApiService.post(
                  "NewAnnexuresSave", annexureSaveBody, pref.getString('token'))
              .then((success) {
            var body = jsonDecode(success.body);
            if (body['annexuresID'] > 0) {
              if (attachmentsBody.length > 0) {
                for (int i = 0; i < attachmentsBody.length; i++) {
                  FileAttachmentSaveBody = jsonEncode({
                    "PluginID": attachmentsBody[i]['PluginID'],
                    "AuditID": AnnexuresID.toString(),
                    "AuditNumber": AnnexuresNumber.toString(),
                    "featurID": attachmentsBody[i]['featurID'],
                    "ChecklistID": attachmentsBody[i]['ChecklistID'],
                    "ChecklistItemID": attachmentsBody[i]['ChecklistItemID'],
                    "SubchecklistID":
                        attachmentsBody[i]['SubchecklistID'].toString(),
                    "FileName": attachmentsBody[i]['FileName'].toString(),
                    "AttachedBy": attachmentsBody[i]['AttachedBy'].toString(),
                    "ImageBase64": attachmentsBody[i]['ImageBase64'].toString(),
                  });
                  ApiService.post("SaveFileAttachmentforChecklist",
                          FileAttachmentSaveBody, pref.getString('token'))
                      .then((success) {});
                }
              }
            }
          });
          deleteMODB(deleteannextureId);
        }
      }
    }
  }

  checkInternetConnection() async {
    bool isOnline = await Utilities.CheckUserConnection() as bool;
    if (isOnline) {
      CoolAlert.show(
          width: 300,
          text: 'Do you want to logout ?',
          title: 'Are you sure',
          flareAnimationName: "play",
          backgroundColor: Color(0xFFe7e7e7),
          barrierDismissible: false,
          context: context,
          type: CoolAlertType.confirm,
          confirmBtnText: 'Yes',
          cancelBtnText: 'No',
          cancelBtnTextStyle:
              TextStyle(color: red, fontWeight: FontWeight.bold),
          confirmBtnColor: Color(0xFF216f82),
          onCancelBtnTap: () {
            Navigator.pop(context);
          },
          onConfirmBtnTap: () {
            // syncCAPAWorkflowData("logout");

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false);
          });
    } else {
      Utilities.showAlert(context, 'Check Your Internet Connection');
    }
  }

  deleteOfflineDBData() async {
    db.deleteOfflineDatabaseData();
    syncSymbol = true;
    var fileLoadPath = Utilities.attachmentFilePathLocal;
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

  IsGOPAClosedbasedonStation(id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    ApiService.get(
            "IsGOPAClosedbasedonStation?StationID=$id", pref.getString('token'))
        .then((success) {
      var body = jsonDecode(success.body);
      for (int i = 0; i < body.length; i++) {
        db.saveIsGOPAClosedbasedonStation(body[i], id);
      }
    });
  }

  makeAirlinesApiCall(id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    ApiService.get("GetGOPAAirlinesData?StationID=$id", pref.getString('token'))
        .then((success) {
      var body = jsonDecode(success.body);
      for (int i = 0; i < body.length; i++) {
        db.saveorupdateAirline(body[i], id);
      }
      setState(() {
        airlineList = body;
      });
    });

    var emplogin = pref.getString("employeeCode").toString();
    ApiService.get("GetEMPRole?EMPNo=$emplogin", pref.getString('token'))
        .then((success) {
      setState(() {
        var response = jsonDecode(success.body);
        for (int i = 0; i < response.length; i++) {
          db.saveEMPRole(response[i], emplogin);
        }
      });
    });
  }

  makeGroundHandlerApiCall(id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ApiService.get(
            "GetGOPAGroundhandlerData?StationID=$id", pref.getString('token'))
        .then((success) {
      var body = jsonDecode(success.body);
      for (int i = 0; i < body.length; i++) {
        db.saveorupdateGroundHandler(body[i], id);
      }

      setState(() {
        groundHandlers = body;
        selectedGroundHandler = groundHandlers[0]['groundhandlerName'];
        groundHandlerId = groundHandlers[0]['id'];
      });

      IsGOPAClosedbasedGHApiCall(id, groundHandlerId);
    });
  }

  IsGOPAClosedbasedGHApiCall(stationId, groundHandlerId) async {
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
    ApiService.get(
            "IsGOPAClosedbasedGH?StationID=${stationId}&EMPNO=${pref.getString('employeeCode')}&GHID=$groundHandlerId&AuditType=$auditType",
            pref.getString('token'))
        .then((success) async {
      var dataObj = jsonDecode(success.body);
      await db.saveIsGOPAClosedbasedGH(dataObj[0], stationId,
          pref.getString('employeeCode'), groundHandlerId, auditType);
    });
  }

  GOPAOfflineDB() async {
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
        GetMOMasterData(auditNumber);

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

          for (int i = 0; i < gopaoverviewdata1.length; i++) {
            await db.saveGOPAOverviewDetails(gopaoverviewdata1[i]);
            GetMOAirlinesDataByStationGopaNumber(
                gopaoverviewdata1[i]['stationID'],
                gopaoverviewdata1[i]['auditNumber']);
          }

          if (gopaoverviewchecklistdata1.length > 0) {
            for (int i = 0; i < gopaoverviewchecklistdata1.length; i++) {
              await db.saveGOPAOverviewChecklistData(
                  gopaoverviewchecklistdata1[i], auditId, auditNumber, 1);

              if (gopaoverviewchecklistdata1[i]['imagename']
                      .toString()
                      .isNotEmpty ||
                  gopaoverviewchecklistdata1[i]['imagename'].toString() != "") {
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
    AnnexureOfflineDB();
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

  GetGOPAScopeMasterData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    // EasyLoading.show(
    //   status: loaderMessage.toString(),
    // );
    ApiService.get("GetGOPAScopeMasterData", pref.getString('token'))
        .then((success) async {
      if (success.statusCode == 200) {
        EasyLoading.addStatusCallback((status) {
          if (status == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        var scopeOfAudit = json.decode(success.body);
        var getGOPAScopeMasterData = scopeOfAudit['getGOPAScopeMasterData'];
        for (int i = 0; i < getGOPAScopeMasterData.length; i++) {
          await db.saveScopeOfAuditMasterData(getGOPAScopeMasterData[i]);
        }
      } else {
        EasyLoading.showInfo("Data Loading Failed");
      }
    });
  }

  GetMenubasedonLoginEMPNo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    // EasyLoading.show(
    //   status: loaderMessage.toString(),
    // );
    var emplogin = pref.getString("employeeCode").toString();
    var userId = pref.getString("userID").toString();

    ApiService.get(
            "GetMenubasedonLoginEMPNo?EMPNumber=$emplogin&UserID=$userId",
            pref.getString('token'))
        .then((success) async {
      if (success.statusCode == 200) {
        EasyLoading.addStatusCallback((status) {
          if (status == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        var primaryMenu = json.decode(success.body);
        var getPrimaryMenuMasterData = primaryMenu['dyMenuPlugin'];
        var getSecondryMenuMasterData = primaryMenu['dyMenuFeature'];
        for (int i = 0; i < getPrimaryMenuMasterData.length; i++) {
          await db.savePrimaryMenuMasterData(getPrimaryMenuMasterData[i]);
        }
        for (int i = 0; i < getSecondryMenuMasterData.length; i++) {
          await db.saveSecondryMenuMasterData(getSecondryMenuMasterData[i]);
        }
      } else {
        EasyLoading.showInfo("Data Loading Failed");
      }
    });
  }

  GetChecklistRating() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    // EasyLoading.show(
    //   status: loaderMessage.toString(),
    // );
    ApiService.get("GetChecklistRating", pref.getString('token'))
        .then((success) async {
      if (success.statusCode == 200) {
        EasyLoading.addStatusCallback((status) {
          if (status == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        var checklistRating = json.decode(success.body);

        var getChecklistRatingcommnMasterData =
            checklistRating['checklistRatingcommn'];
        var getChecklistRatingIDbasedMasterData =
            checklistRating['checklistRatingIDbased'];

        for (int i = 0; i < getChecklistRatingcommnMasterData.length; i++) {
          await db.saveChecklistRatingcommnMasterData(
              getChecklistRatingcommnMasterData[i]);
        }
        for (int i = 0; i < getChecklistRatingIDbasedMasterData.length; i++) {
          await db.saveChecklistRatingIDbasedMasterData(
              getChecklistRatingIDbasedMasterData[i]);
        }
        // EasyLoading.showSuccess('Loading Success');
      } else {
        EasyLoading.showInfo("Data Loading Failed");
      }
    });
  }

  AnnexureOfflineDB() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var emplogin = pref.getString("employeeCode").toString();

    // Annexure Draft Audits Api
    ApiService.get("GetAirlineAnnexuresDraftAudits?LoginEMPNumber=$emplogin",
            pref.getString('token'))
        .then((success) async {
      //setState(() {
      var annexureDraftAudits = json.decode(success.body);
      for (int i = 0; i < annexureDraftAudits.length; i++) {
        await db.saveAnnexureDraftAudits(annexureDraftAudits[i], 1);
      }
      //});
    });

    ApiService.get("GetAirlineAnnexuresDraftAudits?LoginEMPNumber=$emplogin",
            pref.getString('token'))
        .then((success) {
      //setState(() {
      var annexureDraftAudits = json.decode(success.body);
      for (int i = 0; i < annexureDraftAudits.length; i++) {
        var AnnexuresID = annexureDraftAudits[i]["annexureID"];
        var AnnexuresNumber = annexureDraftAudits[i]["annexureNumber"];

        ApiService.get(
                "GetAnnexuresOveerviewDataBasedonAnnexuresID?AnnexuresID=$AnnexuresID&AnnexuresNumber=$AnnexuresNumber",
                pref.getString('token'))
            .then((success) async {
          var data = jsonDecode(success.body);
          var overviewdata1;
          var overviewchecklistdata1;
          //setState(() {
          overviewdata1 = data["annexures"];
          overviewchecklistdata1 = data["ccaChecklistsList"];
          var PluginID = 145;
          //});

          for (int i = 0; i < overviewdata1.length; i++) {
            await db.saveAnnexureOverviewDetails(overviewdata1[i]);
          }

          if (overviewchecklistdata1.length > 0) {
            for (int i = 0; i < overviewchecklistdata1.length; i++) {
              await db.saveAnnexureOverviewChecklist(
                  overviewchecklistdata1[i], AnnexuresNumber);
              if (overviewchecklistdata1[i]['imagename'] != "") {
                saveMOItemImageData(
                    overviewchecklistdata1[i], AnnexuresNumber, PluginID);
              }
            }
          }
        });
      }
      //});
    });
  }

  GetDraftGOPANumberbasedonEMPStation() async {
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
          IsMOExists(MOAirlinesData[i]['id'], GOPANumber);
          ISAnnexuresdraftedmodebsedrGOPAandAirlineID(
              MOAirlinesData[i]['id'], GOPANumber);
          GetPreviousAnnexuresFlighNoandDate(
              MOAirlinesData[i]['id'], StationID);
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

  GetPreviousAnnexuresFlighNoandDate(airlineID, StationID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ApiService.get(
            "PreviousAnnexuresFlighNoandDate?AirlineID=$airlineID&SationID=$StationID",
            pref.getString('token'))
        .then((success) async {
      var body = jsonDecode(success.body);
      for (int i = 0; i < body.length; i++) {
        db.savePreviousAnnexuresFlighNoandDate(body[i], airlineID, StationID);
      }
    });
  }

  saveMOItemImageData(checklistData, auditNumber, PluginID) async {
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

  CAPAOfflineDB() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    // EasyLoading.show(
    //   status: loaderMessage.toString(),
    // );
    var emplogin = pref.getString("employeeCode").toString();
    var CAPAID;
    var CAPANumber;
    ApiService.get(
            "GetAssignedCAPA?LoginEMPNumber=$emplogin", pref.getString('token'))
        .then((success) async {
      //setState(() {
      if (success.statusCode == 200) {
        EasyLoading.addStatusCallback((status) {
          if (status == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        var assignedCAPAList = json.decode(success.body);

        var x = 0;
        for (int i = 0; i < assignedCAPAList.length; i++) {
          await db.saveAssignedCAPAMasterData(assignedCAPAList[i], emplogin, 1);
          CAPAID = 0;
          CAPANumber = 0;
          CAPAID = assignedCAPAList[i]['id'];
          CAPANumber = assignedCAPAList[i]['number'];

          saveOnlineCAPAData(CAPAID, CAPANumber, i, assignedCAPAList.length);
        }
        // EasyLoading.showSuccess('Loading Success');
      } else {
        EasyLoading.showInfo("Data Loading Failed");
      }

      //});
    });
    // Annexure Checklist Api
  }

  GetCAPAModules() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Utilities.easyLoader();
    // EasyLoading.show(
    //   status: loaderMessage.toString(),
    // );
    // GetCAPAModules Api
    ApiService.get("GetCAPAModules", pref.getString('token'))
        .then((success) async {
      if (success.statusCode == 200) {
        EasyLoading.addStatusCallback((status) {
          if (status == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        var capaModulesList = json.decode(success.body);
        for (int i = 0; i < capaModulesList.length; i++) {
          await db.saveCapaModulesListMasterData(capaModulesList[i]);
        }
        EasyLoading.showSuccess("Data Loading Success");
      } else {
        EasyLoading.showInfo("Data Loading Failed");
      }
    });
  }

  GetCAPAStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    ApiService.get("GetCAPAStatus?StatusID=0", pref.getString('token'))
        .then((success) {
      var capaStatuslist = json.decode(success.body);
      for (int i = 0; i < capaStatuslist.length; i++) {
        var statusId = capaStatuslist[i]['id'];
        ApiService.get(
                "GetCAPAStatus?StatusID=$statusId", pref.getString('token'))
            .then((success) async {
          var capaStatus = json.decode(success.body);
          List dbCapaStatus = await db.getCAPAStatusById(statusId);

          if (capaStatus.length != dbCapaStatus.length) {
            for (int j = 0; j < capaStatus.length; j++) {
              await db.saveCAPAStatus(capaStatus[j], statusId);
            }
          }
        });
      }
    });
  }

  saveOnlineCAPAData(CAPAID, CAPANumber, count, assignedCAPAListLength) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var capaMainDataoverview;
    var capaWorkflowDataoverview;
    var fileAttachmentsModel;
    var finalLength = assignedCAPAListLength - 1;

    ApiService.get("GetCAPAOverview?CAPAID=$CAPAID&CAPANumber=$CAPANumber",
            pref.getString('token'))
        .then((success) {
      var data = jsonDecode(success.body);

      capaMainDataoverview = data["capaMainDataoverview"];
      capaWorkflowDataoverview = data["capaWorkflowDataoverview"];
      fileAttachmentsModel = data["fileAttachmentsModel"];

      for (int l = 0; l < capaMainDataoverview.length; l++) {
        db.saveCAPAMainDataoverview(capaMainDataoverview[l], CAPAID);
      }

      for (int j = 0; j < capaWorkflowDataoverview.length; j++) {
        db.saveCAPAWorkflowDataoverview(
            capaWorkflowDataoverview[j], CAPANumber, 1, CAPAID);
      }

      for (int k = 0; k < fileAttachmentsModel.length; k++) {
        if (fileAttachmentsModel[k]['imageBase64'].toString() != "" ||
            fileAttachmentsModel[k]['imageBase64'].toString().isNotEmpty) {
          final encodedStr = fileAttachmentsModel[k]['imageBase64'].toString();
          Uint8List bytes = base64.decode(encodedStr);
          String dir =
              "${Utilities.attachmentFilePathLocal}${fileAttachmentsModel[k]['fileName'].toString()}";
          String fullPath = dir;

          File file = File(fullPath);
          file.writeAsBytes(bytes);

          db.SaveCAPAFileAttachment(
              fileAttachmentsModel[k], CAPANumber, 1, fullPath);

          ImageGallerySaver.saveImage(bytes);
        }
      }
    });

    if (count == finalLength) {
      _timer?.cancel();
      EasyLoading.showSuccess('Loading Success');
    } else {
      _timer?.cancel();
      EasyLoading.showSuccess('Loading Success');
    }
  }

  clearData(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.clear();
  }

  deleteDB(deleteauditNumber) async {
    await db.deleteGOPA(deleteauditNumber);
  }

  deleteMODB(deleteannextureId) async {
    await db.deleteMO(deleteannextureId);
  }
}

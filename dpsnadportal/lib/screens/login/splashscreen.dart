import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/restapi.dart';
import '../../helpers/utilities.dart';
import '../../widgets/constants.dart';
import '../home/homescreen.dart';
import 'OrgLoginForm.dart';
import 'loginscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  double opacityLevel = 1.0;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      _changeOpacity();
    });
    setOrganizationObj();

  }

  getLoginstatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 1500));
    if (prefs.getBool('isLogin') == null) {
      return false;
    }
    else{
      return true;
    }
  }
  setOrganizationObj() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // Utilities.easyLoader();
    // EasyLoading.show(
    //   status: "Loading Drafts",
    // );
    // _fetchData(context);
    var dataLength;
    var empNumber = pref.getString('employeeCode');
    bool isOnline = await Utilities.CheckUserConnection() as bool;

    //var draftObjdb = await db.getGOPADraftAudits(empNumber);
    if (isOnline) {
      ApiService.get("app-oraganization-status",
          "")
          .then((success) {
        if (success.statusCode == 200) {

          setState(() {
            Utilities.isOrganizationPermission = false;
            var body = jsonDecode(success.body);
            print(body);
            if(body["oraganization"]["app_status"].toString() == "1"){
              Utilities.isOrganizationPermission = true;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => OrgLoginForm()),
                      (Route<dynamic> route) => false);
            }else{
              getLoginstatus().then((status) {
                if (status) {
                  _navigateToHome();
                } else {
                  _navigateToLogin();
                }
              });
            }

          });


        } else {
          getLoginstatus().then((status) {
            if (status) {
              _navigateToHome();
            } else {
              _navigateToLogin();
            }
          });
        }
      });
    }else{
      getLoginstatus().then((status) {
        if (status) {
          _navigateToHome();
        } else {
          _navigateToLogin();
        }
      });
    }
  }

  void _navigateToHome() {
    Timer(Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuditHome(fromType: 'login',))));

  }
  void _navigateToLogin() {
    Timer(Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }

  @override


  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: whiteColor,
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                    opacity: opacityLevel,
                    duration:  Duration(seconds: 3),
                    child: Container(
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      width: MediaQuery.of(context).size.width*0.7,
                      height: MediaQuery.of(context).size.height*0.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image.asset("assets/images/login_logo.jpg", width: 200,height: 200),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}

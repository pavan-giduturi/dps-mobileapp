import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as IO;

import '../../apiservice/restapi.dart';
import '../../database/database_table.dart';
import '../../helpers/utilities.dart';
import '../../widgets/constants.dart';
import '../home/homescreen.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  DatabaseHelper db = DatabaseHelper();
  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();
  bool _showPassword = false;
  bool isPermission = false;
  bool isOnline = true;
  bool isLoader = false;
  int loaderTimer = 0;
  Timer? _timer;

  @override
  void initState() {
    checkConnection();
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      Utilities.requestPermission();
    } else if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {}
    super.initState();

    print(Utilities.isOrganizationPermission);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            SizedBox(height: defaultPadding * 4),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                controller: userName,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSaved: (email) {},
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                    prefixIcon: Icon(
                      Icons.person,
                      color: red,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Username",
                    hintText: 'Enter Username',
                    labelStyle: TextStyle(color: red),
                    // suffixIcon: IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(Icons.close,
                    //         color: Colors.purple))
                  ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  obscureText: !_showPassword,
                  controller: passWord,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: red,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      child: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: red,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Password",
                    hintText: 'Enter Password',
                    labelStyle: TextStyle(color: red),
                    // suffixIcon: IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(Icons.close,
                    //         color: Colors.purple))
                  ),
                ),
              ),
            ),
            // Container(
            //   alignment: Alignment.centerRight,
            //   child: TextButton(
            //     onPressed: () {},
            //     child: Text(
            //       'Forgot Password ?',
            //       style: TextStyle(
            //         color: red,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: defaultPadding),
            Center(
              child: Container(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    isLoader = true;
                    loaderTimer = 10;
                    bool is_Online =
                        await Utilities.CheckUserConnection() as bool;

                    if (userName.text.isEmpty) {
                      Get.snackbar('Alert', 'Username Required',
                          titleText: Text(
                            'Alert',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: red),
                          ),
                          messageText: Text(
                            'Username Required',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          backgroundColor: whiteColor,
                          overlayBlur: 3,
                          duration: Duration(milliseconds: 1000),
                          isDismissible: false);
                    } else if (passWord.text.isEmpty) {
                      Get.snackbar('Alert', 'Password Required',
                          titleText: Text(
                            'Alert',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: red),
                          ),
                          messageText: Text(
                            'Password Required',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          backgroundColor: whiteColor,
                          overlayBlur: 3,
                          duration: Duration(milliseconds: 1000),
                          isDismissible: false);
                    } else if (!is_Online) {
                      Utilities.showAlert(
                          context, 'Check Your Internet Connection');
                    } else {
                      // loaderTimer = 10;
                      // _fetchData(context);
                      makeApiCall(userName.text, passWord.text);
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(
                      //         builder: (context) => const AuditHome(
                      //           fromType: 'login',
                      //         )),
                      //         (Route<dynamic> route) => false);
                    }
                  },
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              ),
            ),
            SizedBox(height: 150),
            // Text(
            //   "© 2024 Meloskula Platform Pvt Ltd.All Rights Reserved.\n App Version: 1.0.0",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 10, color: red),
            // ),
            SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }

  checkConnection() async {
    bool isOnline = await Utilities.CheckUserConnection();
  }

  makeApiCall(username, password) async {
    final body = jsonEncode(
        {"username": username, "password": password});

    Utilities.easyLoader();
    EasyLoading.show(status: 'Logging in');
    ApiService.login(username, password).then((success) {
      //String data = success.body; //store response as string
      // print('token--------------------> $data');
      if (success.statusCode == 200) {
        EasyLoading.addStatusCallback((status) {
          if (status == EasyLoadingStatus.dismiss) {
            _timer?.cancel();
          }
        });
        var data = success.body; //store response as string
        var resposnse = json.decode(data);


        if(resposnse['status'].toString() == "success"){
          saveUserDetails(resposnse);
          EasyLoading.showSuccess('Login Success');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const AuditHome(
                    fromType: 'login',
                  )),
                  (Route<dynamic> route) => false);
        }else{
          EasyLoading.showInfo("Invalid Username/Password");
        }
        // saveToken(json.decode(data)['access_token'], username, password);

      } else {
        EasyLoading.showInfo("Invalid Username/Password");
      }
    });
  }

  saveToken(token, username, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log('save token');
    prefs.setString("token", token);
    log('save token1');
    makeLoginApiCall(username, password, token);
  }

  makeLoginApiCall(username, password, token) async {
    log('save token2');
    // Map<String, dynamic> jsonMap = {"username": username, "password": password, "grant_type": "password"};
    final body = jsonEncode({"username": username, "password": password});

    ApiService.post("LoginUser", body, token).then((success) {
      var data = success.body; //store response as string
      var resposnse = json.decode(data);
      log(resposnse.toString());
      saveUserDetails(resposnse);
      //saveUserDetails(json.decode(data));
      // var employeeCount = await db.getEmployeeDetails(resposnse["employeeID"].toString());

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const AuditHome(
                    fromType: 'login',
                  )),
          (Route<dynamic> route) => false);
    });
  }

  saveUserDetails(resposnse) async {

    print(resposnse);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("employeeID", resposnse["data"]["student_id"].toString());
    prefs.setString("firstName", resposnse["data"]["username"].toString());
    prefs.setString("lastName", resposnse["data"]["username"].toString());
    prefs.setString("employeeCode", resposnse["data"]["login_username"].toString());
    prefs.setString("role", resposnse["data"]["role"].toString());

    prefs.setString("userID", resposnse["data"]["id"].toString());
    // prefs.setString("emailID", resposnse["emailID"].toString());
    // prefs.setString("dob", resposnse["dob"].toString());
    // prefs.setString("imageBase64", resposnse["imageBase64"].toString());
    prefs.setBool("isLogin", true);
    // await db.saveUserDetails(resposnse);
  }
}

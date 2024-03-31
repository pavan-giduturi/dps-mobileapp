import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/utilities.dart';
import '../../widgets/responsive.dart';
import '../inappwebview/inappwebview.dart';

class OrgLoginForm extends StatefulWidget {
  OrgLoginForm({Key? key}) : super(key: key);

  @override
  State<OrgLoginForm> createState() => _OrgLoginFormState();
}

class _OrgLoginFormState extends State<OrgLoginForm> {
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
    return Responsive(
      mobile: const HomePage(),
      desktop: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: const HomePage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  checkConnection() async {
    bool isOnline = await Utilities.CheckUserConnection();
  }


}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg_img.jpg"), fit: BoxFit.fill)),
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 1,
                  width: MediaQuery.of(context).size.width * 1,
                  color: Colors.black54,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                    ),
                    margin: const EdgeInsets.all(20),
                    child: Image.asset(
                      "assets/images/dpsnad_new.jpeg",
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.62,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          String headerTitle =
                              "Welcome to DPS-NAD Student / Parent Portal";
                          const url =
                              'https://portal.dpsnad.org.in/site/userLogin';
                          Get.to(() => const InAppWebViewHome(), arguments: [
                            url.toString(),
                            headerTitle.toString()
                          ]);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xFF00743F),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                              border: Border.all(color: Colors.orange, width: 2)),
                          child: Text(
                            'Student / Parent',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 20.0),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          String headerTitle =
                              "Welcome to DPS-NAD Administration Portal";
                          const url = 'https://portal.dpsnad.org.in/site/login';
                          Get.to(() => const InAppWebViewHome(), arguments: [
                            url.toString(),
                            headerTitle.toString()
                          ]);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xFF00743F),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                              border: Border.all(color: Colors.orange, width: 2)),
                          child: Text(
                            'Administration',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      /* Column(
        children: [
          Container(

          )
          // Center(
          //   child: Container(
          //     margin: const EdgeInsets.all(20),
          //     child: Image.asset(
          //       Constants.logoImage,
          //       height: 300,
          //       width: 300,
          //     ),
          //   ),
          // ),
          // Center(
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: Container(
          //       margin: const EdgeInsets.all(20),
          //       width: MediaQuery.of(context).size.width * 0.8,
          //       height: Constants.registrationTextFieldHeight,
          //       alignment: Alignment.center,
          //       decoration: BoxDecoration(
          //           color: Constants.dpsColor,
          //           borderRadius: const BorderRadius.all(Radius.circular(30))),
          //       child: Text(
          //         'Student/Parent',
          //         style: TextStyle(
          //             color: Constants.buttonTextColor,
          //             fontSize: Constants.loginBtnTextSize),
          //       ),
          //     ),
          //   ),
          // ),
          // Center(
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: Container(
          //       margin: const EdgeInsets.all(20),
          //       width: MediaQuery.of(context).size.width * 0.8,
          //       height: Constants.registrationTextFieldHeight,
          //       alignment: Alignment.center,
          //       decoration: BoxDecoration(
          //           color: Constants.dpsColor,
          //           borderRadius: const BorderRadius.all(Radius.circular(30))),
          //       child: Text(
          //         'Administration',
          //         style: TextStyle(
          //             color: Constants.buttonTextColor,
          //             fontSize: Constants.loginBtnTextSize),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      )*/
    );
  }
}

import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import '../../widgets/constants.dart';
import '../../widgets/responsive.dart';
import 'OrgLoginForm.dart';
import 'loginform.dart';
import 'loginimages.dart';

class Orglogin extends StatelessWidget {
  const Orglogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: Row(
            children: [
              Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: OrgLoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: defaultPadding * 2),
        LoginScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: OrgLoginForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

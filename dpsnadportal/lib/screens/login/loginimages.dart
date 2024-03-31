import 'package:flutter/material.dart';
import '../../widgets/constants.dart';

class LoginScreenTopImage extends StatelessWidget {
   LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text(
        //   "Sign In",
        //   style: TextStyle(fontWeight: FontWeight.bold),
        // ),
        SizedBox(height: defaultPadding * 2),
        Row(
          children: [
             Spacer(),
            Expanded(
              flex: 4,
              child:  Image.asset("assets/images/dpsnad_new.jpeg",),
            ),
             Spacer(),
          ],
        ),
        // SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
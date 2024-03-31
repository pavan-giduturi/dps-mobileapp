import 'package:flutter/material.dart';

import '../../widgets/responsive.dart';
class ProfilePictureview extends StatefulWidget {
  const ProfilePictureview({Key? key}) : super(key: key);

  @override
  State<ProfilePictureview> createState() => _ProfilePictureviewState();
}

class _ProfilePictureviewState extends State<ProfilePictureview> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: ProfilePictureview1(),
      desktop: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Color(0xFFe7e7e7),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: ProfilePictureview1(),
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
class ProfilePictureview1 extends StatefulWidget {
  const ProfilePictureview1({Key? key}) : super(key: key);

  @override
  State<ProfilePictureview1> createState() => _ProfilePictureview1State();
}

class _ProfilePictureview1State extends State<ProfilePictureview1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Profile Picture'),
    centerTitle: true,
    backgroundColor: Color(0xFFf5003a),
    ),
    backgroundColor: Color(0xFFe7e7e7),
    body: SingleChildScrollView(
    child: Padding(
    padding:EdgeInsets.only(top: 30, right: 20, left: 20, bottom: 20),
    child: Container(
      child :
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 300,
            width: 300,

          ),
        ],
      ),
    ))));
  }
}


import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/constants.dart';
import '../../widgets/responsive.dart';

class Profileinfopage extends StatefulWidget {
  const Profileinfopage({
    Key? key,
  }) : super(key: key);

  @override
  State<Profileinfopage> createState() => _ProfileinfopageState();
}

class _ProfileinfopageState extends State<Profileinfopage> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const PersonalInfoPage1(),
      desktop: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: const Color(0xFFe7e7e7),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: const PersonalInfoPage1(),
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

class PersonalInfoPage1 extends StatefulWidget {
  const PersonalInfoPage1({
    Key? key,
  }) : super(key: key);

  @override
  State<PersonalInfoPage1> createState() => _PersonalInfoPage1State();
}

class _PersonalInfoPage1State extends State<PersonalInfoPage1> {
  dynamic argData = Get.arguments;
  final TextEditingController employnameconductedByController =
      TextEditingController();
  final TextEditingController departmentconductedByController =
      TextEditingController();
  final TextEditingController contactnumberbycontroller =
      TextEditingController();
  final TextEditingController aepNobycontroller = TextEditingController();
  final TextEditingController aepValiditycontroller = TextEditingController();
  final TextEditingController positionIDcontroller = TextEditingController();
  final TextEditingController positioncontroller = TextEditingController();
  final TextEditingController deptCodecontroller = TextEditingController();
  final TextEditingController empStatuscontroller = TextEditingController();
  final TextEditingController userIDcontroller = TextEditingController();
  final TextEditingController companycontroller = TextEditingController();
  final TextEditingController emialcontroller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _visible = false;
  File? image, selectedImages;
  List names = [], paths1 = [], baseImg = [];
  FilePickerResult? results;

  int? selectedQues;

  @override
  void initState() {
    super.initState();

    getLoggedInUserDetailsprofile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          centerTitle: true,
          backgroundColor: red,
        ),
        backgroundColor: bgColor,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ProfilePictureview()));
                },
                child: argData.toString() == "null"
                    ? Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/profilepick.png',
                                ),
                                fit: BoxFit.fill),
                            borderRadius:
                                BorderRadius.all(Radius.circular(45.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: red)
                            ]),
                        // child: Container(
                        //   margin: EdgeInsets.only(),
                        //   child: Align(
                        //     alignment: Alignment.bottomRight,
                        //     child: IconButton(
                        //       icon: Icon(
                        //         Icons.camera_enhance_sharp,
                        //         color: red,
                        //         size: 25,
                        //       ),
                        //       onPressed: () {
                        //         imageDialog(selectedQues);
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ) : Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/profilepick.png',
                          ),
                          fit: BoxFit.fill),
                      borderRadius:
                      BorderRadius.all(Radius.circular(45.0)),
                      boxShadow: [
                        BoxShadow(blurRadius: 7.0, color: red)
                      ]),
                  // child: Container(
                  //   margin: EdgeInsets.only(),
                  //   child: Align(
                  //     alignment: Alignment.bottomRight,
                  //     child: IconButton(
                  //       icon: Icon(
                  //         Icons.camera_enhance_sharp,
                  //         color: red,
                  //         size: 25,
                  //       ),
                  //       onPressed: () {
                  //         imageDialog(selectedQues);
                  //       },
                  //     ),
                  //   ),
                  // ),
                )
                    // : Container(
                    //     width: 100.0,
                    //     height: 100.0,
                    //     child: Container(
                    //         child:
                    //             Image.memory(base64Decode(argData.toString()))),
                    //   ),
              ),
            ),
            // SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: darkgrey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Table(
                children: [
                  TableRow(children: [
                    TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("Parent",
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        )),
                    TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("Pavan Kumar G",
                              style: TextStyle(color: whiteColor, fontSize: 12)),
                        )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Student",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    )),
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                          employnameconductedByController.text == null
                              ? "- -"
                              : employnameconductedByController.text,
                          style: TextStyle(color: whiteColor, fontSize: 12)),
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Class",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    )),
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                          "NURSERY (2023-24)",
                          style: TextStyle(color: whiteColor, fontSize: 12)),
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Section",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    )),
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                          "A",
                          style: TextStyle(color: whiteColor, fontSize: 12)),
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Admission Date",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    )),
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                          "01/20/2024",
                          style: TextStyle(color: whiteColor, fontSize: 12)),
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Date Of Birth",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    )),
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                          "12/01/2020",
                          style: TextStyle(color: whiteColor, fontSize: 12)),
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Address",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    )),
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                          "Visakhapatnam",
                          style: TextStyle(color: whiteColor, fontSize: 12)),
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Father's Name",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    )),
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                          "Pavan",
                          style: TextStyle(color: whiteColor, fontSize: 12)),
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("Contact Number",
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        )),
                    TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                              "9032137221",
                              style: TextStyle(color: whiteColor, fontSize: 12)),
                        )),
                  ]),
                ],
              ),
            )
          ],
        )));
  }

  imageDialog(selectedQues) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Add Photo!",
        ),
        content: Container(
          height: 130,
          width: 50,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              GestureDetector(
                  child: Card(
                    color: red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Take Photo",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () async {
                    takePhoto(ImageSource.camera);
                    Navigator.pop(context);
                  }),
              GestureDetector(
                child: Card(
                  color: red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Choose From Gallery",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  updateImageData(selectedQues);
                  Navigator.pop(context);
                },
              ),
              GestureDetector(
                child: Card(
                  color: red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> takePhoto(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
    );

    final File? file = File(image!.path);

    if (image != null) {
      setState(() {
        _visible = true;
        selectedImages = file;
        String fileName = image.path.toString().split('/').last;
        List<int> imageBytes = selectedImages!.readAsBytesSync();
        var imageB64 = base64Encode(imageBytes);
        baseImg.add(imageB64);
        names.add(fileName);
        paths1.add(image.path.toString());
      });
    }
  }

  updateImageData(selectedQue) async {
    results = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'png'],
    );

    setState(() {
      _visible = true;
      names = results!.names;
      paths1 = results!.paths;
      for (int i = 0; i < names.length; i++) {
        var bytes = File(paths1[i]).readAsBytesSync();
        baseImg.add(base64Encode(bytes));
      }
    });
  }

  filePickers() async {
    results = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'xls', 'mp4', 'docx'],
    );
    if (results != null && names.isEmpty) {
      setState(() {
        _visible = true;
        names = results!.names;
        paths1 = results!.paths;
        for (int i = 0; i < names.length; i++) {
          var bytes = File(paths1[i]).readAsBytesSync();
          baseImg.add(base64Encode(bytes));
        }
      });
    }
  }

  getLoggedInUserDetailsprofile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      employnameconductedByController.text =
          pref.getString("firstName").toString() +
              " " +
              pref.getString("employeeCode").toString() +
              ")";

      if (pref.getString("empStatus").toString() == "1") {
        setState(() {
          empStatuscontroller.text = "Active";
        });
      } else {
        setState(() {
          empStatuscontroller.text = "In-Active";
        });
      }
    });
  }
}

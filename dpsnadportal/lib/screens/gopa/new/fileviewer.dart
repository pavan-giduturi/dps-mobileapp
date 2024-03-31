import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../widgets/constants.dart';

class ImageView extends StatefulWidget {
  final String link;
  final String linkExt;
  const ImageView({Key? key, required this.link, required this.linkExt}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Viewer', style: TextStyle(color: whiteColor)),
        centerTitle: true,
        backgroundColor: red,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: widget.linkExt.contains("jpg") || widget.linkExt.contains("gif") || widget.linkExt.contains("jfif") || widget.linkExt.contains("png")|| widget.linkExt.contains("jpeg")
            ? Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Image.memory(
                  base64Decode(widget.link),
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                ))
            : Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Text("")),
      ),
    );
  }
}

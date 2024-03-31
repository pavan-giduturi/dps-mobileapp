import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';

class InAppWebViewHome extends StatefulWidget {
  const InAppWebViewHome({super.key});

  @override
  _InAppWebViewHomeState createState() => _InAppWebViewHomeState();
}

class _InAppWebViewHomeState extends State {
  dynamic argData = Get.arguments;
  TextEditingController controller = TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();


  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {});
    log('arguments');
    log(argData.toString());
    log(argData[0].toString());
    log(argData[1].toString());
  }


  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: argData[0].toString(),
      withJavascript: true,
      withLocalStorage: true,
      appBar: AppBar(
        title: Text(argData[1].toString()),
        backgroundColor: Color(0xFF00743F),
        titleTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        automaticallyImplyLeading: false,
      ),
    );
  }
}

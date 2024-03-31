import 'package:flutter/material.dart';
class CheckListView extends StatefulWidget {
  final auditId;
  const CheckListView({Key? key, this.auditId}) : super(key: key);


  State<CheckListView> createState() => _CheckListViewState();
}

class _CheckListViewState extends State<CheckListView> {
  @override
  void initState() {
    widget.auditId;
    print(widget.auditId);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audit Check List"),
        backgroundColor: Color(0xFFf5003a),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFe7e7e7),
      body: SingleChildScrollView(

      ),
    );
  }
}

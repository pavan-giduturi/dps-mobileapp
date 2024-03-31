import 'package:flutter/material.dart';

class SimpleAppBarPopupMenuButton extends StatelessWidget {
  const SimpleAppBarPopupMenuButton({Key? key}) : super(key: key);
// definition of the dialog
// box when value is selected
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert!!"),
          content: Text("You are awesome!"),
          actions: [
            MaterialButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp with debugShowCheckedModeBanner
    // false and title.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppBar Popup Menu Button',
      // scaffold with appbar
      home: Scaffold(
        // appbar with title text
        appBar: AppBar(
          title: Text('AppBar Popup Menu Button'),
          // in action widget we have PopupMenuButton
          actions: [
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                // PopupMenuItem 1
                PopupMenuItem(
                  value: 1,
                  // row with 2 children
                  child: Row(
                    children: [
                      Icon(Icons.star),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Get The App")
                    ],
                  ),
                ),
                // PopupMenuItem 2
                PopupMenuItem(
                  value: 2,
                  // row with two children
                  child: Row(
                    children: [
                      Icon(Icons.chrome_reader_mode),
                      SizedBox(
                        width: 10,
                      ),
                      Text("About")
                    ],
                  ),
                ),
              ],
              offset: Offset(0, 100),
              color: Colors.grey,
              elevation: 2,
              // on selected we show the dialog box
              onSelected: (value) {
                // if value 1 show dialog
                if (value == 1) {
                  _showDialog(context);
                  // if value 2 show dialog
                } else if (value == 2) {
                  _showDialog(context);
                }
              },
            ),
          ],
        ),
        // body with centered text
        body: Center(
          child: Text("Press the 3 Point Button Up!"),
        ),
      ),
    );
  }
}

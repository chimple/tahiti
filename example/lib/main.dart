import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:tahiti/tahiti.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    setPermission();
  }

  void setPermission() async {
    await SimplePermissions.requestPermission(Permission.RecordAudio);
    await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        body: ActivityBoard(
          templates: [
            'assets/templates/LionSA1.svg',
            'assets/templates/LionSA1.svg'
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahiti/tahiti.dart';

void main() => runApp(new MyApp());

final templates = [
  'assets/templates/LionSA1.svg',
  'assets/templates/pattern.svg',
  'assets/templates/pattern1.svg',
  'assets/filter_image/filterImage1.png',
  'assets/filter_image/filterImage2.png',
  'assets/filter_image/filterImage3.png',
  'assets/filter_image/filterImage4.png',
  'assets/filter_image/filterImage5.png',
];

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
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Drawing'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.add_circle),
              tooltip: 'Create new drawing',
              onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return DrawingWrapper();
                  })),
            )
          ],
        ),
        body: DrawingList());
  }
}

class DrawingList extends StatefulWidget {
  const DrawingList({Key key}) : super(key: key);

  @override
  DrawingListState createState() {
    return new DrawingListState();
  }
}

class DrawingListState extends State<DrawingList> {
  List<String> _drawings;
  bool _isLoading = true;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    _drawings = prefs
        .getKeys()
        .toList(growable: false)
        .map((k) => prefs.getString(k))
        .toList(growable: false);
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: _drawings
          .map((d) => RaisedButton(
                onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                      return DrawingWrapper(
                        jsonMap: json.decode(d),
                      );
                    })),
                child: ScopedModel<ActivityModel>(
                  model: ActivityModel(
                      paintData: PaintData.fromJson(json.decode(d)))
                    ..isInteractive = false,
                  child: Paper(),
                ),
              ))
          .toList(growable: false),
    );
  }
}

class DrawingWrapper extends StatelessWidget {
  Map<String, dynamic> jsonMap;

  DrawingWrapper({Key key, this.jsonMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ActivityBoard(
        json: jsonMap,
        templates: jsonMap == null ? templates : null,
        title: 'Test',
        saveCallback: ({Map<String, dynamic> jsonMap}) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(jsonMap['id'], json.encode(jsonMap));
        },
      ),
    );
  }
}

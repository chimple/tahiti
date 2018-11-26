import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahiti/masking.dart';
import 'package:tahiti/tahiti.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(new MyApp());

final templates = [
  'assets/topic/306950.svg',
  'assets/topic/bus_tire.svg',
  'assets/topic/animal-animal-photography-big-cat-792381.jpg',
  'assets/topic/mammal-908445__340.png',
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

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  String extStorageDir;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    await getExternalStorageDirectory()
        .then((d) => extStorageDir = '${d.path}/');
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
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Drawing'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.add_circle),
              tooltip: 'Create new drawing',
              onPressed: () async => await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => _buildDialog(context),
                  ).then((result) {
                    if (result != null) {
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) => DrawingWrapper(
                                  extStorageDir: extStorageDir,
                                  template: result,
                                )),
                      );
                    }
                  }),
            )
          ],
        ),
        body: DrawingList(
          extStorageDir: extStorageDir,
        ));
  }

  Widget _buildDialog(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.all(0.0),
      title: new Container(
          height: MediaQuery.of(context).size.height * .06,
          color: Colors.blue,
          child: new Center(child: new Text("Choose a template"))),
      children: <Widget>[
        new Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 1.6,
            child: TemplateGrid(
              templates: templates,
              extStorageDir: extStorageDir,
            )),
      ],
    );
  }
}

class TemplateGrid extends StatelessWidget {
  final String cardId;
  final List<String> templates;
  final String extStorageDir;

  TemplateGrid({key, this.cardId, this.templates, this.extStorageDir})
      : super(key: key);

  Widget _buildTile(BuildContext context, String template) {
    return Card(
      elevation: 5.0,
      child: new InkWell(
        onTap: () => Navigator.pop(context, template),
        child: new AspectRatio(
          aspectRatio: 1.0,
          child: template.endsWith('.svg')
              ? new SvgPicture.file(
                  File(extStorageDir + template),
                )
              : Image.file(
                  File(extStorageDir + template),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children:
          templates.map((t) => _buildTile(context, t)).toList(growable: false),
    );
  }
}

class DrawingList extends StatefulWidget {
  final String extStorageDir;
  const DrawingList({Key key, this.extStorageDir}) : super(key: key);

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
    await Future.forEach(
        Masking.listOfImage, (i) async => ActivityModel.cacheImage(i));
    if (prefs.getString('dot') == null) {
      prefs.setString('dot',
          '{"id":"dot","pathHistory":{"paths":[],"startX":null,"startY":null,"x":null,"y":null},"things":[{"id":"dot","type":"dot","dotData":{"x":[65,69,83,104,133,170,213,262,310,351,387,417,441,460,474,482,476,445,415,410,410,410,410,410,410,410,410,410,386,356,326,296,266,236,206,176,146,116,101,103,105,107,108,110,112,113,115,116,97,47,42,51],"y":[101,98,92,83,74,64,57,52,52,55,61,71,83,96,112,129,159,175,180,196,226,256,286,316,346,376,406,436,443,443,444,444,445,445,446,446,447,447,433,403,374,344,314,284,254,224,194,170,171,169,138,118],"c":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}}]}');
    }

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
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return DrawingWrapper(
                      extStorageDir: widget.extStorageDir,
                      jsonMap: json.decode(d),
                    );
                  })).then((onValue) {
                    //print('$onValue');
                  });
                },
                child: ScopedModel<ActivityModel>(
                  model: ActivityModel(
                      extStorageDir: widget.extStorageDir,
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
  String template;
  String extStorageDir;

  DrawingWrapper({Key key, this.jsonMap, this.template, this.extStorageDir})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ActivityBoard(
        json: jsonMap,
        template: jsonMap == null ? template : null,
        title: 'Test',
        extStorageDir: extStorageDir,
        saveCallback: ({Map<String, dynamic> jsonMap}) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(jsonMap['id'], json.encode(jsonMap));
        },
        backCallback: () => Navigator.of(context).pop(),
      ),
    );
  }
}

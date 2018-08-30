import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TemplateList extends StatefulWidget {
  TemplateList({key, @required this.onPress, @required this.topicId})
      : super(key: key);
  final Function onPress;
  final String topicId;

  @override
  State<StatefulWidget> createState() => new TemplateListState();
}

class TemplateListState extends State<TemplateList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => _build(context),
      );
    });
  }

  Widget _build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.all(0.0),
      title: new Container(
          height: MediaQuery.of(context).size.height * .06,
          color: Colors.blue,
          child: new Center(child: new Text(widget.topicId))),
      children: <Widget>[
        new Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 1.6,
            child: TemplateListData(
              onPress: widget.onPress,
              topicId: widget.topicId,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}

class TemplateListData extends StatefulWidget {
  TemplateListData({key, @required this.onPress, @required this.topicId})
      : super(key: key);
  final Function onPress;
  final String topicId;

  @override
  State<StatefulWidget> createState() => new TemplateListDataState();
}

class TemplateListDataState extends State<TemplateListData> {
  List templates = ['draw', 'roar', 'play', 'run', 'sleep', 'eat', 'walk'];
  bool _isLoading = true;
  String _assetName = 'assets/templates/LionSA1.svg';

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    print('hii   ${widget.topicId}');
    // activity = await ActivityRepo().getActivitiesByTopicId(widget.activityId);
    setState(() => _isLoading = false);
  }

  Widget _buildTile(int index) {
    return Card(
        elevation: 5.0,
        child: new InkWell(
          onTap: () {
            widget.onPress(_assetName);
            Navigator.of(context).pop();
          },
          child: new Column(
            children: <Widget>[
              new AspectRatio(
                  aspectRatio: 1.2, child: new SvgPicture.asset(_assetName)),
              new Expanded(
                  child: new Container(
                color: Colors.grey,
                child: new Center(child: new Text(templates[index])),
              ))
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? new SizedBox(
            width: 20.0,
            height: 20.0,
            child: new CircularProgressIndicator(),
          )
        : GridView.count(
            crossAxisCount: 3,
            children:
                new List.generate(templates.length, (i) => _buildTile(i)));
  }
}

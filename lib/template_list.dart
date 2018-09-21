import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TemplateList extends StatefulWidget {
  TemplateList({key, @required this.onPress, @required this.templates})
      : super(key: key);
  final Function onPress;
  final List<String> templates;

  @override
  State<StatefulWidget> createState() => new TemplateListState();
}

class TemplateListState extends State<TemplateList> {
  String onValue;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => _build(context),
      ).then((onValue) {
        if (onValue == null) {
          widget.onPress(null);
        }
      });
    });
  }

  Widget _build(BuildContext context) {
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
            child: TemplateListData(
              onPress: widget.onPress,
              templates: widget.templates,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}

class TemplateListData extends StatelessWidget {
  TemplateListData({key, @required this.onPress, @required this.templates})
      : super(key: key);
  final Function onPress;
  final List<String> templates;

  Widget _buildTile(BuildContext context, int index) {
    return Card(
        elevation: 5.0,
        child: new InkWell(
          onTap: () {
            onPress(templates[index]);
            Navigator.pop(context, 'selected');
          },
          child: new Column(
            children: <Widget>[
              new AspectRatio(
                  aspectRatio: 1.2,
                  child: new SvgPicture.asset(
                    templates[index],
                  )),
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
    return GridView.count(
        crossAxisCount: 3,
        children:
            new List.generate(templates.length, (i) => _buildTile(context, i)));
  }
}

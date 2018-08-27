import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/paper.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/select_sticker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/template_list.dart';

class ActivityBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ActivityModel>(
      model: ActivityModel(),
      child: InnerActivityBoard(),
    );
  }
}

class InnerActivityBoard extends StatefulWidget {
  @override
  InnerActivityBoardState createState() {
    return new InnerActivityBoardState();
  }
}

class InnerActivityBoardState extends State<InnerActivityBoard> {
  bool _displayPaper = false;
  String topicId = 'lion';

  void _onPress(String template) {
    setState(() {
      _displayPaper = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
      builder: (context, child, model) => Stack(
            children: <Widget>[
              Center(
                child: Container(
                  color: Colors.grey,
                  child: AspectRatio(
                      aspectRatio: 1.0,
                      child: _displayPaper
                          ? Paper()
                          : ActivityTemplateList(
                              topicId: topicId,
                              onPress: _onPress,
                            )),
                ),
              ),
              Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: SelectSticker(side: DisplaySide.top)),
              Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: SelectSticker(side: DisplaySide.bottom)),
            ],
          ),
    );
  }
}

class ActivityTemplateList extends StatelessWidget {
  final String topicId;
  final Function onPress;
  const ActivityTemplateList({Key key, this.topicId, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
      builder: (context, child, model) => TemplateList(
            topicId: topicId,
            onPress: (String template) {
              model.template = template;
              onPress(template);
            },
          ),
    );
  }
}

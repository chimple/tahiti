import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/paper.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/tool_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/template_list.dart';

class ActivityBoard extends StatefulWidget {
  @override
  ActivityBoardState createState() {
    return new ActivityBoardState();
  }
}

class ActivityBoardState extends State<ActivityBoard> {
  bool _displayPaper = false;
  String template = '';
  String topicId = 'lion';

  void _onPress(String activity, String template) {
    setState(() {
      _displayPaper = true;
      this.template = template;
      print('data is   $activity');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<ActivityModel>(
        model: new ActivityModel(),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                color: Colors.grey,
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: _displayPaper
                        ? Paper(template: template)
                        : TemplateList(
                            topicId: topicId,
                            onPress: _onPress,
                          )),
              ),
            ),
            Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: ToolPicker(DisplaySide.top)),
            Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: ToolPicker(DisplaySide.bottom)),
          ],
        ));
  }
}

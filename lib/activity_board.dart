import 'package:flutter/widgets.dart';
import 'package:tahiti/paper.dart';
import 'package:tahiti/tool_picker.dart';

class ActivityBoard extends StatefulWidget {
  @override
  ActivityBoardState createState() {
    return new ActivityBoardState();
  }
}

class ActivityBoardState extends State<ActivityBoard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.0,
          child: Paper(),
        ),
        Expanded(child: ToolPicker()),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tahiti/activity_model.dart';

class Masking extends StatefulWidget {
  final ActivityModel model;

  Masking({Key key, this.model}) : super(key: key);
  static final List<String> listOfImage = [
    'assets/masking/pattern_01.png',
    'assets/masking/pattern_02.png',
    'assets/masking/pattern_03.png',
    'assets/masking/pattern_04.png',
    'assets/masking/pattern_05.png',
    'assets/masking/pattern_06.png',
    'assets/masking/pattern_07.png',
    'assets/masking/pattern_08.png',
    'assets/masking/pattern_09.png',
    'assets/masking/pattern_10.png',
    'assets/masking/pattern_11.png',
    'assets/masking/pattern_12.png',
    'assets/masking/pattern_13.png',
    'assets/masking/pattern_14.png',
    'assets/masking/pattern_15.png',
    'assets/masking/pattern_16.png',
    'assets/masking/pattern_17.png',
    'assets/masking/pattern_18.png',
    'assets/masking/pattern_19.png',
    'assets/masking/pattern_20.png',
    'assets/masking/pattern_21.png',
    'assets/masking/pattern_22.png',
    'assets/masking/pattern_23.png',
    'assets/masking/pattern_24.png',
    'assets/masking/pattern_25.png',
    'assets/masking/pattern_26.png',
    'assets/masking/pattern_27.png',
    'assets/masking/pattern_28.png',
    'assets/masking/pattern_29.png',
    'assets/masking/pattern_30.png',
    'assets/masking/pattern_31.png',
    'assets/masking/pattern_32.png',
    'assets/masking/pattern_33.png',
    'assets/masking/pattern_34.png',
    'assets/masking/pattern_35.png',
    'assets/masking/pattern_36.png',
    'assets/masking/pattern_37.png',
    'assets/masking/pattern_38.png',
    'assets/masking/pattern_39.png',
    'assets/masking/pattern_40.png',
  ];

  @override
  MaskingState createState() {
    return new MaskingState();
  }
}

class MaskingState extends State<Masking> {
  double selectedWidth = 3.0;
  @override
  void didChangeDependencies() {
    selectedWidth = widget.model.painterController.thickness;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text('Roller',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.w500)),
            ),
            Expanded(
              flex: 1,
              child: GridView.count(
                crossAxisCount: 5,
                children: Masking.listOfImage
                    .map((t) => _buildTile(context, t))
                    .toList(growable: false),
              ),
            ),
          ]),
    );
  }

  Widget _buildTile(BuildContext context, String text) {
    return new InkWell(
      onTap: () {
        widget.model.addMaskImage(text);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    text,
                  ),
                  repeat: ImageRepeat.repeat),
              borderRadius: BorderRadius.all(new Radius.circular(15.0))),
        ),
      ),
    );
  }
}

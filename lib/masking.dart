import 'package:flutter/material.dart';
import 'package:tahiti/activity_model.dart';

class Masking extends StatefulWidget {
  final ActivityModel model;

  Masking({Key key, this.model}) : super(key: key);
  static final List<String> listOfImage = [
    'assets/masking/pattern1.png',
    'assets/masking/pattern2.jpg',
    'assets/masking/pattern3.png',
    'assets/masking/pattern4.png',
    'assets/masking/pattern5.jpg',
    'assets/masking/pattern6.png',
    'assets/masking/pattern7.png',
    'assets/masking/pattern8.png',
    'assets/masking/pattern9.png',
    'assets/masking/pattern10.jpg',
    'assets/masking/pattern11.jpg',
    'assets/masking/pattern12.jpg',
    'assets/masking/pattern1.png',
    'assets/masking/pattern2.jpg',
    'assets/masking/pattern3.png',
    'assets/masking/pattern4.png',
    'assets/masking/pattern5.jpg',
    'assets/masking/pattern6.png',
    'assets/masking/pattern7.png',
    'assets/masking/pattern8.png',
    'assets/masking/pattern9.png',
    'assets/masking/pattern10.jpg',
    'assets/masking/pattern11.jpg',
    'assets/masking/pattern12.jpg',
  ];

  @override
  MaskingState createState() {
    return new MaskingState();
  }
}

class MaskingState extends State<Masking> {
  List<double> widthValue = [
    3.0,
    6.0,
    11.0,
    16.0,
    19.0,
  ];
  double selectedWidth = 3.0;
  @override
  void didChangeDependencies() {
    selectedWidth = widget.model.painterController.thickness;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
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
            flex: 9,
            child: GridView.count(
              crossAxisCount: 3,
              children: Masking.listOfImage
                  .map((t) => _buildTile(context, t))
                  .toList(growable: false),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widthValue
                    .map((width) => Expanded(
                          flex: 2,
                          child: Center(
                              child: RawMaterialButton(
                            onPressed: () {
                              widget.model.painterController.thickness = width;
                              setState(() {
                                selectedWidth = width;
                              });
                            },
                            constraints: new BoxConstraints.tightFor(
                              width: width + (size.height - size.width) * .02,
                              height: width + (size.height - size.width) * .02,
                            ),
                            fillColor: new Color(0xffffffff),
                            shape: new CircleBorder(
                              side: new BorderSide(
                                color: width == selectedWidth
                                    ? Colors.red
                                    : Color(0xffffffff),
                                width: 2.0,
                              ),
                            ),
                          )),
                        ))
                    .toList(growable: false),
              ),
            ),
          ),
        ]);
  }

  Widget _buildTile(BuildContext context, String text) {
    return Card(
      elevation: 3.0,
      child: new InkWell(
        onTap: () {
          widget.model.addMaskImage(text);
          Navigator.pop(context);
        },
        child: new AspectRatio(
          aspectRatio: 1.0,
          child: Image.asset(
            text,
          ),
        ),
      ),
    );
  }
}

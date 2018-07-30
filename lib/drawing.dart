import 'package:flutter/material.dart';



class Drawing extends StatefulWidget {
  DrawingState createState() => new DrawingState();
}

class DrawingState extends State<Drawing> {
  List<Offset> _points = <Offset>[];

Widget build(BuildContext context) {

    return new Container(
      child: new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox referenceBox = context.findRenderObject();

              Offset localPosition =
              referenceBox.globalToLocal(details.globalPosition);
              _points = new List.from(_points)..add(localPosition);
            });
          },
          onPanEnd: (DragEndDetails details) =>_points.add(null),
          child: new CustomPaint(
            painter: new DrawPainter (_points),

          ),
        ),
      ),
    );
  }
}




class DrawPainter  extends CustomPainter {
  List<Offset> points = [];
  Canvas _lastCanvas;
  Size _lastSize;
  DrawPainter (points){

    this.points = points;
  }

  void paint(Canvas canvas, Size size) {
   // print({"the main paint is called .... ": {"size" : size}});
    _lastCanvas = canvas;
    _lastSize = size;


    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;


    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null &&
          points[i + 1] != null &&
          (points[i].dx >= 0 &&
              points[i].dy >= 0 &&
              points[i].dx < size.width &&
              points[i].dy < size.height) &&
          (points[i + 1].dx >= 0 &&
              points[i + 1].dy >= 0 &&
              points[i + 1].dx < size.width &&
              points[i + 1].dy < size.height)){
        canvas.drawLine(points[i], points[i + 1], paint);
      }

    }
  }

  bool shouldRepaint(DrawPainter  other) => other.points != points;
}
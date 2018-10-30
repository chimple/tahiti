import 'package:flutter/material.dart';

class PulseAnimation extends StatefulWidget {
  final Color color;
  final double size;

  const PulseAnimation({
    Key key,
    @required this.color,
    this.size = 40.0,
  }) : super(key: key);

  @override
  _PulseAnimationState createState() => new _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = CurveTween(curve: Curves.easeInOut).animate(_controller)
      ..addListener(
        () => setState(() => <String, void>{}),
      );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 1.0 - _animation.value,
        child: new Transform.scale(
          scale: _animation.value,
          child: new Container(
            height: widget.size,
            width: widget.size,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: widget.color),
          ),
        ),
      ),
    );
  }
}

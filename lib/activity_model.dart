import 'package:tahiti/drawing.dart';
import 'package:scoped_model/scoped_model.dart';

class ActivityModel extends Model {

  PainterController _controller;
 
  ActivityModel() {
    _controller = new PainterController();
  }

  PainterController get controller => this._controller;
}
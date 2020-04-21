import 'package:flutter/material.dart';
import 'package:trackcorona/utilities/person_condition_enum.dart';

class ShapesPainter extends CustomPainter {

  final PersonCondition personCondition;

  const ShapesPainter(this.personCondition);

  @override
  void paint(Canvas canvas, Size size) {
    Color pointerColor;
    switch(personCondition){
      case PersonCondition.infected:
        pointerColor=Colors.deepOrange.withOpacity(0.50);
        break;
      case PersonCondition.symptoms:
        pointerColor=Colors.lightBlueAccent.withOpacity(0.50);
        break;
      case PersonCondition.well:
        pointerColor=Colors.lightGreen.withOpacity(0.50);
        break;
    }

    final paint = Paint();
    // set the color property of the paint
    paint.color = pointerColor;
    // center of the canvas is (x,y) => (width/2, height/2)
//    var center = Offset(size.width / 2, size.height / 2);

    // draw the circle on centre of canvas having radius 75.0
    canvas.drawCircle(Offset(8, 14), 3, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}



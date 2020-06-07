import 'package:flutter/material.dart';


class BoucyPageRoute extends PageRouteBuilder{
  final Widget widget;

  BoucyPageRoute({this.widget}):super(
      transitionDuration: Duration(milliseconds: 1000),
      transitionsBuilder: (BuildContext context, 
        Animation<double> animation,
        Animation<double> secAnimation,
        Widget child) {
          animation = CurvedAnimation(parent: animation,curve: Curves.elasticInOut);

          return ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: child,
          );
          },
          pageBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secAnimation) {
            return widget;
          }
          );
}
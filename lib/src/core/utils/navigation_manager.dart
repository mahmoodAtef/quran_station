import 'package:flutter/material.dart';

extension NavigationMethods on BuildContext {
  void pop() {
    Navigator.pop(this);
  }

  void pushPage(Widget screen) {
    Navigator.push(
        this,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

            // var begin = const Offset(-1.0, 0);
            // var end = const Offset(0, 0);
            // var tween = Tween(begin: begin,end: end);
            // var offsetAnimation = animation.drive(tween);
            // return SlideTransition(position: offsetAnimation,child: child,);
          },
        ));
  }

  void push(Widget screen) {
    Navigator.push(this, MaterialPageRoute(builder: (context) => screen));
  }

  void pushAndRemove(Widget screen) {
    Navigator.pushAndRemoveUntil(this,
        MaterialPageRoute(builder: (context) => screen), (route) => false);
  }
}

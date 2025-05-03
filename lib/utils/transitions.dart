import 'package:flutter/material.dart';

class ScaleTransitionRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  ScaleTransitionRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(
            begin: 0.0,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.ease));
          return ScaleTransition(scale: animation.drive(tween), child: child);
        },
      );
}

class FadeTransitionRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  FadeTransitionRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
}

class SlideTransitionRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Offset beginOffset;

  SlideTransitionRoute({
    required this.page,
    this.beginOffset = const Offset(1.0, 0.0),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final tween = Tween(
             begin: beginOffset,
             end: Offset.zero,
           ).chain(CurveTween(curve: Curves.ease));
           return SlideTransition(
             position: animation.drive(tween),
             child: child,
           );
         },
       );
}

class RotateTransitionRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  RotateTransitionRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(
            begin: 0.0,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.ease));
          return RotationTransition(
            turns: animation.drive(tween),
            child: child,
          );
        },
      );
}

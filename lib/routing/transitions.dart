import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A page that fades in and out.
class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
          key: key,
          child: child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation.drive(_curveTween),
            child: child,
          ),
        );

  static final _curveTween = CurveTween(curve: Curves.easeIn);
}

/// A page that slides in from the right.
class SlideTransitionPage extends CustomTransitionPage<void> {
  SlideTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
          key: key,
          child: child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeIn)),
            ),
            child: child,
          ),
        );
}

/// A page that scales in from the center.
class ScaleTransitionPage extends CustomTransitionPage<void> {
  ScaleTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
          key: key,
          child: child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: animation.drive(
              Tween<double>(begin: 0.5, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeIn)),
            ),
            child: child,
          ),
        );
}

/// A page that rotates in.
class RotationTransitionPage extends CustomTransitionPage<void> {
  RotationTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
          key: key,
          child: child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              RotationTransition(
            turns: animation.drive(
              Tween<double>(begin: 0.8, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeIn)),
            ),
            child: ScaleTransition(
              scale: animation.drive(Tween<double>(begin: 0.5, end: 1.0)),
              child: child,
            ),
          ),
        );
}

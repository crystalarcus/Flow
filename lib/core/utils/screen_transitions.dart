import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SlideTransitionPage extends CustomTransitionPage {
  final GoRouterState state;
  SlideTransitionPage({required super.child, required this.state})
      : super(
            key: state.pageKey,
            transitionDuration: Durations.long1,
            reverseTransitionDuration: Durations.medium2,
            transitionsBuilder:
                ((context, animation, secondaryAnimation, child) =>
                    CupertinoPageTransition(
                      primaryRouteAnimation: animation,
                      secondaryRouteAnimation: secondaryAnimation,
                      linearTransition: false,
                      child: child,
                    )));
}

class SlideBottomTransitionPage extends CustomTransitionPage {
  final GoRouterState state;
  SlideBottomTransitionPage({required super.child, required this.state})
      : super(
          key: state.pageKey,
          transitionDuration: Durations.short2,
          reverseTransitionDuration: Durations.short1,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeThroughTransition(
            secondaryAnimation: secondaryAnimation,
            animation: animation,
            child: child,
          ),
        );
}

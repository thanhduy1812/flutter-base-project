// Packages you must install ==>  simple_animations: ^4.0.1 || supercharged: ^2.1.1

// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
// import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { opacity, translateY }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation({required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    // final tween = MulTtiTrackTween<AniProps>()
    //   ..add(AniProps.opacity, 0.0.tweenTo(1.0), 500.milliseconds)
    //   ..add(AniProps.translateY, (-30.0).tweenTo(0.0), 500.milliseconds, Curves.easeOut);
    final movieTween = MovieTween()
      ..tween(AniProps.opacity, Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500), curve: Curves.easeOut)
          .thenTween(AniProps.translateY, Tween(begin: -30.0, end: 0.0),
              duration: const Duration(milliseconds: 500), curve: Curves.easeOut);

    return PlayAnimationBuilder<Movie>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: movieTween.duration,
      tween: movieTween,
      child: child,
      builder: (context, value, child) => Opacity(
        // opacity: value.get(AniProps.opacity),
        opacity: value.get(AniProps.opacity),
        child: Transform.translate(offset: Offset(0, value.get(AniProps.translateY)), child: child),
      ),
    );
  }
}

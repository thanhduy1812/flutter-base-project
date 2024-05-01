import 'package:cctv_stream_app/core/common_color/common_color.dart';
import 'package:dvt_helper/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cctv_stream_app/router/router.dart';

class SplashScreen extends StatefulWidget {
  static const String route = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Future.delayed(const Duration(seconds: 2)).then((value) {
      context.pushReplacement(Routes.homescreen.path);
    });
    return ColoredBox(
      color: const Color(0xfffffdfa),
      // color: const Color(0xff2A2438),
      // color: secondrycolor,
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Center(
          child: DVTImage.lottieImage(assetName: "assets/icons/logocicimedia1.json", repeat: false),
        ),
      ),
    );
  }
}

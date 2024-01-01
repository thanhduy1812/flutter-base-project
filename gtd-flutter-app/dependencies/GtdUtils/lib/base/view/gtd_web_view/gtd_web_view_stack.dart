import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GtdWebViewStack extends StatefulWidget {
  final String url;
  const GtdWebViewStack({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<GtdWebViewStack> createState() => _GtdWebViewStackState();
}

class _GtdWebViewStackState extends State<GtdWebViewStack> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}

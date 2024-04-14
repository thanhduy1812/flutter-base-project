import 'package:dvt_helper/dvt_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/data/cache_helper/user_manager.dart';
// import 'package:gtd_utils/data/cache_helper/user_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GtdWebViewStack extends StatefulWidget {
  final String url;

  const GtdWebViewStack({super.key, required this.url});

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
          if (!mounted) {
            return;
          }
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          if (!mounted) {
            return;
          }
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          if (!mounted) {
            return;
          }
          if (kDebugMode) {
            print('onPageFinished: $url');
          }
          if (url.contains('booking/result?bookingNumber')) {
            final bookingNumber = Uri.parse(url).queryParameters['bookingNumber'];
            if (!bookingNumber.isNullOrEmpty()) {
              UtilManager.shared.bookingResultWebViewCallback.call(bookingNumber!);
            }
          }

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

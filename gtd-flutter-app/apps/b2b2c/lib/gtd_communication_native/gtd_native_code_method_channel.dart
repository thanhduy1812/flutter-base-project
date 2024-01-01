import 'package:flutter/services.dart';

class GtdNativeCodeMethodChannel {
  static const channelName = 'b2b2c.messageToNativeCodeChannel';
  MethodChannel? methodChannel;
  MethodChannel navigationChannel = SystemChannels.navigation;
  MethodChannel localizationChannel = SystemChannels.localization;
  BasicMessageChannel lifeCycleChannel = SystemChannels.lifecycle;

  static final GtdNativeCodeMethodChannel shared = GtdNativeCodeMethodChannel._init();
  GtdNativeCodeMethodChannel._init();

  void configureChannel() {
    methodChannel = MethodChannel(channelName);
  }
}

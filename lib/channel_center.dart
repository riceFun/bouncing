import 'package:flutter/services.dart';

const _platform = MethodChannel('bouncing');

class ChannelCenter {
  static ChannelCenter instance = ChannelCenter();

  static preConfig() async {
    const invokeMethodName = 'preConfig';
    try {
      final String result = await _platform.invokeMethod(invokeMethodName);
      print(result);
    } on PlatformException catch (e) {
      print("Failed to $invokeMethodName: '${e.message}'.");
    }
  }

  static resizeWindow(double width, double height) async {
    const invokeMethodName = 'resizeWindow';
    try {
      final String result = await _platform.invokeMethod(invokeMethodName, {
        'width': width,
        'height': height,
      });
      print(result);
    } on PlatformException catch (e) {
      print("Failed to $invokeMethodName: '${e.message}'.");
    }
  }

  static audioPlay(int index) async {
    const invokeMethodName = 'audioPlay';
    try {
      final String result = await _platform.invokeMethod(invokeMethodName, index);
      print(result);
    } on PlatformException catch (e) {
      print("Failed to $invokeMethodName: '${e.message}'.");
    }
  }

  static startVideoRecord() async {
    const invokeMethodName = 'startVideoRecord';
    try {
      final String result = await _platform.invokeMethod(invokeMethodName);
      print(result);
    } on PlatformException catch (e) {
      print("Failed to $invokeMethodName: '${e.message}'.");
    }
  }

  static stopVideoRecord() async {
    const invokeMethodName = 'stopVideoRecord';
    try {
      final String result = await _platform.invokeMethod(invokeMethodName);
      print(result);
    } on PlatformException catch (e) {
      print("Failed to $invokeMethodName: '${e.message}'.");
    }
  }





}

// channelAudioPlay(int index) async {
//   try {
//     final String result = await _platform.invokeMethod('play', index);
//     print(result);
//   } on PlatformException catch (e) {
//     print("Failed to audio play: '${e.message}'.");
//   }
// }
//
// const _platform = MethodChannel('audioPlay');
//
// channelAudioPlay(int index) async {
//   try {
//     final String result = await _platform.invokeMethod('play', index);
//     print(result);
//   } on PlatformException catch (e) {
//     print("Failed to audio play: '${e.message}'.");
//   }
// }
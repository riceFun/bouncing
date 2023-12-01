// import 'package:flutter/services.dart';
//
// const _platform = MethodChannel('windowResizer');
//
// channelResizeWindow(double width, double height) async {
//   try {
//     final String result = await _platform.invokeMethod('resizeWindow', {
//       'width': width,
//       'height': height,
//     });
//     print(result);
//   } on PlatformException catch (e) {
//     print("Failed to resize window: '${e.message}'.");
//   }
// }
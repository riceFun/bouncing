import 'package:bouncing/base_title.dart';
import 'package:bouncing/bounding_ball_path.dart';
import 'package:flutter/material.dart';

class BallPathPage extends StatefulWidget {
  const BallPathPage({Key? key}) : super(key: key);

  @override
  State<BallPathPage> createState() => _BallPathPageState();
}

class _BallPathPageState extends State<BallPathPage> {
  bool isStart = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const BaseTitle(title: '每弹一次,球的速度会越来越快，越来越大'),
          if (isStart)
            LayoutBuilder(builder: (context,cons) {
              return BouncingBallPath(width: cons.maxWidth,onEnd: () {
                setState(() {
                  isStart = false;
                });
              },);
            }),
          const BaseTitle(title: 'BouncingMove'),
          Visibility(
              visible: isStart == false,
              child: ElevatedButton(onPressed: () {
                setState(() {
                  isStart = true;
                });
              }, child: Text('开始')))
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

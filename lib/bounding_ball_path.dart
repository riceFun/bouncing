import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bouncing/channel_center.dart';
import 'package:bouncing/music_list.dart';
import 'package:bouncing/rgb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BouncingBallPath extends StatefulWidget {
  final double width;
  final Function() onEnd;
  const BouncingBallPath({Key? key, required this.width, required this.onEnd}) : super(key: key);

  @override
  State<BouncingBallPath> createState() => _BouncingBallPathState();
}

class _BouncingBallPathState extends State<BouncingBallPath>
    with TickerProviderStateMixin {
  late Ticker _ticker;
  late AnimationController _controller;
  late Animation<double> _animation;
  late double containerWidth;
  late double halfContainerWidth;
  late double ballSize = 20.0;
  static double ballSizeAdd = 0.2;
  late double ballX;
  late double ballY;
  late double ballSpeedX = 2.0;
  late double ballSpeedY = 1.0;
  static double ballSpeedAdd = 0.2;
  int r = 200, g = 200, b = 200;
  late RGB ballRgb;
  int i = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<AudioPlayer> audioPlayerList = [];


  // 保存先前圆的位置
  List<Ball> previousBalls = [];

  @override
  void initState() {
    super.initState();
    audioPlayerList = [
      AudioPlayer(),
      AudioPlayer(),
      AudioPlayer(),
      AudioPlayer(),
      AudioPlayer(),
      AudioPlayer(),
      AudioPlayer(),
    ];
    ballRgb = RGB(r: r, g: g, b: b);
    containerWidth = widget.width;
    halfContainerWidth = containerWidth / 2;
    ballX = halfContainerWidth;
    ballY = halfContainerWidth;
    onStart();

  }

  onStart() async {
    ChannelCenter.startVideoRecord();
    await Future.delayed(const Duration(seconds: 2), () {});
    _ticker = createTicker(_onTick)..start();
  }

  onStop() async {
    ChannelCenter.stopVideoRecord();
    await Future.delayed(const Duration(seconds: 1), () {});
    widget.onEnd();
  }

  void _onTick(Duration elapsed) {
    if (ballSize >= halfContainerWidth) {
      setState(() {
        ballSpeedX = 0;
        ballSpeedY = 0;
        ballX = halfContainerWidth;
        ballY = halfContainerWidth;
      });
      onStop();
    } else {
      ballX += ballSpeedX;
      ballY += ballSpeedY;

      _saveCurrentPosition();
      setState(() {
        // 碰撞检测
        if (ballX - ballSize <= 0 || ballX + ballSize >= containerWidth) {
          if (ballX - ballSize <= 0) {
            ballX = ballSize;
          }
          if (ballX + ballSize >= containerWidth) {
            ballX = containerWidth - ballSize;
          }

          ballSpeedX = -ballSpeedX;
          ballSpeedX > 0 ? ballSpeedX += ballSpeedAdd : ballSpeedX -= ballSpeedAdd;
          ballSize += ballSizeAdd;
          _randomizeColor();
        }

        if (ballY - ballSize <= 0 || ballY + ballSize >= containerWidth) {
          if (ballY - ballSize <= 0) {
            ballY = ballSize;
          }
          if (ballY + ballSize >= containerWidth) {
            ballY = containerWidth - ballSize;
          }
          ballSpeedY = -ballSpeedY;
          ballSpeedY > 0 ? ballSpeedY += ballSpeedAdd : ballSpeedY -= ballSpeedAdd;
          ballSize += ballSizeAdd;
          _randomizeColor();
        }
      });
    }
  }

  _saveCurrentPosition() {
    i++;
    if (i % 2 == 1) {
      return;
    }

    double ballXTemp = ballX;
    double ballYTemp = ballY;
    if (ballXTemp - ballSize <= 0) {
      ballXTemp = ballSize;
    }
    if (ballXTemp + ballSize >= containerWidth) {
      ballXTemp = containerWidth - ballSize;
    }

    if (ballYTemp - ballSize <= 0) {
      ballYTemp = ballSize;
    }
    if (ballYTemp + ballSize >= containerWidth) {
      ballYTemp = containerWidth - ballSize;
    }

    previousBalls.add(Ball(
        ballX: ballXTemp,
        ballY: ballYTemp,
        ballSize: ballSize,
        ballRgb: ballRgb));
    if (previousBalls.length > 200) {
      previousBalls.removeAt(0);
    }
  }


  String curRgbType = 'r';
  void _randomizeColor() {
    r++;
    g++;
    b++;

    // if (curRgbType == 'r') {
    //   if (r < 256) {
    //     r++;
    //   } else {
    //     r = 0;
    //     curRgbType = 'g';
    //   }
    // } else if (curRgbType == 'g') {
    //   if (g < 256) {
    //     g++;
    //   } else {
    //     g = 0;
    //     curRgbType = 'b';
    //   }
    // } else if (curRgbType == 'b') {
    //   if (b < 256) {
    //     b++;
    //   } else {
    //     b = 0;
    //     curRgbType = 'r';
    //   }
    // }

    r = Random().nextInt(255);
    g = Random().nextInt(255);
    b = Random().nextInt(255);
    ballRgb = RGB(r: r, g: g, b: b);
    _playMp3();
  }

  // List
  int musicIndex = 0;
  // List musics = ['audios/1.mp3','audios/2.mp3','audios/3.mp3','audios/4.mp3','audios/5.mp3','audios/6.mp3','audios/7.mp3'];
  // List musics2 = ['assets/audios/1.mp3','assets/audios/2.mp3','assets/audios/3.mp3','assets/audios/4.mp3','assets/audios/5.mp3','assets/audios/6.mp3','assets/audios/7.mp3'];
  // List musics = ['audios/1_C.mp3','audios/2_D.mp3','audios/3_E.mp3','audios/4_F.mp3','audios/5_G.mp3','audios/6_A.mp3','audios/7_B.mp3'];
  // List musics2 = ['assets/audios/1_C.mp3','assets/audios/2_D.mp3','assets/audios/3_E.mp3','assets/audios/4_F.mp3','assets/audios/5_G.mp3','assets/audios/6_A.mp3','assets/audios/7_B.mp3'];

  _playMp3() {
    ChannelCenter.audioPlay(music1[musicIndex]);
    musicIndex++;
    if (musicIndex > music1.length - 1) {
      musicIndex = 0;
    }
  }

  // _playMp3() {
  //   // _audioPlayer.stop();
  //   // String music = musics[musicIndex];
  //   // String music2 = musics2[musicIndex];
  //   musicIndex++;
  //   if (musicIndex > music1.length) {
  //     musicIndex = 0;
  //   }
  //   // audioPlayerList[musicIndex].stop();
  //   // audioPlayerList[musicIndex].play(AssetSource(music),mode: PlayerMode.lowLatency);
  //   // _audioPlayer.play(AssetSource(music),mode: PlayerMode.lowLatency, position: const Duration(milliseconds: 500));
  //
  //   ChannelCenter.audioPlay(music1[musicIndex]);
  //   // channelAudioPlay(musicIndex);
  //
  //   // AssetsAudioPlayer.newPlayer().open(Audio(music2));
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: containerWidth,
        height: containerWidth,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(32, 32, 32, 1.0,),
          // border: Border.all(color: Colors.white),
        ),
        child: CustomPaint(
          painter: BouncingBallPathPainter(
              curBall: Ball(
                  ballX: ballX,
                  ballY: ballY,
                  ballSize: ballSize,
                  ballRgb: ballRgb),
              previousBalls: previousBalls),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Ball {
  final double ballX;
  final double ballY;
  final double ballSize;
  final RGB ballRgb;
  Ball({
    required this.ballX,
    required this.ballY,
    required this.ballSize,
    required this.ballRgb,
  });
}

class BouncingBallPathPainter extends CustomPainter {
  final Ball curBall;
  final List<Ball> previousBalls;

  BouncingBallPathPainter({
    required this.curBall,
    required this.previousBalls,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 渲染先前的圆
    for (int i = 0; i < previousBalls.length; i++) {
      Ball ball = previousBalls[i];
      double alpha = (i + 1) / previousBalls.length;
      // 渲染白色边框
      final Paint borderPaint = Paint()
        ..color = Color.fromRGBO(255, 255, 255, alpha)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(
          Offset(ball.ballX, ball.ballY), ball.ballSize, borderPaint);
      // ball.ballColor.opacity = (i + 1) / 100;
      //
      // Color.
      final Paint currentPaint = Paint()..color = Color.fromRGBO(
        ball.ballRgb.r,
        ball.ballRgb.g,
        ball.ballRgb.b,
        alpha,
      );
      canvas.drawCircle(
          Offset(ball.ballX, ball.ballY), ball.ballSize, currentPaint);
    }

    // 渲染当前圆
    // 渲染白色边框
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
        Offset(curBall.ballX, curBall.ballY), curBall.ballSize, borderPaint);
    final Paint currentPaint = Paint()..color = Color.fromRGBO(
      curBall.ballRgb.r,
      curBall.ballRgb.g,
      curBall.ballRgb.b,
      1.0,
    );
    canvas.drawCircle(
        Offset(curBall.ballX, curBall.ballY), curBall.ballSize, currentPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



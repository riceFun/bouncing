import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BouncingBallBase extends StatefulWidget {
  const BouncingBallBase({Key? key}) : super(key: key);

  @override
  State<BouncingBallBase> createState() => _BouncingBallBaseState();
}

class _BouncingBallBaseState extends State<BouncingBallBase>with TickerProviderStateMixin {
  late Ticker _ticker;
  late AnimationController _controller;
  late Animation<double> _animation;
  static double containerWidth = 400.0;
  late double halfContainerWidth;
  late double ballSize = 20.0;
  late double ballX = 30.0;
  late double ballY = 30.0;
  late double ballSpeedX = 2.0;
  late double ballSpeedY = 2.5;
  late Color ballColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    halfContainerWidth = containerWidth/2;
    _ticker = createTicker(_onTick)
      ..start();
  }

  void _onTick(Duration elapsed) {
    if (ballSize >= halfContainerWidth) {
      setState(() {
        ballSpeedX = 0;
        ballSpeedY = 0;
        ballX = halfContainerWidth;
        ballY = halfContainerWidth;
      });
    } else {
      ballX += ballSpeedX;
      ballY += ballSpeedY;
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
          ballSpeedX > 0 ? ballSpeedX++ : ballSpeedX--;
          ballSize++;
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
          ballSpeedY > 0 ? ballSpeedY++ : ballSpeedY--;
          ballSize++;
          _randomizeColor();
        }
      });
    }
  }

  void _randomizeColor() {
    final random = Random();
    ballColor = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: containerWidth,
        height: containerWidth,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: CustomPaint(
          painter: BouncingBallPainter(
            ballX: ballX,
            ballY: ballY,
            ballSize: ballSize,
            ballColor: ballColor,
          ),
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

class BouncingBallPainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final double ballSize;
  final Color ballColor;

  BouncingBallPainter({
    required this.ballX,
    required this.ballY,
    required this.ballSize,
    required this.ballColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = ballColor;

    canvas.drawCircle(Offset(ballX, ballY), ballSize, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

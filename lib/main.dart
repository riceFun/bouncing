import 'dart:io';
import 'dart:math';

import 'package:bouncing/boucing_ball_base.dart';
import 'package:bouncing/bounding_ball_path.dart';
import 'package:bouncing/channel_center.dart';
import 'package:bouncing/page/ball_path_page.dart';
import 'package:bouncing/window_resize.dart';
import 'package:flutter/material.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isMacOS) {
    // 设置macOS应用程序窗口大小
    ChannelCenter.resizeWindow(400,800);
  }
   ChannelCenter.preConfig();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bouncing'),),
      // backgroundColor: Colors.black,
      body: ListView(children: [
        InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BallPathPage()),
              );
            },
            child: ListTile(title: Text('ball_path'),)),
      ],)

      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     LayoutBuilder(builder: (context,cons) {
      //       return BouncingBallPath(width: cons.maxWidth,);
      //     })
      //
      //   ],
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';

List<CameraDescription> cameras;

void main() => runApp(MyCameraApp());

Future<void> _takeMyPhoto() async {
    cameras = await availableCameras();
    CameraController controller = CameraController(cameras[0], ResolutionPreset.medium);
    String filePath = 'Photos/image_test.jpg';
    await controller.takePicture(filePath);
}

class MyCameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'License Plate Detector'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'Cool!',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takeMyPhoto,
        tooltip: 'Increment',
        child: Icon(Icons.camera),
      ),
    );
  }
}

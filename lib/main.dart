import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

List<CameraDescription> cameras;
String mailAddress;

void main() => runApp(MyCameraApp());

Future<void> _takeMyPhoto() async {
    cameras = await availableCameras();
    CameraController controller = CameraController(cameras[0], ResolutionPreset.medium);
    String filePath = 'Photos/image_test.jpg';
    await controller.takePicture(filePath);

    final File imageFile = File(filePath);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    String mailPattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regEx = RegExp(mailPattern);

    mailAddress = "Couldn't find any mail in the foto! Please try again!";

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        if (regEx.hasMatch(line.text)) {
          mailAddress = line.text;
        }
      }
    }
}

class MyCameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
              '$mailAddress',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takeMyPhoto,
        backgroundColor: Colors.blueGrey[400],
        tooltip: 'Increment',
        
        child: Icon(Icons.photo_camera, size: 32, color: Colors.white,),
      ),
    );
  }
}

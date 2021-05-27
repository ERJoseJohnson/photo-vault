import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


// Unable to implement in time.
// Gallery saver package seems to be affected by the storage changes highlighted in storage.dart
// Unable to save picture taken to device.



class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  final String albumName;
  
  const CameraPage({
    Key? key,
    required this.camera,
    required this.albumName,
  }) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            // // Save image to gallery
            // ImageGallerySaver
            // GallerySaver.saveImage(image.path).then((value) {
            //   print(value);
            // // Write to image to database
            // Map<String,dynamic> dbData = {"albumName": widget.albumName, photoPath": image.path}
            // Provider.of<DBProvider>(context, listen:false).insertItems("Albums",dbData,)
            //   Navigator.pop(context);
            // //   Navigator.of(context).push(
            // //     MaterialPageRoute(
            // //       builder: (context) => DisplayPictureScreen(
            // //         imagePath: image.path,
            // //       ),
            //     ),
            //   );
            // });
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
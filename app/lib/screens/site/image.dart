// A screen that takes in a list of cameras and the Directory to store images.
import 'package:app/screens/shared/app_bar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class InletImage extends StatefulWidget {
  final CameraDescription camera;
  XFile? image;

  InletImage({Key? key, required this.camera})
      : super(key: key);

  @override
  InletImageState createState() => InletImageState();
}

class InletImageState extends State<InletImage> {
  static final Logger _lg = new Logger();
  // Add two variables to the state class to store the CameraController and
  // the Future.
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller?.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: SdAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and then get the location
            // where the image file is saved.
            widget.image = await _controller?.takePicture();
           // _lg.d(this.image);
            Navigator.of(context).pop();
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    // You must wait until the controller is initialized before displaying the
    // camera preview. Use a FutureBuilder to display a loading spinner until the
    // controller has finished initializing.
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return CameraPreview(_controller!);
        } else {
          // Otherwise, display a loading indicator.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

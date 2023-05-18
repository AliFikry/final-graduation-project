import 'package:flutter_bluetooth_serial_example/bluetoothApp.dart';
import 'package:flutter_bluetooth_serial_example/main.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

// CameraController _controller;
// Future<void> _initializeControllerFuture;
String value = "hello";
String selectedLed = "";
String selectedGesture = "";

class _CameraScreenState extends State<CameraScreen> {
  // Future<void> _initializeCamera() async {
  //   // Get the list of available cameras
  //   // final cameras = await availableCameras();

  //   // Select the back camera
  //   final camera = cameras[1];

  //   // Initialize the camera controller
  //   _controller = CameraController(camera, ResolutionPreset.medium);

  //   // Initialize the controller future
  //   _initializeControllerFuture = _controller.initialize();
  //   cameraControlle
  // }

  @override
  void initState() {
    super.initState();
    cameraController.initialize();

    // _initializeCamera(); // Assign the future to the field
  }

  @override
  void dispose() {
    // cameraController.dispose();
    super.dispose();
  }

  void _sendOnMessageToBluetooth(String input) async {
    connection.output.add(utf8.encode(input + "\r\n"));
    await connection.output.allSent;
    // show('Device Turned Off');
    setState(() {
      // _deviceState = -1; // device off
    });
  }

  String apiUrl =
      'http://192.168.43.141:5000/detect2'; // Replace with your API endpoint

  Future<bool> uploadImage(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        var json = jsonDecode(value);
        // json = jsonDecode(json["gesture"]);
        if (json["gesture"] == "One" ||
            json["gesture"] == "Two" ||
            json["gesture"] == "Three" ||
            json["gesture"] == "Four") {
          setState(() {
            selectedLed = json["gesture"];
          });
        }
        if (json["gesture"] == "Open" || json["gesture"] == "Close") {
          selectedGesture = json["gesture"];
          if (selectedLed.length != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Device ${selectedLed} ${selectedGesture}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                duration: Duration(seconds: 2),
              ),
            );
            var nameToNumber = {
              "One": "1",
              "Two": "2",
              "Three": "3",
              "Four": "4",
            };
            if (json["gesture"] == "Open") {
              _sendOnMessageToBluetooth(nameToNumber[selectedLed] + "on");
              print(nameToNumber[selectedLed]);
            } else if (json["gesture"] == "Close") {
              _sendOnMessageToBluetooth(nameToNumber[selectedLed] + "off");
              print(nameToNumber[selectedLed]);
            }

            setState(() {
              selectedLed = "";
            });
          }
        }
        print(selectedLed);
        print(selectedGesture);
      });
      if (response.statusCode == 200) {
        print("good1");
        // print(response)
        return true; // Image upload success
      }
    } catch (e) {
      print('Error uploading image: $e');
    }

    return false; // Image upload failed
  }

  Future<void> _captureImage() async {
    try {
      final image = await cameraController.takePicture();
      bool uploadSuccess = await uploadImage(File(image.path));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DisplayImageScreen(imagePath: image.path),
      //   ),
      // );
      print(uploadSuccess);
      if (uploadSuccess) {
        // Image upload successful
        // Perform any desired actions
        print("sent");
      } else {
        // Image upload failed
        print("failed");
        // Handle the failure
      }

      // Do something with the captured image (e.g., save or display)
    } catch (e) {
      // Handle the exception
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Timer.periodic(Duration(milliseconds: 500), (timer) {
    //   // Your function logic here
    //   print('Triggered every 0.5 seconds');
    //   _captureImage();
    // });

    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Detection"),
      ),
      body: Stack(
        children: [
          CameraPreview(cameraController),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.15,
            child: Text(
              selectedLed == ""
                  ? "No Selected Device"
                  : "Selected Device: ${selectedLed}",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      // body: FutureBuilder<void>(
      //   future: _initializeCamera(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       return CameraPreview(_controller);
      //     } else {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: _captureImage,
      ),
    );
  }
}

// class APIService {
  
// }

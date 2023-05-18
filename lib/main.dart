// For performing some operations asynchronously
import 'dart:async';
import 'dart:convert';

// For using PlatformException
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_example/aboutUs.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_bluetooth_serial_example/bluetoothApp.dart';
import 'package:flutter_bluetooth_serial_example/drawer.dart';
import 'package:flutter_bluetooth_serial_example/test.dart';
import 'package:flutter_bluetooth_serial_example/voice.dart';

List<CameraDescription> cameras;
CameraController cameraController;
List DeviceNames = ["Device 1", "Device 2", "Device 3", "Device 4"];
List DeviceStatus = [true, true, true, true];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Retrieve the available cameras
  cameras = await availableCameras();

  // Initialize the first camera
  cameraController = CameraController(
    cameras[1],
    ResolutionPreset.medium,
  );

  // Initialize the camera
  await cameraController.initialize();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List _pages = [BluetoothApp(), MyHomePage(), CameraScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.voice_chat),
            label: 'Voice Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.back_hand),
            label: 'Hand Gesture',
          ),
        ],
      ),
    );
  }
}

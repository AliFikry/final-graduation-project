// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class New extends StatefulWidget {
//   const New({Key key}) : super(key: key);

//   @override
//   State<New> createState() => _NewState();
// }

// class _NewState extends State<New> {
//   File _image;
//   ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage() async {
//     final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _image = File(pickedImage.path);
//       });
//     }
//   }

//   Future<void> _processImage() async {
//     if (_image == null) return;

//     final request = http.MultipartRequest(
//         'POST', Uri.parse('http://192.168.1.8:5000/process-image'));

//     request.files.add(await http.MultipartFile.fromPath('image', _image.path));

//     final response = await request.send();
//     final responseData = await response.stream.toBytes();

//     setState(() {
//       _image = File.fromRawPath(responseData);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Image Processing Example')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image != null ? Image.file(_image) : Text('No image selected.'),
//             TextButton(
//               onPressed: _pickImage,
//               child: Text('Pick Image'),
//             ),
//             TextButton(
//               onPressed: _processImage,
//               child: Text('Process Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

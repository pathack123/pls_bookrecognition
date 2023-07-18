import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  String result = '';
  late ImagePicker imagePicker;

  dynamic textRecognizer;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();

    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    File image = File(pickedFile!.path);
    setState(() {
      _image = image;
      if (_image != null) {
        doTextRecognition();
      }
    });
  }

  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile!.path);
    setState(() {
      _image = image;
      if (_image != null) {
        doTextRecognition();
      }
    });
  }

  doTextRecognition() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;

    setState(() {
      result = text;
    });

    for (TextBlock block in recognizedText.blocks) {
      // ignore: unused_local_variable
      final Rect rect = block.boundingBox;
      // ignore: unused_local_variable
      final List<Point<int>> cornerPoints = block.cornerPoints;
      // ignore: unused_local_variable
      final String text = block.text;
      // ignore: unused_local_variable
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        // ignore: unused_local_variable
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bg2.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const SizedBox(
              width: 100,
            ),
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/notebook.png'),
                    fit: BoxFit.cover),
              ),
              height: 280,
              width: 250,
              margin: const EdgeInsets.only(top: 70),
              padding: const EdgeInsets.only(left: 28, bottom: 5, right: 18),
              child: SingleChildScrollView(
                  child: Text(
                result,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 15),
              )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 140),
              child: Stack(children: <Widget>[
                Center(
                  child: Image.asset(
                    'images/clipboard.png',
                    height: 240,
                    width: 240,
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: _imgFromGallery,
                    onLongPress: _imgFromCamera,
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent),
                    child: Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: 140,
                              height: 192,
                              fit: BoxFit.fill,
                            )
                          // ignore: sized_box_for_whitespace
                          : Container(
                              width: 140,
                              height: 150,
                              child: Icon(
                                Icons.find_in_page,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

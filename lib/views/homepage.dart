import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File? selectedImage;
  String recognizedText = '';
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        recognizedText = '';
      });

      await _performTextRecognition(selectedImage!);
    }
  }

  Future<void> _performTextRecognition(File imageFile) async {
    setState(() => isLoading = true);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognized = await textRecognizer.processImage(inputImage);
      setState(() {
        recognizedText = recognized.text;
      });
    } catch (e) {
      setState(() {
        recognizedText = 'Error: $e';
      });
    } finally {
      await textRecognizer.close();
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Textify')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: selectedImage == null
                ? const Text('No image selected.')
                : Image.file(selectedImage!),
          ),
          const SizedBox(height: 20),
          if (isLoading)
            const CircularProgressIndicator()
          else if (recognizedText.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Text(recognizedText),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: _pickImage,
        child: const Icon(Icons.add),
      ),
    );
  }
}

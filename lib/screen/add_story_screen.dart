import 'dart:io';

import 'package:declarative_navigation/provider/camera_provider.dart';
import 'package:declarative_navigation/provider/story_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Story')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            context.watch<HomeProvider>().imagePath == null
                ? const Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.image, size: 100),
                )
                : _showImage(),
            ElevatedButton(
              onPressed: () => _onGalleryView(),
              child: const Text('Gallery'),
            ),
            ElevatedButton(
              onPressed: () => _onCameraView(),
              child: const Text('Camera'),
            ),
            ElevatedButton(
              onPressed: () => _onUpload(),
              child:
                  context.watch<StoryProvider>().isUploading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  _onUpload() async {
    final ScaffoldMessengerState scaffoldMessengerState = ScaffoldMessenger.of(
      context,
    );
    final storyProvider = context.read<StoryProvider>();
    final homeProvider = context.read<HomeProvider>();
    final imagepath = homeProvider.imagePath;
    final imageFile = homeProvider.imageFile;
    if (imagepath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await storyProvider.compressImage(bytes);

    await storyProvider.uploadStory(
      bytes: newBytes,
      fileName: fileName,
      description: 'Description',
    );

    if (storyProvider.uploadResponse != null) {
      homeProvider.setImageFile(null);
      homeProvider.setImagePath(null);
    }

    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(storyProvider.message)),
    );
  }

  _onGalleryView() async {
    final provider = context.read<HomeProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<HomeProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<HomeProvider>().imagePath;
    return kIsWeb
        ? Image.network(imagePath.toString(), fit: BoxFit.contain)
        : Image.file(File(imagePath.toString()), fit: BoxFit.contain);
  }
}

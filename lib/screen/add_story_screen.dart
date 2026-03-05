import 'package:declarative_navigation/widgets/image_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/camera_provider.dart';
import '../provider/list_story_provider.dart';
import '../provider/story_provider.dart';

class AddStoryPage extends StatefulWidget {
  final Function() onUploadSuccess;
  final Function() onCameraOpened;
  const AddStoryPage({
    super.key,
    required this.onCameraOpened,
    required this.onUploadSuccess,
  });

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = context.watch<StoryProvider>();
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Add Story"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagePreview(imagePath: homeProvider.imagePath),

              const SizedBox(height: 24),

              const Text(
                "Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write your story...",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Description cannot be empty";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _onGalleryView,
                      icon: const Icon(Icons.photo),
                      label: const Text("Gallery"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _onCameraView,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Camera"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: storyProvider.isUploading ? null : _onUpload,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child:
                      storyProvider.isUploading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            "Upload Story",
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onUpload() async {
    if (!_formKey.currentState!.validate()) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final storyProvider = context.read<StoryProvider>();
    final homeProvider = context.read<HomeProvider>();
    final listProvider = context.read<ListStoryProvider>();

    final imageFile = homeProvider.imageFile;
    if (imageFile == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final compressedBytes = await storyProvider.compressImage(bytes);

    await storyProvider.uploadStory(
      bytes: compressedBytes,
      fileName: fileName,
      description: _descriptionController.text,
    );

    if (!mounted) return;

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(storyProvider.message)),
    );

    if (storyProvider.uploadResponse != null) {
      homeProvider.setImageFile(null);
      homeProvider.setImagePath(null);
      _descriptionController.clear();

      await listProvider.fetchListStory();

      if (mounted) widget.onUploadSuccess();
    }
  }

  Future<void> _onGalleryView() async {
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

  Future<void> _onCameraView() async {
    final provider = context.read<HomeProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;

    if (isAndroid || isiOS) {
      widget.onCameraOpened();
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        provider.setImageFile(pickedFile);
        provider.setImagePath(pickedFile.path);
      }
    }
  }
}

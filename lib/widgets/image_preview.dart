import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String? imagePath;

  const ImagePreview({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child:
          imagePath == null
              ? Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:
                    kIsWeb
                        ? Image.network(imagePath!, fit: BoxFit.cover)
                        : Image.file(File(imagePath!), fit: BoxFit.cover),
              ),
    );
  }
}

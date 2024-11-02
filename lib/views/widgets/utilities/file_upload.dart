//create file upload widget

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FileUpload extends StatelessWidget {
  final Function(String) onFileSelected;

  const FileUpload({Key? key, required this.onFileSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final file = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (file == null) return;
            onFileSelected(file.path);
          },
          child: const Text('Upload File'),
        ),
      ],
    );
  }
}

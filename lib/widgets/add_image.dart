import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddImage extends StatefulWidget {
  const AddImage({super.key, required this.getImage});
  final void Function(File image) getImage;
  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  File? imageFile;

  void addImage() async {
    final imagePicker = ImagePicker();
    final image =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (image == null) {
      return;
    }
    setState(() {
      imageFile = File(image.path);
    });
    widget.getImage(imageFile!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: () {
          addImage();
        },
        icon: const Icon(Icons.camera),
        label: const Text('Take Image'));
    if (imageFile != null) {
      content = GestureDetector(
        onTap: addImage,
        child: Image.file(
          imageFile!,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      );
    }
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}

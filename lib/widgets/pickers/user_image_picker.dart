import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this._imagePickFn);

  final Function(File pickedImage) _imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void _pickImage() async {
    var pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 200);

    if (pickedFile == null) {
      return;
    }
    setState(() {
      _pickedImage = File(pickedFile.path);
    });
    widget._imagePickFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.red.shade300,
          backgroundImage:
              _pickedImage == null ? null : FileImage(_pickedImage!),
        ),
        ElevatedButton.icon(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(primary: Colors.grey.shade500),
          icon: Icon(Icons.image),
          label: Text("Select an Image"),
        ),
      ],
    );
  }
}

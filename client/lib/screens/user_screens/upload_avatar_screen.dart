import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:found_adoption_application/repository/change_avatar_api.dart';
import 'package:found_adoption_application/screens/user_screens/edit_profile_screen.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  PickedFile? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    PickedFile? pickedImage =
        await _picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.white),
                  shape: BoxShape.circle,
                  image: _pickedImage != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(_pickedImage!.path))
                              as ImageProvider<Object>,
                        )
                      : null,
                ),
                child: _pickedImage == null
                    ? Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20),
            _pickedImage != null
                ? ElevatedButton(
                    onPressed: () async {
                      await changeAvatar(context, _pickedImage);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen()));
                    },
                    child: Text('Upload Image'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

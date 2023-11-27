import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Pet {
  String name = '';
  String breed = '';
  String type = 'Cat'; // Default to Cat
  File? image;
  String address = '';
  String gender = 'Male'; // Default to Male
  int age = 0;
  String description = '';
}

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});
  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedType = 'Cat';
  String _selectedGender = 'Male';

  File? _selectedImage;

  Future _getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Pet'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MenuFrameCenter()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _getImage,
                child: _selectedImage == null
                    ? Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[200],
                        child: Icon(Icons.add_a_photo,
                            size: 50, color: Colors.grey[400]),
                      )
                    : Image.file(_selectedImage!,
                        width: double.infinity, height: 200, fit: BoxFit.cover),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Pet Name'),
              ),
              TextField(
                controller: _breedController,
                decoration: InputDecoration(labelText: 'Breed'),
              ),
              Row(
                children: [
                  Text('Type:'),
                  Radio(
                    value: 'Cat',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value.toString();
                      });
                    },
                  ),
                  Text('Cat'),
                  Radio(
                    value: 'Dog',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value.toString();
                      });
                    },
                  ),
                  Text('Dog'),
                ],
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text('Gender:'),
                  Radio(
                    value: 'Male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value.toString();
                      });
                    },
                  ),
                  Text('Male'),
                  Radio(
                    value: 'Female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value.toString();
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tell us about your pet',
                    helperText: 'Keep it short, this is just demo',
                    labelText: 'About Pet'),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle cancel button press
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 241, 189,
                          186), // Specify background color for the cancel button
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Create a new Pet object with the entered information
                      Pet newPet = Pet()
                        ..name = _nameController.text
                        ..breed = _breedController.text
                        ..type = _selectedType
                        ..image = _selectedImage
                        ..address = _addressController.text
                        ..gender = _selectedGender
                        ..age = int.tryParse(_ageController.text) ?? 0
                        ..description = _descriptionController.text;

                      // Print or use the newPet object as needed
                      print(
                          'New Pet Added: ${newPet.name}, ${newPet.type}, ${newPet.breed}, ${newPet.address}, ${newPet.gender}, ${newPet.age}, ${newPet.description}');
                    },
                    child: Text('Add Pet'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wsmb_day1_try6_jam/models/driver.dart';
import 'package:wsmb_day1_try6_jam/serevice/firestoreService.dart';
import 'package:wsmb_day1_try6_jam/widgets/buildBottomSheet.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.driver});
  final Driver driver;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final icnoController = TextEditingController();
  String gender = 'male';
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  File? photo;

  void genderChanged(String? value) {
    setState(() {
      gender = value!;
    });
  }

  void submitForm() async {
    if (photo != null) {
      widget.driver.photo = await Driver.saveImage(photo!);
    }
    if (formkey.currentState!.validate()) {
      Driver d = Driver(
          name: nameController.text,
          icno: widget.driver.icno,
          gender: gender == 'male',
          phone: widget.driver.phone,
          email: widget.driver.email,
          address: addressController.text,
          photo: widget.driver.photo);

      var res = await FirestoreService.updateDriver(d, widget.driver.id!);

      if (res) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Your profile is edited successfully'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'))
                  ],
                ));
        Navigator.of(context).pop();
      } else {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Warning'),
                  content: Text('Something went wrong'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'))
                  ],
                ));
      }
    }
  }

  Future<void> takePhoto(BuildContext context) async {
    ImageSource? source = await showModalBottomSheet(
        context: context, builder: (context) => buildBottomSheet(context));

    if (source == null) {
      return;
    }

    ImagePicker picker = ImagePicker();
    var file = await picker.pickImage(source: source);
    if (file == null) {
      return;
    }

    photo = File(file.path);
    setState(() {});
  }

  Widget displayImage() {
    if (photo != null) {
      return Image.file(
        photo!,
        fit: BoxFit.cover,
        height: 100,
        width: double.infinity,
      );
    } else if (widget.driver.photo != null && widget.driver.photo!.isNotEmpty) {
      return Image.network(
        widget.driver.photo!,
        fit: BoxFit.cover,
        height: 100,
        width: double.infinity,
      );
    } else {
      return Container(
        height: 100,
        width: double.infinity,
        color: Colors.grey[300],
        child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.driver.name;
    icnoController.text = widget.driver.icno;
    phoneController.text = widget.driver.phone;
    emailController.text = widget.driver.email;
    addressController.text = widget.driver.address;
    gender = widget.driver.gender ? 'male' : 'female';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Text(
                      'Driver Information',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                        controller: nameController,
                        decoration:
                            InputDecoration(label: Center(child: Text('Name'))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        }),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: icnoController,
                      readOnly: true,
                      enabled: true,
                      decoration: InputDecoration(
                        label: Center(child: Text('IC No')),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Gender:'),
                        Radio(
                            value: 'male',
                            groupValue: gender,
                            onChanged: genderChanged),
                        Text('Male'),
                        Radio(
                            value: 'female',
                            groupValue: gender,
                            onChanged: genderChanged),
                        Text('Female'),
                      ],
                    ),
                    TextFormField(
                      controller: phoneController,
                      readOnly: true,
                      enabled: false,
                      decoration: InputDecoration(
                        label: Center(child: Text('Phone')),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      readOnly: true,
                      enabled: false,
                      decoration: InputDecoration(
                        label: Center(child: Text('Email')),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                            label: Center(child: Text('Address'))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your address";
                          }
                          return null;
                        }),
                    SizedBox(height: 16),
                    OutlinedButton(
                        onPressed: () {
                          takePhoto(context);
                        },
                        child: Container(
                            width: double.infinity,
                            child: Center(child: Text('Change Photo')))),
                    SizedBox(height: 8),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: displayImage(),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: submitForm,
                      child: Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

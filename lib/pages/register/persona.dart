import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wsmb_day1_try6_jam/models/driver.dart';
import 'package:wsmb_day1_try6_jam/pages/register/accountVerification.dart';
import 'package:wsmb_day1_try6_jam/widgets/buildBottomSheet.dart';

class PersonaPage extends StatefulWidget {
  const PersonaPage({super.key});

  @override
  State<PersonaPage> createState() => _PersonaPageState();
}

class _PersonaPageState extends State<PersonaPage> {
  final nameController = TextEditingController();
  final icnoController = TextEditingController();
  String gender = 'male';
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  File? photo;

  void genderChanged(String? value) {
    setState(() {
      gender = value!;
    });
  }

  void submitForm() async {
    if (photo == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Warning'),
                content: Text('Please upload your image first'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'))
                ],
              ));
    }
    if (formkey.currentState!.validate()) {
      Driver tempDriver = Driver(
          name: nameController.text,
          icno: icnoController.text,
          gender: gender == 'male',
          phone: phoneController.text,
          email: emailController.text,
          address: addressController.text);

      var driver =
          await Driver.register(tempDriver, passwordController.text, photo!);

      if (driver == null) {
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
                        child: Text('Ok'))
                  ],
                ));
        return;
      } else {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('You have to verify your account'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AccountVerificationPage()));
                        },
                        child: Text('Ok'))
                  ],
                ));
        Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Register - Personal Information',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                  key: formkey,
                  child: Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Driver Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                                label: Center(child: Text('Name'))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please key in your name";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                            controller: icnoController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                label: Center(child: Text('IC No'))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please key in your ic number";
                              } else if (value.length != 12 ||
                                  int.tryParse(value) == null) {
                                return 'Please enter a valid ic number';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Gender :'),
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
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                label: Center(child: Text('Phone'))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please key in your phone number";
                              } else if (int.tryParse(value) == null) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                                label: Center(child: Text('Email'))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please key in your email address";
                              } else if (!value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                            controller: addressController,
                            decoration: InputDecoration(
                                label: Center(child: Text('Address'))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please key in your address";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                label: Center(child: Text('Password'))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please key in your password";
                              } else if (value.length < 6) {
                                return 'Please enter a strong password';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        OutlinedButton(
                            onPressed: () {
                              takePhoto(context);
                            },
                            child: Container(
                                width: double.infinity,
                                child: Center(child: Text('Photo')))),
                        Container(
                          height: 100,
                          width: double.infinity,
                          child: (photo != null)
                              ? Image.file(
                                  photo!,
                                  fit: BoxFit.fitHeight,
                                )
                              : Container(),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {
                              submitForm();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Next >>',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          )),
    );
  }
}

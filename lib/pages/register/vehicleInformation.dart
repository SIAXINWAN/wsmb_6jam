import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wsmb_day1_try6_jam/models/vehicle.dart';
import 'package:wsmb_day1_try6_jam/pages/LoginPage.dart';
import 'package:wsmb_day1_try6_jam/pages/ride/ridePage.dart';
import 'package:wsmb_day1_try6_jam/widgets/buildBottomSheet.dart';

class VehicleInformationPage extends StatefulWidget {
  const VehicleInformationPage({super.key});

  @override
  State<VehicleInformationPage> createState() => _VehicleInformationPageState();
}

class _VehicleInformationPageState extends State<VehicleInformationPage> {
  final modelController = TextEditingController();
  final capacityController = TextEditingController();
  final featureController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  File? image;

  void submitForm() async {
    if (formkey.currentState!.validate()) {
      var res = await Vehicle.registerVehicle(modelController.text,
          int.parse(capacityController.text), featureController.text, image);
      if (res) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Your vehicle is submit succefully'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginPage()));
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

    image = File(file.path);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    featureController.text = 'None';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: const Color.fromARGB(255, 230, 222, 150),
        title: Text(
          'Register - Vehicle Information',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Expanded(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Vehicle Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: modelController,
                          decoration: InputDecoration(
                              label: Center(child: Text('Car model'))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the car model';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: capacityController,
                          decoration: InputDecoration(
                              label: Center(child: Text('Capacity'))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the capacity';
                            } else if (int.tryParse(value) == null) {
                              return 'Please enter a valid capacity';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: featureController,
                          decoration: InputDecoration(
                              label: Center(child: Text('Special feature'))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the special feature';
                            }
                            return null;
                          },
                        ),
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: (image != null)
                              ? Image.file(image!)
                              : Container(),
                        ),
                        OutlinedButton(
                            onPressed: () {
                              takePhoto(context);
                            },
                            child: Container(
                                width: double.infinity,
                                child: Center(child: Text('Photo')))),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                '<<Previous',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue),
                              ),
                            ),
                            TextButton(
                              onPressed: submitForm,
                              child: Text(
                                'Submit>>',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

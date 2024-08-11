import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wsmb_day1_try6_jam/models/vehicle.dart';
import 'package:wsmb_day1_try6_jam/serevice/firestoreService.dart';
import 'package:wsmb_day1_try6_jam/widgets/buildBottomSheet.dart';

class EditVehiclePage extends StatefulWidget {
  const EditVehiclePage({super.key, required this.vehicle});
  final Vehicle vehicle;

  @override
  State<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  final modelController = TextEditingController();
  final capacityController = TextEditingController();
  final featureController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? image;

  void submitForm() async {
    if (image != null) {
      widget.vehicle.image = await Vehicle.saveImage(image!);
    }

    if (formKey.currentState!.validate()) {
      Vehicle v = Vehicle(
          car_model: modelController.text,
          capacity: int.parse(capacityController.text),
          driver_id: widget.vehicle.driver_id,
          special_feature: featureController.text,
          image: widget.vehicle.image);

      var res = await FirestoreService.updateVehicle(v, widget.vehicle.id!);
      if (res) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Your vehicle is edit successfully'),
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

    image = File(file.path);
    setState(() {});
  }

  Widget displayImage() {
    if (image != null) {
      return Image.file(
        image!,
        fit: BoxFit.cover,
        height: 100,
        width: double.infinity,
      );
    } else if (widget.vehicle.image != null &&
        widget.vehicle.image!.isNotEmpty) {
      return Image.network(
        widget.vehicle.image!,
        fit: BoxFit.cover,
        height: 100,
        width: double.infinity,
      );
    } else {
      return Container(
        height: 100,
        width: double.infinity,
        color: Colors.grey[300],
        child: Icon(
          Icons.person,
          size: 50,
          color: Colors.grey[600],
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    featureController.text = widget.vehicle.special_feature;
    modelController.text = widget.vehicle.car_model;
    capacityController.text = widget.vehicle.capacity.toString();
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
                    key: formKey,
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
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          width: double.infinity,
                          child: displayImage(),
                        ),
                        SizedBox(height: 36),
                        ElevatedButton(
                          onPressed: submitForm,
                          child: Text(
                            'Update Vehicle',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
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

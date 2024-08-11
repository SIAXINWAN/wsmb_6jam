import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wsmb_day1_try6_jam/models/ride.dart';
import 'package:wsmb_day1_try6_jam/serevice/firestoreService.dart';

class CreateRidePage extends StatefulWidget {
  const CreateRidePage({super.key});

  @override
  State<CreateRidePage> createState() => _CreateRidePageState();
}

class _CreateRidePageState extends State<CreateRidePage> {
  final originController = TextEditingController();
  final destController = TextEditingController();
  final fareController = TextEditingController();
  final riderController = TextEditingController();
  final carCapacityController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();
  List<String> riders = [];

  void submitForm() async {
    if (dateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid Date')));
      return;
    }
    if (formKey.currentState!.validate()) {
      Ride ride = Ride(
        date: dateTime,
        origin: originController.text,
        destination: destController.text,
        fare: double.parse(fareController.text),
        riders: riders,
      );

      var res = await Ride.registerRide(
        dateTime,
        double.parse(fareController.text),
        originController.text,
        destController.text,
        riders,
      );
      if (res) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Your ride is added successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
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
                child: Text('OK'),
              )
            ],
          ),
        );
      }
    }
  }

  void takeDateTime() async {
    var tempDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (tempDate == null) {
      return;
    }
    dateTime = tempDate;

    var tempTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: DateTime.now().hour,
        minute: DateTime.now().minute,
      ),
    );
    if (tempTime == null) {
      return;
    }

    dateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      tempTime.hour,
      tempTime.minute,
    );

    if (dateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid Date')));
      return;
    }
    setState(() {});
  }

  void addRider() {
    if (riderController.text.isNotEmpty) {
      int capacity = int.tryParse(carCapacityController.text) ?? 0;
      if (riders.length < capacity) {
        setState(() {
          riders.add(riderController.text);
          riderController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Car capacity reached')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: const Color.fromARGB(255, 230, 172, 240),
        title: Text('Add Ride',
            style: TextStyle(fontSize: 18, color: Colors.black87)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    'Ride Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: originController,
                    decoration: InputDecoration(
                      label: Center(child: Text('Origin')),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please key in the origin";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: destController,
                    decoration: InputDecoration(
                      label: Center(child: Text('Destination')),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please key in the destination";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: fareController,
                    decoration: InputDecoration(
                      label: Center(child: Text('Fare')),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please key in the fare';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid fare';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: carCapacityController,
                    decoration: InputDecoration(
                      label: Center(child: Text('Car Capacity')),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please key in the car capacity';
                      } else if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Choose the DateTime',
                    style: TextStyle(fontSize: 16),
                  ),
                  OutlinedButton(
                    onPressed: takeDateTime,
                    child: Text(
                      'Click me',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Depart Time: ' +
                        dateTime.toString().replaceRange(16, null, ''),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Riders',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: riderController,
                          decoration: InputDecoration(
                            label: Text('Rider Name'),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: addRider,
                        child: Text('Add Rider'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Current Riders: ${riders.join(", ")}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: submitForm,
                    child: Text('Add'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
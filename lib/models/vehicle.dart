import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsmb_day1_try6_jam/serevice/firestoreService.dart';

class Vehicle {
  final String car_model;
  final int capacity;
  String? driver_id;
  final String special_feature;
  String? image;
  String? id;

  Vehicle(
      {this.image,
      this.id,
      required this.car_model,
      required this.capacity,
      this.driver_id,
      required this.special_feature});

  static Future<bool> registerVehicle(
      String model, int capacity, String feature, File? image) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    if (token == null) {
      return false;
    }
    String imageLink = '';
    if (image != null) {
      String fileName = 'vehicle/${DateTime.now().microsecondsSinceEpoch}.jpg';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref(fileName).putFile(image!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      imageLink = downloadURL;
    }

    Vehicle vehicle = Vehicle(
        car_model: model,
        capacity: capacity,
        driver_id: token,
        special_feature: feature,
        image: imageLink);

    var res = await FirestoreService.addVehicle(vehicle);
    return res;
  }

  static Future<String> saveImage(File image) async {
    String fileName = 'vehicle/${DateTime.now().millisecondsSinceEpoch}.jpg';
    UploadTask uploadTask =
        FirebaseStorage.instance.ref(fileName).putFile(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  // static Future<Vehicle> getCurrentUserVehicle(String userId) async {

    
    
  //   DocumentSnapshot doc = await FirebaseFirestore.instance
  //       .collection('vehicles')
  //       .doc(userId)
  //       .get();

  //   if (doc.exists) {
  //     return Vehicle(
        
  //       capacity: doc.get('capacity'),
  //       // other properties...
  //     );
  //   } else {
  //     throw Exception('Vehicle not found for current user');
  //   }
  // }
  

  factory Vehicle.fromJson(Map<String, dynamic> json, String vid) {
    return Vehicle(
        id: vid,
        car_model: json['car_model'] ?? '',
        capacity: (json['capacity'] ?? 0) as int,
        driver_id: json['driver_id'] ?? '',
        special_feature: json['special_feature'] ?? 'None',
        image: json['image'] ?? '');
  }

  toJson() {
    return {
      'id': id,
      'car_model': car_model,
      'capacity': capacity,
      'driver_id': driver_id,
      'special_feature': special_feature,
      'image': image,
    };
  }
}

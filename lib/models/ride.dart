import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsmb_day1_try6_jam/serevice/firestoreService.dart';

class Ride {
  final DateTime date;
  final String origin;
  final String destination;
  final double fare;
  String? id;
  String? driver_id;
  List<String> riders;
  List<DocumentReference> vehicle;

  Ride(
      {this.id,
      this.driver_id,
      required this.date,
      required this.origin,
      required this.destination,
      required this.fare,
      List<String>? riders,
      List<DocumentReference>?vehicle})
      : riders = riders ?? [],
      vehicle = vehicle?? [];

  static Future<bool> registerRide(
      DateTime masa, double duit, String tempat, String sampai,List<String> orang) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    if (token == null) {
      return false;
    }
    Ride ride = Ride(
        driver_id: token,
        date: masa,
        origin: tempat,
        destination: sampai,
        fare: duit,
        riders:orang );

    var res = await FirestoreService.addRide(ride);
    return res;
  }

  factory Ride.fromJson(Map<String, dynamic> json, rid) {
    return Ride(
        id: rid,
        driver_id: json['driver_id'] ?? '',
        date: DateTime.parse(json['date']),
        origin: json['origin'] ?? '',
        destination: json['destination'] ?? '',
        riders: (json['riders'] as List<dynamic>?)
                ?.map((x) => x.toString())
                .toList() ??
            [],
            vehicle:(json['vehicle']as List<dynamic>?)?.map((x) => x as DocumentReference).toList() ?? [],
        fare: json['fare'] as double);
  }

  toJson() {
    return {
      'id': id,
      'driver_id': driver_id,
      'date': date.toString(),
      'origin': origin,
      'destination': destination,
      'fare': fare,
      'riders': riders,
      'vehicle':vehicle
    };
  }
}

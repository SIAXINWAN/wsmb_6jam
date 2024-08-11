import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wsmb_day1_try6_jam/models/driver.dart';
import 'package:wsmb_day1_try6_jam/models/ride.dart';
import 'package:wsmb_day1_try6_jam/models/vehicle.dart';
import 'package:wsmb_day1_try6_jam/pages/ride/createRidePage.dart';
import 'package:wsmb_day1_try6_jam/serevice/firestoreService.dart';
import 'package:wsmb_day1_try6_jam/widgets/rideCard.dart';

class RidePage extends StatefulWidget {
  const RidePage({super.key});

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  List<Ride> list = [];
  String keyword = '';
  final SearchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRideList();
  }

  void getRideList() async {
    var token = await Driver.getToken();
    list = await FirestoreService.getRide(token);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var filterList = list
        .where((e) =>
            e.origin.toLowerCase().contains(keyword.toLowerCase()) ||
            e.destination.toLowerCase().contains(keyword.toLowerCase()) ||
            e.date.toString().toLowerCase().contains(keyword.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
        backgroundColor: Color.fromARGB(255, 248, 216, 168),
        title: Text('Kongsi Kereta',
            style: TextStyle(fontSize: 18, color: Colors.black87)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    style: TextStyle(),
                    controller: SearchController,
                    decoration: InputDecoration(
                      label: Center(child: Text('Search Ride')),
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        keyword = value.trim();
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateRidePage()));
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filterList.length,
              itemBuilder: (context, index) {
                return RideCard(ride: filterList[index], func: getRideList);
              },
            ),
          ),
        ],
      ),
    );
  }
}

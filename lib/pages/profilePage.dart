import 'package:flutter/material.dart';
import 'package:wsmb_day1_try6_jam/models/driver.dart';
import 'package:wsmb_day1_try6_jam/models/vehicle.dart';
import 'package:wsmb_day1_try6_jam/pages/LoginPage.dart';
import 'package:wsmb_day1_try6_jam/serevice/firestoreService.dart';
import 'package:wsmb_day1_try6_jam/widgets/driverCard.dart';
import 'package:wsmb_day1_try6_jam/widgets/vehicleCard.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Vehicle? _vehicle;
  Driver? _driver;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDriverData();
    getVehicleList();
  }

  void getDriverData() async {
    try {
      var token = await Driver.getToken();
      Driver driver = await FirestoreService.getDriver(token);
      setState(() {
        _driver = driver;
      });
    } catch (e) {
      return;
    }
  }

  void getVehicleList() async {
    try {
      var token = await Driver.getToken();
      _vehicle = await FirestoreService.getVehicle(token);
      setState(() {});
    } catch (e) {
      return;
    }
  }

  Future<void> Logout() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Log Out'),
              content: Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('No')),
                TextButton(
                    onPressed: () async {
                      await Driver.signOut();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                      ;
                    },
                    child: Text('Yes')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
        backgroundColor: const Color.fromARGB(255, 248, 216, 168),
        title: const Text('Kongsi Kereta',
            style: TextStyle(fontSize: 18, color: Colors.black87)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_driver != null) DriverCard(driver: _driver!),
          SizedBox(height: 20),
          if (_vehicle != null) Vehiclecard(vehicle: _vehicle!),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3))),
                    onPressed: Logout,
                    child: Text('Log Out'))),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wsmb_day1_try6_jam/models/vehicle.dart';
import 'package:wsmb_day1_try6_jam/pages/edit/editVehicle.dart';

class Vehiclecard extends StatefulWidget {
  const Vehiclecard({super.key, required this.vehicle});
  final Vehicle vehicle;

  @override
  State<Vehiclecard> createState() => _VehiclecardState();
}

class _VehiclecardState extends State<Vehiclecard> {
  @override
  Widget build(BuildContext context) {
    var imageLink = widget.vehicle.image == '' ? null : widget.vehicle.image;
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(4),
        child: Column(
          children: [
            Center(
              child: Text(
                'Vehicle',
                style: TextStyle(
                    fontSize: 24, decoration: TextDecoration.underline),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Car Model: ${widget.vehicle.car_model}'),
                      Text('Capacity: ${(widget.vehicle.capacity)}'),
                      Text(
                          'Spacial Features: ${widget.vehicle.special_feature}'),
                    ],
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.25,
                    child: Image.network(
                      imageLink ??
                          'https://firebasestorage.googleapis.com/v0/b/wsmb-try1.appspot.com/o/vehicle%2F1721706260095.jpg?alt=media&token=9b331ad6-2781-4ecc-9c04-be4884005184',
                      fit: BoxFit.fill,
                    ),
                  )
                ]),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditVehiclePage(
                            vehicle: widget.vehicle,
                          )));
                },
                child: Text('Edit')),
          ],
        ));
  }
}

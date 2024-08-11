import 'package:flutter/material.dart';
import 'package:wsmb_day1_try6_jam/models/ride.dart';
import 'package:wsmb_day1_try6_jam/pages/ride/rideDetailsPage.dart';
import 'package:wsmb_day1_try6_jam/serevice/firestoreService.dart';

class RideCard extends StatefulWidget {
  const RideCard({super.key, required this.ride, required this.func});
  final Ride ride;
  final Function func;

  @override
  State<RideCard> createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Origin: ${widget.ride.origin}'),
              Text('Destination: ${widget.ride.destination}'),
              Text('Fare: RM ${widget.ride.fare}'),
              Text('Date Time: ${widget.ride.date}')
            ],
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RideDetailsPage(
                              numberOfRiders: 7,
                              ride: widget.ride,
                            )));
                  },
                  child: Text('Detail')),
              MaterialButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Warning'),
                            content: Text('Are you want to cancel?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('No')),
                              MaterialButton(
                                  onPressed: () async {
                                    await FirestoreService.deleteRide(
                                        widget.ride.id ?? '');
                                  },
                                  child: Text('Yes')),
                            ],
                          ));
                },
                child: Text('Cancel'),
              )
            ],
          )
        ],
      ),
    );
  }
}

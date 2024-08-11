import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wsmb_day1_try6_jam/models/ride.dart';
import 'package:wsmb_day1_try6_jam/models/vehicle.dart';

class RideDetailsPage extends StatefulWidget {
  const RideDetailsPage(
      {super.key, required this.numberOfRiders, required this.ride});
  final int numberOfRiders;
  final Ride ride;

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  late List<Offset> riderPositions;
  double centerX = 200;
  double centerY = 200;
  final double radius = 150;
  bool isEnd = true;
  bool loadAgain = true;

  @override
  void initState() {
    super.initState();
  }

  void _initializeRiderPositions() {
    riderPositions = List.generate(widget.numberOfRiders, (index) {
      double angle = 2 * pi * index / widget.numberOfRiders;
      return Offset(
        centerX + radius * cos(angle),
        centerY + radius * sin(angle),
      );
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    centerX = MediaQuery.of(context).size.width / 2;
    centerY = MediaQuery.of(context).size.height / 2 - 50;
    if (loadAgain) {
      loadAgain = false;
      _initializeRiderPositions();
    }

    setState(() {});
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor: Color.fromARGB(255, 213, 238, 163),
        title: Text('Register Detail',
            style: TextStyle(fontSize: 18, color: Colors.black87)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter:
                  ConnectionsPainter(riderPositions, centerX, centerY, isEnd),
            ),
            Positioned(
              left: centerX - 60,
              top: centerY - 60,
              child: GestureDetector(
                onTap: () {
                  _initializeRiderPositions();
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
                      child: Column(
                    children: [
                      Text('Ride', style: TextStyle(color: Colors.white)),
                      Text(
                        'Origin: ${widget.ride.origin}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text('Destination : ${widget.ride.destination}',
                          style: TextStyle(color: Colors.white)),
                      Text('Date Time : ${widget.ride.date}',
                          style: TextStyle(color: Colors.white)),
                    ],
                  )),
                ),
              ),
            ),
            ...List.generate(widget.numberOfRiders, (index) {
              return Positioned(
                left: riderPositions[index].dx - 40,
                top: riderPositions[index].dy - 40,
                child: Draggable(
                  feedback: RiderNode(index: index),
                  childWhenDragging: Container(),
                  onDragStarted: () {
                    print(riderPositions[0]);
                    setState(() {
                      isEnd = false;
                    });
                  },
                  onDragEnd: (details) {
                    setState(() {
                      isEnd = true;

                      Offset offset = Offset(
                          details.offset.dx + 40, details.offset.dy + 40);

                      riderPositions[index] = offset;
                    });
                  },
                  child: RiderNode(index: index),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class RiderNode extends StatefulWidget {
  final int index;
  const RiderNode({super.key, required this.index});

  @override
  State<RiderNode> createState() => _RiderNodeState();
}

class _RiderNodeState extends State<RiderNode>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('R${widget.index + 1}',
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }
}

class ConnectionsPainter extends CustomPainter {
  final List<Offset> riderPositions;
  final double centerX;
  final double centerY;
  final bool isEnd;

  ConnectionsPainter(
      this.riderPositions, this.centerX, this.centerY, this.isEnd);

  @override
  void paint(Canvas canvas, Size size) {
    if (!isEnd) {
      return;
    }
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 4;

    for (final position in riderPositions) {
      canvas.drawLine(Offset(centerX, centerY), position, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

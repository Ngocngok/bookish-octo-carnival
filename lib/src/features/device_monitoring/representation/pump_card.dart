import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PumpCard extends StatefulWidget {
  const PumpCard(this.deviceID, {super.key});

  final String deviceID;
  @override
  State<PumpCard> createState() => _PumpCardState();
}

class _PumpCardState extends State<PumpCard> {
  bool isOn = false;
  StreamSubscription<DatabaseEvent>? stream;
  late DatabaseReference starCountRef;

  @override
  void initState() {
    debugPrint("devices/${widget.deviceID}/pump");
    starCountRef = FirebaseDatabase.instance
        .ref()
        .child("devices/${widget.deviceID}/pump");

    stream = starCountRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        final data = event.snapshot.value;
        debugPrint(".");
        debugPrint("." + data.toString());
      });
    }, onError: (err) {
      debugPrint("error");
    }, onDone: (() {
      debugPrint("on done");
    }));

    debugPrint("devices/${widget.deviceID}/pump");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    stream?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.water_damage_outlined,
              ),
              Text("Pump"),
              FutureBuilder(builder: ((context, snapshot) {
                return GestureDetector(
                  onTap: () async {
                    debugPrint("vv");
                    final snapshot = await starCountRef.get().onError(
                      (error, stackTrace) {
                        debugPrint(error.toString());
                        throw Exception(error);
                      },
                    ).whenComplete(() => debugPrint("tada"));
                    debugPrint("v");

                    if (snapshot.exists) {
                      debugPrint("a");
                    } else {
                      debugPrint("b");
                    }
                  },
                  child: Icon(Icons.abc),
                );
              }))

              //Swi
            ],
          ),
        ],
      ),
    );
  }
}

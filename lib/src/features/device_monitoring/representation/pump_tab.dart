import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ControlTab extends StatefulWidget {
  @override
  State<ControlTab> createState() => _ControlTabState();

  const ControlTab(this.deviceID, {super.key});

  final String deviceID;
}

class _ControlTabState extends State<ControlTab> {
  StreamSubscription<DatabaseEvent>? pumpStatusStream;
  StreamSubscription<DatabaseEvent>? lastActiveTimeStream;
  late DatabaseReference pumpStatusRef;
  late TextEditingController pickDurationTextController;

  bool pickDurationTextValidation = false;

  bool pumpStatus = false;
  bool isPumpInfoTabExpanded = false;
  bool isPumpSettingTabExpanded = false;
  bool isAutoWateringOn = false;
  bool isWateringDurationSet = false;
  TimeOfDay scheduledTime = TimeOfDay.now();
  int wateringDuration = 120;
  DateTime lastActiveTime = DateTime.now();

  @override
  void initState() {
    pickDurationTextController = TextEditingController();
    pumpStatusRef =
        FirebaseDatabase.instance.ref("devices/${widget.deviceID}/pump");

    pumpStatusStream =
        pumpStatusRef.child('status').onValue.listen((DatabaseEvent event) {
      setState(() {
        final data = event.snapshot.value;
        pumpStatus = data.toString().toLowerCase() == 'true';
        debugPrint("." + data.toString() + " " + pumpStatus.toString());
      });
    });

    lastActiveTimeStream =
        pumpStatusRef.child('lastUpTime').onValue.listen((DatabaseEvent event) {
      setState(() {
        final data = event.snapshot.value;
        lastActiveTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(data.toString()) * 1000);
        debugPrint("." + data.toString() + " " + pumpStatus.toString());
      });
    });

    //get auto watering status
    // pumpStatusRef
    //     .child('setAutoWatering')
    //     .once(DatabaseEventType.value)
    //     .then((event) {
    //   setState(() {
    //     isAutoWateringOn = !event.snapshot.exists
    //         ? false
    //         : (event.snapshot.value?.toString().compareTo("true") == 0);
    //   });
    // });

    //get watering duration status
    // pumpStatusRef
    //     .child('setDuration')
    //     .once(DatabaseEventType.value)
    //     .then((event) {
    //   setState(() {
    //     isWateringDurationSet = !event.snapshot.exists
    //         ? false
    //         : (event.snapshot.value?.toString().compareTo("true") == 0);
    //   });
    // });

    //get auto watering time
    pumpStatusRef
        .child('autoWateringTime')
        .once(DatabaseEventType.value)
        .then((event) {
      setState(() {
        isAutoWateringOn = int.parse(event.snapshot.value.toString()) > 0;
        int time = int.parse(event.snapshot.value.toString());
        if (time > 0) {
          time = time > DateTime.now().timeZoneOffset.inSeconds
              ? time - DateTime.now().timeZoneOffset.inSeconds
              : 86400 + time - DateTime.now().timeZoneOffset.inSeconds;
        } else {
          scheduledTime = const TimeOfDay(hour: 18, minute: 0);
        }
      });
    });

    //get watering duration
    pumpStatusRef.child('duration').once(DatabaseEventType.value).then((event) {
      setState(() {
        isWateringDurationSet = int.parse(event.snapshot.value.toString()) > 0;
        wateringDuration = int.parse(event.snapshot.value.toString()) > 0
            ? int.parse(event.snapshot.value.toString())
            : 120;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pickDurationTextController.dispose();
    pumpStatusStream?.cancel();
    lastActiveTimeStream?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Water pump",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Power",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey),
                      ),
                      Switch(
                        value: pumpStatus,
                        onChanged: togglePumpButton,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        pumpStatus ? "On" : "Idle",
                        style: TextStyle(
                          color: pumpStatus ? Colors.green : Colors.grey,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Status",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      const Image(
                        image: AssetImage('assets/water_pump.png'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Last active time:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd – kk:mm').format(lastActiveTime),
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 149, 167, 143),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Schedule",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            pumpScheduleWidget(),
                            SizedBox(
                              height: 10,
                            ),
                            pumpActiveIntervalWidget()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 159, 176, 153),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pump information",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Power",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "60",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        " watt",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Flow rate",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "8",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        " l/min",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Max pressure",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "0.95",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        " Amp",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pumpActiveIntervalWidget() {
    if (!isWateringDurationSet) {
      return GestureDetector(
        onTap: () async {
          await pumpStatusRef.child('duration').set(120).then((_) {
            setState(() {
              isWateringDurationSet = true;
            });
          });
        },
        child: Row(
          children: [
            Icon(
              Icons.add_box,
              color: Colors.white60,
              size: 18,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Set active duration",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        const Text(
          "Watering duration",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          wateringDuration.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          "s",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        GestureDetector(
          onTap: () async {
            final duration = await pickDuration();
            if (duration == null) {
              return;
            }
            await pumpStatusRef.child('duration').set(duration);
            setState(() {
              wateringDuration = duration;
            });
          },
          child: Icon(
            Icons.mode_edit_outline_outlined,
            color: Colors.white60,
            size: 20,
          ),
        ),
        GestureDetector(
          onTap: () async {
            await pumpStatusRef.child('duration').set(-1);
            setState(() {
              isWateringDurationSet = false;
            });
          },
          child: Icon(
            Icons.delete_outline,
            color: Colors.white60,
            size: 20,
          ),
        )
      ],
    );
  }

  Widget pumpScheduleWidget() {
    if (!isAutoWateringOn) {
      return GestureDetector(
          onTap: () async {
            await pumpStatusRef
                .child('autoWateringTime')
                .set(scheduledTime.hour * 3600 + scheduledTime.minute * 60 >
                        DateTime.now().timeZoneOffset.inSeconds
                    ? scheduledTime.hour * 3600 +
                        scheduledTime.minute * 60 -
                        DateTime.now().timeZoneOffset.inSeconds
                    : 86400 +
                        scheduledTime.hour * 3600 +
                        scheduledTime.minute * 60 -
                        DateTime.now().timeZoneOffset.inSeconds)
                .then((_) {
              setState(() {
                isAutoWateringOn = true;
              });
            });
          },
          child: Row(
            children: [
              Icon(
                Icons.add_box,
                color: Colors.white60,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Automate watering",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ));
    }
    return Row(
      children: [
        Text(
          "Start on",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "${scheduledTime.hour.toString().padLeft(2, '0')}:${scheduledTime.minute.toString().padLeft(2, '0')}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        GestureDetector(
          onTap: () async {
            final time = await pickTime();
            if (time == null) return;
            await pumpStatusRef.child('autoWateringTime').set(
                time.hour * 3600 + time.minute * 60 >
                        DateTime.now().timeZoneOffset.inSeconds
                    ? time.hour * 3600 +
                        time.minute * 60 -
                        DateTime.now().timeZoneOffset.inSeconds
                    : 86400 +
                        time.hour * 3600 +
                        time.minute * 60 -
                        DateTime.now().timeZoneOffset.inSeconds);
            setState(() {
              scheduledTime = TimeOfDay(hour: time.hour, minute: time.minute);
            });
          },
          child: Icon(
            Icons.mode_edit_outline_outlined,
            color: Colors.white60,
            size: 20,
          ),
        ),
        GestureDetector(
          onTap: () async {
            await pumpStatusRef.child('autoWateringTime').set(-1).then((_) {
              setState(() {
                isAutoWateringOn = false;
              });
            });
          },
          child: Icon(
            Icons.delete_outline,
            color: Colors.white60,
            size: 20,
          ),
        )
      ],
    );
  }

  void togglePumpButton(bool toggle) {
    pumpStatusRef.child('status').set(toggle.toString()).whenComplete(() {
      setState(() {
        pumpStatus = toggle;
      });
      debugPrint("Toggle " + pumpStatus.toString());
    });
  }

  Future<TimeOfDay?> pickTime() {
    return showTimePicker(context: context, initialTime: scheduledTime);
  }

  Future<int?> pickDuration() {
    return showDialog<int?>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(
            'ENTER DURATION',
            style: TextStyle(fontSize: 12),
          ),
          content: TextField(
            controller: pickDurationTextController,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              hintText: "Eg: 120",
              hintStyle: TextStyle(color: Colors.grey),
              errorText:
                  pickDurationTextValidation ? 'Value Can\'t Be Empty' : null,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: Text("CANCEL")),
            TextButton(
                onPressed: () {
                  debugPrint(pickDurationTextController.text);
                  if (pickDurationTextController.text.isEmpty ||
                      int.parse(pickDurationTextController.text) < 10) {
                    setState(() {
                      pickDurationTextValidation = true;
                    });
                  } else {
                    pickDurationTextValidation = false;
                    final duration = int.parse(pickDurationTextController.text);
                    Navigator.of(context).pop(duration);
                  }
                },
                child: Text("OK")),
          ],
        );
      }),
    );
  }
}

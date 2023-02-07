import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  bool notificationStatus = false;
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

    FirebaseFirestore.instance
        .collection('devices')
        .doc(widget.deviceID)
        .get()
        .then((doc) => {
              if (!doc.exists ||
                  doc.data()!['token'] == null ||
                  doc.data()!['token'].toString().isEmpty)
                {
                  setState(
                    () {
                      notificationStatus = false;
                    },
                  )
                }
              else
                {
                  setState(
                    () {
                      notificationStatus = true;
                    },
                  )
                }
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
    // pumpStatusRef
    //     .child('autoWateringTime')
    //     .once(DatabaseEventType.value)
    //     .then((event) {
    //   setState(() {
    //     isAutoWateringOn = int.parse(event.snapshot.value.toString()) > 0;
    //     int time = int.parse(event.snapshot.value.toString());
    //     if (time > 0) {
    //       time = time + DateTime.now().timeZoneOffset.inSeconds < 86400
    //           ? time + DateTime.now().timeZoneOffset.inSeconds
    //           : -86400 + time + DateTime.now().timeZoneOffset.inSeconds;
    //       scheduledTime =
    //           TimeOfDay(hour: time ~/ 3600, minute: time % 3600 ~/ 60);
    //     } else {
    //       scheduledTime = const TimeOfDay(hour: 18, minute: 0);
    //     }
    //   });
    // });

    //get watering duration
    pumpStatusRef.child('duration').once(DatabaseEventType.value).then((event) {
      setState(() {
        isWateringDurationSet = int.parse(event.snapshot.value.toString()) > 0;
        wateringDuration = int.parse(event.snapshot.value.toString()) > 0
            ? int.parse(event.snapshot.value.toString())
            : 20;
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
    return Stack(
      children: [
        SizedBox(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Water pump",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
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
                            height: 20,
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
                            DateFormat('yyyy-MM-dd – kk:mm')
                                .format(lastActiveTime),
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          // border: Border.all(
                          //   color: Colors.teal,
                          //   width: 5,
                          // ),
                          color: Colors.green[50],
                        ),
                        child: SizedBox(
                          width: 180,
                          height: 140,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.notifications,
                                      size: 30,
                                      color: Colors.teal,
                                    ),
                                    Switch(
                                      value: notificationStatus,
                                      onChanged: toggleNotificationButton,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Notifications",
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  notificationStatus ? "On" : "Off",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: notificationStatus
                                        ? Colors.teal
                                        : Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          // border: Border.all(
                          //   color: Colors.teal,
                          //   width: 5,
                          // ),
                          color: Colors.green[50],
                        ),
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Water duration",
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "60",
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w300,
                                        color: notificationStatus
                                            ? Colors.teal
                                            : Colors.grey,
                                      ),
                                    ),
                                    Text(" s"),
                                    Icon(Icons.mode),
                                  ],
                                )
                              ],
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
        ),
        DraggableScrollableSheet(
          initialChildSize: .2,
          minChildSize: .2,
          maxChildSize: .5,
          snap: true,
          builder: (BuildContext context, myScrollController) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    child: ListView(
                      controller: myScrollController,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.amber,
                          ),
                          child: SizedBox(
                            height: 400,
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: SizedBox(
                            height: 400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        myScrollController.animateTo(
                          1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Icon(Icons.menu, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        backgroundColor: Colors.blue, // <-- Button color
                        foregroundColor: Colors.red, // <-- Splash color
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ],
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

  toggleNotificationButton(bool toggle) async {
    var docRef =
        FirebaseFirestore.instance.collection('devices').doc(widget.deviceID);
    if (!toggle) {
      // var doc = await docRef.get();
      // if (!doc.exists ||
      //     doc.data()!['token'] == null ||
      //     doc.data()!['token'].toString().isEmpty) {
      //   return;
      // }

      await docRef.update({"token": ""});
      setState(() {
        notificationStatus = toggle;
      });
      return;
    }

    String? token = await FirebaseMessaging.instance.getToken();
    docRef.update({"token": token}).then(
      (value) => setState(
        () {
          notificationStatus = toggle;
        },
      ),
    );
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

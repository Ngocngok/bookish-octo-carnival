import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indoor_plant_watering_app/src/features/device_monitoring/representation/device_monitoring_page.dart';

class DeviceItem extends StatefulWidget {
  const DeviceItem({
    Key? key,
    required this.index,
    required this.deviceID,
    required this.name,
  }) : super(key: key);

  final int index;
  final String deviceID;
  final String name;

  @override
  State<DeviceItem> createState() => _DeviceItemState();
}

Color getBackgroundColor(int index) {
  switch (index % 4) {
    case 0:
      return const Color.fromARGB(255, 111, 221, 199);
    case 1:
      return const Color.fromARGB(255, 148, 208, 229);
    case 2:
      return const Color.fromARGB(255, 164, 160, 230);
    case 3:
      return const Color.fromARGB(255, 248, 142, 90);
    default:
      return const Color.fromARGB(255, 148, 208, 229);
  }
}

class _DeviceItemState extends State<DeviceItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          DeviceMonitoringPage.routeName,
          arguments: DevicePageMonitoringArguments(
            widget.deviceID,
            widget.name,
          ),
        );
      },
      child: SizedBox(
        child: DecoratedBox(
            decoration: BoxDecoration(
              color: getBackgroundColor(widget.index),
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              widget.deviceID,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                          // IconButton(
                          //   iconSize: 30,
                          //   icon: const Icon(
                          //     Icons.more_vert_rounded,
                          //     color: Colors.white,
                          //   ),
                          //   onPressed: (() {
                          //     debugPrint('b');
                          //   }),
                          // ),
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert_outlined,
                              color: Colors.white,
                            ),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                              PopupMenuItem(
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Delete"),
                                  ],
                                ),
                                onTap: () {
                                  final docRef = FirebaseFirestore.instance
                                      .collection("devices")
                                      .doc(widget.deviceID);
                                  docRef.get().then(
                                    (DocumentSnapshot doc) {
                                      if (doc['owner'].toString().isNotEmpty) {
                                        doc.reference.update({
                                          'owner': "",
                                          'name': "",
                                          'token': "",
                                        });
                                      } else {}
                                    },
                                    onError: (e) => debugPrint(
                                        "Error getting document: $e"),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.home,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

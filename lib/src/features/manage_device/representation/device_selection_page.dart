import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:indoor_plant_watering_app/src/common_widgets/add_device_item_button.dart';
import 'package:indoor_plant_watering_app/src/common_widgets/add_device_item_popup.dart';
import 'package:indoor_plant_watering_app/src/common_widgets/custom_drawer.dart';
import 'package:indoor_plant_watering_app/src/common_widgets/device_item.dart';

import '../../../utils/hero_dialog_route.dart';

class DeviceSelectionPage extends StatefulWidget {
  const DeviceSelectionPage({super.key});

  static const String routeName = '/device_selection';

  @override
  State<DeviceSelectionPage> createState() => _DeviceSelectionPageState();
}

class _DeviceSelectionPageState extends State<DeviceSelectionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Stack(
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                height: size.width * .55,
                width: size.width * .5,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 252, 254, 1),
                  ),
                ),
              ),
              SizedBox(
                height: size.width * .55,
                width: size.width * .5,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(254, 250, 246, 1),
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            //content
            child: Container(
              margin: const EdgeInsets.only(top: 18, left: 35, right: 35),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          child: Icon(
                            Icons.menu_rounded,
                            color: Colors.grey[500],
                            size: 35,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.notifications_rounded,
                            color: Colors.grey[500],
                            size: 35,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                (user != null && user.displayName != null && user.displayName!.isNotEmpty) ? user.displayName! : "User",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 55,
                            height: 55,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                image: DecorationImage(
                                  image: AssetImage('assets/test.jpg'),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              //child: Icon(Icons.person),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: SizedBox(
                        width: size.width * .15,
                        height: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        height: (((size.width - 70) - 20) / 2 / .85) * 2 +
                            20, //funny calculation
                        child: DecoratedBox(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("devices")
                                  .where("owner", isEqualTo: user?.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.docs.isNotEmpty) {
                                  final List<DocumentSnapshot> devicesData =
                                      snapshot.data!.docs;
                                  return GridView.count(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: .85,
                                    children: [
                                      ...devicesData.map<Widget>(
                                        (data) {
                                          int index = devicesData.indexOf(data);
                                          return DeviceItem(
                                              index: index,
                                              deviceID: data.id,
                                              name: data['name']);
                                        },
                                      ).toList(),
                                      AddDeviceItem(user: user)
                                    ],

                                    //    [
                                    //   const DeviceItem(index: 0, deviceID: 'A'),
                                    //   const DeviceItem(index: 1, deviceID: 'AB'),
                                    //   const DeviceItem(index: 2, deviceID: 'AC'),
                                    //   const DeviceItem(index: 3, deviceID: 'AD'),

                                    // ],
                                  );
                                } else {
                                  return AddDeviceItem(user: user);
                                }
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            HeroDialogRoute(
              builder: (context) {
                return const AddDevicePopupCard();
              },
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

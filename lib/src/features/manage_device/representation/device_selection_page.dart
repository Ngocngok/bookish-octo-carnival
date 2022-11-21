import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:indoor_plant_watering_app/src/common_widgets/custom_drawer.dart';
import 'package:indoor_plant_watering_app/src/common_widgets/device_item.dart';

class DeviceSelectionPage extends StatefulWidget {
  const DeviceSelectionPage({super.key});

  @override
  State<DeviceSelectionPage> createState() => _DeviceSelectionPageState();
}

class _DeviceSelectionPageState extends State<DeviceSelectionPage> {
  int _count = 0;

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
                              ' ${user?.displayName}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
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
                        decoration: BoxDecoration(color: Colors.white),
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: .85,
                          children: [
                            DeviceItem(),
                            DeviceItem(),
                            DeviceItem(),
                            DeviceItem(),
                            GestureDetector(
                              onTap: () {
                                print(user?.displayName ?? user?.email);
                              },
                              child: SizedBox(
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: Colors.black12,
                                  strokeWidth: 5,
                                  borderPadding: const EdgeInsets.all(2.5),
                                  radius: const Radius.circular(25),
                                  dashPattern: const [
                                    16,
                                    6,
                                  ],
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: const Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Icon(
                                            Icons.add_circle_outline_rounded,
                                            color: Colors.black12,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: const Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            'Add new device',
                                            style: TextStyle(
                                                color: Colors.black12,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   child: DecoratedBox(
                            //     decoration: BoxDecoration(
                            //       color: Colors.black,
                            //       borderRadius: BorderRadius.all(
                            //         Radius.circular(15),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   child: DecoratedBox(
                            //     decoration: BoxDecoration(
                            //       color: Colors.black,
                            //       borderRadius: BorderRadius.all(
                            //         Radius.circular(15),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   child: DecoratedBox(
                            //     decoration: BoxDecoration(
                            //       color: Colors.black,
                            //       borderRadius: BorderRadius.all(
                            //         Radius.circular(15),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   child: DecoratedBox(
                            //     decoration: BoxDecoration(
                            //       color: Colors.black,
                            //       borderRadius: BorderRadius.all(
                            //         Radius.circular(15),
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _count++),
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

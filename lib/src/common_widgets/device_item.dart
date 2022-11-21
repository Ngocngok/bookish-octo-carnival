import 'package:flutter/material.dart';

class DeviceItem extends StatefulWidget {
  const DeviceItem({
    Key? key,
  }) : super(key: key);

  @override
  State<DeviceItem> createState() => _DeviceItemState();
}

class _DeviceItemState extends State<DeviceItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Open device');
      },
      child: SizedBox(
        child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(111, 221, 199, 1),
              borderRadius: BorderRadius.all(
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
                          const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              'Device',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                          IconButton(
                            iconSize: 30,
                            icon: const Icon(
                              Icons.more_vert_rounded,
                              color: Colors.white,
                            ),
                            onPressed: (() {
                              print('b');
                            }),
                          ),
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
                  const Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'ESP8266',
                        style: TextStyle(
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

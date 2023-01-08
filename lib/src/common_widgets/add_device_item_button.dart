import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:indoor_plant_watering_app/src/constants/constants.dart';

import '../utils/hero_dialog_route.dart';
import 'add_device_item_popup.dart';

class AddDeviceItem extends StatelessWidget {
  const AddDeviceItem({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) {
              return const AddDevicePopupCard();
            },
          ),
        );
      },
      child: Hero(
        tag: heroAddDevice,
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
              children: const [
                Expanded(
                  flex: 3,
                  child: Align(
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Add new device',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.black12,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

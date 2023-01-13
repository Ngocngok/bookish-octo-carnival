import 'package:flutter/material.dart';
import 'package:indoor_plant_watering_app/src/features/device_monitoring/representation/pump_card.dart';

class ControlTab extends StatefulWidget {
  @override
  State<ControlTab> createState() => _ControlTabState();

  const ControlTab(this.deviceID, {super.key});

  final String deviceID;
}

class _ControlTabState extends State<ControlTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SizedBox(
        child: Column(
          children: [
            PumpCard(widget.deviceID),
          ],
        ),
      ),
    );
  }
}

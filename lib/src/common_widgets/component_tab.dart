import 'package:flutter/material.dart';

class ComponentTab extends StatelessWidget {
  final IconData? icon;

  const ComponentTab({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 80,
      child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
          child: Icon(
            icon,
            color: Colors.grey[600],
          )),
    );
  }
}

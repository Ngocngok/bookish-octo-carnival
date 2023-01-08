import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:indoor_plant_watering_app/src/constants/constants.dart';

import '../utils/custom_rect_tween.dart';

class AddDevicePopupCard extends StatefulWidget {
  /// {@macro add_todo_popup_card}
  const AddDevicePopupCard({Key? key}) : super(key: key);

  @override
  State<AddDevicePopupCard> createState() => _AddDevicePopupCardState();
}

class _AddDevicePopupCardState extends State<AddDevicePopupCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final TextEditingController deviceIDController = TextEditingController();
    final TextEditingController deviceDisplayNameController =
        TextEditingController();

    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(32, 0, 32, keyboardHeight),
      child: Center(
        child: Hero(
          tag: heroAddDevice,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Colors.amber[50],
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Add new device",
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 0.2,
                      ),
                      TextFormField(
                        controller: deviceIDController,
                        decoration: const InputDecoration(
                          labelText: 'Device ID',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          floatingLabelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3.0)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 3.0),
                          ),
                          prefixIcon: Icon(
                            Icons.info_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        cursorColor: Colors.white,
                        maxLines: 1,
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return 'Please enter device id';
                          }
                          return null;
                        },
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 0.2,
                      ),
                      TextFormField(
                        controller: deviceDisplayNameController,
                        decoration: const InputDecoration(
                          labelText: 'Display name',
                          labelStyle: TextStyle(color: Colors.grey),
                          floatingLabelStyle: TextStyle(color: Colors.black),
                          //hintText: 'Device ID',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 3.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.black, width: 3.0),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return 'Please enter display name';
                          }
                          return null;
                        },
                        maxLines: 1,
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.2,
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final docRef = FirebaseFirestore.instance
                                .collection("devices")
                                .doc(deviceIDController.text);
                            docRef.get().then(
                              (DocumentSnapshot doc) {
                                if (doc['owner'].toString().isEmpty) {
                                  doc.reference.update({
                                    'owner':
                                        FirebaseAuth.instance.currentUser?.uid,
                                    'name': deviceDisplayNameController.text,
                                  });
                                } else {}
                              },
                              onError: (e) =>
                                  debugPrint("Error getting document: $e"),
                            );
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void tryAddNewDevice(String deviceID, String displayName) {}

import 'package:flutter/material.dart';
import 'package:indoor_plant_watering_app/src/features/device_monitoring/representation/humidity_tab.dart';
import 'package:indoor_plant_watering_app/src/features/device_monitoring/representation/moisture_tab.dart';
import 'package:indoor_plant_watering_app/src/features/device_monitoring/representation/pump_tab.dart';
import 'package:indoor_plant_watering_app/src/features/device_monitoring/representation/temperature_tab.dart';

import '../../../common_widgets/component_tab.dart';

class DeviceMonitoringPage extends StatefulWidget {
  const DeviceMonitoringPage({
    super.key,
  });

  static const String routeName = '/device_monitoring';

  @override
  State<DeviceMonitoringPage> createState() => _DeviceMonitoringPageState();
}

class _DeviceMonitoringPageState extends State<DeviceMonitoringPage>
    with SingleTickerProviderStateMixin {
  List<Widget> componentTab = const [
    // temperature tab
    ComponentTab(
      icon: Icons.thermostat_outlined,
    ),

    // humidity tab
    ComponentTab(
      icon: Icons.cloudy_snowing,
    ),

    // moisture tab
    ComponentTab(
      icon: Icons.water_drop,
    ),

    // pump tab
    ComponentTab(
      icon: Icons.settings,
    ),
  ];

  late TabController _tabController;
  int _tabIndex = 0;

  HeaderTheme? header;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: componentTab.length);

    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
        header = getHeaderTheme(_tabIndex);
      });
    });

    header = getHeaderTheme(0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as DevicePageMonitoringArguments;

    final deviceID = args.deviceID;
    final deviceName = args.deviceName;

    return DefaultTabController(
      length: componentTab.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   leading: Padding(
        //     padding: const EdgeInsets.only(left: 24.0),
        //     child: IconButton(
        //       icon: Icon(
        //         Icons.arrow_back_outlined,
        //         color: Colors.grey[800],
        //         size: 36,
        //       ),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: Navigator.of(context).pop,
                          child: Icon(
                            Icons.arrow_back_outlined,
                            size: 20,
                          )),
                    ),
                    Expanded(
                      flex: 6,
                      child: Center(
                        child: Text(
                          header?.header ?? "",
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),

              // tab bar
              TabBar(
                controller: _tabController,
                tabs: componentTab,
                isScrollable: false,
              ),

              // tab bar view
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // temperature page
                    TemperatureTab(deviceID),

                    // humidity page
                    HumidityTab(deviceID),

                    // moisture page
                    MoistureTab(deviceID),

                    // pump page
                    ControlTab(deviceID),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void GetHeaderForTab(int tabIndex) {}

HeaderTheme? getHeaderTheme(int tabIndex) {
  List<HeaderTheme> headerTheme = [
    HeaderTheme("Temperature", const Color.fromARGB(255, 228, 11, 11)),
    HeaderTheme("Humidity", const Color.fromARGB(226, 6, 226, 142)),
    HeaderTheme("Eart moisture", const Color.fromARGB(255, 107, 53, 2)),
    HeaderTheme("Pump", const Color.fromARGB(185, 209, 136, 197)),
  ];

  return headerTheme[
      tabIndex > headerTheme.length - 1 ? headerTheme.length - 1 : tabIndex];
}

class HeaderTheme {
  final String header;
  final Color backgroundColor;

  HeaderTheme(this.header, this.backgroundColor);
}

class DevicePageMonitoringArguments {
  final String deviceID;
  final String deviceName;

  DevicePageMonitoringArguments(this.deviceID, this.deviceName);
}

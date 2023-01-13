import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TemperatureTab extends StatefulWidget {
  const TemperatureTab(this.deviceID, {super.key});

  final String deviceID;
  @override
  State<TemperatureTab> createState() => _TemperatureTabState();
}

class _TemperatureTabState extends State<TemperatureTab> {
  _TemperatureTabState();
  List<_SplineAreaData>? _chartData = [
    _SplineAreaData(DateTime.fromMillisecondsSinceEpoch(1), 0)
  ];
  final List<_SplineAreaData> _topChartData = [
    _SplineAreaData(DateTime.fromMillisecondsSinceEpoch(1), 0)
  ];

  // Timer? _timer;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? listener;

  @override
  void initState() {
    var collection = FirebaseFirestore.instance
        .collection("devices")
        .doc(widget.deviceID)
        .collection("monitoring_data")
        .orderBy('timestamp', descending: true)
        .limit(10);

    listener = collection.snapshots().listen(
      (event) {
        setState(
          () {
            //check false value due to network error
            for (DocumentChange change in event.docChanges) {
              if (change.type == DocumentChangeType.added) {
                if (DateTime.fromMillisecondsSinceEpoch(
                        change.doc['timestamp'] * 1000)
                    .isAfter(DateTime.now())) {
                  change.doc.reference.delete().then(
                        (doc) => debugPrint("Document deleted"),
                        onError: (e) =>
                            debugPrint("Error updating document $e"),
                      );
                }
              }
            }
            _chartData = event.docs
                .map(
                  (doc) => _SplineAreaData(
                    DateTime.fromMillisecondsSinceEpoch(
                        doc['timestamp'] * 1000),
                    double.parse(
                      doc['temperature'].toString(),
                    ),
                  ),
                )
                .toList();

            _SplineAreaData tmp = _chartData!.first;
            for (var splineAreaData in _chartData!) {
              if (splineAreaData.temperature > tmp.temperature) {
                tmp = splineAreaData;
              }
            }

            _topChartData.clear();
            _topChartData.add(tmp);

            _meterValue = _chartData?.first.temperature ?? 0;
          },
        );
      },
    );
    super.initState();
  }

  double _meterValue = 35;
  final double _temperatureValue = 32.5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 40, 20, 0),
            child: Row(
              children: [
                Icon(
                  _meterValue > 30
                      ? Icons.sunny
                      : (_meterValue > 20 ? Icons.cloud : Icons.ac_unit),
                  size: 50,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "$_meterValue°C",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: SizedBox(
                      height: 360,
                      child: SfCartesianChart(
                        //legend: Legend(isVisible: true, opacity: 0.7),
                        // title: ChartTitle(text: 'Inflation rate'),

                        borderWidth: 0,
                        plotAreaBorderWidth: 0,
                        primaryXAxis: DateTimeAxis(
                            axisLine: AxisLine(width: 0),
                            majorTickLines: MajorTickLines(width: 0),
                            interval: 3,
                            majorGridLines: const MajorGridLines(width: 0),
                            labelStyle: TextStyle(
                              fontFamily: GoogleFonts.nunito().fontFamily,
                            ),
                            edgeLabelPlacement: EdgeLabelPlacement.shift),
                        primaryYAxis: NumericAxis(
                            // labelFormat: '{value}%',

                            labelsExtent: 0,
                            minimum: 0,
                            maximum: 40,
                            axisLine: const AxisLine(width: 0),
                            majorGridLines: const MajorGridLines(width: 0),
                            majorTickLines: const MajorTickLines(size: 0)),
                        series: _getSplieAreaSeries(),
                        tooltipBehavior: TooltipBehavior(enable: true),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: 400,
                  //width: 100,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          /// Linear gauge to display celsius scale.
                          SfLinearGauge(
                            minimum: 0,
                            maximum: 40,
                            interval: 5,
                            majorTickStyle: LinearTickStyle(length: 5),
                            minorTicksPerInterval: 0,
                            axisLabelStyle: TextStyle(
                              fontFamily: GoogleFonts.nunito().fontFamily,
                              color: Colors.black54,
                            ),
                            axisTrackExtent: 23,
                            axisTrackStyle: const LinearAxisTrackStyle(
                                thickness: 13,
                                color: Colors.white,
                                borderWidth: 2,
                                borderColor: Colors.grey,
                                edgeStyle: LinearEdgeStyle.bothCurve),
                            tickPosition: LinearElementPosition.inside,
                            labelPosition: LinearLabelPosition.inside,
                            orientation: LinearGaugeOrientation.vertical,
                            markerPointers: <LinearMarkerPointer>[
                              LinearWidgetPointer(
                                  markerAlignment: LinearMarkerAlignment.end,
                                  value: 50,
                                  enableAnimation: false,
                                  position: LinearElementPosition.inside,
                                  offset: 8,
                                  child: SizedBox(
                                    height: 30,
                                    child: Text(
                                      '°C',
                                      style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.nunito().fontFamily,
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  )),
                              const LinearShapePointer(
                                value: 0,
                                markerAlignment: LinearMarkerAlignment.start,
                                shapeType: LinearShapePointerType.circle,
                                borderWidth: 2,
                                borderColor: Colors.grey,
                                color: Colors.white,
                                position: LinearElementPosition.cross,
                                width: 26,
                                height: 26,
                              ),
                              const LinearShapePointer(
                                value: -20,
                                markerAlignment: LinearMarkerAlignment.start,
                                shapeType: LinearShapePointerType.circle,
                                borderWidth: 6,
                                borderColor: Colors.transparent,
                                color: Color.fromARGB(255, 255, 111, 33),
                                position: LinearElementPosition.cross,
                                width: 26,
                                height: 26,
                              ),
                              LinearWidgetPointer(
                                value: 0,
                                markerAlignment: LinearMarkerAlignment.start,
                                child: Container(
                                  width: 9,
                                  height: 3.4,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 1.7, color: Colors.white),
                                        right: BorderSide(
                                            width: 1.7, color: Colors.white),
                                      ),
                                      color: Color.fromARGB(255, 255, 111, 33)),
                                ),
                              ),
                              // LinearWidgetPointer(
                              //   value: _meterValue,
                              //   enableAnimation: false,
                              //   position: LinearElementPosition.outside,
                              //   onChanged: (dynamic value) {
                              //     setState(() {
                              //       _meterValue = value as double;
                              //     });
                              //   },
                              //   child: Container(
                              //     width: 16,
                              //     height: 12,
                              //     transform: Matrix4.translationValues(4, 0, 0.0),
                              //     child: Icon(Icons.abc),
                              //   ),
                              // ),
                              // LinearShapePointer(
                              //   value: _meterValue,
                              //   width: 20,
                              //   height: 20,
                              //   enableAnimation: true,
                              //   color: Colors.transparent,
                              //   position: LinearElementPosition.cross,
                              //   onChanged: (dynamic value) {
                              //     setState(
                              //       () {
                              //         _meterValue = value as double;
                              //       },
                              //     );
                              //   },
                              // )
                            ],
                            barPointers: <LinearBarPointer>[
                              LinearBarPointer(
                                  value: _meterValue,
                                  enableAnimation: true,
                                  thickness: 6,
                                  edgeStyle: LinearEdgeStyle.endCurve,
                                  color:
                                      const Color.fromARGB(255, 255, 111, 33))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<ChartSeries<_SplineAreaData, DateTime>> _getSplieAreaSeries() {
    return <ChartSeries<_SplineAreaData, DateTime>>[
      SplineAreaSeries<_SplineAreaData, DateTime>(
        dataSource: _chartData!,
        color: const Color.fromRGBO(75, 135, 185, 0.6),
        gradient: const LinearGradient(colors: <Color>[
          Color.fromARGB(255, 255, 255, 255),
          Color.fromRGBO(252, 207, 189, 1)
        ], stops: <double>[
          0,
          1
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        borderWidth: 4,
        borderColor: Color.fromARGB(255, 248, 154, 104),
        name: 'Temperature',
        xValueMapper: (_SplineAreaData data, _) => data.date as DateTime,
        yValueMapper: (_SplineAreaData data, _) => data.temperature,
      ),
      // ColumnSeries<_SplineAreaData, DateTime>(
      //   animationDuration: 0,
      //   dataSource: _topChartData,
      //   dataLabelSettings: const DataLabelSettings(
      //       isVisible: true,
      //       labelAlignment: ChartDataLabelAlignment.outer,
      //       textStyle:
      //           TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
      //   color: const Color.fromARGB(255, 255, 111, 33),
      //   borderWidth: 1.5,
      //   trackBorderWidth: 1,
      //   width: 0,
      //   borderColor: const Color.fromARGB(255, 255, 136, 72),
      //   markerSettings: const MarkerSettings(
      //       isVisible: true,
      //       color: Colors.orange,
      //       borderWidth: 2,
      //       borderColor: Color.fromARGB(255, 247, 247, 247)),
      //   name: 'Temperature',
      //   xValueMapper: (_SplineAreaData data, _) => data.date as DateTime,
      //   yValueMapper: (_SplineAreaData data, _) => data.temperature,
      // ),
    ];
  }

  @override
  void dispose() {
    // _timer?.cancel();
    _chartData!.clear();
    listener?.cancel();
    super.dispose();
  }
}

class _SplineAreaData {
  _SplineAreaData(this.date, this.temperature);
  final dynamic date;
  final double temperature;
}

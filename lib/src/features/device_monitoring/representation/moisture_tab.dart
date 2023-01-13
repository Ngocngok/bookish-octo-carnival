import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide CornerStyle;
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MoistureTab extends StatefulWidget {
  const MoistureTab(this.deviceID, {super.key});

  final String deviceID;

  @override
  State<MoistureTab> createState() => _MoistureTabState();
}

class _MoistureTabState extends State<MoistureTab> {
  _MoistureTabState();
  List<_ChartData>? _chartData = [_ChartData(y: DateTime.now(), x: 0)];

  List<_ChartData>? _backChartData = [_ChartData(y: DateTime.now(), x: 0)];

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

    listener = collection.snapshots().listen((event) {
      setState(() {
        _chartData = event.docs
            .map(
              (doc) => _ChartData(
                  y: DateTime.fromMillisecondsSinceEpoch(
                      doc['timestamp'] * 1000),
                  x: double.parse(doc['humidity'].toString())),
            )
            .toList();

        _backChartData!.clear();
        _backChartData =
            _chartData!.map((e) => _ChartData(x: 100, y: e.y)).toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 350,
                    child: SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      // title: ChartTitle(text: isCardView ? '' : 'Tourism - Number of arrivals'),
                      // legend: Legend(isVisible: !isCardView),
                      primaryXAxis: DateTimeCategoryAxis(
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.nunito().fontFamily,
                        ),
                        labelRotation: 0,
                        axisLine: AxisLine(color: Colors.grey[100], width: 1),
                        majorTickLines: MajorTickLines(width: 0),
                        majorGridLines: const MajorGridLines(
                          width: 0,
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 0,
                        maximum: 100,
                        axisLine: AxisLine(width: 0),
                        interval: 50,
                        majorGridLines: MajorGridLines(
                          width: .2,
                        ),
                        majorTickLines: MajorTickLines(width: 0),
                        //numberFormat: NumberFormat.compact()
                      ),
                      series: _getDefaultDateTimeSeries(),
                      tooltipBehavior: TooltipBehavior(enable: true),
                    ),
                  )),
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        startAngle: 90,
                        endAngle: 270,
                        centerX: 1,
                        showAxisLine: true,
                        showTicks: false,
                        showLabels: false,
                        radiusFactor: 1.4,
                        useRangeColorForAxis: true,
                        axisLineStyle: AxisLineStyle(
                          thickness: .13,
                          thicknessUnit: GaugeSizeUnit.factor,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Colors.grey[200],
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: _chartData!.first.x!.toDouble(),
                            width: .13,
                            sizeUnit: GaugeSizeUnit.factor,
                            pointerOffset: 0,
                            cornerStyle: CornerStyle.bothCurve,
                            color: const Color(0xFFF67280),
                            gradient: const SweepGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 59, 184, 126),
                                Color.fromARGB(255, 122, 191, 161),
                              ],
                              stops: <double>[0.8, 1],
                            ),
                          ),
                          MarkerPointer(
                            value: _chartData!.first.x!.toDouble(),
                            markerWidth: 26,
                            markerHeight: 26,
                            borderWidth: 0,
                            color: Colors.grey[200],
                            markerType: MarkerType.circle,
                          ),
                          MarkerPointer(
                            value: _chartData!.first.x!.toDouble(),
                            markerWidth: 20,
                            markerHeight: 20,
                            borderWidth: 4,
                            borderColor: Colors.white,
                            markerType: MarkerType.circle,
                            elevation: 5,
                          ),
                        ],
                      ),
                      RadialAxis(
                        showTicks: false,
                        showLabels: false,
                        startAngle: 90,
                        offsetUnit: GaugeSizeUnit.factor,
                        centerX: 1,
                        endAngle: 270,
                        radiusFactor: 1.8,
                        axisLineStyle: const AxisLineStyle(
                            // Dash array not supported in web
                            thickness: 12,
                            dashArray: <double>[2, 8]),
                      ),
                      RadialAxis(
                        showTicks: false,
                        showLabels: false,
                        startAngle: 90,
                        endAngle: 90 + _chartData!.first.x! / 100.0 * 180,
                        offsetUnit: GaugeSizeUnit.factor,
                        centerX: 1,
                        radiusFactor: 1.8,
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            angle: 180,
                            positionFactor: 0.3,
                            widget: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '${_chartData!.first.x}%',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  'Moisture',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black26,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        axisLineStyle: const AxisLineStyle(
                          color: Color.fromARGB(255, 59, 184, 126),
                          thickness: 12,
                          dashArray: <double>[2, 8],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _timer?.cancel();
    _chartData!.clear();
    listener?.cancel();
    super.dispose();
  }

  List<BarSeries<_ChartData, DateTime>> _getDefaultDateTimeSeries() {
    return <BarSeries<_ChartData, DateTime>>[
      BarSeries<_ChartData, DateTime>(
          name: "Humidity",
          dataSource: _chartData!,
          // markerSettings: MarkerSettings(
          //   isVisible: true,
          //   width: 5,
          //   height: 5,
          // ),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
          width: 0.3,
          spacing: 0.2,
          xValueMapper: (_ChartData x, xx) => x.y as DateTime,
          yValueMapper: (_ChartData data, _) => data.x,
          isTrackVisible: true,
          // dataLabelSettings: DataLabelSettings(
          //   isVisible: true,
          //   textStyle: TextStyle(
          //     fontFamily: GoogleFonts.nunito().fontFamily,
          //   ),
          // ),
          trackColor: const Color.fromARGB(255, 235, 255, 235),
          pointColorMapper: (_ChartData data, _) => _getPointColor(data.x))

      // BarSeries<_ChartData, DateTime>(
      //   dataSource: _backChartData!,
      //   borderRadius: BorderRadius.all(Radius.circular(10)),
      //   width: 0.5,
      //   spacing: 0.2,
      //   xValueMapper: (_ChartData x, xx) => x.y as DateTime,
      //   yValueMapper: (_ChartData data, _) => data.x,
      //   color: Colors.grey[100],
      // ),
    ];
  }

  Color? _getPointColor(num? value) {
    Color? color;
    if (value! < 20) {
      color = Color.fromARGB(255, 197, 232, 183);
    } else if (value < 40) {
      color = Color.fromARGB(255, 171, 224, 152);
    } else if (value < 60) {
      color = Color.fromARGB(255, 131, 212, 117);
    } else if (value < 80) {
      color = Color.fromARGB(255, 87, 200, 77);
    } else {
      color = Color.fromARGB(255, 46, 182, 44);
    }
    return color;
  }
}

class _ChartData {
  final dynamic y;
  final num? x;
  _ChartData({this.x, this.y});
}

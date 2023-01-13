import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide CornerStyle;
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HumidityTab extends StatefulWidget {
  const HumidityTab(this.deviceID, {super.key});

  final String deviceID;

  @override
  State<HumidityTab> createState() => _HumidityTabState();
}

class _HumidityTabState extends State<HumidityTab> {
  _HumidityTabState();
  List<_ChartData>? _chartData = [
    _ChartData(x: DateTime.fromMillisecondsSinceEpoch(1), y: 0)
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

    listener = collection.snapshots().listen((event) {
      setState(() {
        _chartData = event.docs
            .map(
              (doc) => _ChartData(
                  x: DateTime.fromMillisecondsSinceEpoch(
                      doc['timestamp'] * 1000),
                  y: double.parse(doc['humidity'].toString())),
            )
            .toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // _getChartData();
    // _timer = Timer(const Duration(seconds: 2), () {
    //   setState(() {
    //     _getChartData();
    //   });
    // });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * .7,
          height: size.width * .7,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                foregroundPainter: LinePainter(),
              ),
              SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    startAngle: 275,
                    endAngle: 265,
                    minimum: 0,
                    maximum: 100,
                    radiusFactor: 1,
                    canRotateLabels: true,
                    showLastLabel: true,
                    showTicks: false,
                    showLabels: false,
                    axisLineStyle: const AxisLineStyle(
                      color: Color.fromARGB(255, 235, 246, 253),
                      thickness: .1,
                      thicknessUnit: GaugeSizeUnit.factor,
                      cornerStyle: CornerStyle.bothCurve,
                    ),
                    pointers: <GaugePointer>[
                      RangePointer(
                          value: _chartData?.first.y?.toDouble() ?? 0,
                          width: 0.1,
                          cornerStyle: CornerStyle.bothCurve,
                          sizeUnit: GaugeSizeUnit.factor,
                          color: const Color.fromARGB(255, 116, 212, 224),
                          animationDuration: 1300,
                          animationType: AnimationType.ease,
                          enableAnimation: true)
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        angle: 90,
                        positionFactor: 0,
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              'Humidity:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_chartData?.first.y ?? 0}%',
                              style: const TextStyle(
                                fontSize: 36,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                    axisLabelStyle:
                        const GaugeTextStyle(color: Color(0xFF00A8B5)),
                  ),
                  RadialAxis(
                    startAngle: 270,
                    endAngle: 270,
                    radiusFactor: .75,
                    showAxisLine: false,
                    showLabels: false,
                    ticksPosition: ElementsPosition.inside,
                    interval: 10,
                    majorTickStyle: const MajorTickStyle(
                      length: 0.04,
                      lengthUnit: GaugeSizeUnit.factor,
                      thickness: 2,
                    ),
                    minorTicksPerInterval: 4,
                    minorTickStyle: MinorTickStyle(
                      color: Colors.teal[100],
                      length: 0.04,
                      lengthUnit: GaugeSizeUnit.factor,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
            width: size.width * .9,
            height: size.width * .6,
            child: _buildAnimationSplineChart()),
      ],
    );
  }

  /// get the spline chart sample with dynamically updated data points.
  SfCartesianChart _buildAnimationSplineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis:
          DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          axisLine: const AxisLine(width: 0),
          minimum: 0,
          maximum: 100),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: _getDefaultDateTimeSeries(),
    );
  }

  @override
  void dispose() {
    // _timer?.cancel();
    _chartData!.clear();
    listener?.cancel();
    super.dispose();
  }

  List<LineSeries<_ChartData, DateTime>> _getDefaultDateTimeSeries() {
    return <LineSeries<_ChartData, DateTime>>[
      LineSeries<_ChartData, DateTime>(
        name: "Humidity",
        dataSource: _chartData!,
        markerSettings: const MarkerSettings(
          isVisible: true,
          width: 5,
          height: 5,
        ),
        xValueMapper: (_ChartData data, _) => data.x as DateTime,
        yValueMapper: (_ChartData data, _) => data.y,
        color: const Color.fromARGB(255, 7, 136, 242),
      )
    ];
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..shader = const RadialGradient(colors: [
        Color.fromARGB(255, 240, 240, 240),
        Color.fromARGB(255, 253, 254, 255),
      ], stops: [
        1 - 1 / 2.75,
        1 - 1 / 2.75 + .15
      ]).createShader(
        Rect.fromCircle(
          center: center,
          radius: size.width / 2,
        ),
      );

    canvas.drawCircle(
      center,
      size.width / 2.75,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChartData {
  final dynamic x;
  final num? y;
  _ChartData({this.x, this.y});
}

import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iot_firebase/manual.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final rdb = FirebaseDatabase.instance.ref();

  bool led=false;
  double _temp=0,_humidity=0,_soil=0;
  String ?temp;
  String ?humidity;
  String ?soil;

//   rdb.onValue.listen((DatabaseEvent event) {
//   final data = event.snapshot.value;
//   // updateStarCount(data);
//   }) {
//   // TODO: implement listen
//   throw UnimplementedError();
// }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readData();
  }

  void _readData(){
    rdb.child('auto/dht/temp').onValue.listen((event) {
      final data=event.snapshot.value;
      log(data.toString());
      temp=data.toString();
      setState(() {
        _temp=double.parse(temp!);
      });
    });
    rdb.child('auto/dht/humidity').onValue.listen((event) {
      final data=event.snapshot.value;
      log(data.toString());
      humidity=data.toString();
      setState(() {
        _humidity=double.parse(humidity!);
      });
    });
    rdb.child('auto/soil').onValue.listen((event) {
      final data=event.snapshot.value;
      log(data.toString());
      soil=data.toString();
      setState(() {
        _soil=double.parse(soil!);
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Automatic Mode"),
          backgroundColor: Colors.greenAccent[400],
          actions: [
            PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
                itemBuilder: (context){
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Switch to manual mode"),
                    ),
                  ];
                },
                onSelected:(value){
                  if(value == 0){
                    print("Manual mode activated");
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Manual()));
                  }
                }
            ),

          ],

        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Expanded(
                    flex: 1,
                    child: SfRadialGauge(
                        enableLoadingAnimation: true,
                        // backgroundColor: Colors.amber,
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            showLabels: false,
                            showTicks: false,
                            radiusFactor: 0.75,
                            canScaleToFit: true,
                            axisLineStyle: AxisLineStyle(
                              thickness: 0.2,
                              cornerStyle: CornerStyle.bothCurve,
                              color: Colors.greenAccent[100],
                              thicknessUnit: GaugeSizeUnit.factor,
                            ),
                            pointers: <GaugePointer>[
                              RangePointer(color: Colors.green[800],
                                value: _temp,
                                cornerStyle: CornerStyle.bothCurve,
                                width: 0.2,
                                sizeUnit: GaugeSizeUnit.factor,
                              )],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  positionFactor: 0.1,
                                  angle: 90,
                                  widget: Text('Temperature\n'+ '      '+
                                    _temp.toStringAsFixed(0) + ' ℃',
                                    style: TextStyle(fontSize: 18),
                                  ))
                            ],
                          )]),
                  ),
                  Expanded(
                    flex: 1,
                    child: SfRadialGauge(
                      // backgroundColor: Colors.amber,
                        axes: <RadialAxis>[
                          RadialAxis(
                            radiusFactor: 0.75,
                            minimum: 0,
                            maximum: 100,
                            canScaleToFit: true,
                            showLabels: false,
                            showTicks: false,
                            axisLineStyle: AxisLineStyle(
                              thickness: 0.2,
                              cornerStyle: CornerStyle.bothCurve,
                              color: Colors.greenAccent[100],
                              thicknessUnit: GaugeSizeUnit.factor,
                            ),
                            pointers: <GaugePointer>[
                              RangePointer(color: Colors.green[800],
                                value: _humidity,
                                cornerStyle: CornerStyle.bothCurve,
                                width: 0.2,
                                sizeUnit: GaugeSizeUnit.factor,
                              )],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  positionFactor: 0.1,
                                  angle: 90,
                                  widget: Text('Humidity\n'+'    '+
                                    _humidity.toStringAsFixed(0) + ' %',
                                    style: TextStyle(fontSize: 18),
                                  ))
                            ],
                          )]),
                  ),
                ]
              ),
            ),
            Expanded(
              flex: 2,
              child: SfRadialGauge(
                // backgroundColor: Colors.amber,
                  axes: <RadialAxis>[
                    RadialAxis(
                      radiusFactor: 0.75,
                      minimum: 0,
                      maximum: 100,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.2,
                        cornerStyle: CornerStyle.bothCurve,
                        color: Colors.greenAccent[100],
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(color: Colors.green[800],
                          value: _soil,
                          cornerStyle: CornerStyle.bothCurve,
                          width: 0.2,
                          sizeUnit: GaugeSizeUnit.factor,
                        )],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            positionFactor: 0.1,
                            angle: 90,
                            widget: Text('Soil Moisture\n'+'        '+
                              _soil.toStringAsFixed(0) + ' %',
                              style: TextStyle(fontSize: 18),
                            ))
                      ],
                    )]),
            )


        ])
    );
  }
}

// void readData(DatabaseReference reference){
//   reference.onValue.listen((event) { })
//
// }
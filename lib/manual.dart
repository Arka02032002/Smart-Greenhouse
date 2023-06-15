import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Manual extends StatefulWidget {


  @override
  State<Manual> createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  final rdb = FirebaseDatabase.instance.ref();
  int temp=0,humidity=0,soil=0,humidity2=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readManualData();
  }

  void _readManualData() async{
    rdb.child('auto/threshold/temp').onValue.listen((event) async {
      final data=await event.snapshot.value;
      print(data);
        temp=data.toString() as int;
    });
    rdb.child('auto/threshold/humidity').onValue.listen((event) async {
      final data=await event.snapshot.value;
      print(data);
      // setState(() {
        humidity=data.toString() as int;
      // });
    });
    rdb.child('auto/threshold/soil').onValue.listen((event) async {
      final data=await event.snapshot.value;
      print(data);
      // setState(() {
        soil=data.toString() as int;
      // });
    });
  }

  final _textcontrollertemp=TextEditingController();
  final _textcontrollerhumidity2=TextEditingController();
  final _textcontrollerhumidity=TextEditingController();
  final _textcontrollersoil=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manual Mode"),
        backgroundColor: Colors.greenAccent[400],
      ),
      body: Column(
        children: [
          // Text("Temp"),
          SizedBox(height: 8,),
          Row(
            children: [
              Flexible(
                child: TextField (
                  controller: _textcontrollerhumidity,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Humidity',
                      suffixIcon: IconButton(
                        onPressed: (){
                          _textcontrollerhumidity.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                  ),
                ),
              ),
              Flexible(
                child: TextField (
                  controller: _textcontrollerhumidity2,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Humidity2',
                      suffixIcon: IconButton(
                        onPressed: (){
                          _textcontrollerhumidity2.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                  ),
                ),
              ),
            ],
          ),

          MaterialButton(
            color: Colors.amber,
              onPressed: (){
                setState(() {
                  humidity=int.parse(_textcontrollerhumidity.text);
                  humidity2=int.parse(_textcontrollerhumidity2.text);

                  rdb.child('auto/threshold').update({
                    'humidity': humidity,
                    'humidity2': humidity2
                  });
                }
                );

          },
            child: Text("Update"),
          ),
          // Text("Humidity"),
          // SizedBox(width: 50,),
          SizedBox(height: 8,),
          TextField (
            controller: _textcontrollertemp,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Temperature',
                suffixIcon: IconButton(
                  onPressed: (){
                    _textcontrollertemp.clear();
                  },
                  icon: const Icon(Icons.clear),
                )
            ),
          ),
          MaterialButton(
            color: Colors.amber,
            onPressed: (){
              setState(() {
                temp=int.parse(_textcontrollertemp.text);
                rdb.child('auto/threshold').update({
                  'temp': temp
                });
              }
              );

            },
            child: Text("Update"),
          ),
          // Text("Soil Moisture"),
          // SizedBox(width: 50,),
          SizedBox(height: 8,),
          TextField (
            controller: _textcontrollersoil,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Soil Moisture',
                suffixIcon: IconButton(
                  onPressed: (){
                    _textcontrollersoil.clear();
                  },
                  icon: const Icon(Icons.clear),
                )
            ),

          ),
          MaterialButton(
            color: Colors.amber,
            onPressed: (){
              setState(() {
                soil=int.parse(_textcontrollersoil.text);
                rdb.child('auto/threshold').update({
                  'soil': soil
                });
              }
              );

            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }
}

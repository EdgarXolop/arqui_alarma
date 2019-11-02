import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Control'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  final arquiChild = FirebaseDatabase.instance.reference().child("ARQUI");

  bool porton = false;

  bool alarma = false;

  @override
  void initState() {
    super.initState();

    arquiChild.onChildChanged.listen(_onEntryChangedShop);
  }


  void cambiarAlarma() {
    databaseReference.child('ARQUI').update({"estadoAlarma": alarma});
  }

  void cambiarPorton() {
    databaseReference.child('ARQUI').update({"abrirPorton": alarma});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Estado Alarma ',
                  style: TextStyle(fontSize: 24),
                ),
                Switch(
                  value: alarma,
                  onChanged: (value) {
                    setState(() {
                      alarma = value;
                    });

                    cambiarAlarma();
                  },
                  activeTrackColor: Colors.lightBlueAccent,
                  activeColor: Colors.lightBlue,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Estado Portódn ',
                  style: TextStyle(fontSize: 24),
                ),
                Switch(
                  value: porton,
                  onChanged: (value) {
                    setState(() {
                      porton = value;
                    });

                    cambiarPorton();
                  },
                  activeTrackColor: Colors.lightBlueAccent,
                  activeColor: Colors.lightBlue,
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _onEntryChangedShop(Event event) {
    setState(() {
      if (event.snapshot.key == "estadoAlarma") alarma = event.snapshot.value;

      if (event.snapshot.key == "abrirPorton") porton = event.snapshot.value;
    });
  }
}

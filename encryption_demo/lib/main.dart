import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:core';

void main() {
  runApp(ModularDemo());
}

class ModularDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Unpadded RSA Demo')),
        body: BackgroundContent(),
      ),
    );
  }
}

class BackgroundContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: ModularForm(),
    );
  }
}

class ModularForm extends StatefulWidget {
  @override
  _ModularFormState createState() => _ModularFormState();
}

class _ModularFormState extends State<ModularForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController x1Controller = TextEditingController();
  TextEditingController x2Controller = TextEditingController();
  TextEditingController eController = TextEditingController();
  TextEditingController mController = TextEditingController();

  int? result1, result2, combinedResult;

  void _calculate() {
    int x1 = int.parse(x1Controller.text);
    int x2 = int.parse(x2Controller.text);
    int e = int.parse(eController.text);
    int m = int.parse(mController.text);
    debugPrint('x1: $x1, x2: $x2, e: $e, m: $m');
    setState(() {
      num base1 = pow(x1, e) % m;
      num base2 = pow(x2, e) % m;
      result1 = base1.toInt();
      result2 = base2.toInt();
      combinedResult = (pow((x1 * x2) % m, e) % m.toInt()) as int?;
    });
  }

  void _generateKey() {
    Random rand = Random();
    setState(() {
      eController.text = (rand.nextInt(10) + 2).toString(); // Simple random exponent
      mController.text = (rand.nextInt(100) + 3).toString(); // Simple random modulus
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: x1Controller,
                  decoration: InputDecoration(labelText: 'Enter x1', fillColor: Colors.white70, filled: true),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: x2Controller,
                  decoration: InputDecoration(labelText: 'Enter x2', fillColor: Colors.white70, filled: true),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: eController,
                  decoration: InputDecoration(labelText: 'Enter e (exponent)', fillColor: Colors.white70, filled: true),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: mController,
                  decoration: InputDecoration(labelText: 'Enter m (modulus)', fillColor: Colors.white70, filled: true),
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: _calculate,
                        child: Text('Calculate'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _generateKey,
                        child: Text('Generate Keys'),
                      ),
                    ],
                  ),
                ),
                if (result1 != null && result2 != null && combinedResult != null) ...[
                  Text(
                    'Calculation Details:',
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      backgroundColor: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    '1. Result of pow(x1, e) % m: $result1',
                    style: _resultTextStyle(),
                  ),
                  Text(
                    '2. Result of pow(x2, e) % m: $result2',
                    style: _resultTextStyle(),
                  ),
                  Text(
                    '3. Result of pow((x1 * x2) % m, e) % m: $combinedResult',
                    style: _resultTextStyle(),
                  ),
                  Text(
                    '4. Modular multiplication result: ${result1! * result2! % int.parse(mController.text)}',
                    style: _resultTextStyle(),
                  )
                ]
              ],
            ),
          ),
          Text('Prepared by Ahmet Furkan Akıncı, Eyüp Şahin, and Cahid Enes Keleş',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  TextStyle _resultTextStyle() => TextStyle(
    color: Colors.white,
    fontSize: 16,
    backgroundColor: Colors.black.withOpacity(0.5),
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: Colors.black,
        offset: Offset(2.0, 2.0),
      ),
    ],
  );

}

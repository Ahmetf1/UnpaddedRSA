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
    BigInt x1 = BigInt.parse(x1Controller.text);
    BigInt x2 = BigInt.parse(x2Controller.text);
    BigInt e = BigInt.parse(eController.text);
    BigInt m = BigInt.parse(mController.text);

    setState(() {
      BigInt base1 = x1.modPow(e, m);
      BigInt base2 = x2.modPow(e, m);
      result1 = base1.toInt();
      result2 = base2.toInt();
      combinedResult = ((x1 * x2) % m).modPow(e, m).toInt();
    });
  }

  void _generateKey() {
    int p = _findPrime(50, 100);
    int q = _findPrime(50, 100);
    BigInt m = BigInt.from(p) * BigInt.from(q);
    int phi = (p - 1) * (q - 1);
    int e = _findCoPrime(phi);

    setState(() {
      eController.text = e.toString();
      mController.text = m.toString();
    });
  }

  bool _isPrime(int number) {
    for (int i = 2; i <= sqrt(number); i++) {
      if (number % i == 0) {
        return false;
      }
    }
    return true;
  }

  int _findPrime(int start, int end) {
    Random rand = Random();
    int candidate = start + rand.nextInt(end - start);
    while (!_isPrime(candidate)) {
      candidate = start + rand.nextInt(end - start);
    }
    return candidate;
  }

  int _findCoPrime(int number) {
    Random rand = Random();
    int candidate = 2 + rand.nextInt(number - 2); // e must be between 2 and phi-1
    while (_gcd(candidate, number) != 1) {
      candidate = 2 + rand.nextInt(number - 2);
    }
    return candidate;
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      int t = b;
      b = a % b;
      a = t;
    }
    return a;
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

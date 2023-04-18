import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: scan());
  }
}

class scan extends StatefulWidget {
  const scan({Key? key}) : super(key: key);

  @override
  State<scan> createState() => _scanState();
}

class _scanState extends State<scan> {
  String _scanBarcode = "Unknow";

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version';
    }

    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanQR() async{
    String barcodeScanRes;
    try{
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    }on PlatformException{
      barcodeScanRes = 'Failed to get platform version';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> startBarcodeScanStream() async{
    FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", true, ScanMode.BARCODE)!.listen((barcode) { print(barcode); });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barcode Scan"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                startBarcodeNormal();
              },
              child: Text("Start barcode scan"),
            ),
            ElevatedButton(
              onPressed: () {
                scanQR();
              },
              child: Text("Start QR scan"),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     startBarcodeScanStream();
            //   },
            //   child: Text("Start barcode scan stream"),
            // ),
            SizedBox(height : 20),
            Text(
              _scanBarcode,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

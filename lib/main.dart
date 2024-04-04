import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:solana/base58.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solana PrivateKey Encode/Decoder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Solana PrivateKey Encode/Decoder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> decode = [];
  String encode = '';

  void _decode(String base58) {
    setState(() {
      decode = base58decode(base58);
    });
  }

  void triggerFileDownload(String jsonString, String fileName) {
    // Create a blob from the JSON string
    final blob = html.Blob([Uint8List.fromList(jsonString.codeUnits)]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void downloadJsonFile(String jsonString, String fileName) async {
    try {
      triggerFileDownload(jsonString, fileName);
    } catch (e) {
      print("Error downloading JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 14, 23, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(36, 40, 62, 1),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(48.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your string private key',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (String value) {
                  _decode(value);
                },
              ),
            ),
            const Text('Your Decoded Private Key:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )),
            const SizedBox(
              height: 20,
            ),
            Text(
              '$decode',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => Clipboard.setData(
                ClipboardData(
                  text: decode.toString().replaceAll(' ', ''),
                ),
              ).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bytes copied to clipboard"),
                  ),
                );
              }),
              child: const Text('Copy'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => downloadJsonFile(
                  decode.toString().replaceAll(' ', ''), 'id.json'),
              child: const Text('Download'),
            )
          ],
        ),
      ),
    );
  }
}

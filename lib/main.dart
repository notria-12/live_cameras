import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'mjpeg.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamController controller = StreamController<List<int>>();
  StreamSubscription? videoStream;
  List<int> buf = [];
  int startIndex = -1;
  int endIndex = -1;

  Stream<List<int>> getVideo() async* {
    // File fileHandle = File('test_frame.jpg');
    Uri url = Uri.parse(
        "https://zm.apagaofogo.eco.br/zm/cgi-bin/zms?monitor=22&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJab25lTWluZGVyIiwiaWF0IjoxNjM5NTg2MDUxLCJleHAiOjE2Mzk1ODk2NTEsInVzZXIiOiJhcGFnYW9mb2dvIiwidHlwZSI6ImFjY2VzcyJ9.qaHozckT3siVNP41reg7qSeQSx9__alKa-qzpTqshkY&mode=jpeg&scale=100&maxfps=2");
    var client = HttpClient();
    Map<String, String> bodyMap = {"name": "camera.getLivePreview"};

    var request = await client.postUrl(url)
      ..headers.contentType =
          ContentType("application", "json", charset: "utf-8")
      ..write(jsonEncode(bodyMap));

    var response = await request.close();
    yield* response;
  }

  @override
  Widget build(BuildContext context) {
    // controller.sink.add(getVideo());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              // child: StreamBuilder(
              //   stream: getVideo(),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       print((snapshot.data));
              //       return Container();
              //     } else {
              //       return Container();
              //     }
              //   },
              // ),
              child: Center(
                child: Mjpeg(
                  isLive: true,
                  error: (context, error, stack) {
                    print(error);
                    print(stack);
                    return Text(error.toString(),
                        style: TextStyle(color: Colors.red));
                  },
                  stream:
                      'https://zm.apagaofogo.eco.br/zm/cgi-bin/zms?monitor=22&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJab25lTWluZGVyIiwiaWF0IjoxNjM5NTczNDA2LCJleHAiOjE2Mzk1NzcwMDYsInVzZXIiOiJhcGFnYW9mb2dvIiwidHlwZSI6ImFjY2VzcyJ9.FDo8kUwUEfwwJ-ndFEdcoa3oaLxp2FJAH1zvfJ89OGQ&mode=jpeg&scale=100&maxfps=2', //'http://192.168.1.37:8081',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

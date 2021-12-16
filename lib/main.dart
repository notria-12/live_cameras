import 'package:cameras/mjpeg_dio.dart';
import 'package:cameras/mjpeg_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  http.Client client = http.Client();
  // Stream<List<int>> getVideo() async* {
  //   Dio dio = Dio();
  //   // File fileHandle = File('test_frame.jpg');
  //   Uri url = Uri.parse(
  //       "https://zm.apagaofogo.eco.br/zm/cgi-bin/zms?monitor=22&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJab25lTWluZGVyIiwiaWF0IjoxNjM5NTg2MDUxLCJleHAiOjE2Mzk1ODk2NTEsInVzZXIiOiJhcGFnYW9mb2dvIiwidHlwZSI6ImFjY2VzcyJ9.qaHozckT3siVNP41reg7qSeQSx9__alKa-qzpTqshkY&mode=jpeg&scale=100&maxfps=2");
  //   // var client = HttpClient();
  //   Map<String, String> bodyMap = {"name": "camera.getLivePreview"};

  //   var request = await dio.getUri(url,
  //       options: Options(responseType: ResponseType.stream));
  //   // ..headers.contentType =
  //   //     ContentType("application", "json", charset: "utf-8")
  //   // ..write(jsonEncode(bodyMap));

  //   // var response = await request.;
  //   yield* request.data;
  // }

  Stream<List<int>> getVideo() async* {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    var request = http.Request(
        "GET",
        Uri.parse(
            'https://zm.apagaofogo.eco.br/zm/cgi-bin/zms?monitor=22&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJab25lTWluZGVyIiwiaWF0IjoxNjM5NjU5NTY0LCJleHAiOjE2Mzk2NjMxNjQsInVzZXIiOiJhcGFnYW9mb2dvIiwidHlwZSI6ImFjY2VzcyJ9.gXvRJGyw7tsBS_vM_8FlHj5blBzwu-YlzfpWb3ghU-A&mode=jpeg&scale=100&maxfps=2'));
    request.headers.addAll(headers);
    var response = await client.send(request).timeout(Duration(seconds: 20));

    yield* response.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                // child: StreamBuilder(builder: (context, snapshot) {
                //   print(snapshot)
                //   return Container();
                // },),
                child: Center(
                    child: StreamBuilder<List<int>>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return const Center(
                    child: Text("Rodou"),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Deu erro ${snapshot.error}}'),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              stream: getVideo(),
            ))
                // child: Mjpeg(
                //   isLive: true,
                //   error: (context, error, stack) {
                //     print(error);
                //     print(stack);
                //     return Text(error.toString(),
                //         style: TextStyle(color: Colors.red));
                //   },
                //   stream:
                //       'https://zm.apagaofogo.eco.br/zm/cgi-bin/zms?monitor=22&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJab25lTWluZGVyIiwiaWF0IjoxNjM5NTk5OTQyLCJleHAiOjE2Mzk2MDM1NDIsInVzZXIiOiJhcGFnYW9mb2dvIiwidHlwZSI6ImFjY2VzcyJ9.KaqiaeE_AO1NV5QZdR4a3ImYXR7WSdbFiPqSdfViEXQ&mode=jpeg&scale=100&maxfps=2',
                // ),
                ),
          ],
        ),
      ),
    );
  }
}

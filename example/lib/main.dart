import 'package:easy_refresh/easy_refresh.dart';
import 'package:easy_refresh_water_drop/easy_refresh_water_drop.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _count = 0;

  void _incrementCounter() {
    setState(() {
      _count++;
    });
  }

  EasyRefreshController easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true, controlFinishLoad: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: EasyRefresh(
        controller: easyRefreshController,
        header: WaterDropHeader(),
        footer: CustomFooter(),
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          if (!mounted) {
            return;
          }
          setState(() {
            _count = 10;
          });
          easyRefreshController.finishRefresh();
          easyRefreshController.resetFooter();
        },
        onLoad: () async {
          await Future.delayed(const Duration(seconds: 4));
          if (!mounted) {
            return;
          }
          setState(() {
            _count += 5;
          });
          easyRefreshController.finishLoad();
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                alignment: Alignment.center,
                height: 80,
                child: Text('${index + 1}'),
              ),
            );
          },
          itemCount: _count,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

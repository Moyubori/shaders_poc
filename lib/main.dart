import 'package:flutter/material.dart';
import 'package:shaders_poc/blur_hash.dart';
import 'package:shaders_poc/camera.dart';
import 'package:shaders_poc/warp.dart';

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
  int _index = 0;
  bool useShader = true;

  final List _pages = [
    (bool useShader) => WarpShaderWidget(
          useShader: useShader,
        ),
    (bool useShader) => CameraShaderWidget(
          useShader: useShader,
        ),
    (bool useShader) => BlurHashWidget(
          useShader: useShader,
        ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  useShader = !useShader;
                });
              },
              icon: Icon(useShader ? Icons.turned_in : Icons.turned_in_not)),
        ],
      ),
      body: _pages[_index](useShader),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.looks_one), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.looks_two), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.looks_3), label: ''),
        ],
      ),
    );
  }
}

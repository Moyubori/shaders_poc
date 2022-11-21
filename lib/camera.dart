import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shaders_poc/camera_effect_sprv.dart';

class CameraShaderWidget extends StatefulWidget {
  final bool useShader;

  const CameraShaderWidget({super.key, required this.useShader});

  @override
  _CameraShaderWidgetState createState() => _CameraShaderWidgetState();
}

class _CameraShaderWidgetState extends State<CameraShaderWidget> {
  CameraController? controller;

  late List<CameraDescription> _cameras;
  ui.Image? cameraImage;

  @override
  void initState() {
    super.initState();
    availableCameras().then((List<CameraDescription> cameras) {
      _cameras = cameras;
      controller = CameraController(
        _cameras[1],
        ResolutionPreset.max,
      );
      controller!.initialize().then((_) => setState(() {})).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print('User denied camera access.');
              break;
            default:
              print('Handle other errors.');
              break;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: cameraImage == null
          ? Center(
              child: CameraPreview(
              controller!,
            ))
          : FutureBuilder(
              future: cameraEffectFragmentProgram(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox.expand(
                    child: CustomPaint(
                      painter: CameraEffectShaderPainter(snapshot.data!, cameraImage!),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () async {
            final image = await controller!.takePicture();
            await controller!.pausePreview();
            final Uint8List bytes = await image.readAsBytes();
            cameraImage = await decodeImageFromList(bytes);
            setState(() {});
          },
          child: const Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}

class CameraEffectShaderPainter extends CustomPainter {
  CameraEffectShaderPainter(
    this.fragmentProgram,
    this.image,
  );

  final ui.FragmentProgram fragmentProgram;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = fragmentProgram.shader(
          floatUniforms: Float32List.fromList(
            [
              size.width,
              size.height,
            ],
          ),
          samplerUniforms: [
            ImageShader(
              image,
              TileMode.repeated,
              TileMode.repeated,
              Matrix4.identity().storage,
            ),
          ]);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CameraEffectShaderPainter && oldDelegate.fragmentProgram == fragmentProgram) {
      return false;
    }
    return true;
  }
}

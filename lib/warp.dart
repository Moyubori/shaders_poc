import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shaders_poc/warp_sprv.dart';
import 'package:vector_math/vector_math.dart';

class WarpShaderWidget extends StatefulWidget {
  final bool useShader;

  const WarpShaderWidget({
    Key? key,
    this.useShader = true,
  }) : super(key: key);

  @override
  State<WarpShaderWidget> createState() => _WarpShaderWidgetState();
}

class _WarpShaderWidgetState extends State<WarpShaderWidget> with SingleTickerProviderStateMixin {
  Duration _elapsed = Duration.zero;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsed = elapsed;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useShader) {
      return FutureBuilder<FragmentProgram?>(
        /// Use the generated loader function here
        future: warpFragmentProgram(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return SizedBox.expand(
            child: CustomPaint(
              painter: WarpShaderPainter(snapshot.data!, _elapsed),
            ),
          );
        }),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: CustomPaint(
          painter: WarpCustomPainter(_elapsed),
        ),
      );
    }
  }
}

class WarpShaderPainter extends CustomPainter {
  final Duration currentTime;

  WarpShaderPainter(
    this.fragmentProgram,
    this.currentTime,
  );

  final FragmentProgram fragmentProgram;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = fragmentProgram.shader(
        floatUniforms: Float32List.fromList(
          [
            size.width,
            size.height,
            currentTime.inMilliseconds.toDouble() / 1000,
          ],
        ),
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is WarpShaderPainter && oldDelegate.fragmentProgram == fragmentProgram) {
      return false;
    }
    return true;
  }
}

class WarpCustomPainter extends CustomPainter {
  final Duration currentTime;

  WarpCustomPainter(
    this.currentTime,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final time = currentTime.inMilliseconds.toDouble();
    const strength = 0.4;
    final t = time / 3.0;
    for (double x = 0; x < size.width; x++) {
      for (double y = 0; y < size.height; y++) {
        Vector3 col = Vector3(0, 0, 0);
        Vector2 pos = Vector2(x / size.width, y / size.height);
        pos.y /= size.width / size.height;
        pos = (Vector2(0.5, 0.5) - pos);
        pos = pos * 4.0;
        for (double k = 1.0; k < 7.0; k += 1.0) {
          pos.x += strength * sin(2.0 * t + k * 1.5 * pos.y) + t * 0.5;
          pos.y += strength * cos(2.0 * t + k * 1.5 * pos.x);
        }
        col += Vector3(0.5 + 0.5 * cos(0 + pos.x + time), 0.5 + 0.5 * cos(2 + pos.y + time),
            0.5 + 0.5 * cos(4 + pos.x + time));
        col = Vector3(pow(col.x, 0.4545).toDouble(), pow(col.y, 0.4545).toDouble(),
            pow(col.z, 0.4545).toDouble());
        paint.color =
            Color.fromRGBO((col.x * 255).round(), (col.y * 255).round(), (col.z * 255).round(), 1);
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(WarpCustomPainter oldDelegate) {
    if (oldDelegate.currentTime == currentTime) {
      return false;
    }
    return true;
  }
}

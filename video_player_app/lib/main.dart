import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoScreen(),
    );
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _controller;
  bool _loading = true;

  Future<void> loadVideo(int videoId) async {
    setState(() => _loading = true);

    final response = await http.get(
      Uri.parse("http://10.0.2.2:3000/videos/$videoId/stream"),
    );

    final data = jsonDecode(response.body);
    final url = data["stream_url"];

    await _controller?.dispose();

    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await _controller!.initialize();
    _controller!.play();

    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    loadVideo(1);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text(
    "SAMANSA Demo Stream App",
    style: TextStyle(fontWeight: FontWeight.w600),
  ),
  centerTitle: true,
),
      body: Stack(
        children: [
          const FallingParticles(), // 🌸 background

          Center(
            child: _loading
                ? const CircularProgressIndicator()
                : AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "v1",
            onPressed: () => loadVideo(1),
            child: const Icon(Icons.movie),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "v2",
            onPressed: () => loadVideo(2),
            child: const Icon(Icons.timelapse),
          ),
        ],
      ),
    );
  }
}

class FallingParticles extends StatefulWidget {
  const FallingParticles({super.key});

  @override
  State<FallingParticles> createState() => _FallingParticlesState();
}

class _FallingParticlesState extends State<FallingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: PetalPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class PetalPainter extends CustomPainter {
  final double progress;
  final Random random = Random();

  PetalPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final image = AssetImage('assets/images/petal.png');
    final paint = Paint();

    for (int i = 0; i < 25; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = (progress * size.height + i * 120) % size.height;
      final rotation = random.nextDouble() * pi;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(rotation);

      image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) {
          canvas.drawImageRect(
            info.image,
            Rect.fromLTWH(0, 0, info.image.width.toDouble(),
                info.image.height.toDouble()),
            const Rect.fromLTWH(-20, -20, 40, 40),
            paint,
          );
        }),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

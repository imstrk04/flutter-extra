import 'package:flutter/material.dart';

class AnimatedBallApp extends StatefulWidget {
  const AnimatedBallApp({super.key});

  @override
  State<AnimatedBallApp> createState() => _AnimatedBallAppState();
}

class _AnimatedBallAppState extends State<AnimatedBallApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _speed = 1.0;
  bool _isAnimating = false;
  Color _ballColor = Colors.red;

  final List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.orange];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (4 / _speed).round()),
    )..addListener(() {
      setState(() {});
    });

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  void _toggleAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
      if (_isAnimating) {
        _controller.forward();
      } else {
        _controller.stop();
      }
    });
  }

  void _changeSpeed(double value) {
    setState(() {
      _speed = value;
      _controller.duration = Duration(seconds: (4 / _speed).round());
      if (_isAnimating) {
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _ballSize => 50 + 20 * (_animation.value); // Scale

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double ballPosition = _animation.value * (screenWidth - _ballSize);

    return Scaffold(
      appBar: AppBar(title: const Text("Animated Ball")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ball
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: ballPosition,
                    top: 100,
                    child: Container(
                      width: _ballSize,
                      height: _ballSize,
                      decoration: BoxDecoration(
                        color: _ballColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Dropdown for color
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ball Color:"),
                DropdownButton<Color>(
                  value: _ballColor,
                  items: _colors
                      .map((color) => DropdownMenuItem(
                    value: color,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ))
                      .toList(),
                  onChanged: (color) {
                    if (color != null) {
                      setState(() {
                        _ballColor = color;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Slider
            Column(
              children: [
                const Text("Animation Speed"),
                Slider(
                  min: 0.5,
                  max: 3.0,
                  divisions: 5,
                  label: _speed.toStringAsFixed(1),
                  value: _speed,
                  onChanged: _changeSpeed,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Toggle button
            ElevatedButton(
              onPressed: _toggleAnimation,
              child: Text(_isAnimating ? "Stop" : "Start"),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

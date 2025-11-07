import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

/// Animated splash screen with saffron–yellow gradient,
/// rotating ॐ logo, and smooth fade-in transition.
class SplashScreen extends StatefulWidget {
  final Duration duration;
  const SplashScreen({Key? key, this.duration = const Duration(seconds: 3)})
      : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _rotateController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    // Fade-in animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();

    // Continuous rotation animation for the logo
    _rotateController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat();

    // Navigate to main route after delay
    Timer(widget.duration, () {
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 3),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF9933), Color(0xFFFFF176)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_rotateController),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [AppTheme.saffron , AppTheme.deepSaffron!]),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5))
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "ॐ",
                        style: TextStyle(
                          fontSize: 52,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Pandittalk",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 3)
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Divine Guidance • Daily Wisdom",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

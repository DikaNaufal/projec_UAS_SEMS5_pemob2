// screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _glowController;
  late AnimationController _particleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _controller.forward();
    
    Timer(Duration(seconds: 3), () {
      // Navigate ke Login screen (bukan onboarding)
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00E676),
              Color(0xFF00BFA5),
              Color(0xFF00B0FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Animated particles
            ...List.generate(20, (index) {
              return AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  double angle = (index / 20) * 2 * math.pi;
                  double progress = (_particleController.value + (index / 20)) % 1.0;
                  double radius = 150 * progress;
                  double x = MediaQuery.of(context).size.width / 2 + 
                            math.cos(angle) * radius;
                  double y = MediaQuery.of(context).size.height / 2 + 
                            math.sin(angle) * radius;
                  
                  return Positioned(
                    left: x,
                    top: y,
                    child: Opacity(
                      opacity: 1.0 - progress,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xFFFFD600),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
            
            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Glowing icon
                          AnimatedBuilder(
                            animation: _glowController,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(
                                        0.3 + (_glowController.value * 0.4)
                                      ),
                                      blurRadius: 40 + (_glowController.value * 30),
                                      spreadRadius: 10 + (_glowController.value * 10),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.eco,
                                  size: 120,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 30),
                          // Title with glow
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: [
                                  Colors.white,
                                  Color(0xFFFFD600),
                                ],
                              ).createShader(bounds);
                            },
                            child: Text(
                              'EcoPet',
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 3,
                                shadows: [
                                  Shadow(
                                    color: Colors.white.withOpacity(0.8),
                                    blurRadius: 20,
                                  ),
                                  Shadow(
                                    color: Color(0xFFFFD600).withOpacity(0.6),
                                    blurRadius: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Tumbuhkan Hutan Virtualmu',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withOpacity(0.6),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          // Loading indicator
                          AnimatedBuilder(
                            animation: _glowController,
                            builder: (context, child) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 3,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
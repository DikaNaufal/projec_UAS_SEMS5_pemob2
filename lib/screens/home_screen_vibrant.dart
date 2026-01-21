// screens/home_screen_vibrant.dart
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  late AnimationController _shimmerController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat();
    
    _shimmerController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00E676),
              Color(0xFF00BFA5),
              Color(0xFFF5F9F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildVibrantHeader(appState),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildGlowingIsland(appState),
                      SizedBox(height: 25),
                      _buildVibrantQuickActions(),
                      SizedBox(height: 25),
                      _buildRecentActivity(appState),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildGlowingBottomNav(),
    );
  }

  Widget _buildVibrantHeader(AppState appState) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00E676), Color(0xFF00C853)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00E676).withOpacity(0.5),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [Colors.white, Color(0xFFFFD600)],
                  ).createShader(bounds);
                },
                child: Text(
                  'Hutan Level ${appState.forestLevel}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildAnimatedBadge(
                    icon: Icons.water_drop,
                    value: appState.waterDrops,
                    gradient: LinearGradient(
                      colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
                    ),
                  ),
                  SizedBox(width: 15),
                  _buildAnimatedBadge(
                    icon: Icons.wb_sunny,
                    value: appState.sunPoints,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                      blurRadius: 20 + (_glowController.value * 15),
                      spreadRadius: 5 + (_glowController.value * 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.person, color: Color(0xFF00E676), size: 28),
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBadge({
    required IconData icon,
    required int value,
    required Gradient gradient,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: value.toDouble()),
      duration: Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                animValue.toInt().toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlowingIsland(AppState appState) {
    double healthPercentage = appState.forestHealth / 100;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_floatingController, _glowController, _particleController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            math.sin(_floatingController.value * 2 * math.pi) * 8,
            math.sin(_floatingController.value * 2 * math.pi) * 12,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow particles orbiting
              ...List.generate(12, (index) {
                double angle = (index / 12) * 2 * math.pi;
                double radius = 140 + math.sin(_particleController.value * 2 * math.pi + index) * 25;
                double x = math.cos(angle + _particleController.value * 2 * math.pi) * radius;
                double y = math.sin(angle + _particleController.value * 2 * math.pi) * radius;
                
                Color particleColor = healthPercentage > 0.5 
                  ? Color(0xFF00E676) 
                  : Color(0xFFFF6D00);
                
                return Transform.translate(
                  offset: Offset(x, y),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          particleColor,
                          particleColor.withOpacity(0.3),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: particleColor.withOpacity(0.8),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              
              // Main island with enhanced glow
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                height: 340,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: healthPercentage > 0.7 
                      ? [
                          Color(0xFF00E676).withOpacity(0.4),
                          Color(0xFF00E676),
                          Color(0xFF00C853),
                        ]
                      : healthPercentage > 0.4
                        ? [
                            Color(0xFFFFD600).withOpacity(0.4),
                            Color(0xFFFFD600),
                            Color(0xFFFF6D00),
                          ]
                        : [
                            Color(0xFFFF6D00).withOpacity(0.4),
                            Color(0xFFFF6D00),
                            Color(0xFFD84315),
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: (healthPercentage > 0.7 
                        ? Color(0xFF00E676) 
                        : Color(0xFFFFD600)
                      ).withOpacity(0.4 + (_glowController.value * 0.3)),
                      blurRadius: 30 + (_glowController.value * 20),
                      spreadRadius: 10 + (_glowController.value * 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Shimmer effect
                    AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, child) {
                        return Positioned(
                          top: -100 + (_shimmerController.value * 500),
                          left: -50,
                          right: -50,
                          child: Transform.rotate(
                            angle: 0.3,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildVibrantTree(appState.forestLevel, healthPercentage),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.9),
                                  Colors.white.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Text(
                              '${appState.forestHealth.toInt()}% Sehat',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: healthPercentage > 0.7 
                                  ? Color(0xFF00C853) 
                                  : Color(0xFFFF6D00),
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    if (healthPercentage > 0.7) ..._buildFloatingAnimals(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVibrantTree(int level, double health) {
    int treeSize = 50 + (level * 12).clamp(0, 100);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 1200),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: 0.8 + (scale * 0.2) + (math.sin(_glowController.value * 2 * math.pi) * 0.05),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (health > 0.7 ? Color(0xFF00E676) : Color(0xFFFFD600))
                        .withOpacity(0.6),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: health > 0.7
                        ? [Color(0xFF00E676), Color(0xFF69F0AE)]
                        : [Color(0xFFFFD600), Color(0xFFFF6D00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.park,
                    size: treeSize.toDouble(),
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 5),
        Container(
          width: 25,
          height: 35,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFloatingAnimals() {
    return [
      Positioned(
        top: 50 + math.sin(_particleController.value * 2 * math.pi) * 15,
        left: 40,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF6D00).withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Icon(Icons.pets, color: Color(0xFFFF6D00), size: 28),
        ),
      ),
      Positioned(
        bottom: 80 + math.cos(_particleController.value * 2 * math.pi) * 15,
        right: 50,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xFF00B0FF).withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Icon(Icons.flutter_dash, color: Color(0xFF00B0FF), size: 28),
        ),
      ),
    ];
  }

  Widget _buildVibrantQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildGlowingActionButton(
            icon: Icons.add_circle,
            label: 'Log Habit',
            gradient: LinearGradient(
              colors: [Color(0xFF00E676), Color(0xFF00C853)],
            ),
            onTap: () => Navigator.pushNamed(context, '/habits'),
          ),
          _buildGlowingActionButton(
            icon: Icons.bar_chart,
            label: 'Statistik',
            gradient: LinearGradient(
              colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
            ),
            onTap: () => Navigator.pushNamed(context, '/statistics'),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingActionButton({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.3 + (_glowController.value * 0.3)),
                  blurRadius: 15 + (_glowController.value * 10),
                  spreadRadius: 2 + (_glowController.value * 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentActivity(AppState appState) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF5F9F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00E676).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 3,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00E676), Color(0xFF00C853)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.history, color: Colors.white, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'Aktivitas Terakhir',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C853),
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          ...appState.habitLogs.take(5).map((log) => _buildActivityItem(log)),
          if (appState.habitLogs.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Icon(Icons.eco, size: 50, color: Colors.grey[300]),
                    SizedBox(height: 10),
                    Text(
                      'Belum ada aktivitas.\nMulai log habit pertamamu!',
                      style: TextStyle(color: Colors.grey[500], fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(HabitLog log) {
    IconData icon = log.habitType.contains('water') ? Icons.water_drop : Icons.wb_sunny;
    Gradient gradient = log.habitType.contains('water')
      ? LinearGradient(colors: [Color(0xFF00B0FF), Color(0xFF0091EA)])
      : LinearGradient(colors: [Color(0xFFFFD600), Color(0xFFFF6D00)]);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              log.habitType,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+${log.reward}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingBottomNav() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF5F9F5)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00E676).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          switch (index) {
            case 0: break;
            case 1: Navigator.pushNamed(context, '/social'); break;
            case 2: Navigator.pushNamed(context, '/statistics'); break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Social'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
        selectedItemColor: Color(0xFF00E676),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
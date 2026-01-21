// screens/habit_tracker_screen_vibrant.dart
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'dart:math' as math;

class HabitTrackerScreen extends StatefulWidget {
  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> 
    with TickerProviderStateMixin {
  late AnimationController _cardAnimController;
  late AnimationController _rewardAnimController;
  late AnimationController _confettiController;
  late AnimationController _glowController;
  late AnimationController _pulseController;
  
  bool _showReward = false;
  int _lastReward = 0;
  String _lastHabit = '';
  Gradient? _lastGradient;

  final List<HabitOption> _habits = [
    HabitOption(
      name: 'Minum Air Putih 8 Gelas',
      icon: Icons.water_drop,
      reward: 10,
      type: 'water',
      gradient: LinearGradient(
        colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
      ),
    ),
    HabitOption(
      name: 'Jalan Kaki 30 Menit',
      icon: Icons.directions_walk,
      reward: 15,
      type: 'sun',
      gradient: LinearGradient(
        colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
      ),
    ),
    HabitOption(
      name: 'Tidak Pakai Sedotan Plastik',
      icon: Icons.no_drinks,
      reward: 8,
      type: 'water',
      gradient: LinearGradient(
        colors: [Color(0xFF00E676), Color(0xFF00C853)],
      ),
    ),
    HabitOption(
      name: 'Bawa Botol Minum Sendiri',
      icon: Icons.local_drink,
      reward: 12,
      type: 'water',
      gradient: LinearGradient(
        colors: [Color(0xFF40C4FF), Color(0xFF0091EA)],
      ),
    ),
    HabitOption(
      name: 'Naik Transportasi Umum',
      icon: Icons.directions_bus,
      reward: 20,
      type: 'sun',
      gradient: LinearGradient(
        colors: [Color(0xFF69F0AE), Color(0xFF00C853)],
      ),
    ),
    HabitOption(
      name: 'Matikan Lampu Saat Keluar',
      icon: Icons.lightbulb_outline,
      reward: 10,
      type: 'sun',
      gradient: LinearGradient(
        colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
      ),
    ),
    HabitOption(
      name: 'Daur Ulang Sampah',
      icon: Icons.recycling,
      reward: 15,
      type: 'sun',
      gradient: LinearGradient(
        colors: [Color(0xFF00E676), Color(0xFF00BFA5)],
      ),
    ),
    HabitOption(
      name: 'Bawa Tas Belanja Sendiri',
      icon: Icons.shopping_bag,
      reward: 10,
      type: 'water',
      gradient: LinearGradient(
        colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _cardAnimController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _rewardAnimController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _confettiController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cardAnimController.dispose();
    _rewardAnimController.dispose();
    _confettiController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                  _buildVibrantAppBar(appState),
                  _buildGlowingMotivationCard(appState),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: _habits.length,
                      itemBuilder: (context, index) {
                        return _buildVibrantHabitCard(_habits[index], appState, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (_showReward) _buildRewardExplosion(),
          if (_showReward) _buildConfettiExplosion(),
        ],
      ),
    );
  }

  Widget _buildVibrantAppBar(AppState appState) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00E676), Color(0xFF00C853)],
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
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [Colors.white, Color(0xFFFFD600)],
                ).createShader(bounds);
              },
              child: Text(
                'Log Kebiasaan Baik',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.6),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingMotivationCard(AppState appState) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF5F9F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00E676).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Text(
                  '🌱',
                  style: TextStyle(fontSize: 50),
                ),
              );
            },
          ),
          SizedBox(height: 12),
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [Color(0xFF00E676), Color(0xFF00BFA5)],
              ).createShader(bounds);
            },
            child: Text(
              'Terus Semangat!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Setiap habit yang kamu log akan membuat hutanmu tumbuh lebih subur!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGlowingStatChip(
                icon: Icons.water_drop,
                label: 'Air',
                value: appState.waterDrops.toString(),
                gradient: LinearGradient(
                  colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
                ),
              ),
              _buildGlowingStatChip(
                icon: Icons.wb_sunny,
                label: 'Matahari',
                value: appState.sunPoints.toString(),
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingStatChip({
    required IconData icon,
    required String label,
    required String value,
    required Gradient gradient,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: double.parse(value)),
      duration: Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3 + (_glowController.value * 0.3)),
                    blurRadius: 15 + (_glowController.value * 10),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    animatedValue.toInt().toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
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
      },
    );
  }

  Widget _buildVibrantHabitCard(HabitOption habit, AppState appState, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFF5F9F5)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _logHabit(habit, appState),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        AnimatedBuilder(
                          animation: _glowController,
                          builder: (context, child) {
                            return Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: habit.gradient,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(
                                      0.3 + (_glowController.value * 0.3)
                                    ),
                                    blurRadius: 15 + (_glowController.value * 10),
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                habit.icon,
                                color: Colors.white,
                                size: 32,
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    habit.type == 'water' 
                                      ? Icons.water_drop 
                                      : Icons.wb_sunny,
                                    size: 16,
                                    color: habit.type == 'water' 
                                      ? Color(0xFF00B0FF) 
                                      : Color(0xFFFFD600),
                                  ),
                                  SizedBox(width: 6),
                                  ShaderMask(
                                    shaderCallback: (bounds) {
                                      return habit.gradient.createShader(bounds);
                                    },
                                    child: Text(
                                      '+${habit.reward} poin',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _cardAnimController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _cardAnimController.value * 2 * math.pi,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: habit.gradient,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      blurRadius: 15,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRewardExplosion() {
    return AnimatedBuilder(
      animation: _rewardAnimController,
      builder: (context, child) {
        double scale = Curves.elasticOut.transform(
          _rewardAnimController.value.clamp(0.0, 1.0)
        );
        double opacity = _rewardAnimController.value.clamp(0.0, 1.0);
        
        return Container(
          color: Colors.black.withOpacity(0.6 * opacity),
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: Container(
                margin: EdgeInsets.all(40),
                padding: EdgeInsets.all(35),
                decoration: BoxDecoration(
                  gradient: _lastGradient ?? LinearGradient(
                    colors: [Color(0xFF00E676), Color(0xFF00C853)],
                  ),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 40,
                      spreadRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_pulseController.value * 0.15),
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.8),
                                  blurRadius: 25,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xFF00E676),
                              size: 55,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 25),
                    Text(
                      'Luar Biasa! 🎉',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 10,
                          ),
                          Shadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      _lastHabit,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: _lastReward.toDouble()),
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            '+${value.toInt()} poin',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfettiExplosion() {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        return IgnorePointer(
          child: Stack(
            children: List.generate(40, (index) {
              double angle = (index / 40) * 2 * math.pi;
              double distance = _confettiController.value * 400;
              double x = MediaQuery.of(context).size.width / 2 + 
                         math.cos(angle) * distance;
              double y = MediaQuery.of(context).size.height / 2 + 
                         math.sin(angle) * distance - 
                         (_confettiController.value * 250);
              
              List<Color> colors = [
                Color(0xFF00E676),
                Color(0xFF00B0FF),
                Color(0xFFFFD600),
                Color(0xFFFF6D00),
                Color(0xFFFF4081),
                Color(0xFF7C4DFF),
              ];
              
              Color color = colors[index % 6];
              
              return Positioned(
                left: x,
                top: y,
                child: Opacity(
                  opacity: 1.0 - _confettiController.value,
                  child: Transform.rotate(
                    angle: _confettiController.value * 6 * math.pi,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [color, color.withOpacity(0.5)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.8),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  void _logHabit(HabitOption habit, AppState appState) async {
    _cardAnimController.forward().then((_) {
      _cardAnimController.reverse();
    });
    
    appState.logHabit(habit.name, habit.reward);
    
    setState(() {
      _showReward = true;
      _lastReward = habit.reward;
      _lastHabit = habit.name;
      _lastGradient = habit.gradient;
    });
    
    _rewardAnimController.forward(from: 0.0);
    _confettiController.forward(from: 0.0);
    
    Future.delayed(Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _showReward = false;
        });
        _rewardAnimController.reset();
        _confettiController.reset();
      }
    });
  }
}

class HabitOption {
  final String name;
  final IconData icon;
  final int reward;
  final String type;
  final Gradient gradient;

  HabitOption({
    required this.name,
    required this.icon,
    required this.reward,
    required this.type,
    required this.gradient,
  });
}
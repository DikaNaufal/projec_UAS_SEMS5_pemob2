// screens/statistics_screen.dart
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'dart:math' as math;

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _glowController;
  String _selectedPeriod = 'Minggu';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    
    _glowController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    _glowController.dispose();
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
              Color(0xFFFFD600),
              Color(0xFFFF6D00),
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
              _buildVibrantAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildGlowingOverviewCard(appState),
                      _buildPeriodSelector(),
                      _buildRootVisualization(appState),
                      _buildActivityBreakdown(appState),
                      _buildVibrantAchievements(appState),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVibrantAppBar() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD600).withOpacity(0.5),
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
                  colors: [Colors.white, Color(0xFF00E676)],
                ).createShader(bounds);
              },
              child: Text(
                'Statistik & Progress',
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

  Widget _buildGlowingOverviewCard(AppState appState) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD600).withOpacity(0.4),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Total Poin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(color: Colors.black26, blurRadius: 5),
              ],
            ),
          ),
          SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0.0,
              end: (appState.waterDrops + appState.sunPoints).toDouble(),
            ),
            duration: Duration(milliseconds: 2000),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [Colors.white, Color(0xFF00E676)],
                  ).createShader(bounds);
                },
                child: Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatBadge(
                icon: Icons.water_drop,
                label: 'Air',
                value: appState.waterDrops.toString(),
                gradient: LinearGradient(
                  colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
                ),
              ),
              Container(width: 2, height: 50, color: Colors.white30),
              _buildStatBadge(
                icon: Icons.wb_sunny,
                label: 'Matahari',
                value: appState.sunPoints.toString(),
                gradient: LinearGradient(
                  colors: [Color(0xFF00E676), Color(0xFF00C853)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required String label,
    required String value,
    required Gradient gradient,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: double.parse(value)),
      duration: Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4 + (_glowController.value * 0.3)),
                    blurRadius: 15 + (_glowController.value * 10),
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(icon, color: Colors.white, size: 32),
                  SizedBox(height: 8),
                  Text(
                    animValue.toInt().toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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

  Widget _buildPeriodSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _buildPeriodButton('Hari'),
          SizedBox(width: 10),
          _buildPeriodButton('Minggu'),
          SizedBox(width: 10),
          _buildPeriodButton('Bulan'),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    bool isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = period;
          });
        },
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Color(0xFFFFD600).withOpacity(0.4 + (_glowController.value * 0.2)),
                          blurRadius: 15 + (_glowController.value * 8),
                          spreadRadius: 2,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
              ),
              child: Text(
                period,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 16,
                  shadows: isSelected
                      ? [Shadow(color: Colors.black26, blurRadius: 5)]
                      : [],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRootVisualization(AppState appState) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF5F9F5)],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00E676), Color(0xFF00C853)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.park, color: Colors.white, size: 28),
              ),
              SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [Color(0xFF00E676), Color(0xFF00C853)],
                  ).createShader(bounds);
                },
                child: Text(
                  'Akar Progressmu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          _buildGlowingRootBranch(
            'Kebiasaan Air',
            appState.waterDrops.toDouble(),
            LinearGradient(
              colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
            ),
          ),
          SizedBox(height: 18),
          _buildGlowingRootBranch(
            'Kebiasaan Matahari',
            appState.sunPoints.toDouble(),
            LinearGradient(
              colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
            ),
          ),
          SizedBox(height: 18),
          _buildGlowingRootBranch(
            'Kesehatan Hutan',
            appState.forestHealth,
            LinearGradient(
              colors: [Color(0xFF00E676), Color(0xFF00C853)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingRootBranch(String label, double value, Gradient gradient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: value),
              duration: Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, animValue, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return gradient.createShader(bounds);
                  },
                  child: Text(
                    animValue.toInt().toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Container(
                  height: 16,
                  width: MediaQuery.of(context).size.width *
                      (value / 200).clamp(0.0, 1.0) *
                      _animController.value *
                      0.8,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityBreakdown(AppState appState) {
    Map<String, int> activityCount = {};
    
    for (var log in appState.habitLogs) {
      activityCount[log.habitType] = (activityCount[log.habitType] ?? 0) + 1;
    }

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breakdown Aktivitas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          if (activityCount.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Belum ada data aktivitas',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...activityCount.entries.take(5).map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      '${entry.value}x',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildVibrantAchievements(AppState appState) {
    List<Achievement> achievements = [
      Achievement(
        name: 'Pemula Hijau',
        description: 'Log 5 kebiasaan',
        icon: Icons.eco,
        unlocked: appState.habitLogs.length >= 5,
        gradient: LinearGradient(
          colors: [Color(0xFF00E676), Color(0xFF00C853)],
        ),
      ),
      Achievement(
        name: 'Pejuang Lingkungan',
        description: 'Capai level 5',
        icon: Icons.military_tech,
        unlocked: appState.forestLevel >= 5,
        gradient: LinearGradient(
          colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
        ),
      ),
      Achievement(
        name: 'Raja Air',
        description: 'Kumpulkan 100 tetes air',
        icon: Icons.water_drop,
        unlocked: appState.waterDrops >= 100,
        gradient: LinearGradient(
          colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
        ),
      ),
      Achievement(
        name: 'Master Matahari',
        description: 'Kumpulkan 100 sinar',
        icon: Icons.wb_sunny,
        unlocked: appState.sunPoints >= 100,
        gradient: LinearGradient(
          colors: [Color(0xFFFF6D00), Color(0xFFFFD600)],
        ),
      ),
    ];

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF5F9F5)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD600).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '🏆',
                style: TextStyle(fontSize: 32),
              ),
              SizedBox(width: 10),
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
                  ).createShader(bounds);
                },
                child: Text(
                  'Pencapaian',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.0,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              return _buildGlowingAchievementCard(achievements[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingAchievementCard(Achievement achievement) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: achievement.unlocked
                ? achievement.gradient
                : LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey[200]!],
                  ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: achievement.unlocked
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3 + (_glowController.value * 0.3)),
                      blurRadius: 15 + (_glowController.value * 10),
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                achievement.icon,
                size: 44,
                color: achievement.unlocked ? Colors.white : Colors.grey[400],
                shadows: achievement.unlocked
                    ? [
                        Shadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 15,
                        ),
                      ]
                    : [],
              ),
              SizedBox(height: 12),
              Text(
                achievement.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: achievement.unlocked ? Colors.white : Colors.grey[600],
                  shadows: achievement.unlocked
                      ? [Shadow(color: Colors.black26, blurRadius: 5)]
                      : [],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6),
              Text(
                achievement.description,
                style: TextStyle(
                  fontSize: 12,
                  color: achievement.unlocked
                      ? Colors.white.withOpacity(0.9)
                      : Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

class Achievement {
  final String name;
  final String description;
  final IconData icon;
  final bool unlocked;
  final Gradient gradient;

  Achievement({
    required this.name,
    required this.description,
    required this.icon,
    required this.unlocked,
    required this.gradient,
  });
}
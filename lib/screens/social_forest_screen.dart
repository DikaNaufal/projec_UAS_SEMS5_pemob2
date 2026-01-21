// screens/social_forest_screen_vibrant.dart
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'dart:math' as math;

class SocialForestScreen extends StatefulWidget {
  @override
  _SocialForestScreenState createState() => _SocialForestScreenState();
}

class _SocialForestScreenState extends State<SocialForestScreen> 
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _glowController;
  
  final List<Friend> _mockFriends = [
    Friend(name: 'Budi Santoso', level: 8),
    Friend(name: 'Siti Rahma', level: 12),
    Friend(name: 'Ahmad Rifai', level: 6),
    Friend(name: 'Dewi Lestari', level: 15),
    Friend(name: 'Eko Prasetyo', level: 9),
    Friend(name: 'Fitri Handayani', level: 7),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
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
              _buildVibrantAppBar(),
              _buildMyGlowingForestCard(appState),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Icon(Icons.people, color: Color(0xFF00E676), size: 28),
                    SizedBox(width: 10),
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [Color(0xFF00E676), Color(0xFF00C853)],
                        ).createShader(bounds);
                      },
                      child: Text(
                        'Hutan Teman',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _mockFriends.length,
                  itemBuilder: (context, index) {
                    return _buildVibrantFriendCard(_mockFriends[index], appState, index);
                  },
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
                'Social Forest',
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
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4 + (_glowController.value * 0.3)),
                      blurRadius: 15 + (_glowController.value * 10),
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22,
                  child: IconButton(
                    icon: Icon(Icons.person_add, color: Color(0xFF00E676), size: 24),
                    onPressed: _showAddFriendDialog,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMyGlowingForestCard(AppState appState) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00E676), Color(0xFF00C853)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00E676).withOpacity(0.5),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4 + (_glowController.value * 0.3)),
                      blurRadius: 15 + (_glowController.value * 10),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.eco,
                  size: 55,
                  color: Colors.white,
                ),
              );
            },
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hutanku',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 8,
                      ),
                      Shadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Level ${appState.forestLevel}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildMiniStat(Icons.water_drop, appState.waterDrops),
                    SizedBox(width: 15),
                    _buildMiniStat(Icons.wb_sunny, appState.sunPoints),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, int value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 20),
        SizedBox(width: 5),
        Text(
          value.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildVibrantFriendCard(Friend friend, AppState appState, int index) {
    Color levelColor = _getLevelGradientColor(friend.level);
    bool canWater = friend.lastWatered == null || 
      DateTime.now().difference(friend.lastWatered!).inHours > 24;

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
                    color: levelColor.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                levelColor.withOpacity(0.3),
                                levelColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: levelColor.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [levelColor, levelColor.withOpacity(0.7)],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.6),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Text(
                              '${friend.level}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            friend.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.eco, color: levelColor, size: 18),
                              SizedBox(width: 6),
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    colors: [levelColor, levelColor.withOpacity(0.7)],
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  'Level ${friend.level}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (friend.lastWatered != null)
                            Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                'Disiram ${_getTimeAgo(friend.lastWatered!)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: canWater 
                            ? 1.0 + (_waveController.value * 0.15) 
                            : 1.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: canWater
                                  ? LinearGradient(
                                      colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
                                    )
                                  : null,
                              color: canWater ? null : Colors.grey[300],
                              shape: BoxShape.circle,
                              boxShadow: canWater
                                  ? [
                                      BoxShadow(
                                        color: Color(0xFF00B0FF).withOpacity(
                                          0.4 + (_waveController.value * 0.3)
                                        ),
                                        blurRadius: 15 + (_waveController.value * 10),
                                        spreadRadius: 3,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.water_drop,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: canWater 
                                ? () => _waterFriend(friend, appState) 
                                : null,
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

  Color _getLevelGradientColor(int level) {
    if (level >= 15) return Color(0xFF9C27B0);
    if (level >= 10) return Color(0xFFFF6D00);
    if (level >= 5) return Color(0xFF00E676);
    return Color(0xFF00B0FF);
  }

  String _getTimeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else {
      return 'Baru saja';
    }
  }

  void _waterFriend(Friend friend, AppState appState) {
    appState.waterFriendForest(friend.name);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.water_drop, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Kamu menyiram hutan ${friend.name}! 💚',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF00B0FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.all(15),
      ),
    );

    setState(() {});
  }

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00E676), Color(0xFF00C853)],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_add, color: Colors.white, size: 50),
                SizedBox(height: 15),
                Text(
                  'Tambah Teman',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan kode teman',
                    hintStyle: TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'Atau bagikan kode milikmu:',
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [Color(0xFF00E676), Color(0xFF00C853)],
                          ).createShader(bounds);
                        },
                        child: Text(
                          'ECOPET-${math.Random().nextInt(9999).toString().padLeft(4, '0')}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.copy, color: Color(0xFF00E676)),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Teman berhasil ditambahkan!'),
                              backgroundColor: Color(0xFF00E676),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Tambah',
                          style: TextStyle(
                            color: Color(0xFF00E676),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
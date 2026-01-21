// screens/onboarding_screen.dart
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.forest,
      title: 'Tumbuhkan Hutanmu',
      description: 'Setiap kebiasaan baik yang kamu lakukan akan menumbuhkan pohon virtualmu',
      gradient: LinearGradient(
        colors: [Color(0xFF00E676), Color(0xFF00C853)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    OnboardingPage(
      icon: Icons.water_drop,
      title: 'Kumpulkan Poin',
      description: 'Dapatkan tetesan air dan sinar matahari dari aktivitas ramah lingkungan',
      gradient: LinearGradient(
        colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    OnboardingPage(
      icon: Icons.people,
      title: 'Social Forest',
      description: 'Lihat hutan temanmu dan saling support untuk tumbuh bersama',
      gradient: LinearGradient(
        colors: [Color(0xFFFF6D00), Color(0xFFFFD600)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildDot(index),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _currentPage == _pages.length - 1
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFD600).withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Mulai Sekarang',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text(
                      'Lewati',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Container(
      decoration: BoxDecoration(
        gradient: page.gradient,
      ),
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing icon
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.6),
                  blurRadius: 40,
                  spreadRadius: 15,
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 150,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 50),
          Text(
            page.title,
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
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 25),
          Text(
            page.description,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.5,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 8,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 12,
      width: _currentPage == index ? 40 : 12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: _currentPage == index ? [
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ] : [],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
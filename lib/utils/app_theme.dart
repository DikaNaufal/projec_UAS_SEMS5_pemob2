// lib/utils/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Vibrant Primary Colors
  static const Color primaryGreen = Color(0xFF00E676);
  static const Color darkGreen = Color(0xFF00C853);
  static const Color lightGreen = Color(0xFF69F0AE);
  
  // Accent Colors - More Vibrant
  static const Color electricBlue = Color(0xFF00B0FF);
  static const Color skyBlue = Color(0xFF40C4FF);
  static const Color sunYellow = Color(0xFFFFD600);
  static const Color sunOrange = Color(0xFFFF6D00);
  static const Color vibrantPink = Color(0xFFFF4081);
  static const Color purple = Color(0xFF7C4DFF);
  
  // Background Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunGradient = LinearGradient(
    colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient islandGradient = LinearGradient(
    colors: [
      Color(0xFF69F0AE),
      Color(0xFF00E676),
      Color(0xFF00C853),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Glow Effects
  static BoxShadow glowEffect({Color? color, double blur = 20}) {
    return BoxShadow(
      color: (color ?? primaryGreen).withOpacity(0.6),
      blurRadius: blur,
      spreadRadius: blur / 4,
    );
  }
  
  static List<BoxShadow> multiGlow({
    required Color color,
    int layers = 3,
  }) {
    return List.generate(layers, (index) {
      return BoxShadow(
        color: color.withOpacity(0.3 - (index * 0.1)),
        blurRadius: 15.0 + (index * 10),
        spreadRadius: 3.0 + (index * 2),
      );
    });
  }
  
  // Card Decorations
  static BoxDecoration vibrantCard({
    Gradient? gradient,
    Color? color,
    bool withGlow = true,
  }) {
    return BoxDecoration(
      gradient: gradient,
      color: color,
      borderRadius: BorderRadius.circular(25),
      boxShadow: withGlow ? [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 15,
          offset: Offset(0, 5),
        ),
        if (gradient != null || color != null)
          glowEffect(
            color: color ?? primaryGreen,
            blur: 25,
          ),
      ] : null,
    );
  }
  
  // Text Styles with Glow
  static TextStyle glowText({
    required double fontSize,
    Color color = Colors.white,
    FontWeight weight = FontWeight.bold,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: weight,
      color: color,
      shadows: [
        Shadow(
          color: color.withOpacity(0.8),
          blurRadius: 15,
        ),
        Shadow(
          color: color.withOpacity(0.5),
          blurRadius: 25,
        ),
      ],
    );
  }
  
  // Button Styles
  static BoxDecoration vibrantButton(Color color) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          color,
          Color.lerp(color, Colors.white, 0.2)!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: multiGlow(color: color),
    );
  }
  
  // Icon with Glow
  static Widget glowIcon({
    required IconData icon,
    required Color color,
    double size = 24,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}
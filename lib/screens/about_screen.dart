// screens/about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang EcoPet'),
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.eco,
                    size: 100,
                    color: Color(0xFF4CAF50),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'EcoPet',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  Text(
                    'Versi 1.0.0',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            _buildSection(
              title: 'Tentang Aplikasi',
              content: 'EcoPet adalah aplikasi habit tracker yang menggabungkan konsep keberlanjutan dengan gamifikasi. Setiap kebiasaan baik yang kamu lakukan akan menumbuhkan hutan virtualmu, membuat bumi menjadi tempat yang lebih baik.',
              icon: Icons.info,
            ),
            SizedBox(height: 20),
            _buildSection(
              title: 'Misi Kami',
              content: 'Memotivasi masyarakat untuk mengadopsi gaya hidup yang lebih ramah lingkungan melalui pendekatan yang menyenangkan dan interaktif. Kami percaya bahwa perubahan kecil dari setiap individu dapat membuat dampak besar bagi planet kita.',
              icon: Icons.flag,
            ),
            SizedBox(height: 20),
            _buildSection(
              title: 'Fitur Utama',
              content: null,
              icon: Icons.star,
            ),
            _buildFeatureList(),
            SizedBox(height: 20),
            _buildSection(
              title: 'Tim Pengembang',
              content: 'Dikembangkan dengan ❤️ oleh tim yang peduli lingkungan. Kami adalah sekelompok developer dan environmentalist yang bersemangat untuk menciptakan teknologi yang membawa perubahan positif.',
              icon: Icons.people,
            ),
            SizedBox(height: 20),
            _buildSection(
              title: 'Kontak',
              content: null,
              icon: Icons.email,
            ),
            SizedBox(height: 10),
            _buildContactInfo(),
            SizedBox(height: 30),
            Center(
              child: Text(
                '© 2026 EcoPet. All rights reserved.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? content,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFF4CAF50), size: 28),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (content != null) ...[
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ],
    );
  }

  Widget _buildFeatureList() {
    final features = [
      'Log kebiasaan ramah lingkungan',
      'Visualisasi hutan virtual yang tumbuh',
      'Social Forest untuk berinteraksi dengan teman',
      'Statistik progress dengan tampilan akar pohon',
      'Sistem reward dan achievement',
    ];

    return Container(
      margin: EdgeInsets.only(top: 10, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features.map((feature) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContactItem(Icons.email, 'support@ecopet.app'),
          SizedBox(height: 10),
          _buildContactItem(Icons.language, 'www.ecopet.app'),
          SizedBox(height: 10),
          _buildContactItem(Icons.phone, '+62 812-3456-7890'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF4CAF50), size: 20),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
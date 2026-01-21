// screens/privacy_screen.dart
import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kebijakan Privasi'),
        backgroundColor: Color(0xFF9C27B0),
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
                    Icons.privacy_tip,
                    size: 80,
                    color: Color(0xFF9C27B0),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Kebijakan Privasi',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Terakhir diperbarui: 18 Januari 2026',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            _buildIntroduction(),
            SizedBox(height: 25),
            _buildSection(
              title: '1. Informasi yang Kami Kumpulkan',
              content: 'Kami mengumpulkan informasi yang Anda berikan secara langsung kepada kami, seperti ketika Anda membuat akun, log aktivitas, atau berinteraksi dengan pengguna lain. Informasi ini meliputi nama pengguna, data kebiasaan, dan statistik penggunaan aplikasi.',
            ),
            SizedBox(height: 20),
            _buildSection(
              title: '2. Penggunaan Informasi',
              content: 'Informasi yang kami kumpulkan digunakan untuk menyediakan, memelihara, dan meningkatkan layanan kami. Kami menggunakan data untuk personalisasi pengalaman pengguna, menampilkan progress hutan virtual, dan memfasilitasi fitur social forest.',
            ),
            SizedBox(height: 20),
            _buildSection(
              title: '3. Berbagi Informasi',
              content: 'Kami tidak menjual, menyewakan, atau membagikan informasi pribadi Anda kepada pihak ketiga untuk tujuan pemasaran mereka. Informasi hanya dibagikan dengan persetujuan Anda atau dalam konteks fitur Social Forest di mana Anda memilih untuk terhubung dengan teman.',
            ),
            SizedBox(height: 20),
            _buildSection(
              title: '4. Keamanan Data',
              content: 'Kami menerapkan langkah-langkah keamanan teknis dan organisasi yang sesuai untuk melindungi informasi pribadi Anda dari akses, penggunaan, atau pengungkapan yang tidak sah. Data Anda dienkripsi dan disimpan dengan aman di server kami.',
            ),
            SizedBox(height: 20),
            _buildSection(
              title: '5. Hak Pengguna',
              content: 'Anda memiliki hak untuk mengakses, memperbarui, atau menghapus informasi pribadi Anda kapan saja. Anda juga dapat mengontrol preferensi privasi Anda melalui pengaturan aplikasi.',
            ),
            SizedBox(height: 20),
            _buildSection(
              title: '6. Data Anak-Anak',
              content: 'Layanan kami tidak ditujukan untuk anak-anak di bawah usia 13 tahun. Kami tidak secara sengaja mengumpulkan informasi pribadi dari anak-anak di bawah 13 tahun.',
            ),
            SizedBox(height: 20),
            _buildSection(
              title: '7. Cookies dan Teknologi Pelacakan',
              content: 'Kami menggunakan cookies dan teknologi pelacakan serupa untuk meningkatkan pengalaman pengguna dan menganalisis penggunaan aplikasi. Anda dapat mengontrol penggunaan cookies melalui pengaturan browser Anda.',
            ),
            SizedBox(height: 20),
            _buildSection(
              title: '8. Perubahan Kebijakan',
              content: 'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Kami akan memberi tahu Anda tentang perubahan dengan memposting kebijakan baru di halaman ini dan memperbarui tanggal "Terakhir diperbarui".',
            ),
            SizedBox(height: 30),
            _buildContactSection(),
            SizedBox(height: 20),
            _buildConsentBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroduction() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF9C27B0).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFF9C27B0).withOpacity(0.3),
        ),
      ),
      child: Text(
        'Di EcoPet, kami menghargai privasi Anda dan berkomitmen untuk melindungi informasi pribadi Anda. Kebijakan privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi data Anda.',
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.grey[800],
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9C27B0),
          ),
        ),
        SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.contact_mail, color: Color(0xFF9C27B0)),
              SizedBox(width: 10),
              Text(
                'Hubungi Kami',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Jika Anda memiliki pertanyaan tentang kebijakan privasi ini, silakan hubungi kami:',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.email, color: Color(0xFF9C27B0), size: 18),
              SizedBox(width: 8),
              Text('privacy@ecopet.app'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsentBox() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFF4CAF50),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Color(0xFF4CAF50),
            size: 30,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              'Dengan menggunakan EcoPet, Anda menyetujui kebijakan privasi ini.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
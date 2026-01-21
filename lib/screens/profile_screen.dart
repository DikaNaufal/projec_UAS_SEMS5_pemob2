// screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../models/app_state.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'EcoWarrior';
  bool _notificationsEnabled = true;
  String _selectedTheme = 'Hijau Hutan';

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(appState),
            _buildStatsGrid(appState),
            _buildSettingsSection(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AppState appState) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _editProfilePicture,
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: _editUserName,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.edit,
                  color: Colors.white70,
                  size: 18,
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Member sejak Jan 2026',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(AppState appState) {
    return Container(
      margin: EdgeInsets.all(20),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.3,
        children: [
          _buildStatCard(
            icon: Icons.eco,
            title: 'Level Hutan',
            value: appState.forestLevel.toString(),
            color: Color(0xFF4CAF50),
          ),
          _buildStatCard(
            icon: Icons.favorite,
            title: 'Kesehatan',
            value: '${appState.forestHealth.toInt()}%',
            color: Color(0xFFE91E63),
          ),
          _buildStatCard(
            icon: Icons.local_fire_department,
            title: 'Total Aktivitas',
            value: appState.habitLogs.length.toString(),
            color: Color(0xFFFF9800),
          ),
          _buildStatCard(
            icon: Icons.emoji_events,
            title: 'Total Poin',
            value: '${appState.waterDrops + appState.sunPoints}',
            color: Color(0xFFFFC107),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 35),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.notifications,
            title: 'Notifikasi',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              activeColor: Color(0xFF4CAF50),
            ),
          ),
          Divider(height: 1),
          _buildSettingTile(
            icon: Icons.palette,
            title: 'Tema',
            subtitle: _selectedTheme,
            trailing: Icon(Icons.chevron_right),
            onTap: _selectTheme,
          ),
          Divider(height: 1),
          _buildSettingTile(
            icon: Icons.language,
            title: 'Bahasa',
            subtitle: 'Indonesia',
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fitur dalam pengembangan')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF4CAF50)),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildActionButton(
            icon: Icons.info,
            label: 'Tentang Aplikasi',
            color: Color(0xFF2196F3),
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
          SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.privacy_tip,
            label: 'Kebijakan Privasi',
            color: Color(0xFF9C27B0),
            onTap: () => Navigator.pushNamed(context, '/privacy'),
          ),
          SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.logout,
            label: 'Keluar',
            color: Color(0xFFF44336),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 15),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }

  void _editProfilePicture() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur ubah foto profil dalam pengembangan'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  void _editUserName() {
    showDialog(
      context: context,
      builder: (context) {
        String newName = _userName;
        return AlertDialog(
          title: Text('Edit Nama'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Masukkan nama baru',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              newName = value;
            },
            controller: TextEditingController(text: _userName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userName = newName.isNotEmpty ? newName : _userName;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _selectTheme() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption('Hijau Hutan'),
              _buildThemeOption('Biru Samudra'),
              _buildThemeOption('Coklat Tanah'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(String theme) {
    return RadioListTile<String>(
      title: Text(theme),
      value: theme,
      groupValue: _selectedTheme,
      onChanged: (value) {
        setState(() {
          _selectedTheme = value!;
        });
        Navigator.pop(context);
      },
      activeColor: Color(0xFF4CAF50),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Keluar'),
          content: Text('Apakah kamu yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/onboarding',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF44336),
                foregroundColor: Colors.white,
              ),
              child: Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
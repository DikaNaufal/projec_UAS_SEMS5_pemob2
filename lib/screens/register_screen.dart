// screens/register_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> 
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  late AnimationController _glowController;
  late AnimationController _particleController;
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFD600),
                  Color(0xFFFF6D00),
                  Color(0xFF00E676),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // Animated Particles
          ...List.generate(20, (index) {
            return AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                double angle = (index / 20) * 2 * math.pi;
                double progress = (_particleController.value + (index / 20)) % 1.0;
                double radius = 250 * progress;
                double x = MediaQuery.of(context).size.width / 2 + 
                          math.cos(angle + _particleController.value * 2 * math.pi) * radius;
                double y = MediaQuery.of(context).size.height / 2 + 
                          math.sin(angle + _particleController.value * 2 * math.pi) * radius;
                
                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: 0.5 - (progress * 0.4),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.2),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.7),
                            blurRadius: 18,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    _buildHeader(),
                    SizedBox(height: 35),
                    _buildRegisterForm(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        SizedBox(height: 10),
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFF00E676)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4 + (_glowController.value * 0.4)),
                    blurRadius: 30 + (_glowController.value * 20),
                    spreadRadius: 8 + (_glowController.value * 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_add,
                size: 60,
                color: Color(0xFFFFD600),
              ),
            );
          },
        ),
        SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [Colors.white, Color(0xFF00E676)],
            ).createShader(bounds);
          },
          child: Text(
            'Buat Akun Baru',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Mulai perjalanan hijau kamu!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 25,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildNameField(),
            SizedBox(height: 18),
            _buildEmailField(),
            SizedBox(height: 18),
            _buildPasswordField(),
            SizedBox(height: 18),
            _buildConfirmPasswordField(),
            SizedBox(height: 20),
            _buildTermsCheckbox(),
            SizedBox(height: 28),
            _buildRegisterButton(),
            SizedBox(height: 25),
            _buildLoginLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        hintText: 'Masukkan nama lengkap',
        prefixIcon: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00E676), Color(0xFF00C853)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color(0xFFF5F9F5),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama tidak boleh kosong';
        }
        if (value.length < 3) {
          return 'Nama minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'masukkan@email.com',
        prefixIcon: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.email, color: Colors.white, size: 20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color(0xFFF5F9F5),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        if (!value.contains('@')) {
          return 'Email tidak valid';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: '••••••••',
        prefixIcon: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.lock, color: Colors.white, size: 20),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color(0xFFF5F9F5),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        if (value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Konfirmasi Password',
        hintText: '••••••••',
        prefixIcon: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6D00), Color(0xFFFFD600)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.lock_outline, color: Colors.white, size: 20),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color(0xFFF5F9F5),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Konfirmasi password tidak boleh kosong';
        }
        if (value != _passwordController.text) {
          return 'Password tidak cocok';
        }
        return null;
      },
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
          activeColor: Color(0xFF00E676),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _agreeToTerms = !_agreeToTerms;
              });
            },
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
                children: [
                  TextSpan(text: 'Saya setuju dengan '),
                  TextSpan(
                    text: 'Syarat & Ketentuan',
                    style: TextStyle(
                      color: Color(0xFF00E676),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' dan '),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    style: TextStyle(
                      color: Color(0xFF00E676),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFFD600).withOpacity(0.4 + (_glowController.value * 0.3)),
                blurRadius: 20 + (_glowController.value * 15),
                spreadRadius: 3,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: _handleRegister,
              child: Center(
                child: Text(
                  'Daftar',
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sudah punya akun? ',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
              ).createShader(bounds);
            },
            child: Text(
              'Masuk',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFFD600).withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
              SizedBox(height: 20),
              Text(
                'Membuat akun...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Anda harus menyetujui Syarat & Ketentuan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implement Firebase register
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success and navigate
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Akun berhasil dibuat! 🎉'),
          backgroundColor: Color(0xFF00E676),
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> 
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _glowController;
  late AnimationController _particleController;
  late AnimationController _floatController;
  
  bool _isLoading = false;
  bool _obscurePassword = true;

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
    
    _floatController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    _floatController.dispose();
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
                  Color(0xFF00E676),
                  Color(0xFF00BFA5),
                  Color(0xFF00B0FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // Animated Particles
          ...List.generate(15, (index) {
            return AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                double angle = (index / 15) * 2 * math.pi;
                double progress = (_particleController.value + (index / 15)) % 1.0;
                double radius = 200 * progress;
                double x = MediaQuery.of(context).size.width / 2 + 
                          math.cos(angle) * radius;
                double y = MediaQuery.of(context).size.height / 2 + 
                          math.sin(angle) * radius;
                
                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: 0.6 - (progress * 0.5),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.3),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.6),
                            blurRadius: 15,
                            spreadRadius: 3,
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
                    SizedBox(height: 40),
                    _buildLogo(),
                    SizedBox(height: 50),
                    _buildLoginForm(),
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

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_glowController, _floatController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_floatController.value * 2 * math.pi) * 15),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFFFD600)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4 + (_glowController.value * 0.4)),
                      blurRadius: 30 + (_glowController.value * 20),
                      spreadRadius: 10 + (_glowController.value * 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.eco,
                  size: 80,
                  color: Color(0xFF00E676),
                ),
              ),
              SizedBox(height: 20),
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [Colors.white, Color(0xFFFFD600)],
                  ).createShader(bounds);
                },
                child: Text(
                  'EcoPet',
                  style: TextStyle(
                    fontSize: 48,
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
                'Selamat Datang Kembali!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
          ),
        );
      },
    );
  }

  Widget _buildLoginForm() {
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
            _buildEmailField(),
            SizedBox(height: 20),
            _buildPasswordField(),
            SizedBox(height: 12),
            _buildForgotPassword(),
            SizedBox(height: 30),
            _buildLoginButton(),
            SizedBox(height: 20),
            _buildDivider(),
            SizedBox(height: 20),
            _buildGoogleSignIn(),
            SizedBox(height: 20),
            _buildAnonymousSignIn(),
            SizedBox(height: 25),
            _buildRegisterLink(),
          ],
        ),
      ),
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
              colors: [Color(0xFF00E676), Color(0xFF00C853)],
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
              colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
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

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implement forgot password
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fitur reset password akan segera hadir')),
          );
        },
        child: Text(
          'Lupa Password?',
          style: TextStyle(
            color: Color(0xFF00E676),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00E676), Color(0xFF00C853)],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF00E676).withOpacity(0.4 + (_glowController.value * 0.3)),
                blurRadius: 20 + (_glowController.value * 15),
                spreadRadius: 3,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: _handleLogin,
              child: Center(
                child: Text(
                  'Masuk',
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

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Atau masuk dengan',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
      ],
    );
  }

  Widget _buildGoogleSignIn() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
  color: Colors.transparent,
  child: InkWell(
    borderRadius: BorderRadius.circular(15),
    onTap: _handleGoogleSignIn,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logo_google.png',  // ← Path ke file PNG
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) {
            // Fallback jika image tidak ditemukan
            return Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: Icon(
                Icons.g_mobiledata,
                color: Colors.grey[600],
                size: 20,
              ),
            );
          },
        ),
        SizedBox(width: 12),
        Text(
          'Masuk dengan Google',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    ),
  ),
),
    );
  }

  Widget _buildAnonymousSignIn() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00B0FF), Color(0xFF0091EA)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00B0FF).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: _handleAnonymousSignIn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Coba Tanpa Akun',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Belum punya akun? ',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/register');
          },
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [Color(0xFF00E676), Color(0xFF00C853)],
              ).createShader(bounds);
            },
            child: Text(
              'Daftar',
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
              colors: [Color(0xFF00E676), Color(0xFF00C853)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF00E676).withOpacity(0.5),
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
                'Memproses...',
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

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implement Firebase login
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Implement Google Sign In
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacementNamed(context, '/home');
  }

  void _handleAnonymousSignIn() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Implement Anonymous Sign In
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacementNamed(context, '/home');
  }
}
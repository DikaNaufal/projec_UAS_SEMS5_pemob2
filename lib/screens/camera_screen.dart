// screens/camera_screen.dart
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'dart:math' as math;

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  bool _isDetected = false;
  String _detectedItem = '';
  int _rewardPoints = 0;
  late AnimationController _scanController;

  final List<String> _detectableItems = [
    'Botol Minum',
    'Tas Belanja',
    'Sepeda',
    'Tumbler',
    'Tempat Makan',
  ];

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snap & AI Detector'),
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          _buildCameraPreview(),
          if (_isScanning) _buildScanningOverlay(),
          if (_isDetected) _buildDetectionResult(),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1565C0),
            Color(0xFF42A5F5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  Icons.camera_alt,
                  size: 100,
                  color: Colors.white54,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Arahkan kamera ke objek ramah lingkungan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              '(Botol minum, tas belanja, sepeda, dll)',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return AnimatedBuilder(
      animation: _scanController,
      builder: (context, child) {
        return Container(
          color: Colors.black54,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Mendeteksi objek...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetectionResult() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Color(0xFF4CAF50),
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                'Terdeteksi!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              SizedBox(height: 15),
              Text(
                _detectedItem,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xFF4CAF50), width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Color(0xFF4CAF50)),
                    SizedBox(width: 10),
                    Text(
                      '+$_rewardPoints poin',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isDetected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Scan Lagi'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final appState = AppStateProvider.of(context);
                      appState.addWaterDrops(_rewardPoints);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Poin berhasil ditambahkan!'),
                          backgroundColor: Color(0xFF4CAF50),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Klaim'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: _isScanning || _isDetected ? null : _startScan,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Color(0xFF2196F3), width: 5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.camera,
              size: 40,
              color: Color(0xFF2196F3),
            ),
          ),
        ),
      ),
    );
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
      _isDetected = false;
    });

    _scanController.repeat();

    // Simulate AI detection
    Future.delayed(Duration(seconds: 2), () {
      final random = math.Random();
      final detectedItem = _detectableItems[random.nextInt(_detectableItems.length)];
      final points = 10 + random.nextInt(15);

      setState(() {
        _isScanning = false;
        _isDetected = true;
        _detectedItem = detectedItem;
        _rewardPoints = points;
      });

      _scanController.stop();
      _scanController.reset();
    });
  }
}
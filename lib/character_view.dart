import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:threed/monster_view.dart';

class CharacterViewer extends StatefulWidget {
  const CharacterViewer({super.key});

  @override
  CharacterViewerState createState() => CharacterViewerState();
}

class CharacterViewerState extends State<CharacterViewer> {
  final Flutter3DController _femaleController = Flutter3DController();
  final Flutter3DController _maleController = Flutter3DController();
  bool _isFemaleSelected = true;
  bool _isAnimating = false;

  // Store initial camera positions
  final Map<String, List<double>> _initialCameraSettings = {
    'female': [-50, 90, 200],
    'male': [50, 90, 180],
  };

  //to track current orbit values
  double _femaleTheta = -50;
  double _maleTheta = 50;

  Flutter3DController get _currentController =>
      _isFemaleSelected ? _femaleController : _maleController;

  double get _currentTheta => _isFemaleSelected ? _femaleTheta : _maleTheta;

  set _currentTheta(double value) =>
      _isFemaleSelected ? _femaleTheta = value : _maleTheta = value;

  final Map<String, List<String>> _animations = {
    'female': ['Talk', 'fight', 'jump'],
    'male': ['Talk.001', 'Fight', 'Jump'],
  };

  void _rotateCharacter(bool isLeft) {
    _currentTheta = isLeft ? _currentTheta - 10 : _currentTheta + 10;
    _currentController.setCameraOrbit(_currentTheta, 90, 200);
  }

  void _resetCamera() {
    final settings = _isFemaleSelected
        ? _initialCameraSettings['female']!
        : _initialCameraSettings['male']!;
    _currentController.setCameraOrbit(settings[0], settings[1], settings[2]);
    _currentController.setCameraTarget(0.2, 0.8, 0);
    _currentController.resetAnimation();
    _currentController.pauseAnimation();
  }

  void _stopAllAnimations() {
    _femaleController.resetAnimation();
    _femaleController.pauseAnimation();
    _maleController.resetAnimation();
    _maleController.pauseAnimation();
    _isAnimating = false;
  }

  Future<void> _playAnimation(String animName, {bool bothModels = false}) async {
    if (_isAnimating) {
      _stopAllAnimations();
      await Future.delayed(const Duration(milliseconds: 100)); // Small delay to ensure clean transition
    }

    setState(() => _isAnimating = true);

    try {
      if (bothModels) {
        switch (animName.toLowerCase()) {
          case 'talk':
            _femaleController.playAnimation(animationName: 'Talk');
            _maleController.playAnimation(animationName: 'Talk.001');
            break;
          case 'fight':
            _femaleController.playAnimation(animationName: 'fight');
            _maleController.playAnimation(animationName: 'Fight');
            break;
        }
      } else {
        final animations = _isFemaleSelected ? _animations['female']! : _animations['male']!;
        final animationName = animations.firstWhere(
          (a) => a.toLowerCase().contains(animName.toLowerCase())
        );
        _currentController.playAnimation(animationName: animationName);
      }

      await Future.delayed(const Duration(seconds: 5));
      _stopAllAnimations();
    } catch (e) {
      debugPrint('Error playing animation: $e');
      _stopAllAnimations();
    }
  }

  Widget _buildAnimationButton(String label, String animation, {Color? color}) {
    return ElevatedButton(
      onPressed: () => _playAnimation(animation),
      style: color != null ? ElevatedButton.styleFrom(backgroundColor: color) : null,
      child: Text('$label ${_isFemaleSelected ? "Female" : "Male"}'),
    );
  }

  Widget _buildDualAnimationButton(String label, String animation, Color color) {
    return ElevatedButton(
      onPressed: () => _playAnimation(animation, bothModels: true),
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '3D Character Viewer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MonsterView()),
              ),
              label: const Text("Don't Click Me"),
              icon: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () => _rotateCharacter(true),
              child: const Icon(Icons.rotate_left),
            ),
            FloatingActionButton(
              onPressed: () => _rotateCharacter(false),
              child: const Icon(Icons.rotate_right),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('Female'),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Male'),
                  ),
                ],
                selected: {_isFemaleSelected},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isFemaleSelected = newSelection.first;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.restart_alt),
                onPressed: _resetCamera,
                tooltip: 'Reset Camera',
              ),
              const SizedBox(width: 16),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Flutter3DViewer(
                    enableTouch: true,
                    src: 'assets/models/woman_combo.glb',
                    controller: _femaleController,
                    onLoad: (String modelAddress) {
                      _femaleController.setCameraOrbit(
                        _initialCameraSettings['female']![0],
                        _initialCameraSettings['female']![1],
                        _initialCameraSettings['female']![2],
                      );
                      _femaleController.setCameraTarget(0.2, 0.8, 0);
                    },
                    onError: (String error) {
                      debugPrint('Error loading female character model: $error');
                    },
                  ),
                ),
                Expanded(
                  child: Flutter3DViewer(
                    enableTouch: true,
                    src: 'assets/models/man_combo.glb',
                    controller: _maleController,
                    onLoad: (String modelAddress) {
                      _maleController.setCameraOrbit(
                        _initialCameraSettings['male']![0],
                        _initialCameraSettings['male']![1],
                        _initialCameraSettings['male']![2],
                      );
                      _maleController.setCameraTarget(0.2, 0.8, 0);
                    },
                    onError: (String error) {
                      debugPrint('Error loading male character model: $error');
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Individual animations
                Wrap(
                  spacing: 8,
                  children: [
                    _buildAnimationButton('Talk', 'talk'),
                    _buildAnimationButton('Fight', 'fight'),
                    _buildAnimationButton('Jump', 'jump'),
                  ],
                ),
                const SizedBox(height: 8),
                // Dual animations
                Wrap(
                  spacing: 8,
                  children: [
                    _buildDualAnimationButton('Converse', 'talk', Colors.green),
                    _buildDualAnimationButton('Fight', 'fight', Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class CharacterViewer extends StatefulWidget {
  const CharacterViewer({super.key});

  @override
  CharacterViewerState createState() => CharacterViewerState();
}

class CharacterViewerState extends State<CharacterViewer> {
  final Flutter3DController _femaleController = Flutter3DController();
  final Flutter3DController _maleController = Flutter3DController();
  bool _isFemaleSelected = true;

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

  Future<void> loadAndPlayAnimation(Flutter3DController controller) async {
    try {
      final animations = await controller.getAvailableAnimations();
      log(animations.toString());

      if (animations.isNotEmpty) {
        controller.playAnimation(animationName: animations.first);
        await Future.delayed(const Duration(seconds: 10));
        controller.resetAnimation();
        controller.pauseAnimation();
        //controller.setCameraOrbit(50, 90, 200);
        // controller.setCameraTarget(0.2, 0.8, 0);
      } else {
        debugPrint('No animations found in the model.');
      }
    } catch (e) {
      debugPrint('Error loading animation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('3D Character Viewer'),
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
                    enableTouch: false,
                    src: 'assets/models/female1.glb',
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
                      debugPrint(
                          'Error loading female character model: $error');
                    },
                  ),
                ),
                Expanded(
                  child: Flutter3DViewer(
                    enableTouch: false,
                    src: 'assets/models/man_talk.glb',
                    controller: _maleController,
                    onLoad: (String modelAddress) {
                      _maleController.setCameraOrbit(
                        _initialCameraSettings['male']![0],
                        _initialCameraSettings['male']![1],
                        _initialCameraSettings['male']![2],
                      );
                      _maleController.setCameraTarget(0.2, 0.8, 0.2);
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => loadAndPlayAnimation(_currentController),
                  child: Text(
                      'Play ${_isFemaleSelected ? "Female" : "Male"} Animation'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

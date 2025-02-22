import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'dart:developer';

class MonsterView extends StatefulWidget {
  const MonsterView({super.key});

  @override
  State<MonsterView> createState() => _State();
}

class _State extends State<MonsterView> {
  final _controller = Flutter3DController();
  final List<String> _selectedAnimations = [
    'SK_Huggy|A_Huggy_Roar_SK_Huggy',
    'SK_Huggy|A_Huggy_MiniAlert_SK_Huggy',
    'SK_Huggy|A_Huggy_Run_SK_Huggy',
    'SK_Huggy|A_Huggy_Walk_SK_Huggy',
  ];

  Future<void> _playAnimation(String animationName) async {
    if (animationName == 'SK_Huggy|A_Huggy_Roar_SK_Huggy') {
      _controller.setCameraTarget(0, 0.33, -0.23);
      _controller.setCameraOrbit(0, 90, 0);
    } else if (animationName == 'SK_Huggy|A_Huggy_MiniAlert_SK_Huggy') {
      _controller.setCameraTarget(0, 0.3, -0.13);
      _controller.setCameraOrbit(0, 90, 100);
    } else {
      _controller.setCameraTarget(0, 0.2, 0);
      _controller.setCameraOrbit(0, 90, 50);
    }
    _controller.playAnimation(animationName: animationName);
    await Future.delayed(const Duration(seconds: 5));
    _controller.resetAnimation();
  }

  Future<void> _playRandomAnimation() async {
    final animations = await _controller.getAvailableAnimations();
    final remainingAnimations = animations
        .where((anim) => !_selectedAnimations.contains(anim))
        .toList();
    if (remainingAnimations.isNotEmpty) {
      final randomAnim = (remainingAnimations..shuffle()).first;
      log(randomAnim);
      _playAnimation(randomAnim);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monster View')),
      body: Column(
        children: [
          Expanded(
            child: Flutter3DViewer(
              enableTouch: false,
              src: 'assets/models/huggy.glb',
              controller: _controller,
              onLoad: (String modelAddress) {
                _controller.playAnimation(
                    animationName: _selectedAnimations[0]);
                _controller.setCameraTarget(0, 0.33, -0.23);
                _controller.setCameraOrbit(0, 90, 0);
                _controller.resetAnimation();
              },
              onError: (String error) {
                debugPrint('Error loading monster model: $error');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _playAnimation(_selectedAnimations[0]),
                  child: const Text('Roar'),
                ),
                ElevatedButton(
                  onPressed: () => _playAnimation(_selectedAnimations[1]),
                  child: const Text('Jumpscare'),
                ),
                ElevatedButton(
                  onPressed: () => _playAnimation(_selectedAnimations[2]),
                  child: const Text('Run'),
                ),
                ElevatedButton(
                  onPressed: () => _playAnimation(_selectedAnimations[3]),
                  child: const Text('Walk'),
                ),
                ElevatedButton(
                  onPressed: _playRandomAnimation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text('Random'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

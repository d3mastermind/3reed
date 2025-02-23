# 3D Character Viewer

3reed is a Flutter application that demonstrates interactive 3D character visualization with animated models. This project combines ReadyPlayer.me avatars with Mixamo animations to create an engaging 3D character viewing experience.

## Live Preview

[View Live Demo on Appetize.io](https://appetize.io/embed/b_d6uavy76zba64e5vzfxplachlu)

## Demo

![Demo Preview](https://github.com/d3mastermind/3reed/blob/main/Media/threed.gif)

For a full video demonstration, check out our [detailed walkthrough](https://github.com/d3mastermind/3reed/blob/main/Media/threed.mp4).

## Download

[![Download APK](https://img.shields.io/badge/Download-APK-green.svg)](https://github.com/d3mastermind/3reed/blob/3c4d8bfaa41042071c3906df6df8cf7544774c34/APK/app-release.apk)

## Features

- Display of both male and female 3D characters simultaneously
- Interactive camera controls for character rotation
- Multiple animation sequences for each character:
  - Individual animations (Talk, Fight, Jump)
  - Synchronized dual-character animations (Conversation, Fight)
- Touch-enabled 3D model interaction
- Camera position reset functionality
- Easy character selection with segmented control

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- flutter_3d_controller package

## Project Setup

1. Clone the repository
2. Add the following files to your assets:
   ```
   assets/
   ├── models/
   │   ├── woman_combo.glb
   │   └── man_combo.glb
   ```

## Model Preparation

This project uses custom 3D models that combine ReadyPlayer.me avatars with Mixamo animations:

1. Create your avatar at [ReadyPlayer.me](https://readyplayer.me)
2. Download the avatar in GLB format
3. Go to [Mixamo](https://www.mixamo.com) Download desired animations in FBX format
5. Combine the animations with the base model using a Blender or any £D application

### Included Animations

Female Character:
- Talk
- Fight
- Jump

Male Character:
- Talk.001
- Fight
- Jump

## Camera Controls

- Use the floating action buttons to rotate characters left or right
- Tap the reset icon to return to the default camera position
- Enable touch interaction for direct model manipulation

## Animation Controls

Individual Animations:
- Talk - Triggers talking animation for selected character
- Fight - Triggers fighting animation for selected character
- Jump - Triggers jumping animation for selected character

Dual Character Animations:
- Converse - Synchronizes talking animations between both characters
- Fight - Synchronizes fighting animations between both characters

## Dependencies

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_3d_controller: ^latest_version
```



## Acknowledgments

- [ReadyPlayer.me](https://readyplayer.me) for the base 3D character models
- [Mixamo](https://www.mixamo.com) for the character animations
- [HNG Internship](https://hng.tech/internship)

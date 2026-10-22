import 'package:flutter/material.dart';
import 'package:memory_game/home_screen.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final audioContext = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {AVAudioSessionOptions.mixWithOthers},
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.none,
      ),
    );
    AudioPlayer.global.setAudioContext(audioContext);
  } catch (e) {
    debugPrint("Error configurando audioContext: $e");
  }

  runApp(
    const MaterialApp(
      title: 'Memory Match',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}

class CustomText extends StatelessWidget {
  final String text;
  final Color color;

  const CustomText({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: TextStyle(color: color),
    );
  }
}

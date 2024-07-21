import 'package:flutter/material.dart';
import 'package:music_player/provider/music_provider.dart';
import 'package:music_player/screens/base_screen.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(ChangeNotifierProvider(create: (context) => MusicProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
        home: const BaseScreen());
  }
}

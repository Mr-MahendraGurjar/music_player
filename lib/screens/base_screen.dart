import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:music_player/gen/assets.gen.dart';
import 'package:music_player/provider/music_provider.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/profile_screen.dart';
import 'package:music_player/screens/search_screen.dart';
import 'package:music_player/screens/users_screen.dart';
import 'package:music_player/screens/voice_screen.dart';
import 'package:music_player/widgets/gradient_circle_painter.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const VoiceScreen(),
    const UsersScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: IgnorePointer(
            ignoring: true,
            child: _buildBottomNavigationBar()),
        body: Consumer<MusicProvider>(builder: (context, value, child) => _screens[value.currentIndex]));
  }

  Consumer<MusicProvider> _buildBottomNavigationBar() {
    return Consumer<MusicProvider>(
        builder: (context, value, child) => BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: value.currentIndex,
            selectedItemColor: Colors.white,
            backgroundColor: _getBackgroundColor(value),
            items: _buildBottomNavigationBarItems(value)));
  }

  Color _getBackgroundColor(MusicProvider value) {
    return value.isPlayerDockVisible ? const Color(0xff171E26).withOpacity(0.7) : const Color(0xff171E26);
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems(MusicProvider value) {
    return [
      _buildBottomNavigationBarItem(Assets.homeFillIcon, value),
      _buildBottomNavigationBarItem(Assets.search, value),
      _buildGradientCircleItem(Assets.mic, value),
      _buildBottomNavigationBarItem(Assets.usersIcon, value),
      _buildAvatarItem(Assets.avatar.image(height: 30, width: 30), value)
    ];
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(String asset, MusicProvider value) {
    return BottomNavigationBarItem(
        icon: SvgPicture.asset(asset), label: '', backgroundColor: _getBackgroundColor(value));
  }

  BottomNavigationBarItem _buildGradientCircleItem(String asset, MusicProvider value) {
    return BottomNavigationBarItem(
        icon: CustomPaint(
            painter: GradientCirclePainter(),
            child: CircleAvatar(
                radius: 24, backgroundColor: Colors.transparent, child: SvgPicture.asset(asset))),
        label: '',
        backgroundColor: _getBackgroundColor(value));
  }

  BottomNavigationBarItem _buildAvatarItem(Widget avatar, MusicProvider value) {
    return BottomNavigationBarItem(icon: avatar, label: '', backgroundColor: _getBackgroundColor(value));
  }
}

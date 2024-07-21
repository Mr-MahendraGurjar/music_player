import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/model/music_response.dart';
import 'package:music_player/service/api_service.dart';
import 'package:rxdart/rxdart.dart';

class MusicProvider extends ChangeNotifier {
  MusicProvider() {
    fetchMusicData();
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final apiService = ApiService();
  late PersistentBottomSheetController bottomSheetController;
  List<Music> musicList = [];
  bool isPlayerDockVisible = false;
  int? currentSongIndex;
  int currentIndex = 0;
  bool isLoading = false;
  String? errorMessage;

  final BehaviorSubject<bool> _isPlayingSubject = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<Duration> _durationSubject = BehaviorSubject<Duration>.seeded(Duration.zero);
  final BehaviorSubject<Duration> _positionSubject = BehaviorSubject<Duration>.seeded(Duration.zero);
  final BehaviorSubject<bool> _isBufferingSubject = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<int> _currentSongIndexSubject = BehaviorSubject<int>.seeded(0);

  Stream<bool> get isPlayingStream => _isPlayingSubject.stream;
  Stream<Duration> get durationStream => _durationSubject.stream;
  Stream<Duration> get positionStream => _positionSubject.stream;
  Stream<bool> get isBufferingStream => _isBufferingSubject.stream;
  Stream<int> get currentSongIndexStream => _currentSongIndexSubject.stream;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isBuffering = false;

  void setupAudioPlayer() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlayingSubject.add(state == PlayerState.playing);
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      _durationSubject.add(newDuration);
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      _positionSubject.add(newPosition);
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        _positionSubject.add(Duration.zero);
      }
    });
  }

  void updateMusic(int index) async {
    if (currentSongIndex != index) {
      currentSongIndex = index;
      _currentSongIndexSubject.add(index);
      isPlayerDockVisible = true;
      setupAudioPlayer();
      await _setAudio(index);
    }
  }

  Future<void> _setAudio(int index) async {
    try {
      _isBufferingSubject.add(true);

      // Stop current playback
      await audioPlayer.stop();
      _positionSubject.add(Duration.zero);

      // Set new audio
      audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.setSourceUrl(musicList[index].source.toString());

      _isBufferingSubject.add(false);
    } catch (e) {
      _isBufferingSubject.add(false);
      debugPrint('Error setting audio: $e');
    }
  }

  void updateVal() {
    isPlayerDockVisible = false;
    notifyListeners();
  }

  Future<void> stopPlayback() async {
    await audioPlayer.stop();
    _positionSubject.add(Duration.zero);
  }

  @override
  void dispose() {
    _isPlayingSubject.close();
    _durationSubject.close();
    _positionSubject.close();
    _isBufferingSubject.close();
    super.dispose();
  }

  Future<void> fetchMusicData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final response = await apiService.getAllFetchMusicData();
      MusicResponse data = MusicResponse.fromJson(jsonDecode(response.body));
      isLoading = false;
      musicList = data.music ?? [];
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
      notifyListeners();
  }

  void onTabTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }
}

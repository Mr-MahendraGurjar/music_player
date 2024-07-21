import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/provider/music_provider.dart';
import 'package:music_player/widgets/gradient_circle_painter.dart';
import 'package:provider/provider.dart';

import '../gen/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
        builder: (context, musicProvider, child) => Scaffold(
            key: musicProvider.scaffoldKey,
            body: CustomScrollView(slivers: [
              _buildSliverAppBar(),
              if (musicProvider.isLoading)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (musicProvider.errorMessage != null)
                SliverFillRemaining(
                    child: Center(child: Text(musicProvider.errorMessage!, textAlign: TextAlign.center)))
              else
                _buildSliverList()
            ])));
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
        backgroundColor: const Color(0xff171E26).withOpacity(0.7),
        leadingWidth: 70,
        shape: const ContinuousRectangleBorder(
            borderRadius:
                BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
        leading: Padding(padding: const EdgeInsets.only(left: 12), child: SvgPicture.asset(Assets.arreVoice)),
        floating: false,
        snap: false,
        pinned: true,
        actions: [
          SvgPicture.asset(Assets.bellIcon),
          const SizedBox(width: 16),
          SvgPicture.asset(Assets.audioMessageIcon),
          const SizedBox(width: 16)
        ]);
  }

  Widget _buildSliverList() {
    return Consumer<MusicProvider>(
        builder: (context, musicProvider, child) => SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                    color: const Color(0xff171E26),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: InkWell(
                        onTap: () => _handlePlayButtonPressed(musicProvider, index),
                        child: Assets.cardPng.image())),
                childCount: musicProvider.musicList.length)));
  }

  void _handlePlayButtonPressed(MusicProvider musicProvider, int index) {
    if (musicProvider.isPlayerDockVisible) {
      musicProvider.updateMusic(index);
      setState(() {});
    } else {
      musicProvider.updateMusic(index);
      setState(() {});
      musicProvider.scaffoldKey.currentState
          ?.showBottomSheet((context) {
            return Consumer<MusicProvider>(builder: (context, bottomSheetValue, child) {
              return StatefulBuilder(builder: (BuildContext context, StateSetter setBottomSheetState) {
                return Container(
                    decoration: const BoxDecoration(
                        color: Color(0xff181e26),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Flexible(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                      StreamBuilder<int>(
                                          stream: musicProvider.currentSongIndexStream,
                                          builder: (context, snapshot) {
                                            final currentIndex = snapshot.data ?? 0;
                                            final title = musicProvider.musicList[currentIndex].title ?? '';
                                            return Text(title,
                                                style: const TextStyle(color: Color(0xffE4F1EE)),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis);
                                          }),
                                      StreamBuilder<int>(
                                          stream: musicProvider.currentSongIndexStream,
                                          builder: (context, snapshot) {
                                            final currentIndex = snapshot.data ?? 0;
                                            final artist =
                                                "@${musicProvider.musicList[currentIndex].artist ?? ''}";
                                            return Text(artist,
                                                style:
                                                    const TextStyle(color: Color(0xff4BC7B6), fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis);
                                          })
                                    ])),
                                Row(children: [
                                  Center(child: SvgPicture.asset(Assets.heartIcon)),
                                  const SizedBox(width: 5),
                                  StreamBuilder<bool>(
                                      stream: musicProvider.isBufferingStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData && snapshot.data!) {
                                          return CustomPaint(
                                              painter: GradientCirclePainter(),
                                              child: const CircleAvatar(
                                                  backgroundColor: Colors.transparent,
                                                  radius: 25,
                                                  child: Padding(
                                                      padding: EdgeInsets.all(15),
                                                      child: CircularProgressIndicator(strokeWidth: 1))));
                                        }
                                        return Center(
                                            child: InkWell(
                                                onTap: () async {
                                                  if (await musicProvider.isPlayingStream.first) {
                                                    await musicProvider.audioPlayer.pause();
                                                  } else {
                                                    await musicProvider.audioPlayer.resume();
                                                  }
                                                  setBottomSheetState(() {});
                                                },
                                                child: StreamBuilder<bool>(
                                                    stream: musicProvider.isPlayingStream,
                                                    builder: (context, snapshot) {
                                                      if (!snapshot.hasData || snapshot.hasError) {
                                                        return const CircularProgressIndicator();
                                                      }
                                                      final isPlaying = snapshot.data!;
                                                      return CustomPaint(
                                                          painter: GradientCirclePainter(),
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              radius: 25,
                                                              child: Icon(
                                                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                                                  color: Colors.white,
                                                                  size: 30)));
                                                    })));
                                      }),
                                  const SizedBox(width: 5),
                                  Center(child: SvgPicture.asset(Assets.playlistIcon))
                                ])
                              ]))),
                          StreamBuilder<bool>(
                              stream: musicProvider.isBufferingStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data!) {
                                  return const SizedBox();
                                }
                                return StreamBuilder<Duration>(
                                    stream: musicProvider.positionStream,
                                    builder: (context, positionSnapshot) {
                                      final position = positionSnapshot.data ?? Duration.zero;
                                      return StreamBuilder<Duration>(
                                          stream: musicProvider.durationStream,
                                          builder: (context, durationSnapshot) {
                                            final duration = durationSnapshot.data ?? Duration.zero;
                                            return Container(
                                                height: 20,
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(top: 10),
                                                child: SliderTheme(
                                                    data: SliderTheme.of(context).copyWith(
                                                        trackShape: const RectangularSliderTrackShape(),
                                                        thumbShape: const RoundSliderThumbShape(
                                                            enabledThumbRadius: 2),
                                                        overlayShape: SliderComponentShape.noOverlay,
                                                        trackHeight: 3),
                                                    child: Slider(
                                                        value: position.inSeconds.toDouble(),
                                                        min: 0,
                                                        activeColor: const Color(0xff4BC7B6),
                                                        max: duration.inSeconds.toDouble(),
                                                        inactiveColor: const Color(0xff41595C),
                                                        onChanged: (value) async {
                                                          final newPosition =
                                                              Duration(seconds: value.toInt());
                                                          await musicProvider.audioPlayer.seek(newPosition);
                                                          await musicProvider.audioPlayer.resume();
                                                          setBottomSheetState(() {});
                                                        })));
                                          });
                                    });
                              })
                        ]));
              });
            });
          })
          .closed
          .whenComplete(() {
            musicProvider.updateVal();
            musicProvider.audioPlayer.stop();
            setState(() {});
          });
    }
  }
}

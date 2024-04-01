import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:musix/utils/images.dart';

import '../../../widgets/hero_widget.dart';
import '../../Home/bloc/home_bloc.dart';
import '../../Home/model/song_model.dart';

class DetailsScreen extends StatelessWidget {
  final Song song;
  final String tag;

  const DetailsScreen({super.key, required this.song, required this.tag});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: DetailsView(
        song: song,
        tag: tag,
      ),
    );
  }
}

class DetailsView extends StatefulWidget {
  final Song song;
  final String tag;

  const DetailsView({super.key, required this.song, required this.tag});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  var player = AudioPlayer();
  bool loaded = false;
  bool playing = false;
  bool isFavorite = false;
   ValueNotifier<bool> isPlaying = ValueNotifier(false);

  final List<Color> colors = [
    Colors.grey[500]!,
    Colors.white60,
    Colors.black54,
    Colors.white60,
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

  void loadMusic() async {
    isFavorite = widget.song.isFavorite;
    await player.setUrl(widget.song.link);
    setState(() {
      loaded = true;
    });
  }

  void playMusic() async {
    setState(() {
      playing = true;
      isPlaying = ValueNotifier(true);
    });
    await player.play();
  }

  void pauseMusic() async {
    setState(() {
      playing = false;
      isPlaying = ValueNotifier(false);
    });
    await player.pause();
  }

  @override
  void initState() {
    loadMusic();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  _updateFavorite() {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(UpdateFavoriteEvent(
        docId: widget.song.id.toString(), value: !widget.song.isFavorite));
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.navigate_before)),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: const Center(
            child: Text(
          "Now Playing",
          style: TextStyle(
              fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        )),
      ),
      body: Column(
        children: [
          Hero(
            tag: widget.tag,
            child: HeroBoxWidget(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height * .55),
              link: widget.song.coverUrl,
              radius: 50,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Column(
                    children: [
                      Text(
                        widget.song.name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                      Text(
                        widget.song.artist,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                  InkResponse(
                    onTap: () {
                      _updateFavorite();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: isFavorite
                          ? Icon(
                              Icons.favorite_rounded,
                              size: 28,
                              color: Theme.of(context).primaryColor,
                            )
                          : Icon(
                              Icons.favorite_border_rounded,
                              size: 28,
                              color: Theme.of(context).primaryColor,
                            ),
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                child: StreamBuilder(
                    stream: player.positionStream,
                    builder: (context, snapshot1) {
                      final Duration duration = loaded
                          ? snapshot1.data as Duration
                          : const Duration(seconds: 0);
                      return StreamBuilder(
                          stream: player.bufferedPositionStream,
                          builder: (context, snapshot2) {
                            final Duration bufferedDuration = loaded
                                ? snapshot2.data as Duration
                                : const Duration(seconds: 0);
                            return SizedBox(
                              height: 30,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ProgressBar(
                                  progress: duration,
                                  total: player.duration ??
                                      const Duration(seconds: 0),
                                  buffered: bufferedDuration,
                                  timeLabelPadding: 5,
                                  timeLabelTextStyle: TextStyle(
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).primaryColorDark),
                                  progressBarColor:
                                      Theme.of(context).primaryColorDark,
                                  baseBarColor: Colors.grey[200],
                                  bufferedBarColor: Colors.grey[350],
                                  thumbColor:
                                      Theme.of(context).primaryColorDark,
                                  onSeek: loaded
                                      ? (duration) async {
                                          await player.seek(duration);
                                        }
                                      : null,
                                ),
                              ),
                            );
                          });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 20,
                  //   width: 40,
                  //   child: playing ? MusicVisualizer(
                  //     barCount: 5,
                  //     colors: colors,
                  //     duration: duration,
                  //   ) : Container(),
                  // ),
                  ValueListenableBuilder<bool>(
                    valueListenable: isPlaying,
                    builder: (BuildContext context, value, Widget? child) {
                      return playing ? MiniMusicVisualizer(
                        color: Theme.of(context).primaryColorDark,
                        width: 2,
                        height: 20,
                        radius: 1,
                        animate: value,
                      ) : Container();
                    },
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    height: 86,
                    width: 86,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          Images.playButton,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: IconButton(
                        onPressed: loaded
                            ? () {
                                if (playing) {
                                  pauseMusic();
                                } else {
                                  playMusic();
                                }
                              }
                            : null,
                        icon: Icon(
                          size: 56,
                          playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                        )),
                  ),
                  const SizedBox(width: 10,),
                  ValueListenableBuilder<bool>(
                    valueListenable: isPlaying,
                    builder: (BuildContext context, value, Widget? child) {
                      return playing ? MiniMusicVisualizer(
                        color: Theme.of(context).primaryColorDark,
                        width: 2,
                        height: 20,
                        radius: 1,
                        animate: value,
                      ) : Container();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

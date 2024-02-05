import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:quran_station/src/core/utils/constance_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/reciter_screen.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/utils/styles_manager.dart';
import '../../bloc/audios_bloc.dart';
import '../../data/models/moshaf.dart';
import '../../data/models/reciter_model.dart';
import '../screens/mushaf_screen.dart';

void defaultToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    backgroundColor: ColorManager.primary,
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void warnToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: ColorManager.secondary,
    // textColor: ColorManager.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}

void errorToast({
  required String msg,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: ColorManager.error,
    toastLength: Toast.LENGTH_SHORT,
  );
}

class RecitersList extends StatefulWidget {
  final List<Reciter> reciters;
  const RecitersList({super.key, required this.reciters});

  @override
  State<RecitersList> createState() => _RecitersListState();
}

class _RecitersListState extends State<RecitersList> {
  List<MapEntry<String, List<Reciter>>> groupedRecitersList = [];
  int displayedGroupes = 2;
  ScrollController? _scrollController;

  @override
  void initState() {
    groupedRecitersList = groupRecitersByLetter(widget.reciters);
    super.initState();
    if (_isLongList()) {
      _scrollController = ScrollController();
      _scrollController!.addListener(_scrollListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: _isLongList() ? displayedGroupes + 1 : groupedRecitersList.length,
        itemBuilder: (context, index) {
          print(index);
          if (index > displayedGroupes - 1 && _isLongList()) {
            return Center(
              child: Padding(
                padding: EdgeInsetsDirectional.all(1.sp),
                child: const SizedBox(),
              ),
            );
          } else {
            return RecitersGroup(
                letter: groupedRecitersList[index].key, reciters: groupedRecitersList[index].value);
          }
        });
  }

  List<MapEntry<String, List<Reciter>>> groupRecitersByLetter(List<Reciter> reciters) {
    Map<String, List<Reciter>> groupedReciters = {};

    reciters.sort((a, b) => a.data.letter.compareTo(b.data.letter));

    for (var reciter in reciters) {
      String letter = reciter.data.letter.toUpperCase();

      if (!groupedReciters.containsKey(letter)) {
        groupedReciters[letter] = [];
      }

      groupedReciters[letter]!.add(reciter);
    }

    groupedReciters.forEach((key, value) {
      value.sort((a, b) => a.data.name.compareTo(b.data.name));
    });
    print("len :${groupedRecitersList.length}");
    return groupedReciters.entries.toList();
  }

  Future _getMoreLetters() async {
    int remaining = groupedRecitersList.length - displayedGroupes;
    print("gerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
    if (remaining > 5) {
      setState(() {
        displayedGroupes += 5;
      });
    } else {
      setState(() {
        displayedGroupes += remaining;
      });
    }
  }

  void _scrollListener() async {
    if (_scrollController?.offset == _scrollController?.position.maxScrollExtent) {
      _getMoreLetters();
    } else {}
  }

  bool _isLongList() {
    print("is long ? : ${groupedRecitersList.length > 5}");
    return groupedRecitersList.length > 5;
  }
}

class RecitersGroup extends StatelessWidget {
  final String letter;
  final List<Reciter> reciters;

  const RecitersGroup({super.key, required this.letter, required this.reciters});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(letter),
        ),
        ListView.builder(
          itemBuilder: (context, int index) => ReciterItem(reciter: reciters[index]),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: reciters.length,
        ),
      ],
    );
  }
}

class ReciterItem extends StatelessWidget {
  final Reciter reciter;
  const ReciterItem({super.key, required this.reciter});
  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get();
    return InkWell(
      onTap: () {
        print(reciter.data.id);
        context.push(ReciterScreen(
          reciterID: reciter.data.id,
        ));
      },
      child: Card(
        surfaceTintColor: ColorManager.error,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
          1,
        ),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: ColorManager.darkBlue,
              gradient: LinearGradient(
                colors: [
                  ColorManager.darkBlue.withOpacity(0.8),
                  // ColorManager.darkBlue.withOpacity(0.7),
                  // ColorManager.darkBlue.withOpacity(0.8),
                  // ColorManager.darkBlue.withOpacity(0.9),
                  ColorManager.darkBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          reciter.data.name,
                          style: TextStylesManager.regularBoldWhiteStyle,
                        ),
                        subtitle: Text(
                          '${reciter.data.rewayasCount}'
                          ' قراءة / ${reciter.data.surahsCount} تسجيل ',
                          style: TextStylesManager.regularWhiteStyle,
                        ),
                        // trailing: Text(reciter.count.toString()),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0.sp),
                  child: BlocBuilder<AudiosBloc, AudiosState>(
                    bloc: bloc,
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          if (bloc.favoriteReciters.contains(reciter)) {
                            bloc.add(RemoveReciterFromFavoritesEvent(reciter.data.id));
                          } else {
                            bloc.add(AddReciterToFavoritesEvent(reciter.data.id));
                          }
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: bloc.favoriteReciters.contains(reciter)
                              ? ColorManager.secondary
                              : ColorManager.white,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class MoshafWidget extends StatelessWidget {
  final Moshaf moshaf;
  const MoshafWidget({super.key, required this.moshaf});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(MoshafScreen(moshaf: moshaf));
      },
      child: Card(
        surfaceTintColor: ColorManager.error,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
          1,
        ),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: ColorManager.darkBlue,
              gradient: LinearGradient(
                colors: [
                  ColorManager.darkBlue.withOpacity(0.8),
                  ColorManager.darkBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    moshaf.moshafData.name,
                    style: TextStylesManager.regularBoldWhiteStyle,
                  ),
                  subtitle: Text(
                    '${moshaf.moshafData.surahTotal} تسجيل ',
                    style: TextStylesManager.regularWhiteStyle,
                  ),
                  // trailing: Text(reciter.count.toString()),
                ),
              ],
            )),
      ),
    );
  }
}

class SurahItem extends StatelessWidget {
  final int surahId;
  const SurahItem({super.key, required this.surahId});

  @override
  Widget build(BuildContext context) {
    int surahIndex = surahId - 1;
    return Card(
      child: ListTile(
        title: Text(ConstanceManager.quranSurahsNames[surahIndex]),
      ),
    );
  }
}

class TabWidget extends StatelessWidget {
  final int index;
  const TabWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    AudiosBloc bloc = AudiosBloc.get();
    return InkWell(
      onTap: () {
        bloc.add(ChangeTabEvent(index));
      },
      child: BlocBuilder<AudiosBloc, AudiosState>(
        bloc: bloc,
        builder: (context, state) {
          return Container(
            alignment: Alignment.center,
            height: 4.0.h,
            // constraints: BoxConstraints(
            //   minWidth: 20.w,
            //   maxWidth: 80.w,
            // ),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: bloc.currentTab == index ? ColorManager.primary : ColorManager.grey1,
            ),
            child: Text(
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              "${bloc.tabs[index]}  ",
              style: bloc.currentTab == index
                  ? TextStylesManager.selectedTabStyle
                  : TextStylesManager.unSelectedTabStyle,
            ),
          );
        },
      ),
    );
  }
}

/// audio player widget

class PlayerWidget extends StatefulWidget {
  final AudioPlayer player;
  final String audioUrl;
  const PlayerWidget({
    required this.player,
    super.key,
    required this.audioUrl,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;
  bool get _isCompleted => _playerState == PlayerState.completed;
  bool _willRepeat = false;
  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  AudioPlayer get player => widget.player;

  @override
  void initState() {
    super.initState();
    // Use initial values from player
    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
            _duration = value;
          }),
        );
    player.getCurrentPosition().then(
          (value) => setState(() {
            _position = value;
            if (_willRepeat && _isCompleted) {
              _repeat();
            }
          }),
        );
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          _position != null
              ? '$_positionText / $_durationText'
              : _duration != null
                  ? _durationText
                  : '',
          style: const TextStyle(fontSize: 16.0),
        ),
        Slider(
          onChanged: (value) {
            final duration = _duration;
            if (duration == null) {
              return;
            }
            final position = value * duration.inMilliseconds;
            player.seek(Duration(milliseconds: position.round()));
          },
          value: (_position != null &&
                  _duration != null &&
                  _position!.inMilliseconds > 0 &&
                  _position!.inMilliseconds < _duration!.inMilliseconds)
              ? _position!.inMilliseconds / _duration!.inMilliseconds
              : 0.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _changeRepeatState,
              iconSize: 48.0,
              icon: Icon(
                Icons.repeat,
                color: _willRepeat ? color : ColorManager.grey2,
              ),
            ),
            FloatingActionButton(
              onPressed: _isPlaying ? _pause : _play,
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            IconButton(
              key: const Key('stop_button'),
              onPressed: _isPlaying || _isPaused ? _stop : null,
              iconSize: 48.0,
              icon: const Icon(Icons.stop),
              color: color,
            ),
          ],
        ),
      ],
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
        if (_willRepeat) {
          _repeat();
        } else {
          _initStreams();
        }
      });
    });

    _playerStateChangeSubscription = player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    if (_isPaused) {
      await player.resume();
    } else {
      await _repeat();
    }
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }

  Future<void> _repeat() async {
    await player.play(UrlSource(widget.audioUrl));
    player.play(player.source!);
    setState(() => _playerState = PlayerState.playing);
  }

  void _changeRepeatState() {
    setState(() {
      _willRepeat = !_willRepeat;
    });
  }
}

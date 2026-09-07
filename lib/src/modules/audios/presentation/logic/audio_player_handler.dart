// lib/src/modules/audios/services/audio_player_handler.dart
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_station/src/core/utils/images_manager.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';


class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer audioPlayer;
  final String id;
  final String title;
  final AudiosBloc bloc = AudiosBloc.get();
  static MediaItem? item;

  AudioPlayerHandler({
    required this.id,
    required this.audioPlayer,
    required this.title,
  }) {
    audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
    mediaItem.add(MediaItem(
      id: id,
      title: title,
      artUri: Uri.parse(ImagesManager.notificationImage),
      artist: bloc.currentReciter,
    ));
  }

  @override
  Future<void> play() => audioPlayer.play();

  @override
  Future<void> pause() => audioPlayer.pause();

  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  @override
  Future<void> stop() => audioPlayer.stop();

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        audioPlayer.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
      ],
      androidCompactActionIndices: const [0, 1],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioPlayer.processingState]!,
      playing: audioPlayer.playing,
      updatePosition: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }

  Future<void> updateItem(MediaItem newItem) async {
    item = newItem;
    mediaItem.add(newItem);
  }
}
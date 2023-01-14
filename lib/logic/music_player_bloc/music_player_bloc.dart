import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import '../../utils/music_player.dart';
import '../../api/vk_api.dart';

import '../../const/enums.dart';
import '../../model/song.dart';
import '../../model/user.dart';
import '../file_manager_bloc/file_manager_bloc.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final MusicPlayer musicPlayer;
  final VKApi vkApi;
  final FileManagerBloc readDownloadFolderBloc;
  late StreamSubscription playerCompleteSubscription;
  late StreamSubscription playerStatusSubscription;
  MusicPlayerBloc(
      {required this.musicPlayer,
      required this.vkApi,
      required this.readDownloadFolderBloc})
      : super(MusicPlayerState()) {
    playerStatusSubscription = musicPlayer.onComplete().listen((event) {
      if (event.processingState == ProcessingState.idle) {
        add(ChangePlayerState(processingState: ProcessingState.idle));
      } else if (event.processingState == ProcessingState.loading) {
        add(ChangePlayerState(processingState: ProcessingState.loading));
      } else if (event.processingState == ProcessingState.ready) {
        add(ChangePlayerState(processingState: ProcessingState.ready));
      }
    });
    playerCompleteSubscription = musicPlayer.onComplete().listen((event) async {
      if (event.processingState == ProcessingState.completed) {
        try {
          late Song song;
          int nextSongIndex = state.nextSongIndex!;
          if (state.onlineSong) {
            while (true) {
              song = (state.playlistId == -1)
                  ? (await vkApi.music
                          .getMusic(args: 'count=1&offset=$nextSongIndex'))
                      .first
                  : (await vkApi.music.getMusic(
                          args:
                              'owner_id=${(Hive.box('userBox').get('user') as User).userId}&playlist_id=${state.playlistId}&count=1&offset=${state.nextSongIndex!}'))
                      .first;
              if (song.url == '') {
                nextSongIndex++;
              } else {
                break;
              }
              print(nextSongIndex);
            }
          } else {
            song = readDownloadFolderBloc.state.song![state.nextSongIndex!];
          }
          add(PlayMusicEvent(
              song: song, index: nextSongIndex, playlistId: state.playlistId));
        } catch (e) {
          add(StopMusicWhenCompletedEvent());
        }
      }
    });
    on<PlayMusicEvent>((event, emit) async {
      if (musicPlayer.player.playing &&
          event.song == state.song &&
          state.processingState != ProcessingState.loading) {
        musicPlayer.pause();
        emit(state.copyWith(playStatus: PlayStatus.trackInPause));
      } else if (state.playStatus == PlayStatus.trackInPause &&
          event.song == state.song) {
        musicPlayer.resume();
        emit(state.copyWith(playStatus: PlayStatus.trackPlaying));
      } else {
        musicPlayer.play(song: event.song);
        emit(state.copyWith(
            song: event.song,
            playStatus: PlayStatus.trackPlaying,
            nextSongIndex: event.index + 1,
            onlineSong: event.song.online,
            playlistId: event.playlistId));
      }
    });
    on<StopMusicWhenCompletedEvent>((event, emit) {
      musicPlayer.stop();
      emit(state.copyWith(playStatus: PlayStatus.empty));
    });
    on<ChangePlayerMode>((event, emit) {
      emit(state.copyWith(playerMode: event.playMode));
    });
    on<ChangePlayerState>((event, emit) {
      emit(state.copyWith(processingState: event.processingState));
    });
  }

  @override
  Future<void> close() async {
    await playerStatusSubscription.cancel();
    await playerCompleteSubscription.cancel();
    super.close();
  }
}

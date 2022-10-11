import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../api/vk_api.dart';
import '../../model/song.dart';
import '../../model/user.dart';

import '../../const/enums.dart';

part 'music_loader_event.dart';
part 'music_loader_state.dart';

class MusicLoaderBloc extends Bloc<MusicLoaderEvent, MusicLoaderState> {
  final VKApi vkApi;

  MusicLoaderBloc({required this.vkApi}) : super(MusicLoaderState()) {
    on<LoadMusicEvent>((event, emit) async {
      emit(state.copyWith(loadMusicStatus: Status.submissionInProgress));
      dynamic response =
          await vkApi.music.getMusic(args: 'count=25&offset=${state.offset}');
      try {
        final List<Song> songsResult = response;
        emit(state.copyWith(
            loadMusicStatus: Status.submissionSuccess, songList: songsResult));
      } catch (e) { 
        emit(state.copyWith(
            loadMusicStatus: Status.submissionFailure, errorMessage: response));
      }
    });

    on<LoadMoreMusicEvent>((event, emit) async {
      emit(state.copyWith(
          offset: state.offset + 1,
          loadMoreMusicStatus: Status.submissionInProgress));
      try {
        final List<Song> currentSong = state.songList!;
        final List<Song> songsResult = await vkApi.music
            .getMusic(args: 'count=25&offset=${25 * state.offset}');
        currentSong.addAll(songsResult);
        emit(state.copyWith(
            loadMoreMusicStatus: Status.submissionSuccess,
            songList: currentSong));
      } catch (e) {
        emit(state.copyWith(loadMoreMusicStatus: Status.submissionFailure));
        throw Exception(e);
      }
    });

    on<LoadPlaylistMusicEvent>((event, emit) async {
      emit(state.copyWith(
          loadPlaylistMusicStatus: Status.submissionInProgress,
          playlistOffset: 0));
      try {
        final List<Song> songsResult = await vkApi.music.getMusic(
            args:
                'owner_id=${(Hive.box('userBox').get('user') as User).userId}&playlist_id=${event.playlistId}&count=25&offset=${state.playlistOffset}');

        emit(state.copyWith(
            loadPlaylistMusicStatus: Status.submissionSuccess,
            songPlaylistList: songsResult));
      } catch (e) {
        emit(state.copyWith(loadPlaylistMusicStatus: Status.submissionFailure));
        throw Exception(e);
      }
    });
    on<LoadMorePlaylistMusicEvent>((event, emit) async {
      emit(state.copyWith(
          playlistOffset: state.playlistOffset + 1,
          loadMorePlaylistMusicStatus: Status.submissionInProgress));
      try {
        final List<Song> currentSong = state.songPlaylistList!;
        final List<Song> songsResult = await vkApi.music.getMusic(
            args:
                'owner_id=${(Hive.box('userBox').get('user') as User).userId}&playlist_id=${event.playlistId}&count=25&offset=${25 * state.playlistOffset}');
        currentSong.addAll(songsResult);
        emit(state.copyWith(
            loadMorePlaylistMusicStatus: Status.submissionSuccess,
            songPlaylistList: currentSong));
      } catch (e) {
        emit(state.copyWith(loadMoreMusicStatus: Status.submissionFailure));
        throw Exception(e);
      }
    });
  }
}

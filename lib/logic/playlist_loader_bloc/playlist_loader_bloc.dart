import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/vk_api.dart';

import '../../const/enums.dart';
import '../../model/playlist.dart';

part 'playlist_loader_event.dart';
part 'playlist_loader_state.dart';

class PlaylistLoaderBloc
    extends Bloc<PlaylistLoaderEvent, PlaylistLoaderState> {
  final VKApi vkApi;
  PlaylistLoaderBloc({required this.vkApi}) : super(PlaylistLoaderState()) {
    on<Load4PlayListEvent>((event, emit) async {
      emit(state.copyWith(loadPlaylistStatus: Status.submissionInProgress));
      try {
        final Map responsePlaylist =
            await vkApi.music.getPlaylist(args: 'count=4');
        final List<PlayList> playlistResult = responsePlaylist['playlists'];
        final int count = responsePlaylist['count'];
        emit(state.copyWith(
            countPlaylist: count,
            playlist4List: playlistResult,
            loadPlaylistStatus: Status.submissionSuccess));
      } catch (e) {
        emit(state.copyWith(loadPlaylistStatus: Status.submissionFailure));
      }
    });
    on<Load25PlayListEvent>((event, emit) async {
      emit(state.copyWith(load25PlaylistStatus: Status.submissionInProgress));
      try {
        final Map responsePlaylist =
            await vkApi.music.getPlaylist(args: 'count=25');
        final List<PlayList> playlistResult = responsePlaylist['playlists'];
        emit(state.copyWith(
            playlistList: playlistResult,
            load25PlaylistStatus: Status.submissionSuccess));
      } catch (e) {
        emit(state.copyWith(load25PlaylistStatus: Status.submissionFailure));
        throw Exception(e);
      }
    });
    on<LoadMorePlayListEvent>((event, emit) async {
      emit(state.copyWith(
          offset: state.offset + 1,
          loadMorePlaylistStatus: Status.submissionInProgress));
      try {
        final List<PlayList> currentPlaylist = state.playlistList!;
        final Map responsePlaylist = await vkApi.music
            .getPlaylist(args: 'count=25&offset=${25 * state.offset}');
        final List<PlayList> playlistResult = responsePlaylist['playlists'];
        currentPlaylist.addAll(playlistResult);
        emit(state.copyWith(
            loadMorePlaylistStatus: Status.submissionSuccess,
            playlistList: currentPlaylist));
      } catch (e) {
        emit(state.copyWith(loadMorePlaylistStatus: Status.submissionFailure));
        throw Exception(e);
      }
    });
  }
}

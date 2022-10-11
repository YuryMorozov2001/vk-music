part of 'music_loader_bloc.dart';

class MusicLoaderState {
  final List<Song>? songList;
  final List<Song>? songPlaylistList;
  final Status loadMoreMusicStatus;
  final Status loadMusicStatus;
  final Status loadMorePlaylistMusicStatus;
  final Status loadPlaylistMusicStatus;
  final int offset;
  final int playlistOffset;
  final String? errorMessage;
  MusicLoaderState({
    this.songList,
    this.songPlaylistList,
    this.errorMessage,
    this.offset = 0,
    this.playlistOffset = 0,
    this.loadMoreMusicStatus = Status.empty,
    this.loadMusicStatus = Status.empty,
    this.loadMorePlaylistMusicStatus = Status.empty,
    this.loadPlaylistMusicStatus = Status.empty,
  });

  MusicLoaderState copyWith({
    List<Song>? songList,
    List<Song>? songPlaylistList,
    Status? loadMoreMusicStatus,
    Status? loadMusicStatus,
    Status? loadMorePlaylistMusicStatus,
    Status? loadPlaylistMusicStatus,
    int? offset,
    int? playlistOffset,
    String? errorMessage,
  }) {
    return MusicLoaderState(
      songList: songList ?? this.songList,
      songPlaylistList: songPlaylistList ?? this.songPlaylistList,
      loadMoreMusicStatus: loadMoreMusicStatus ?? this.loadMoreMusicStatus,
      loadMusicStatus: loadMusicStatus ?? this.loadMusicStatus,
      loadMorePlaylistMusicStatus: loadMorePlaylistMusicStatus ?? this.loadMorePlaylistMusicStatus,
      loadPlaylistMusicStatus: loadPlaylistMusicStatus ?? this.loadPlaylistMusicStatus,
      offset: offset ?? this.offset,
      playlistOffset: playlistOffset ?? this.playlistOffset,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

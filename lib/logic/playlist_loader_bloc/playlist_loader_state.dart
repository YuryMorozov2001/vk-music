part of 'playlist_loader_bloc.dart';

class PlaylistLoaderState {
  final List<PlayList>? playlist4List;
  final List<PlayList>? playlistList;
  final int? countPlaylist;
  final Status loadPlaylistStatus;
  final Status load25PlaylistStatus;
  final Status loadMorePlaylistStatus;
  final int offset;
  PlaylistLoaderState({
    this.playlist4List,
    this.playlistList,
    this.countPlaylist,
    this.loadPlaylistStatus = Status.empty,
    this.load25PlaylistStatus = Status.empty,
    this.loadMorePlaylistStatus = Status.empty,
    this.offset = 0,
  });

  PlaylistLoaderState copyWith({
    List<PlayList>? playlist4List,
    List<PlayList>? playlistList,
    int? countPlaylist,
    Status? loadPlaylistStatus,
    Status? load25PlaylistStatus,
    Status? loadMorePlaylistStatus,
    int? offset,
  }) {
    return PlaylistLoaderState(
      playlist4List: playlist4List ?? this.playlist4List,
      playlistList: playlistList ?? this.playlistList,
      countPlaylist: countPlaylist ?? this.countPlaylist,
      loadPlaylistStatus: loadPlaylistStatus ?? this.loadPlaylistStatus,
      load25PlaylistStatus: load25PlaylistStatus ?? this.load25PlaylistStatus,
      loadMorePlaylistStatus:
          loadMorePlaylistStatus ?? this.loadMorePlaylistStatus,
      offset: offset ?? this.offset,
    );
  }
}

part of 'music_loader_bloc.dart';

abstract class MusicLoaderEvent {}

class LoadMusicEvent extends MusicLoaderEvent {}

class LoadMoreMusicEvent extends MusicLoaderEvent {}

class LoadPlaylistMusicEvent extends MusicLoaderEvent {
  final String playlistId;
  LoadPlaylistMusicEvent({
    required this.playlistId,
  });
}

class LoadMorePlaylistMusicEvent extends MusicLoaderEvent {
  final String playlistId;
  LoadMorePlaylistMusicEvent({
    required this.playlistId,
  });
}

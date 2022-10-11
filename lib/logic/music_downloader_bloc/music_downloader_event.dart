part of 'music_downloader_bloc.dart';

abstract class MusicDownloaderEvent {}

class DownloadMusicEvent extends MusicDownloaderEvent {
  final String url;
  final String id;
  final String name;
  DownloadMusicEvent({required this.url, required this.id, required this.name});
}

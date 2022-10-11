part of 'music_downloader_bloc.dart';

class MusicDownloaderState {
  final DownloadStatus downloadStatus;
  final List<String> id;
  MusicDownloaderState({
    this.downloadStatus = DownloadStatus.empty,
    this.id = const <String>[],
  });

  MusicDownloaderState copyWith({
    DownloadStatus? downloadStatus,
    List<String>? id,
  }) {
    return MusicDownloaderState(
      downloadStatus: downloadStatus ?? this.downloadStatus,
      id: id ?? this.id,
    );
  }
}

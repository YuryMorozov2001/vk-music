part of 'file_manager_bloc.dart';

class FileManagerState {
  String? pathFolder;
  List<Song>? song;
  FileManagerState({
    this.pathFolder,
    this.song,
  });

  FileManagerState copyWith({
    String? pathFolder,
    List<Song>? song,
  }) {
    return FileManagerState(
      pathFolder: pathFolder ?? this.pathFolder,
      song: song ?? this.song,
    );
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart'; 

import '../../model/song.dart';

part 'file_manager_event.dart';
part 'file_manager_state.dart';

class FileManagerBloc
    extends Bloc<FileManagerEvent, FileManagerState> {
  FileManagerBloc() : super(FileManagerState()) {
    on<ReadFolderEvent>((event, emit) async {
      final projectPath = await getExternalStorageDirectory();
      final List<Song>? finalList = await compute(readFiles, projectPath);
      emit(state.copyWith(pathFolder: projectPath!.path, song: finalList));
    });
    on<DeleteFileEvent>((event, emit) async {
      File file = File(event.url);
      await file.delete();
      List<Song> songList = state.song!;
      songList.removeWhere((e) => e.url == event.url);
      emit(state.copyWith(song: songList));
    });
  }
}

Future<List<Song>?> readFiles(Directory? projectPath) async {
  List<FileSystemEntity> files = await projectPath!.list().toList();
  List<Song> song = [];
  List<FileSystemEntity>? songs = files
      .where(
          (element) => element.path.substring(element.path.length - 3) == 'mp3')
      .toList();
  var statResults = await Future.wait([
    for (var path in songs) FileStat.stat(path.path),
  ]);
  var mtimes = <FileSystemEntity, DateTime>{
    for (var i = 0; i < songs.length; i += 1) songs[i]: statResults[i].changed,
  };
  songs.sort((a, b) => mtimes[a]!.compareTo(mtimes[b]!));
  for (var songE in songs) {
    final artist = songE.path.split(' - ').first.split('/').last;
    final title = songE.path.split(' - ').last.split('_\$d').first;
    final duration =
        songE.path.split(' - ').last.split('_\$d').last.split('.mp3').first;
    song.add(Song(
        artist: artist,
        title: title,
        duration: duration,
        id: '',
        url: songE.path,
        accessKey: null,
        online: false));
  }
  Iterable inReverse = song.reversed;
  List<Song>? finalList = inReverse.cast<Song>().toList();
  return finalList;
}

part of 'file_manager_bloc.dart';

abstract class FileManagerEvent {}

class ReadFolderEvent extends FileManagerEvent {}

class DeleteFileEvent extends FileManagerEvent {
  final String url;
  DeleteFileEvent({
    required this.url,
  });
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../const/enums.dart';
import '../../utils/music_downloader.dart';

part 'music_downloader_event.dart';
part 'music_downloader_state.dart';

class MusicDownloaderBloc
    extends Bloc<MusicDownloaderEvent, MusicDownloaderState> {
  final MusicDownloader musicDownloader;
  MusicDownloaderBloc({required this.musicDownloader})
      : super(MusicDownloaderState()) {
    on<DownloadMusicEvent>((event, emit) async { 
      List<String> list = state.id.toList();
      list.add(event.id);
      emit(state.copyWith(
          downloadStatus: DownloadStatus.trackDownloading, id: list));
      await MusicDownloader()
          .download(url: event.url, name: event.name, id: event.id);
      list = state.id.toList();
      list.removeWhere((element) => element == event.id);
      emit(state.copyWith(id: list));
      // emit(state.)
    });
  }
}

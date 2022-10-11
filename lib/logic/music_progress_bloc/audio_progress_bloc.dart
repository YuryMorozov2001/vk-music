import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart'; 

import '../../utils/music_player.dart';
import '../music_player_bloc/music_player_bloc.dart';

part 'audio_progress_event.dart';
part 'audio_progress_state.dart';

class AudioProgressBloc extends Bloc<AudioProgressEvent, AudioProgressState> {
  final MusicPlayer musicPlayer;
  late StreamSubscription positionChangedSubscription;
  late StreamSubscription bufferPositionSubscription;
  late MusicPlayerBloc musicPlayerBloc;

  AudioProgressBloc({required this.musicPlayer, required this.musicPlayerBloc})
      : super(AudioProgressState()) {
    positionChangedSubscription = musicPlayer.getCurrentPos().listen(
      (event) {
        add(ChangeValueEvent(value: Duration(seconds: event.inSeconds)));
      },
    );
    bufferPositionSubscription = musicPlayer.getCurrentBufferPos().listen(
      (event) {
        add(ChangeBufferValueEvent(value: event));
      },
    );

    on<ChangeValueEvent>((event, emit) {
      emit(state.copyWith(currentDuration: event.value));
    });
    on<ChangeBufferValueEvent>((event, emit) {
      emit(state.copyWith(bufferDuration: event.value));
    });
    on<SeekValueEvent>((event, emit) {
      musicPlayer.seek(event.value);
      emit(state.copyWith(currentDuration: event.value));
    });
  }
}

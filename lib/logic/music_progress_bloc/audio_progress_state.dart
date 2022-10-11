part of 'audio_progress_bloc.dart';

class AudioProgressState {
  final Duration? currentDuration;
  final Duration? bufferDuration;
  AudioProgressState({
    this.currentDuration,
    this.bufferDuration,
  });

  AudioProgressState copyWith({
    Duration? currentDuration,
    Duration? bufferDuration,
  }) {
    return AudioProgressState(
      currentDuration: currentDuration ?? this.currentDuration,
      bufferDuration: bufferDuration ?? this.bufferDuration,
    );
  }
}

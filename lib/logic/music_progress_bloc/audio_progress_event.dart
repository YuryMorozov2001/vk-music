part of 'audio_progress_bloc.dart';

abstract class AudioProgressEvent {}

class ChangeValueEvent extends AudioProgressEvent {
  final Duration value;
  ChangeValueEvent({
    required this.value,
  });
}

class ChangeBufferValueEvent extends AudioProgressEvent {
  final Duration value;
  ChangeBufferValueEvent({
    required this.value,
  });
}

class SeekValueEvent extends AudioProgressEvent {
  final Duration value;
  SeekValueEvent({
    required this.value,
  });
}

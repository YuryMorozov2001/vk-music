import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shimmer/shimmer.dart';
 
import '../../../logic/music_player_bloc/music_player_bloc.dart';
import '../../../logic/music_progress_bloc/audio_progress_bloc.dart';
import 'music_slider_button.dart';

class MusicSlider extends StatelessWidget {
  const MusicSlider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget inactivebar() {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.24),
            borderRadius: BorderRadius.circular(8)),
        height: 6,
      );
    }

    Widget loadingbar() {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.primary.withOpacity(0.24),
        highlightColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(8)),
          height: 6,
        ),
      );
    }

    return BlocBuilder<AudioProgressBloc, AudioProgressState>(
      builder: (context1, state1) {
        return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
          builder: (context, state) {
            return Container(
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: state.processingState == ProcessingState.idle
                          ? inactivebar()
                          : state.processingState == ProcessingState.loading
                              ? loadingbar()
                              : ProgressBar(
                                  thumbCanPaintOutsideBar: false,
                                  thumbColor: Colors.transparent,
                                  thumbGlowRadius: 10,
                                  timeLabelLocation: TimeLabelLocation.none,
                                  progress: state1.currentDuration ??
                                      const Duration(),
                                  buffered:
                                      state1.bufferDuration ?? const Duration(),
                                  total: Duration(
                                      seconds: int.parse(state.song!.duration)),
                                  onSeek: (duration) {
                                    context1
                                        .read<AudioProgressBloc>()
                                        .add(SeekValueEvent(value: duration));
                                  },
                                ),
                    ),
                    const SizedBox(width: 12),
                    const AnimatedButton(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

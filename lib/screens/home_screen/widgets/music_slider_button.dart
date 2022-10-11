import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../const/enums.dart';
import '../../../logic/music_player_bloc/music_player_bloc.dart'; 

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({Key? key}) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late Animation<double> _myAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _myAnimation =
        CurvedAnimation(curve: Curves.easeInOutCubic, parent: _controller);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
      listener: (context, state) {
        if (state.playStatus == PlayStatus.trackPlaying) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state.song != null &&
                state.processingState != ProcessingState.idle) {
              context
                  .read<MusicPlayerBloc>()
                  .add(PlayMusicEvent(index: 0, song: state.song!.copyWith()));
            }
          },
          child: AnimatedIcon(
            progress: _myAnimation,
            icon: AnimatedIcons.play_pause,
            color: state.processingState != ProcessingState.idle
                ? Colors.grey
                : Colors.grey.withOpacity(0.5),
            size: 24,
          ),
        );
      },
    );
  }
}

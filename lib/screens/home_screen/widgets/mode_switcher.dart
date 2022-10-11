import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/logic/file_manager_bloc/file_manager_bloc.dart'; 

import '../../../const/enums.dart';
import '../../../logic/music_player_bloc/music_player_bloc.dart'; 

class PlayerSwitcher extends StatefulWidget {
  const PlayerSwitcher({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayerSwitcher> createState() => _PlayerSwitcherState();
}

class _PlayerSwitcherState extends State<PlayerSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            'оффлайн плеер',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
            builder: (context, state) {
              return Switch(
                activeColor: Colors.white,
                value: state.playerMode == PlayerMode.online ? false : true,
                onChanged: ((value) {
                  PlayerMode playerMode =
                      value == false ? PlayerMode.online : PlayerMode.offline;
                  context
                      .read<MusicPlayerBloc>()
                      .add(ChangePlayerMode(playMode: playerMode)); 
                  if (state.playerMode == PlayerMode.online) {
                    context
                        .read<FileManagerBloc>()
                        .add(ReadFolderEvent());
                  }
                }),
              );
            },
          )
        ]),
      ),
    );
  }
}

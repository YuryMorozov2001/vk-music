import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/logic/auth_bloc/auth_bloc.dart';

import '../../const/enums.dart';
import '../../logic/music_loader_bloc/music_loader_bloc.dart';
import '../../logic/playlist_loader_bloc/playlist_loader_bloc.dart';
import '../../widgets/shimmer_list.dart';
import 'widgets/vk_music_list.dart';

class OnlineSongsList extends StatelessWidget {
  const OnlineSongsList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistLoaderBloc, PlaylistLoaderState>(
      builder: (context, statePlaylist) {
        return BlocBuilder<MusicLoaderBloc, MusicLoaderState>(
          builder: (context, state) {
            if (state.loadMusicStatus == Status.submissionInProgress) {
              return const ShimmerSongList(showPlaylists: true);
            } else if (state.loadMusicStatus == Status.submissionSuccess) {
              return VKSongList(
                loadMoreMusicStatus: state.loadMoreMusicStatus,
                songList: state.songList,
                playlistList: statePlaylist.playlist4List,
              );
            } else if (state.loadMusicStatus == Status.submissionFailure) {
              if (state.errorMessage!.contains('invalid access_token')) {
                context.read<AuthBloc>().add(LogoutUserEvent());
              }
              return Center(
                child: LayoutBuilder(builder: (_, c) {
                  return SizedBox(
                    width: c.maxWidth * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                            'Отключите защиту от подозрительных приложений и перезапустите приложение',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        SizedBox(height: 8),
                        Text(
                            'VK ID > Безопасность и вход > Защита от подозрительных приложений',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center)
                      ],
                    ),
                  );
                }),
              );
            }
            return Center(
              child: Text(
                  'попробуйте перезапустить приложение ${state.loadMusicStatus}'),
            );
          },
        );
      },
    );
  }
}

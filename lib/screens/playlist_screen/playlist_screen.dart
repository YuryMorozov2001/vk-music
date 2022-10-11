import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/screens/playlist_screen/widgets/playlist_music_list.dart';

import '../../const/enums.dart';
import '../../logic/music_loader_bloc/music_loader_bloc.dart';
import '../../widgets/shimmer_list.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen(
      {super.key, required this.title, required this.playlistId});
  final String title;
  final int playlistId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<MusicLoaderBloc, MusicLoaderState>(
        builder: (context, state) {
          if (state.loadPlaylistMusicStatus == Status.submissionInProgress) {
            return const ShimmerSongList(
              showPlaylists: false,
            );
          } else if (state.loadPlaylistMusicStatus ==
              Status.submissionSuccess) {
            return VKPlaylistSongList(
              loadMorePlaylistMusicStatus: state.loadMorePlaylistMusicStatus,
              songList: state.songPlaylistList,
              playlistId: playlistId,
            );
          }
          return const Center(child: Text('что-то пошло не так'));
        },
      ),
    );
  }
}

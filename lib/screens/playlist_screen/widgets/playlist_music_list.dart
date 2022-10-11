import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../const/enums.dart'; 
import '../../../logic/music_loader_bloc/music_loader_bloc.dart';
import '../../../model/song.dart';
import '../../../widgets/song_item.dart';

class VKPlaylistSongList extends StatelessWidget {
  final Status loadMorePlaylistMusicStatus;
  final List<Song>? songList;
  final int playlistId;
  const VKPlaylistSongList({
    Key? key,
    required this.loadMorePlaylistMusicStatus,
    required this.songList,
    required this.playlistId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge &&
            loadMorePlaylistMusicStatus != Status.submissionInProgress) {
          bool isBottom = metrics.pixels == metrics.maxScrollExtent;
          if (isBottom) {
            context.read<MusicLoaderBloc>().add(
                LoadMorePlaylistMusicEvent(playlistId: playlistId.toString()));
          }
        }
        return true;
      },
      child: ListView.builder(
        itemBuilder: (context, index) => SongItemWidget(
          song: songList![index],
          index: index,
          playerMode: PlayerMode.online,
          playlistId: playlistId,
        ),
        shrinkWrap: true,
        itemCount: songList!.length,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../const/enums.dart'; 
import '../../../logic/music_loader_bloc/music_loader_bloc.dart';
import '../../../model/playlist.dart';
import '../../../model/song.dart';
import 'vk_preview_playlist_list.dart';
import '../../../widgets/song_item.dart';

class VKSongList extends StatelessWidget {
  final Status loadMoreMusicStatus;
  final List<Song>? songList;
  final List<PlayList>? playlistList;
  const VKSongList(
      {Key? key,
      required this.loadMoreMusicStatus,
      required this.songList,
      required this.playlistList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge &&
            loadMoreMusicStatus != Status.submissionInProgress) {
          bool isBottom = metrics.pixels == metrics.maxScrollExtent;
          if (isBottom) {
            context.read<MusicLoaderBloc>().add(LoadMoreMusicEvent());
          }
        }
        return true;
      },
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) =>
            (index == 0 && playlistList?.length != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const PlayListWidget(),
                      SongItemWidget(
                        song: songList![index],
                        index: index,
                        playerMode: PlayerMode.online,
                        playlistId: -1,
                      ),
                    ],
                  )
                : SongItemWidget(
                    song: songList![index],
                    index: index,
                    playerMode: PlayerMode.online,
                    playlistId: -1,
                  )),
        shrinkWrap: true,
        itemCount: songList!.length,
      ),
    );
  }
}
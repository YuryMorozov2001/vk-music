
import 'package:flutter/material.dart';

import '../../../const/enums.dart';
import '../../../model/song.dart';
import '../../../widgets/song_item.dart';

class OfflineMusicList extends StatelessWidget {
  const OfflineMusicList({
    Key? key,
    required this.song,
  }) : super(key: key);
  final List<Song> song;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return SongItemWidget(
          index: index,
          song: song[index],
          playerMode: PlayerMode.offline,
          playlistId: null,
        );
      },
      itemCount: song.length,
    );
  }
}

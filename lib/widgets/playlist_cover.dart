
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../logic/music_loader_bloc/music_loader_bloc.dart';
import '../model/playlist.dart';

class PlaylistCoverWidget extends StatelessWidget {
  const PlaylistCoverWidget({
    Key? key,
    required this.playlist,
  }) : super(key: key);
  final PlayList playlist;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/playlist',
            arguments: {'title': playlist.title, 'playlist': playlist.id});
        context
            .read<MusicLoaderBloc>()
            .add(LoadPlaylistMusicEvent(playlistId: playlist.id.toString()));
      },
      child: LayoutBuilder(builder: (_, c) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: playlist.photo_300 != null
              ? CachedNetworkImage(
                  imageUrl: playlist.photo_300!,
                  placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Theme.of(context).cardColor.withOpacity(0.30),
                      highlightColor: Colors.grey.withOpacity(0.5),
                      child: Container(
                        height: c.maxWidth,
                        width: c.maxWidth,
                        color: Theme.of(context).cardColor.withOpacity(0.30),
                      )),
                )
              : Container(
                  height: c.maxWidth,
                  width: c.maxWidth,
                  color: Theme.of(context).cardColor.withOpacity(0.30),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/playlist.svg',
                      width: 75,
                      height: 75,
                      color: Theme.of(context).cardColor,
                    ),
                  )),
        );
      }),
    );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../const/enums.dart';
import '../helpers/helpers.dart';
import '../logic/file_manager_bloc/file_manager_bloc.dart';
import '../logic/music_downloader_bloc/music_downloader_bloc.dart';
import '../logic/music_player_bloc/music_player_bloc.dart';
import '../model/song.dart';

class SongItemWidget extends StatelessWidget {
  const SongItemWidget(
      {super.key,
      required this.song,
      required this.index,
      required this.playerMode,
      this.playlistId});
  final Song song;
  final int index;
  final PlayerMode playerMode;
  final int? playlistId;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: song.url != '' ? 1 : 0.2,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 12.0, right: 12, top: 8, bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Theme.of(context).cardColor.withOpacity(0.30),
            child: Material(
              color: Colors.transparent,
              child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
                builder: (context, state) {
                  return InkWell(
                    splashColor: Theme.of(context).splashColor,
                    onLongPress: () => {
                      if (!song.online)
                        {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Удаление'),
                              content: const Text(
                                  'Вы действительно хотите удалить песню?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('нет'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<FileManagerBloc>()
                                        .add(DeleteFileEvent(url: song.url!));
                                    Navigator.pop(context);
                                  },
                                  child: const Text('удалить'),
                                ),
                              ],
                            ),
                          ),
                        }
                    },
                    onTap: () {
                      if (song.url != '') {
                        context.read<MusicPlayerBloc>().add(PlayMusicEvent(
                            song: song, index: index, playlistId: playlistId));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SongItemCover(
                                  curSong: state.song,
                                  song: song,
                                  playStatus: state.playStatus),
                              const SizedBox(
                                width: 12,
                              ),
                              SongItemName(song: song),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  format(Duration(
                                      seconds: int.parse(song.duration))),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ),
                              playerMode == PlayerMode.online
                                  ? SongItemDownloadBtn(
                                      song: song,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SongItemDownloadBtn extends StatelessWidget {
  const SongItemDownloadBtn({Key? key, required this.song}) : super(key: key);
  final Song song;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileManagerBloc, FileManagerState>(
      builder: (context, stateFolder) {
        return song.url != ''
            ? BlocBuilder<MusicDownloaderBloc, MusicDownloaderState>(
                builder: (context, state) {
                  // ${tempDir!.path}/.mp3
                  final path = stateFolder.pathFolder;
                  File filePath = File(
                      '$path/${song.artist} - ${song.title}_\$d${song.duration}.mp3');
                  return filePath.existsSync()
                      ? const Icon(
                          Icons.check,
                          color: Colors.grey,
                        )
                      : (state.id
                              .where((element) => element == song.id)
                              .isNotEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                    color: Colors.grey, strokeWidth: 3),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => context
                                  .read<MusicDownloaderBloc>()
                                  .add(DownloadMusicEvent(
                                    url: song.url!,
                                    id: song.id!,
                                    name:
                                        '${song.artist} - ${song.title}_\$d${song.duration}',
                                  )),
                              child: const Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.grey,
                                size: 24,
                              ),
                            ));
                },
              )
            : const SizedBox();
      },
    );
  }
}

class SongItemName extends StatelessWidget {
  const SongItemName({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            song.artist,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class SongItemCover extends StatelessWidget {
  const SongItemCover({
    Key? key,
    required this.song,
    required this.curSong,
    required this.playStatus,
  }) : super(key: key);

  final Song song;
  final Song? curSong;
  final PlayStatus playStatus;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 50,
            height: 50,
            child: song.photoUrl135 != null
                ? CachedNetworkImage(
                    imageUrl: song.photoUrl135!,
                    placeholder: (context, url) => Shimmer.fromColors(
                        baseColor:
                            Theme.of(context).cardColor.withOpacity(0.30),
                        highlightColor: Colors.grey.withOpacity(0.5),
                        child: Container(
                          color: Theme.of(context).cardColor.withOpacity(0.30),
                        )),
                  )
                : Stack(
                    children: [
                      Container(
                        color: Theme.of(context).cardColor.withOpacity(0.30),
                      ),
                      Center(
                        child: SvgPicture.asset(
                          'assets/svg/note.svg',
                          color: Colors.grey.withOpacity(0.35),
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        curSong.toString() == song.toString() &&
                playStatus == PlayStatus.trackPlaying
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12)),
                width: 50,
                height: 50,
                child: const Icon(Icons.pause))
            : const SizedBox(),
      ],
    );
  }
}

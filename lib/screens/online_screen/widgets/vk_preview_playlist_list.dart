import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/playlist_loader_bloc/playlist_loader_bloc.dart';
import '../../../widgets/playlist_cover.dart';

class PlayListWidget extends StatelessWidget {
  const PlayListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (_) => true,
      child: BlocBuilder<PlaylistLoaderBloc, PlaylistLoaderState>(
        builder: (context, state) {
          return SizedBox(
            height: 110 + 16,
            child: LayoutBuilder(builder: (_, l) {
              return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 16);
                  },
                  shrinkWrap: true,
                  itemCount: state.playlist4List?.length ?? 0,
                  padding: const EdgeInsets.only(
                      left: 12, top: 8, right: 12, bottom: 8),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return index == state.playlist4List!.length - 1
                        ? Row(
                            children: [
                              SizedBox(
                                height: 110,
                                width: 110,
                                child: PlaylistCoverWidget(
                                    playlist: state.playlist4List![index]),
                              ),
                              state.countPlaylist! > 4
                                  ? Row(
                                      children: const [
                                        SizedBox(width: 12),
                                        ShowMoreBtnWidget(),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          )
                        : SizedBox(
                            height: 110,
                            width: 110,
                            child: PlaylistCoverWidget(
                                playlist: state.playlist4List![index]),
                          );
                  });
            }),
          );
        },
      ),
    );
  }
}

class ShowMoreBtnWidget extends StatelessWidget {
  const ShowMoreBtnWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          onTap: () {
            Navigator.pushNamed(context, '/playlists');
            context.read<PlaylistLoaderBloc>().add(Load25PlayListEvent());
          },
          child: Container(
            color: Theme.of(context).cardColor.withOpacity(0.3),
            width: 120,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'показать больше',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import '../../const/enums.dart'; 
import '../../logic/playlist_loader_bloc/playlist_loader_bloc.dart'; 
import '../../widgets/playlist_cover.dart';

class AllPlaylistsScreen extends StatelessWidget {
  const AllPlaylistsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Плейлисты',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
        ),
      ),
      body: const AllPlaylistBody(),
    );
  }
}

class AllPlaylistBody extends StatelessWidget {
  const AllPlaylistBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistLoaderBloc, PlaylistLoaderState>(
      builder: (context, state) {
        if (state.load25PlaylistStatus == Status.submissionInProgress) {
          return const Center(
              child: SizedBox(
            height: 20,
            width: 20,
            child:
                CircularProgressIndicator(color: Colors.grey, strokeWidth: 4),
          ));
        } else if (state.load25PlaylistStatus == Status.submissionSuccess) {
          return Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (scrollEnd) {
                final metrics = scrollEnd.metrics;
                if (metrics.atEdge &&
                    state.loadMorePlaylistStatus !=
                        Status.submissionInProgress) {
                  bool isBottom = metrics.pixels == metrics.maxScrollExtent;
                  if (isBottom) {
                    context
                        .read<PlaylistLoaderBloc>()
                        .add(LoadMorePlayListEvent());
                  }
                }
                return true;
              },
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: state.playlistList?.length ?? 0,
                itemBuilder: (BuildContext context, int index) => Column(
                  children: [
                    PlaylistCoverWidget(playlist: state.playlistList![index]),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.playlistList![index].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 120 + 16,
                ),
              ),
            ),
          );
        }
        return const Center(child: Text('что-то пошло не так'));
      },
    );
  }
}

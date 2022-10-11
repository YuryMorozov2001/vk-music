import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
  
import '../../logic/file_manager_bloc/file_manager_bloc.dart';
import 'widgets/offline_music_list.dart';

class OfflineSongList extends StatelessWidget {
  const OfflineSongList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileManagerBloc, FileManagerState>(
      builder: (context, state) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: state.song!.isNotEmpty
              ? OfflineMusicList(
                  song: state.song!,
                )
              : Center(
                  child: Text(
                    'у вас еще нет скачанных песен',
                    style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold),
                  ),
                ),
        );
      },
    );
  }
}

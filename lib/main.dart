import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'logic/auth_bloc/auth_bloc.dart';
import 'logic/file_manager_bloc/file_manager_bloc.dart';
import 'logic/music_downloader_bloc/music_downloader_bloc.dart';
import 'logic/music_loader_bloc/music_loader_bloc.dart';
import 'logic/music_player_bloc/music_player_bloc.dart';
import 'logic/music_progress_bloc/audio_progress_bloc.dart';
import 'logic/playlist_loader_bloc/playlist_loader_bloc.dart';
import 'model/user.dart';
import 'utils/music_downloader.dart';
import 'utils/music_player.dart';
import 'api/vk_api.dart';

import 'router/router.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final CrossAppRouter crossAppRouter = CrossAppRouter();
    final musicPlayer = MusicPlayer();
    final vkApi = VKApi();
    final musicDownloader = MusicDownloader();
    final musicLoaderBloc = MusicLoaderBloc(vkApi: vkApi);
    final playlistLoaderBloc = PlaylistLoaderBloc(vkApi: vkApi);
    final authBloc = AuthBloc(
        vkApi: vkApi,
        musicLoaderBloc: musicLoaderBloc,
        playlistLoaderBloc: playlistLoaderBloc)
      ..add(LoadUserEvent());
    final fileManagerBloc = FileManagerBloc()..add(ReadFolderEvent());
    final musicPlayerBloc = MusicPlayerBloc(
        musicPlayer: musicPlayer,
        vkApi: vkApi,
        readDownloadFolderBloc: fileManagerBloc);
    final musicDownloaderBloc =
        MusicDownloaderBloc(musicDownloader: musicDownloader);
    final audioProgressBloc = AudioProgressBloc(
        musicPlayer: musicPlayer, musicPlayerBloc: musicPlayerBloc);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => authBloc,
        ),
        BlocProvider<MusicLoaderBloc>(
          create: (BuildContext context) => musicLoaderBloc,
        ),
        BlocProvider<PlaylistLoaderBloc>(
          create: (BuildContext context) =>
              playlistLoaderBloc..add(Load4PlayListEvent()),
        ),
        BlocProvider<MusicPlayerBloc>(
          create: (BuildContext context) => musicPlayerBloc,
        ),
        BlocProvider<MusicDownloaderBloc>(
          create: (BuildContext context) => musicDownloaderBloc,
        ),
        BlocProvider<FileManagerBloc>(
          create: (BuildContext context) => fileManagerBloc,
        ),
        BlocProvider<AudioProgressBloc>(
          create: (BuildContext context) => audioProgressBloc,
        ),
      ],
      child: MaterialApp(
        title: 'vk music',
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          colorScheme: const ColorScheme.dark(
              surface: Color(0xFF141414),
              surfaceTint: Color.fromARGB(255, 39, 39, 39),
              primary: Colors.white,
              secondary: Colors.black,
              secondaryContainer: Colors.black),
          useMaterial3: true,
          backgroundColor: const Color(0xFF222222),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          }),
        ),
        onGenerateRoute: crossAppRouter.onGenerateRoute,
      ),
    );
  }
}

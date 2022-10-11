import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../const/enums.dart';
import '../../logic/auth_bloc/auth_bloc.dart';
import '../../logic/music_player_bloc/music_player_bloc.dart';
import '../auth_screen/auth_screen.dart';

import '../../router/router.dart';
import '../offline_screen/offline_screen.dart';
import '../online_screen/online_screen.dart';
import 'widgets/mode_switcher.dart';
import 'widgets/music_slider.dart';

class HomePage extends StatelessWidget {
  final title = const Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: 'вконтакте ',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: 'музыка',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.normal),
        ),
      ],
    ),
  );

  Future<bool> backPressed(GlobalKey<NavigatorState> key) async {
    if (key.currentState!.canPop()) {
      key.currentState!.maybePop();
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var keyOne = GlobalKey<NavigatorState>();
    final MainAppRouter mainAppRouter = MainAppRouter(crossContext: context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: WillPopScope(
              onWillPop: () async => await backPressed(keyOne),
              child: Navigator(
                key: keyOne,
                onGenerateRoute: mainAppRouter.onGenerateRoute,
              ),
            ),
          ),
          const MusicSlider(),
        ],
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  final title = const Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: 'вконтакте ',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: 'музыка',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.normal),
        ),
      ],
    ),
  );
  final BuildContext crossContext;
  const HomeBody({Key? key, required this.crossContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: title,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.user != null) {
                return PopupMenuButton(
                    splashRadius: 1,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    onSelected: (result) async {
                      if (result == 0) {
                        context.read<AuthBloc>().add(LogoutUserEvent());
                      }
                    },
                    itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: 0, child: Text('выйти из аккаунта')),
                        ]);
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const PlayerSwitcher(),
          // тут должен быть блок проверки интернета а не музык плеера
          Expanded(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
                  builder: (context, state) {
                    return state.playerMode == PlayerMode.online
                        ? authState.user == null
                            ? AuthScreen(context1: crossContext)
                            : const OnlineSongsList()
                        : const OfflineSongList();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:vk_music/screens/playlists_screen/playlists_screen.dart';

import '../screens/home_screen/home_screen.dart';
import '../screens/playlist_screen/playlist_screen.dart';
import '../screens/tfa_screen/tfa_screen.dart';

class MainAppRouter {
  final BuildContext crossContext;
  MainAppRouter({
    required this.crossContext,
  });
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => HomeBody(
                  crossContext: crossContext,
                ));
      case '/playlists':
        return MaterialPageRoute(builder: (_) => const AllPlaylistsScreen());
      case '/playlist':
        return MaterialPageRoute(
            builder: (_) => PlaylistScreen(
                title: (routeSettings.arguments as Map)['title'],
                playlistId: (routeSettings.arguments as Map)['playlist']));
    }
    return null;
  }
}

class CrossAppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/2fa':
        return MaterialPageRoute(
            builder: (_) => TFAScreen(
                  redirectUri: (routeSettings.arguments as Map)['redirect_uri']
                      .toString(),
                ));
    }
    return null;
  }
}

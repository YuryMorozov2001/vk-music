import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../model/user.dart';

import '../../api/vk_api.dart';
import '../../const/enums.dart';
import '../music_loader_bloc/music_loader_bloc.dart';
import '../playlist_loader_bloc/playlist_loader_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final userBox = Hive.box('userBox');
  final VKApi vkApi;
  final MusicLoaderBloc musicLoaderBloc;
  final PlaylistLoaderBloc playlistLoaderBloc;
  AuthBloc({
    required this.vkApi,
    required this.musicLoaderBloc,
    required this.playlistLoaderBloc,
  }) : super(AuthState()) {
    on<AuthUserEvent>((event, emit) async {
      emit(state.copyWith(status: Status.submissionInProgress));
      try {
        late User user;
        if (event.url == null) {
          final authResponse = await vkApi.auth
              .auth(login: event.login!, password: event.password!);
          user = User.fromMap(authResponse);
        } else {
          user = User(
            accesToken: event.url!.split('access_token=').last.split('&').first,
            secret: event.url!.split('secret=').last,
            userId: event.url!.split('user_id=').last.split('&').first,
          );
        }
        userBox.put('user', user);
        emit(state.copyWith(user: user, status: Status.submissionSuccess));
        musicLoaderBloc.add(LoadMusicEvent());
        playlistLoaderBloc.add(Load4PlayListEvent());
      } on DioError catch (e) {
        print(e.response);
        if (e.response == null) {
          emit(state.copyWith(
              status: Status.submissionFailure,
              errorMessage: 'Нужен интернет'));
        }
        if (e.response!.data['redirect_uri'] != null) {
          Navigator.pushNamed(event.context!, '/2fa',
              arguments: e.response!.data);
        } else {
          emit(
            state.copyWith(
                status: Status.submissionFailure,
                errorMessage: e.response!.data['error_description']),
          );
        }
      } catch (e) {
        emit(state.copyWith(
            status: Status.submissionFailure, errorMessage: 'some error'));
      }
    });

    on<LoadUserEvent>((event, emit) {
      User? user = userBox.get('user');
      if (user != null) {
        emit(state.copyWith(user: user));
        musicLoaderBloc.add(LoadMusicEvent());
        playlistLoaderBloc.add(Load4PlayListEvent());
      }
    });
    on<LogoutUserEvent>((event, emit) {
      userBox.delete('user');
      emit(AuthState());
    });
  }
}

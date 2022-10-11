// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vk_music/model/playlist.dart';
import 'package:vk_music/model/song.dart';
import 'package:vk_music/model/user.dart';

class VKApi {
  final auth = _VKAuth();
  final music = _VKMusic();
}

class _VKAuth {
  Future<Map> auth({required String login, required String password}) async {
    final dio = Dio();
    final authResponse = await dio.post('https://oauth.vk.com/token',
        options: Options(headers: {
          "User-Agent":
              "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
          "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
        }),
        queryParameters: {
          '2fa_supported': '1',
          'grant_type': 'password',
          'scope': 'nohttps,audio',
          'client_id': 2274003,
          'client_secret': 'hHbZxrka2uZ6jB1inYsH',
          'validate_token': 'true',
          'username': login,
          'password': password
        });
    return authResponse.data;
  }
}

class _VKMusic {
  Box userBox = Hive.box('userBox');
  Future<dynamic> getMusic({required String args}) async {
    final User user = userBox.get('user');
    final String deviceId = _getRandomString(16);
    const double v = 5.95;
    final String url =
        '/method/audio.get?v=$v&access_token=${user.accesToken}&device_id=$deviceId&$args';
    final hash = crypto.md5.convert(utf8.encode(url + user.secret));
    var response = await Dio().get('https://api.vk.com$url&sig=$hash',
        options: Options(headers: {
          "User-Agent":
              "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
          "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
        }));
    late dynamic data;
    if (response.data['response'] == null) {
      data = response.data['error']['error_msg']; 
    } else {
      data = (response.data['response']!['items'] as List)
          .map((e) => Song.fromMap(map: e))
          .toList();
    }
    return data;
  }

  Future<Map<String, dynamic>> getPlaylist({required String args}) async {
    final User user = userBox.get('user');
    final String deviceId = _getRandomString(16);
    const double v = 5.95;
    final String url =
        '/method/audio.getPlaylists?v=$v&access_token=${user.accesToken}&device_id=$deviceId&$args&owner_id=${user.userId}';
    final hash = crypto.md5.convert(utf8.encode(url + user.secret));

    var response = await Dio().get('https://api.vk.com$url&sig=$hash',
        options: Options(headers: {
          "User-Agent":
              "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
          "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
        }));
    final int count = response.data['response']['count'];
    final List<PlayList> playlists =
        (response.data['response']['items'] as List).map((e) {
      return PlayList.fromMap(e);
    }).toList();

    return {'count': count, 'playlists': playlists};
  }

  String _getRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}

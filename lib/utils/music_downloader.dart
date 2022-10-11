import 'dart:convert';
import 'dart:io';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../helpers/helpers.dart';
import '../model/ts.dart';

class MusicDownloader {
  download({url, name, id}) async {
    final ts = await _m3u8parse(url);
    final projectPath = await getExternalStorageDirectory();
    final tempDir = Directory('${projectPath!.path}/$id');

    final sections = await _tsDownloader(ts: ts, path: tempDir);
    await _createFullSongTS(sections: sections, path: tempDir);
    await _convertToMP3(
        inputName: 'newTrack', fullName: name, path: tempDir, id: id);
  }

  Future<List<TSModel>> _m3u8parse(url) async {
    final data = await getDataFromUrl(url);

    final newsplt = data!.split('EXT-X-KEY');
    final List<TSModel> ts = [];
    final urlm3u8 = url.split(RegExp(r'index.m3u8'))[0];
    for (var element in newsplt) {
      if (element.contains('METHOD')) {
        if (element.split('=')[1].contains('NONE')) {
          for (var element1 in element.split('=')[1].split('#')) {
            if (element1.contains('EXTINF')) {
              final duration =
                  element1.split(RegExp(r'EXTINF:'))[1].split(',')[0];
              final name = element1
                  .split(RegExp(r'EXTINF:'))[1]
                  .split(',')[1]
                  .split('\n')[1];
              final fileURL = urlm3u8 + name;
              ts.add(TSModel(
                  keyURL: 'NONE',
                  duration: duration,
                  name: name,
                  fileURL: fileURL));
            }
          }
        }
        if (element.split('=')[1].contains('AES-128')) {
          final keyURL = element.split('=')[2].split(RegExp(r'"'))[1];
          final duration =
              element.split('=')[2].split(RegExp(r'EXTINF:'))[1].split(',')[0];

          final name = element
              .split('=')[2]
              .split(RegExp(r','))[1]
              .split('#')[0]
              .split('\n')[1];

          final fileURL = urlm3u8 + name;
          ts.add(TSModel(
              keyURL: keyURL,
              duration: duration,
              name: name,
              fileURL: fileURL));
        }
      }
    }
    return ts;
  }

  _tsDownloader({required List<TSModel> ts, required Directory path}) async {
    final dio = Dio();
    path.create();
    int i = 0;
    List<File> sections = [];
    for (TSModel element in ts) {
      i++;
      String filePath = '${path.path}/$i.ts';
      await dio.download(
        element.fileURL,
        filePath,
      );
      if (element.keyURL != 'NONE') {
        await _decrypte(filePath, element.keyURL);
      }

      sections.add(File(filePath));
    }
    return sections;
  }

  _decrypte(filePath, keyUrl) async {
    final key = await getDataFromUrl(keyUrl);
    File file = File(filePath);
    final fileBytes = await file.readAsBytes();
    List<int> bytes = utf8.encode(key!);
    var crypt = AesCrypt();
    Uint8List iv1 = Uint8List.fromList(
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
    crypt.aesSetKeys(bytes as Uint8List, iv1);
    crypt.setOverwriteMode(AesCryptOwMode.on);

    final decriptBytes = await compute(crypt.aesDecrypt, fileBytes);
    File newFile = File(filePath);
    await newFile.writeAsBytes(decriptBytes);
  }

  _createFullSongTS({required List<File> sections, path}) async {
    File file = File('${path.path}/newTrack.ts');
    for (var i = 0; i < sections.length; i++) {
      await file.writeAsBytes(await sections[i].readAsBytes(),
          mode: FileMode.append);
    }
  }

  _convertToMP3({inputName, fullName, required Directory path, id}) async {
    final tempDir = await getExternalStorageDirectory();
    final String inpPath = '${path.path}/$inputName.ts';
    final File outFile = File('${path.path}/$id.mp3');
    final command =
        "-i '$inpPath' -acodec copy -vcodec copy -f mp3 '${outFile.path}'";
    await FFmpegKit.execute(
      command,
    );
    await outFile.copy('${tempDir!.path}/$fullName.mp3');
    await path.delete(recursive: true);
  }
}

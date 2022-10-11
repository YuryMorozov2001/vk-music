import 'package:dio/dio.dart';

Future<String?> getDataFromUrl(String url) async {
  final dio = Dio();
  try {
    final response = await dio.get(url);
    return response.toString();
  } catch (exception) {
    throw Exception(exception);
  }
}

format(Duration d) {
  return '${d.inMinutes}:${'${d.inSeconds.remainder(60)}'.padLeft(2, '0')}';
}

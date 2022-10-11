import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:webview_flutter/webview_flutter.dart';

import '../../logic/auth_bloc/auth_bloc.dart';

class TFAScreen extends StatefulWidget {
  const TFAScreen({Key? key, required this.redirectUri}) : super(key: key);
  final String redirectUri;
  @override
  State<TFAScreen> createState() => _TFAScreenState();
}

class _TFAScreenState extends State<TFAScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        navigationDelegate: (NavigationRequest request) async {
          if (request.url.startsWith('https://oauth.vk.com/blank.html')) {
            context.read<AuthBloc>().add(AuthUserEvent(url: request.url));
            Navigator.pop(context);
          }
          return NavigationDecision.navigate;
        },
        userAgent:
            'VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)',
        initialUrl: widget.redirectUri,
      ),
    );
  }
}

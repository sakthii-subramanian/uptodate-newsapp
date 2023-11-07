// ignore_for_file: unused_local_variable, avoid_print, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  final String webUrl;
  final bool isDModeArticle;
  ArticleView({
    required this.webUrl,
    required this.isDModeArticle,
  });

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_sharp,
            color: widget.isDModeArticle == true ? Colors.greenAccent : Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: widget.isDModeArticle == true ? Colors.black : Colors.white,
        centerTitle: true,
        title: Text(
          "UPTODATE",
          style: TextStyle(
            color: widget.isDModeArticle == true ? Colors.greenAccent : Colors.black,
            fontSize: 35,
          ),
        ),
      ),
      body: Container(
        child: WebView(
          initialUrl: widget.webUrl,
          onProgress: (int progress) {
            print("Web view is loading progress : $progress");
          },
          onWebViewCreated: ((WebViewController webController) {
            _completer.complete(webController);
          }),
        ),
      ),
    );
  }
}

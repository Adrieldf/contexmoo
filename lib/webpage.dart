import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';

class WebPage extends StatefulWidget {
  final String name;
  final String link;

  const WebPage({Key? key, required this.name, required this.link})
      : super(key: key);

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late WebViewController _controller;
  Timer? _timer;
  int _timeLeft = 5;
  bool _refreshVisible = true;

  String get link => widget.link;
  String get name => widget.name;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeLeft == 0) {
          setState(() {
            timer.cancel();
            _timeLeft = 5;
            enableRefresh();
          });
        } else {
          setState(() {
            _timeLeft--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeLeft = 5;
    super.dispose();
  }

  void refresh() {
    setState(() {
      _refreshVisible = false;
    });
    startTimer();
    context.loaderOverlay.show();

    _controller.loadUrl(link);
  }

  void enableRefresh() {
    setState(() {
      _refreshVisible = true;
    });
    context.loaderOverlay.hide();
  }

  Future<String?> getCurrentURL() {
    return _controller.currentUrl();
  }

  Future<void> onPageFinishedLoading(url) async {
    if (url == null || url == "") {
      url = await getCurrentURL();
    }
    debugPrint("FINISHED LOADING URL: $url");
    if (url.toString().endsWith('404')) {
      refresh();
      return;
    }
    enableRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () => {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Made with ♥ by Adrieldf")))
          },
        ),
        actions: [
          /*    IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed:
                  _refreshVisible && _canGoBack ? () => navigate(true) : null),
          IconButton(
              icon: Icon(Icons.arrow_forward_rounded),
              onPressed: _refreshVisible && _canGoForward
                  ? () => navigate(false)
                  : null),*/
          IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _refreshVisible ? refresh : null),
        ],
      ),
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: SpinKitCubeGrid(
            color: Theme.of(context).colorScheme.primary,
            size: 50.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: link,
              onPageFinished: (url) => onPageFinishedLoading(url),
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
                //  refresh();
              },
            ),
          ),
        ),
      ),
    );
  }
}

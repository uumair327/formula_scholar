import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'platform_view_registry.dart';

class WebviewHtmlWidget extends StatefulWidget {
  const WebviewHtmlWidget({super.key, required this.config});

  final Map<String, dynamic> config;

  @override
  State<WebviewHtmlWidget> createState() => _WebviewHtmlWidgetState();
}

class _WebviewHtmlWidgetState extends State<WebviewHtmlWidget> {
  WebViewController? _controller;
  html.IFrameElement? _webIframe;
  Timer? _debounce;
  late final String _viewId;
  bool _pageLoaded = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _viewId = 'html-viewer-${DateTime.now().millisecondsSinceEpoch}';

      _webIframe = html.IFrameElement()
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..srcdoc = _buildHtmlString();

      registerViewFactory(_viewId, (int viewId) {
        return _webIframe!;
      });
    } else {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              setState(() {
                _pageLoaded = true;
              });
            },
          ),
        )
        ..loadHtmlString(_buildHtmlString());
    }
  }

  @override
  void didUpdateWidget(covariant WebviewHtmlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config['htmlContent'] != oldWidget.config['htmlContent']) {
      if (kIsWeb) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () {
          if (mounted && _webIframe != null) {
            _webIframe!.srcdoc = _buildHtmlString();
          }
        });
      } else if (_pageLoaded) {
        _controller?.loadHtmlString(_buildHtmlString());
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: kIsWeb
          ? HtmlElementView(viewType: _viewId)
          : WebViewWidget(controller: _controller!),
    );
  }

  String _buildHtmlString() {
    final rawHtml =
        widget.config['htmlContent'] as String? ??
        '<div style="color:white;text-align:center;margin-top:20px;font-family:sans-serif;">No HTML Content Provided</div>';

    // Ensure the raw HTML has basic styling if not fully formed
    if (!rawHtml.toLowerCase().contains('<html')) {
      return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    body, html {
      margin: 0; padding: 0; width: 100%; height: 100%;
      background-color: transparent; overflow: hidden;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      color: #ffffff;
      box-sizing: border-box;
    }
    #container { 
      width: 100%; height: 100%; 
      position: relative;
      overflow: hidden;
    }
  </style>
</head>
<body>
  <div id="container">
    $rawHtml
  </div>
</body>
</html>
''';
    }

    return rawHtml;
  }
}

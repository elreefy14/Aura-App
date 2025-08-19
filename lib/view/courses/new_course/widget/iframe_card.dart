import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../controllers/courses/my_course_details.dart';

class IframeCard extends ConsumerStatefulWidget {
  final String iframeUrl;
  final Contents? model;
  final StateProvider<bool>? isViewContent;
  const IframeCard({
    super.key,
    this.model,
    this.isViewContent,
    required this.iframeUrl,
  });

  @override
  ConsumerState<IframeCard> createState() => _IframeCardState();
}

class _IframeCardState extends ConsumerState<IframeCard> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializwWebView();
  }

  void _initializwWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('Loading progress: $progress%');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');

            if (widget.model != null && widget.model?.isViewed == false) {
              if (mounted) {
                makeContentView();
              }
            }
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('HTTP error: ${error.response}');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web resource error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('Blocked navigation to: ${request.url}');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(widget.iframeUrl);
  }

  void makeContentView() {
    ref
        .read(myCourseDetailsController.notifier)
        .makeContentView(widget.model!.id)
        .then((value) {
      if (value.isSuccess) {
        if (mounted) {
          ref.read(widget.isViewContent!.notifier).state = value.response;
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant IframeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iframeUrl != oldWidget.iframeUrl) {
      _controller.loadHtmlString(widget.iframeUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: WebViewWidget(controller: _controller),
    );
  }
}

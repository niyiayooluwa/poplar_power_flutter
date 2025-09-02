import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends HookConsumerWidget{
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Pay'),
      ),
      body: WebViewWidget(
        controller: ref.read(webViewControllerProvider)
      ),
    );
  }
}

final webViewControllerProvider = Provider.autoDispose<WebViewController>((ref) {
  return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://flutter.dev'),
      );
});
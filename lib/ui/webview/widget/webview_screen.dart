import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poplar_power/ui/core/viewmodels/transaction_flow_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends HookConsumerWidget {
  final String webPaymentUrl;

  const WebViewScreen({super.key, required this.webPaymentUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionFlowProvider);
    final transactionFlowNotifier = ref.read(transactionFlowProvider.notifier);

    final controller = useMemoized(() => WebViewController());

    useEffect(() {
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent('Flutter;Webview')
        ..addJavaScriptChannel(
          'PaystackChannel',
          onMessageReceived: (message) {
            debugPrint('Message from PaystackChannel: ${message.message}');
            if (message.message == 'success') {
              transactionFlowNotifier.completeWebPayment();
            } else if (message.message == 'closed') {
              transactionFlowNotifier.cancelTransaction();
            }
            // context.pop(); // Removed: Orchestrator will handle popping the webview
          },
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar. (Optional)
            },
            onPageStarted: (String url) {
              // ... existing logic ...
            },
            onPageFinished: (String url) {
              debugPrint('WebView Page Finished: $url');
              controller.runJavaScript('''
                window.addEventListener('message', (event) => {
                  if (event.origin === 'https://checkout.paystack.com') {
                    const data = event.data;
                    if (data.event === 'closed') {
                      PaystackChannel.postMessage('closed');
                    } else if (data.event === 'success') {
                      PaystackChannel.postMessage('success');
                    }
                  }
                });
              ''');
            },
            onWebResourceError: (WebResourceError error) {
              // ... existing logic ...
            },
            onNavigationRequest: (NavigationRequest request) {
              final uri = Uri.parse(request.url);
              debugPrint('WebView Navigation: ${request.url}');

              // Case 1: User closes the Paystack popup
              if (uri.host == 'standard.paystack.co' && uri.path == '/close') {
                transactionFlowNotifier.cancelTransaction();
                context.pop();
                return NavigationDecision.prevent;
              }

              // Case 2: Paystack redirects to a callback URL
              if (uri.queryParameters.containsKey('trxref') ||
                  uri.queryParameters.containsKey('reference')) {
                debugPrint('Paystack callback detected: ${request.url}');
                transactionFlowNotifier.completeWebPayment();
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(webPaymentUrl));
      return null; // No cleanup needed
    }, [controller, webPaymentUrl]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: BackButton(
          onPressed: () {
            transactionFlowNotifier.cancelTransaction();
            context.pop();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (transactionState.step == TransactionFlowStep.verifying)
          // Show a loading overlay while verifying
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Verifying transaction...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class ZagePayments extends StatefulWidget {
  const ZagePayments({
    Key? key,
    this.publicKey = '',
    this.paymentToken = '',
    this.onComplete,
    this.onExit,
  }) : super(key: key);

  final String publicKey;
  final String paymentToken;
  final void Function(Object)? onComplete;
  final void Function()? onExit;

  @override
  State<ZagePayments> createState() => _ZagePaymentsState();
}

class _ZagePaymentsState extends State<ZagePayments> {
  bool _isIframeLoaded = false;

  void setIsIframeLoaded() {
    setState(() {
      _isIframeLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var zageWebView = InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          transparentBackground: true,
          useShouldOverrideUrlLoading: true,
        ),
      ),
      initialUrlRequest: URLRequest(
          url: Uri.parse('https://production.zage.dev/checkout')),
      onWebViewCreated: (controller) async {
        controller.addJavaScriptHandler(
            handlerName: 'paymentCompleted', callback: (args) {
          if (widget.onComplete != null) {
            widget.onComplete!(args);
          }
          Navigator.pop(context);
        }
        );

        controller.addJavaScriptHandler(
            handlerName: 'paymentExited', callback: (args) {
          if (widget.onExit != null) {
            widget.onExit!();
          }
          Navigator.pop(context);
        }
        );
      },

      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var url = navigationAction.request.url;
        if (url != null && !url.host.endsWith('zage.dev')) {
          launchUrl(url, mode: LaunchMode.inAppWebView);
          return NavigationActionPolicy.CANCEL;
        }

        return NavigationActionPolicy.ALLOW;
      },
      onLoadStop: (controller, url) async {
        if (_isIframeLoaded) {
          return;
        }
        await controller.injectJavascriptFileFromUrl(
          urlFile: Uri.parse('https://api.zage.dev/v1/v1-flutter.js'),
          scriptHtmlTagAttributes: ScriptHtmlTagAttributes(
            id: 'zage-js',
            onLoad: () async {
              setIsIframeLoaded();
              await controller.evaluateJavascript(
                source: "openPayment('${widget.paymentToken}', '${widget.publicKey}')",
              );
            },
            onError: () {
              print('An unknown error occurred while attempting to inject the Zage API');
            }
          ),
        );
      },

    );

    return Scaffold(
      backgroundColor: const Color(0x1F000000),
      resizeToAvoidBottomInset: true,
      body: zageWebView
    );
  }
}
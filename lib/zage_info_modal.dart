import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class ZageInfoModal extends StatefulWidget {
  const ZageInfoModal({
    Key? key,
    this.publicKey = '',
  }) : super(key: key);

  final String publicKey;

  @override
  State<ZageInfoModal> createState() => _ZageInfoModalState();
}

class _ZageInfoModalState extends State<ZageInfoModal> {
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
          url: Uri.parse('https://info.zage.dev/')),
      onWebViewCreated: (controller) async {
        controller.addJavaScriptHandler(
            handlerName: 'dismiss', callback: (args) {
          Navigator.pop(context);
        });
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
                source: "openModal('${widget.publicKey}')",
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
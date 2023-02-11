import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenland/core/themes/my_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CentralGovtSchemesPage extends StatelessWidget {
  CentralGovtSchemesPage({super.key});

  final progress = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int p) => progress(p * 1 / 100),
        ),
      )
      ..loadRequest(Uri.parse('https://agricoop.nic.in/en/Major#gsc.tab=0'));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Central Govt Schemes'),
        actions: [
          IconButton(
            onPressed: () => controller.reload(),
            icon: const Icon(Icons.replay),
          ),
          IconButton(
            onPressed: () async {
              if (await controller.canGoBack()) controller.goBack();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            onPressed: () async {
              if (await controller.canGoForward()) controller.goForward();
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(
            () => LinearProgressIndicator(
              value: progress() * 1,
              minHeight: 5,
              color: MyColors.primary(255),
            ),
          ),
          Expanded(
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}

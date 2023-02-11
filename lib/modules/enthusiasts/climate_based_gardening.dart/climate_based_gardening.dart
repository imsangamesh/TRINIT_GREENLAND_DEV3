import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenland/core/themes/my_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ClimateBasedGardening extends StatelessWidget {
  ClimateBasedGardening({super.key});

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
      ..loadRequest(Uri.parse(
          'https://www.easytogrowbulbs.com/blogs/articles-and-tips/best-plants-for-your-growing-zone-and-climate#:~:text=Best%20Plants%20for%20Your%20Growing%20Zone%20and%20Climate,in%20the%20north%21%20...%203%20Temperate%20Temptations%20'));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Climate based Gardening'),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/themes/my_colors.dart';

class FarmerConsultants extends StatelessWidget {
  FarmerConsultants({super.key});

  final companies = [
    'Clean Green Biosystems',
    'Dhavalas',
    'Evergreen Agro Tech',
    'Global Agriculture System',
    'IACG',
    'Irrigation Professionals',
    'Jain Irrigation Systems Ltd.',
    'Sure Grow',
    'Valanadu Sustainable Agriculture Producer Company',
  ];

  final links = [
    'https://consultants.siliconindia.com/vendor/clean-green-biosystems-green-technology-clean-ecology-cid-10846.html',
    'https://consultants.siliconindia.com/vendor/dhavalas-onestop-agribusiness-enterprise-cid-10847.html',
    'https://consultants.siliconindia.com/ranking/10-most-promising-agriculture-consultants-2019-rid-817.html',
    'https://consultants.siliconindia.com/ranking/10-most-promising-agriculture-consultants-2019-rid-817.html',
    'https://consultants.siliconindia.com/vendor/iacg-innovating-collaborative-solutions-cid-10848.html',
    'https://consultants.siliconindia.com/vendor/irrigation-professionals-leading-design-and-consulting-service-provider-cid-10849.html',
    'https://consultants.siliconindia.com/ranking/10-most-promising-agriculture-consultants-2019-rid-817.html',
    'https://consultants.siliconindia.com/vendor/sure-grow-aeroponic-hydroponic-vertical-farming-solution-providers-cid-10851.html',
    'https://consultants.siliconindia.com/vendor/valanadu-empowering-farmers-cid-10852.html',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultanting Companies')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: companies.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              onTap: () => Get.to(
                  () => ConsultantDetails(companies[index], links[index])),
              title: Text(companies[index]),
              trailing: const Icon(Icons.double_arrow, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class ConsultantDetails extends StatelessWidget {
  ConsultantDetails(this.name, this.url, {super.key});

  final String url, name;
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
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(name),
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

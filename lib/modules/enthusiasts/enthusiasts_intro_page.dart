import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenland/core/themes/my_colors.dart';
import 'package:greenland/modules/farmers/consultants/farmer_consultants.dart';

import '../../core/themes/my_textstyles.dart';
import '../../core/widgets/my_buttons.dart';
import 'chats/enthusiast_expert_chat_screen.dart';
import 'climate_based_gardening.dart/climate_based_gardening.dart';
import 'faqs/faqs.dart';
import 'gardening_community/gardening_community_page.dart';

class EnthusiastsIntroPage extends StatelessWidget {
  EnthusiastsIntroPage({super.key});

  final links = [
    'https://www.startus-insights.com/innovators-guide/agriculture-trends-innovation/',
    'https://eos.com/blog/top-5-newest-technologies-in-agriculture/',
    'https://www.bacancytechnology.com/blog/agriculture-technology-trends',
    'https://www.agrifarming.in/latest-agriculture-technologies-in-india-impact-advantages',
    'https://www.climateaction.org/news/10-innovations-in-agriculture1',
    'https://intellias.com/innovations-in-agriculture/',
  ];

  final names = [
    'Top 10 Agriculture Trends, Technologies & Innovations for 2023',
    'Top 5 Newest Technologies In Agriculture',
    'Agriculture Technology Trends: Collaborating Tech with Agriculture',
    'Latest Agriculture Technologies in India, Impact, Advantages',
    '10 Innovations in Agriculture',
    'The Future of AgriTech: Trends and Innovations in Agriculture to Watch in 2023',
  ];

  final images = [
    'https://www.startus-insights.com/wp-content/uploads/2021/11/AgriTech-Trends-SharedImg-StartUs-Insights-noresize-900x506.png',
    'https://eos.com/wp-content/uploads/2019/10/main-768x240.jpg.webp?x99872',
    'https://www.bacancytechnology.com/blog/wp-content/uploads/2021/04/quote-1024x580.jpg',
    'https://www.agrifarming.in/wp-content/uploads/2020/02/Comp3-20-1024x683.jpg',
    'https://www.climateaction.org/images/made/images/uploads/articles/sharon-rosseels-zTY0RQgqb5g-unsplash_1000_667_80.jpg',
    'https://d17ocfn2f5o4rl.cloudfront.net/wp-content/uploads/2022/04/drones-agriculture.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                height: 250,
                aspectRatio: 2,
              ),
              items: images
                  .map(
                    (ech) => InkWell(
                      splashColor: MyColors.primary(100),
                      onTap: () => Get.to(
                        () => ConsultantDetails(names[images.indexOf(ech)],
                            links[images.indexOf(ech)]),
                      ),
                      child: Stack(
                        // alignment: Alignment.center,
                        children: [
                          Image.network(
                            ech,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            left: 5,
                            bottom: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                width: 250,
                                child: Text(
                                  names[images.indexOf(ech)],
                                  style: MyTStyles.kTS15Medium,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 5,
                            child: MyCloseBtn(
                              icon: Icons.chevron_right,
                              ontap: () => Get.to(
                                () => ConsultantDetails(
                                    names[images.indexOf(ech)],
                                    links[images.indexOf(ech)]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 25),
            ListTile(
              onTap: () => Get.to(() => const EnthusiastExpertChatScreen()),
              title: const Text('Chat with Expert'),
              trailing: const Icon(Icons.double_arrow, size: 20),
            ),
            const SizedBox(height: 15),
            ListTile(
              onTap: () => Get.to(() => const GardeningCommunityPage()),
              title: const Text('Gardening Community'),
              trailing: const Icon(Icons.double_arrow, size: 20),
            ),
            const SizedBox(height: 15),
            ListTile(
              onTap: () => Get.to(() => ClimateBasedGardening()),
              title: const Text('Climate based Gardening'),
              trailing: const Icon(Icons.double_arrow, size: 20),
            ),
            const SizedBox(height: 15),
            ListTile(
              onTap: () => Get.to(() => FAQs()),
              title: const Text('Frequently asked Questions'),
              trailing: const Icon(Icons.double_arrow, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

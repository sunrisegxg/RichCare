import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:translator/translator.dart';

import 'constants/colors.dart';
import 'models/guidemodel.dart';
import 'resultsscreen.dart';
import 'services/guide_service.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  List<GuideModel> guides = [];
  bool isLoading = true;

  int selectedIndex = 0;

  late PageController _pageController;
  late ScrollController _tabScrollController;

  final List<String> tabs = [
    'tab_all',
    'tab_diseases',
    'tab_farming',
    'tab_fertilizer',
    'tab_tips',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabScrollController = ScrollController();
    loadGuides();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  Future<void> loadGuides() async {
    try {
      final data = await GuideService.fetchGuides();

      if (!mounted) return;

      setState(() {
        guides = data;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR LOAD GUIDES: $e");
      if (!mounted) return;

      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// 🔍 Search
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'search'.tr(),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Tabs
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xffEDEFF3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    controller: _tabScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedIndex = index);

                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tabs[index].tr(),
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.grey,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: isLoading
                    ? ListView.builder(
                        itemCount: 5, // số shimmer items
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundlistTileColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 14,
                                          width: double.infinity,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          height: 12,
                                          width: double.infinity,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          height: 12,
                                          width: 150,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => selectedIndex = index);
                        },
                        itemCount: tabs.length,
                        itemBuilder: (context, pageIndex) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(top: 4),
                            itemCount: guides.length,
                            itemBuilder: (context, index) {
                              final item = guides[index];

                              return buildGuideItem(item);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGuideItem(GuideModel item) {
    return FutureBuilder<GuideModel>(
      future: _translateIfNeeded(item),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.backgroundlistTileColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 12,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                        Container(height: 12, width: 150, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final translatedItem = snapshot.data ?? item;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResultsScreen(
                  type: ResultType.guide,
                  guide: translatedItem,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.backgroundlistTileColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    // nếu API chưa có image -> dùng placeholder
                    // item.image ??
                    "https://images.unsplash.com/photo-1501004318641-b39e6451bec6",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translatedItem.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        translatedItem.definition,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<GuideModel> _translateIfNeeded(GuideModel item) async {
    if (context.locale.languageCode == 'en') {
      final translator = GoogleTranslator();
      final titleTrans = await translator.translate(
        item.title,
        from: 'auto',
        to: 'en',
      );
      final defTrans = await translator.translate(
        item.definition,
        from: 'auto',
        to: 'en',
      );
      return GuideModel(
        idFE: item.idFE,
        title: titleTrans.text,
        definition: defTrans.text,
        symtomz: item.symtomz,
        measurement: item.measurement,
        cause: item.cause,
        speadrisk: item.speadrisk,
        humidity: item.humidity,
        severity: item.severity,
      );
    }
    return item;
  }
}

import 'package:flutter/material.dart';

import 'constants/colors.dart';
import 'resultsscreen.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int selectedIndex = 0;

  late PageController _pageController;
  late ScrollController _tabScrollController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  final List<String> tabs = [
    "All",
    "Diseases",
    "Farming",
    "Fertilizer",
    "Pest",
    "Tips",
  ];

  final List<Map<String, String>> articles = [
    {
      "title": "Rice Blast Disease",
      "desc":
          "How to detect rice blast early to detect rice blast early to detect rice blast early",
      "image": "https://images.unsplash.com/photo-1501004318641-b39e6451bec6",
    },
    {
      "title": "Fertilizer Schedule for Rice",
      "desc":
          "How to detect rice blast early to detect rice blast early to detect rice blast early",
      "image": "https://images.unsplash.com/photo-1501004318641-b39e6451bec6",
    },
    {
      "title": "Diagnose",
      "desc":
          "How to detect rice blast early to detect rice blast early to detect rice blast early",
      "image": "https://images.unsplash.com/photo-1501004318641-b39e6451bec6",
    },
    {
      "title": "Diagnose",
      "desc":
          "How to detect rice blast early to detect rice blast early to detect rice blast early",
      "image": "https://images.unsplash.com/photo-1501004318641-b39e6451bec6",
    },
  ];

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
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search Articles...",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xffEDEFF3), // nền xám nhạt
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
                          final diff = (selectedIndex - index).abs();

                          setState(() {
                            selectedIndex = index;
                          });

                          _scrollToCenter(index); // 👈 thêm dòng này

                          if (diff <= 1) {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _pageController.jumpToPage(index);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.grey,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: isSelected
                                  ? 15
                                  : 14, // optional: làm nổi hơn
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// 📄 List bài viết
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                    });

                    _scrollToCenter(index); // 👈 thêm dòng này
                  },
                  itemCount: tabs.length,
                  itemBuilder: (context, pageIndex) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 4),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final item = articles[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ResultsScreen(type: ResultType.guide),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundlistTileColor,
                              borderRadius: BorderRadius.circular(14),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.04),
                              //     blurRadius: 8,
                              //     offset: const Offset(0, 3),
                              //   ),
                              // ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item["image"]!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["title"]!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item["desc"]!,
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToCenter(int index) {
    double itemWidth = 80; // ước lượng width mỗi tab
    double screenWidth = MediaQuery.of(context).size.width;

    double offset = index * itemWidth - (screenWidth / 2) + (itemWidth / 2);

    _tabScrollController.animateTo(
      offset.clamp(
        _tabScrollController.position.minScrollExtent,
        _tabScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

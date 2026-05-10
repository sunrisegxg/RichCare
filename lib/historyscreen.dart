import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'constants/colors.dart';
import 'history_result_screen.dart';
import 'models/historymodel.dart';
import 'services/history_service.dart';
import 'services/token_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? userId;

  List<HistoryModel> historyList = [];
  bool isLoading = true;

  final PageController _pageController = PageController();
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  // ================= LOAD DATA =================
  void loadUser() async {
    final id = await TokenService.getUserId();
    if (!mounted || id == null) return;

    final data = await HistoryService().getHistoryOnce(id);

    setState(() {
      userId = id;
      historyList = data;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildHeader(),
            const SizedBox(height: 16),
            buildSegmentedControl(),
            const SizedBox(height: 12),

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => selectedTab = index);
                },
                children: [buildTodayList(), buildAllList()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER (CÓ KHUNG MENU) =================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'history'.tr(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          // 🔥 KHUNG NÚT MENU
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.menu, size: 20),
          ),
        ],
      ),
    );
  }

  // ================= SEGMENTED (KHUNG ĐẸP + SLIDE) =================
  Widget buildSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            // 🔥 SLIDE BACKGROUND
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: selectedTab == 0
                  ? 4
                  : (MediaQuery.of(context).size.width - 32) / 2 + 4,
              right: selectedTab == 1
                  ? 4
                  : (MediaQuery.of(context).size.width - 32) / 2 + 4,
              top: 4,
              bottom: 4,
              child: Container(
                width: (MediaQuery.of(context).size.width - 40) / 2,
                margin: const EdgeInsets.only(left: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            Row(
              children: [
                Expanded(child: buildTab('tab_today'.tr(), 0)),
                Expanded(child: buildTab('tab_all'.tr(), 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTab(String text, int index) {
    final isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedTab = index);

        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      },
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  // ================= TODAY =================
  Widget buildTodayList() {
    final now = DateTime.now();

    final todayList = historyList.where((item) {
      return item.time.year == now.year &&
          item.time.month == now.month &&
          item.time.day == now.day;
    }).toList();

    if (todayList.isEmpty) {
      return Center(child: Text('no_history_today'.tr()));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: todayList.length,
      itemBuilder: (context, index) {
        return historyItem(todayList[index]);
      },
    );
  }

  // ================= ALL =================
  Widget buildAllList() {
    if (historyList.isEmpty) {
      return Center(child: Text('no_history_yet'.tr()));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: historyList.length,
      itemBuilder: (context, index) {
        return historyItem(historyList[index]);
      },
    );
  }

  // ================= ITEM =================
  Widget historyItem(HistoryModel item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HistoryResultScreen(history: item)),
      ),
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
                item.imageUrl,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 55,
                  height: 55,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String>(
                    future: context.locale.languageCode == "vi"
                        ? Future.value(item.titleVi)
                        : GoogleTranslator()
                              .translate(item.titleVi, to: "en")
                              .then((value) => value.text),

                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? item.titleVi,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${'confidence'.tr()}: ${item.confidence}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            Text(
              "${item.time.day}/${item.time.month}/${item.time.year}",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

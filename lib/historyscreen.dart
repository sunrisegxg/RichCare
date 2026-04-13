import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'resultsscreen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔹 Header (thay AppBar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "History",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.menu, size: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            buildSegmentedControl(),

            const SizedBox(height: 12),

            // 🔹 List
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
                children: [buildTodayList(), buildAllList()],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            // 🔥 nền trắng trượt
            AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double page = 0;

                if (_pageController.hasClients &&
                    _pageController.page != null) {
                  page = _pageController.page!;
                } else {
                  page = selectedTab.toDouble();
                }

                return Align(
                  alignment: Alignment(-1 + page * 2, 0), // 🔥 trượt realtime
                  child: child,
                );
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 32) / 2,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 text + click
            Row(
              children: [
                Expanded(child: buildTab("Today", 0)),
                Expanded(child: buildTab("All", 1)),
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
      behavior: HitTestBehavior.opaque, // 🔥 click full vùng
      onTap: () {
        setState(() {
          selectedTab = index;
        });

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
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget buildTodayList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) => historyItem(),
    );
  }

  Widget buildAllList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 10,
      itemBuilder: (context, index) => historyItem(),
    );
  }

  Widget historyItem() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(type: ResultType.history),
        ),
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
              child: Image.asset(
                "assets/images/paddy1.jpg",
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Rice Blast Disease",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "How to detect rice blast early",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const Text(
              "15 Jun 2026",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

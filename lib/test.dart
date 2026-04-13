import 'package:flutter/material.dart';
import 'guidescreen.dart';
import 'chatscreen.dart';
import 'constants/colors.dart';
import 'historyscreen.dart';
import 'homescreen.dart';
import 'scanscreen.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int _selectedIndex = 0;
  List<Widget> get _pages => [
    HomeScreen(),
    ChatScreen(),
    GuideScreen(),
    HistoryScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ScanScreen()),
          );
        },
        child: Icon(Icons.camera_alt_outlined, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, -4), // bóng hướng lên
                ),
              ],
            ),
          ),
          BottomAppBar(
            color: Colors.white,
            elevation: 0,
            shape: AutomaticNotchedShape(
              RoundedRectangleBorder(),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            ),
            notchMargin: 8,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => _onItemTapped(0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.home,
                          color: _selectedIndex == 0
                              ? AppColors.primaryColor
                              : AppColors.textBottomColor,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedIndex == 0
                                ? AppColors.primaryColor
                                : AppColors.textBottomColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onItemTapped(1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat,
                          color: _selectedIndex == 1
                              ? AppColors.primaryColor
                              : AppColors.textBottomColor,
                        ),
                        Text(
                          "Chat",
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedIndex == 1
                                ? AppColors.primaryColor
                                : AppColors.textBottomColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 40),
                  GestureDetector(
                    onTap: () => _onItemTapped(2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.book,
                          color: _selectedIndex == 2
                              ? AppColors.primaryColor
                              : AppColors.textBottomColor,
                        ),
                        Text(
                          "Guide",
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedIndex == 2
                                ? AppColors.primaryColor
                                : AppColors.textBottomColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onItemTapped(3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history,
                          color: _selectedIndex == 3
                              ? AppColors.primaryColor
                              : AppColors.textBottomColor,
                        ),
                        Text(
                          "History",
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedIndex == 3
                                ? AppColors.primaryColor
                                : AppColors.textBottomColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

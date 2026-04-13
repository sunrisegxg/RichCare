import 'package:flutter/material.dart';
import 'package:ricecare/authswitcherscreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'components/btn_next.dart';
import 'components/btn_text.dart';
import 'constants/colors.dart';
import 'loginscreen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentPageIndex = 0;
  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/paddy1.jpg",
      "title": "Protect your rice crops",
      "description":
          " helps you detect rice plant diseases early and keep your crops healthy.",
    },
    {
      "image": "assets/images/paddy2.webp",
      "title": "Scan rice leaves",
      "description":
          "Take a photo or upload an image of rice leaves to start the analysis.",
    },
    {
      "image": "assets/images/paddy3.webp",
      "title": "AI disease detection",
      "description":
          "Our AI analyzes the image to identify possible diseases on rice plants.",
    },
    {
      "image": "assets/images/paddy3.webp",
      "title": "Get results instantly",
      "description":
          "Receive accurate diagnoses and helpful recommendations for your crops.",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          onPageChanged: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(pages[index]["image"]!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: (MediaQuery.of(context).size.height * 0.6),
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      // boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        children: [
                          //logo
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "RiceCare",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.logoNameColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Image.asset(
                                'assets/images/logo.jpg',
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          // title
                          Text(
                            pages[index]["title"]!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 16),
                          // description
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                index == 0
                                    ? TextSpan(
                                        text: "RiceCare",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.logoNameColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : TextSpan(),
                                TextSpan(
                                  text: pages[index]["description"]!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textNormalColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(), // row of indicators & button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SmoothPageIndicator(
                                controller: _pageController,
                                count: 4,
                                axisDirection: Axis.horizontal,
                                effect: ExpandingDotsEffect(
                                  spacing: 24.0,
                                  dotWidth: 12.0,
                                  dotHeight: 12.0,
                                  dotColor: AppColors.dotColor,
                                  activeDotColor: AppColors.primaryColor,
                                  expansionFactor: 3,
                                ),
                              ),
                              index == 3
                                  ? BtnText(
                                      text: "Start now",
                                      width: 120,
                                      onPressed: () =>
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AuthSwitcherScreen(),
                                            ),
                                          ),
                                    )
                                  : BtnNext(
                                      onPressed: () => _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

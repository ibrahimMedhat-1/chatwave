import 'package:flutter/material.dart';

import '../../auth/login.dart';

class AppColor {
  static Color kPrimary = const Color(0XFF2E4374);
  static Color kLightAccentColor = const Color(0XFFF4E5F7);
  static Color kGrey3Color = const Color(0XFFC4D7E0);
  static Color kBGColor = const Color(0XFFFAF6F0);


}
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBGColor,
      body: Column(
        children: [
          Expanded(
              child: Padding(
                padding:
                const EdgeInsets.only( right: 10, top: 5.76),
                child: Image.asset(pageViewList[_currentIndex].image),
              )),
          Expanded(
            child: Column(
              children: [
                Expanded(
                    child: PageView.builder(
                        itemCount: pageViewList.length,
                        controller: pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return OnboardingCard(
                            onBoardingList: pageViewList,
                            currentIndex: index,
                            pageController: pageController,
                          );
                        }))
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding:
        const EdgeInsets.only(top: 65, left: 32, right: 32, bottom: 57),
        child: PrimaryButton(
          onTap: () {
            if (_currentIndex == pageViewList.length - 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else {
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
            }
          },
          text: _currentIndex == pageViewList.length - 1 ? 'Get Started' : 'Continue',
          bgColor: AppColor.kPrimary,
          borderRadius: 30,
          height: 48,
          width: MediaQuery.of(context).size.width*0.75,
          textColor: Colors.white,
        ),
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final IconData? iconData;
  final Color? textColor, bgColor;
  const PrimaryButton(
      {Key? key,
        required this.onTap,
        required this.text,
        this.width,
        this.height,
        this.borderRadius,
        this.fontSize,
        required this.textColor,
        required this.bgColor,
        this.iconData})
      : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Card(

          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
          ),
          child: Container(
            height: widget.height ?? 55,
            alignment: Alignment.center,
            width: widget.width ?? double.maxFinite,
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.circular(widget.borderRadius!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.iconData != null) ...[
                  Icon(
                    widget.iconData,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize ?? 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingCard extends StatelessWidget {
  final List<OnBoarding> onBoardingList;
  final int currentIndex;
  PageController pageController;

  OnboardingCard({
    Key? key,
    required this.onBoardingList,
    required this.currentIndex,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppColor.kPrimary,
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70, left: 35, right: 34),
              child: Text(
                pageViewList[currentIndex].title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

          ],
        ));
  }
}

class OnBoarding {
  String title;
  String image;

  OnBoarding({
    required this.title,
    required this.image,
  });
}

List<OnBoarding> pageViewList = [
  OnBoarding(
    title:
    'Your Favorite ChatApp. with pro features',
    image: 'assets/images/Black White Yellow Minimal and Modern Podcast Studio Logo (6).png',
  ),
  OnBoarding(
    title:
    'Higher security by adding AI technology in voice Detection',
    image: 'assets/images/Black White Yellow Minimal and Modern Podcast Studio Logo (7).png',
  ),
  OnBoarding(
    title:
    "Let's Start your journey with Us",
    image: 'assets/images/Black White Yellow Minimal and Modern Podcast Studio Logo (5).png',
  ),
];
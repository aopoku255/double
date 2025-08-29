import 'package:doubles/src/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 40,
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: _pages.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnboardingContent(
                    image: _pages[index].image,
                    title: _pages[index].title,
                    description: _pages[index].description,
                  ),
                ),
              ),
              _pageIndex + 1 == _pages.length
                  ? InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Proceed",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(
                            color: AppColors.primaryRed,
                            borderRadius: BorderRadius.circular(10)),
                      ))
                  : Row(
                      children: [
                        ...List.generate(
                            _pages.length,
                            (index) => Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: DotIndicator(
                                      isActive: index == _pageIndex),
                                )),
                        Spacer(),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: AppColors.primaryRed,
                                foregroundColor: Colors.white),
                            child: Icon(Icons.arrow_forward),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isActive ? 14 : 6,
      width: 4,
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class Onboard {
  final String image, title, description;
  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> _pages = [
  Onboard(
    image: "assets/images/gather.png",
    title: "Interactive & Practical Approach",
    description:
        "Our workshops are interactive, using practical tools and insights to empower couples to tackle issues proactively, fostering open communication and deeper connections.",
  ),
  Onboard(
    image: "assets/images/events.png",
    title: "Strengthening Marriages with Purpose",
    description:
        "Doubles is a quarterly workshop designed to engage couples in meaningful conversations that nurture, support, and strengthen the bonds of marriage according to God's divine plan.",
  ),
  Onboard(
    image: "assets/images/schedule.png",
    title: "Equipping Couples with the Right Tools",
    description:
        " Since its launch in 2022, Doubles has been a game-changer for marriages, providing couples with essential tools and unwavering support to enhance their relationships.",
  ),
];

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),

        // Image.asset(
        //   image,
        //   height: 250,
        // ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w500, color: AppColors.primaryBlue),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          description,
          style: Theme.of(context)
              .textTheme!
              .labelLarge!
              .copyWith(color: AppColors.primaryBlue),
          textAlign: TextAlign.center,
        ),
        const Spacer()
      ],
    );
  }
}

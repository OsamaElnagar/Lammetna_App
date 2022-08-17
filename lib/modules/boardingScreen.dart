import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_app/models/boardingModel.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import '../shared/bloc/AppCubit/states.dart';
import '../shared/components/constants.dart';
import '../shared/network/local/cache_helper.dart';
import 'loginScreen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  PageController pageController = PageController();

  // late int _currentPage;
  //
  // @override
  // void initState() {
  //   _currentPage = 0;
  //
  //   pageController.nextPage(
  //     duration: const Duration(milliseconds: 700),
  //     curve: Curves.bounceIn,
  //   );
  //   pageController.addListener(() {
  //     setState(() {
  //       _currentPage = pageController.page!.toInt();
  //     });
  //   });
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   pageController.dispose();
  //   super.dispose();
  // }

  void submit(context) {
    CacheHelper.putData('lastPage', lastPage!).then((value) {
      if (value) {
        navigate2(
          context,
          const LoginScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                onPressed: () {
                  submit(context);
                },
                child: Text(
                  'Skip',
                  style: GoogleFonts.lobster(
                      fontSize: 28.0, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) {
                    if (index == cubit.boarding.length - 1) {
                      setState(() {
                        lastPage = true;
                      });
                    } else {
                      setState(() {
                        lastPage = false;
                      });
                    }
                  },
                  itemBuilder: (context, index) =>
                      onBoardingBuilder(cubit.boarding[index]),
                  controller: pageController,
                  itemCount: cubit.boarding.length,
                ),
              ),
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 5.0),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: cubit.boarding.length,
                    effect: const ExpandingDotsEffect(
                      dotWidth: 16.0,
                      dotHeight: 16.0,
                      dotColor: Colors.grey,
                      activeDotColor: myColor,
                      radius: 16.0,
                      spacing: 6,
                      expansionFactor: 4.0,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: lastPage != true
                      ? FloatingActionButton(
                          onPressed: () {
                            if (lastPage == true) {
                              submit(context);
                            } else {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.bounceIn,
                              );
                            }
                          },
                          child: const Icon(Icons.arrow_forward_ios),
                        )
                      : ElevatedButton(
                          onPressed: ()
                          {
                            submit(context);
                          },
                          child: const Text('Let\'s get started.')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget onBoardingBuilder(BoardingModel boardingModel) {
  return Column(
    children: [
      Expanded(
        child: Image(
          image: AssetImage(boardingModel.image),
          fit: BoxFit.fitWidth,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          boardingModel.title,
          style: GoogleFonts.lobster(
            fontSize: 40.0,
            fontWeight: FontWeight.w900,
            color: myColor,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          boardingModel.body,
          style: GoogleFonts.abel(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}

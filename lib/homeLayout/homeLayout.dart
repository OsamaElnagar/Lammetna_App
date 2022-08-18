import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/components/animatedFAB.dart';
import '../shared/bloc/AppCubit/states.dart';
import '../shared/styles/iconBroken.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  title: cubit.appTitles[cubit.currentIndex],
                  actions: [
                    if (cubit.currentIndex == 2)
                      TextButton(
                          onPressed: () {
                            cubit.signOut(context);
                          },
                          child: const Text('SignOut',
                          style:TextStyle(color: Colors.white)
                            ,),),
                    if (cubit.currentIndex == 1)
                      IconButton(
                        onPressed: () {
                          cubit.wannaSearch();
                        },
                        icon: const Icon(IconBroken.Search)),
                  ],
                  bottom: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    onTap: (index) {
                      cubit.changeIndex(index);
                    },
                    tabs: const [
                      Tab(
                        icon: Icon(
                          IconBroken.Home,
                        ),
                        text: 'Feeds',
                      ),
                      Tab(
                        icon: Icon(IconBroken.Chat),
                        text: 'Chats',
                      ),
                      Tab(
                        icon: Icon(IconBroken.Profile),
                        text: 'Profile',
                      ),
                    ],
                  ),
                ),
              ],
              body: Stack(
                children: [
                  TabBarView(children: cubit.screens),
                  if (cubit.currentIndex == 0) const AnimatedFeedsFAB(),
                  if (cubit.currentIndex == 1) const AnimatedChatsFAB(),
                  if (cubit.currentIndex == 2) const AnimatedProfileFAB(),
                ],
              ),
            ),
            // bottomNavigationBar: AnimatedContainer(
            //   duration: const Duration(milliseconds: 500),
            //   height: _isVisible ? 60.0 : 0.0,
            //   child: _isVisible
            //       ? BottomNavigationBar(
            //           landscapeLayout:
            //               BottomNavigationBarLandscapeLayout.spread,
            //           currentIndex: cubit.currentIndex,
            //           items: cubit.items,
            //           onTap: (index) {
            //             cubit.changeIndex(index);
            //           },
            //         )
            //       : Container(
            //           color: Colors.white,
            //           width: MediaQuery.of(context).size.width,
            //         ),
            // ),
          ),
        );
      },
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/demo/cubit.dart';
import 'package:social_app/demo/demoVideo.dart';
import 'package:social_app/demo/states.dart';
import 'package:social_app/homeLayout/homeLayout.dart';
import 'package:social_app/modules/boardingScreen.dart';
import 'package:social_app/modules/loginScreen.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/blocObserver.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

import 'demo/chewie_demo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  bool? lastPage = CacheHelper.getData('lastPage');
  uId = CacheHelper.getData('uid');
  final Widget stWidget;
  if (lastPage != null) {
    if (uId != null) {
      stWidget = const HomeLayout();
    } else {
      stWidget = const LoginScreen();
    }
  } else {
    stWidget = const OnBoardingScreen();
  }
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        stWidget: stWidget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget stWidget;

  const MyApp({Key? key, required this.stWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit(AppInitialState())
            ..getUserData()
            ..getStory()
            ..getFeedPosts(),
        ),
        BlocProvider(create:(context) => DemoCubit(DemoInitStates()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: stWidget,
      ),
    );
  }
}

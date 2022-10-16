import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/demo/demoPostItem.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        const String vL = 'https://firebasestorage.googleapis.com/v0/b/social'
            '-app-201c9.appspot.com/o/big_buck_bunny_480p_20mb.mp4'
            '?alt=media&token=71cd9cee-324c-4999-9f9e-9d2b7b52979e';
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Column(
                children: [
                  ListView.separated(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildDemoPostItem(
                          context: context,
                          index: index,
                          postModel: cubit.feedPosts[index],
                          moreVert: Container());
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 1,
                      );
                    },
                    itemCount: cubit.feedPosts.length,
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

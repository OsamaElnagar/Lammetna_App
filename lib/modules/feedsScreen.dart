import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/modules/postScreen.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/buildStoryItem.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import '../shared/components/buildPostItem.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return RefreshIndicator(
          color: Colors.deepPurple,
          onRefresh: () {
            return Future.delayed(
              const Duration(milliseconds: 1800),
              () {
                cubit.getFeedPosts();
                cubit.getStory();
              },
            );
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: SizedBox(
                    width: double.infinity,
                    height: 180.0,
                    child: Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.deepPurple,
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                color: Colors.white.withOpacity(.4),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Scroll down to see what people do...',
                                    style: GoogleFonts.lobster(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                color: Colors.white.withOpacity(.4),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Or you can tell us what\'s in your mind!',
                                    style: GoogleFonts.lobster(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              if (cubit.loginModel != null)
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            cubit.loginModel!.profileImage),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        navigateTo(
                                            context, const NewPostScreen());
                                      },
                                      child: const Text(
                                        'More details',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Stories for today',
                    style: GoogleFonts.lobster(
                        fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ConditionalBuilder(
                            condition: cubit.loginModel != null,
                            builder: (context) => buildFirstStoryItem(
                                context: context,
                                loginModel: cubit.loginModel!),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          ConditionalBuilder(
                            condition: cubit.stories.isNotEmpty,
                            builder: (context) => ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                storyIndex = index;
                                return buildStoryItem(
                                    context: context,
                                    index: index,
                                    storyModel: cubit.stories[index]);
                              },
                              itemCount: cubit.stories.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 2,
                              ),
                            ),
                            fallback: (context) => const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ConditionalBuilder(
                  condition: AppCubit.get(context).feedPosts.isNotEmpty,
                  builder: (context) => ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildPostItem(
                          postModel: cubit.feedPosts[index],
                          // loginModel: cubit.allUsers[index],
                          context: context,
                          index: index,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.black.withOpacity(.5),
                        );
                      },
                      itemCount: AppCubit.get(context).feedPosts.length),
                  fallback: (context) => Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: InkWell(
                      onTap: () {
                        navigateTo(context, const NewPostScreen());
                      },
                      child: Text(
                        'No posts here yet, be the first to post in this app.',
                        style: GoogleFonts.lobster(
                            color: Colors.deepPurple,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

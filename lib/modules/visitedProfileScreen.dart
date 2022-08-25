import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/buildPostItem.dart';

import '../shared/components/components.dart';

class VisitedProfileScreen extends StatelessWidget {
  Map<String, dynamic> user;

  VisitedProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              color: Colors.deepPurple,
              onRefresh: () {
                return Future.delayed(
                  const Duration(milliseconds: 1800),
                  () {
                    cubit.getUserData();
                    cubit.getPosts();
                  },
                );
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 210,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      topLeft: Radius.circular(5),
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: 160,
                                  child: Card(
                                    color: Colors.deepPurple,
                                    child: Image(
                                      image: NetworkImage(user['profileCover']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.deepPurple,
                                      radius: 65,
                                      child: CircleAvatar(
                                        radius: 62,
                                        backgroundImage:
                                            NetworkImage(user['profileImage']),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          user['name'],
                          style: GoogleFonts.actor(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            user['bio'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.actor(
                                fontSize: 15.0, fontWeight: FontWeight.w300),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Posts',
                            style: GoogleFonts.alef(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ConditionalBuilder(
                          condition: cubit.visitedUserPosts.isNotEmpty,
                          builder:(context)=> ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => buildProfilePostItem(
                              postModel: cubit.visitedUserPosts[index],
                              index: index,
                              context: context,
                            ),
                            separatorBuilder: (context, index) => const SizedBox(
                              height: 2,
                            ),
                            itemCount: cubit.visitedUserPosts.length,
                          ),
                          fallback: (context) => Column(
                            children: [
                              const Icon(
                                Icons.heart_broken_outlined,
                                size: 150,
                                color: Colors.black54,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'It seems like ${user['name']} doesn\'t have any posts.',
                                  style: GoogleFonts.allertaStencil(
                                      color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

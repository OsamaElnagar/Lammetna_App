import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/modules/postScreen.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import '../shared/components/buildPostItem.dart';
import '../shared/components/popupMenuItems.dart';
import 'modifyPostScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double bottomSheetHeight = 350;
  late Offset tapXY;
  RenderBox? overlay;

  @override
  void initState() {
    AppCubit.get(context).getPosts();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox?;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var profileModel = AppCubit.get(context).loginModel;
        return Scaffold(
          body: RefreshIndicator(
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
              child: SafeArea(
                top: true,
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
                                      image: NetworkImage(
                                          profileModel!.profileCover),
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
                                        backgroundImage: NetworkImage(
                                            profileModel.profileImage),
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
                          profileModel.name,
                          style: GoogleFonts.actor(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            profileModel.bio,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.actor(
                                fontSize: 15.0, fontWeight: FontWeight.w300),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                    Text(
                      'Your Posts',
                      style: GoogleFonts.allerta(fontSize: 30),
                    ),
                    ConditionalBuilder(
                      condition: cubit.myPosts.isNotEmpty,
                      builder: (context) => ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return buildProfilePostItem(
                                moreVert: InkWell(
                                  onTapDown: getPosition,
                                  onTap: () {
                                    showMenu(
                                      context: context,
                                      position: relRectSize,
                                      items: [
                                        popupDo(
                                          onPress: () {
                                            Navigator.pop(context);
                                            navigateTo(context, ModifyPostScreen(postModel: cubit.myPosts[index],));
                                          },
                                          childLabel: 'Modify',
                                        ),
                                        popupDo(
                                          onPress: () {},
                                          childLabel: 'Delete',
                                        ),
                                        popupDo(
                                          onPress: () {},
                                          childLabel: 'invisible',
                                        ),
                                      ],
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.more_vert),
                                  ),
                                ),
                                postModel: cubit.myPosts[index],
                                context: context,
                                index: index);
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.black.withOpacity(.5),
                            );
                          },
                          itemCount: cubit.myPosts.length),
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
                              'It seems like you are new here,Try adding new post to let people now you are here',
                              style: GoogleFonts.allertaStencil(
                                  color: Colors.black87),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              navigateTo(context, const NewPostScreen());
                            },
                            child: const Text('Ok, Let\'s go.'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 70,
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

  // ↓ create the RelativeRect from size of screen and where you tapped
  RelativeRect get relRectSize =>
      RelativeRect.fromSize(tapXY & const Size(40, 40), overlay!.size);

  // ↓ get the tap position Offset
  void getPosition(TapDownDetails detail) {
    tapXY = detail.globalPosition;
  }
}

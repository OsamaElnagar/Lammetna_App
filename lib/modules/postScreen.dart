import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/homeLayout/homeLayout.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/iconBroken.dart';

import '../shared/components/buildPostItem.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  bool whileCreatingPost = false;
  TextEditingController textEditingController = TextEditingController();
  String postText = '';

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var postModel = AppCubit.get(context).loginModel;
        var postImageFile = AppCubit.get(context).postImageFile;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create new post'),
            actions: [
              TextButton(
                onPressed: () {
                  postText = '';
                  AppCubit.get(context).clearPostImagesList();
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(state is AppCreatePostLoadingState)
                  const LinearProgressIndicator(),
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
                                  image: NetworkImage(postModel!.profileCover),
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
                                        NetworkImage(postModel.profileImage),
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
                      postModel.name,
                      style: GoogleFonts.actor(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    if (whileCreatingPost || postImageFile != null)
                      TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Scaffold(
                                  body: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (postText != '' ||
                                                      postImageFile != null) {
                                                    if (postImageFile != null) {
                                                      AppCubit.get(context)
                                                          .uploadPostWithImage(
                                                        postText: postText,
                                                        postDate: DateTime.now()
                                                            .toLocal()
                                                            .toString(),
                                                      );
                                                    } else {
                                                      AppCubit.get(context)
                                                          .createFeedPost(
                                                        postText: postText,
                                                        postDate: DateTime.now()
                                                            .toLocal()
                                                            .toString(),
                                                      );
                                                      AppCubit.get(context)
                                                          .createPost(
                                                              postText:
                                                                  postText,
                                                              postDate: DateTime
                                                                      .now()
                                                                  .toLocal()
                                                                  .toString(),
                                                              context: context);
                                                    }
                                                    AppCubit.get(context)
                                                        .clearPostImagesList();
                                                    postText = '';
                                                    Future.delayed(Duration(seconds: 3,),() {
                                                      navigate2(context,
                                                          const HomeLayout());
                                                    }, );
                                                  }
                                                },
                                                child: const Text('Post',),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Edit'))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Card(
                                          elevation: 10,
                                          child: testPostItem(
                                            context: context,
                                            text: textEditingController.text,
                                            loginModel: postModel,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: const Text('See how it looks before posting'),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Tell people what\'s in your mind...!',
                        style: GoogleFonts.aclonica(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: textEditingController,
                      keyboardType: TextInputType.text,
                      onChanged: (inputText) {
                        setState(() {
                          postText = inputText;
                        });
                      },
                      onFieldSubmitted: (text) {
                        setState(() {
                          whileCreatingPost = true;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 80,
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(.7),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'add one of these to your post',
                              style: GoogleFonts.aclonica(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              AppCubit.get(context).getGalleryPostImage();
                            },
                            icon: const Icon(
                              IconBroken.Image,
                              size: 40,
                              color: Colors.yellow,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              AppCubit.get(context).getCameraPostImage();
                            },
                            icon: const Icon(
                              IconBroken.Camera,
                              size: 40,
                              color: Colors.greenAccent,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              AppCubit.get(context).getCameraPostImage();
                            },
                            icon: const Icon(
                              IconBroken.Play,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.emoji_emotions_rounded,
                              size: 40,
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (postImageFile != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: FileImage(postImageFile),
                          fit: BoxFit.cover,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple.withOpacity(.8),
                        child: IconButton(
                          onPressed: () {
                            dialogMessage(
                              context: context,
                              title: const Text(
                                'remove',
                                style: TextStyle(color: Colors.red),
                              ),
                              content: const Text(
                                'Are you sure deleting this photo?',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      AppCubit.get(context).undoGetPostImage(
                                          postImageFile.lastAccessed());
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: const Text(
                                    'Ok',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                          icon: const Icon(IconBroken.Close_Square),
                        ),
                      ),
                    ],
                  ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (postText != '' ||
                          postImageFile!= null) {
                        if (postImageFile != null) {
                          AppCubit.get(context).uploadPostWithImage(
                            postText: postText,
                            postDate: DateTime.now().toLocal().toString(),
                          );
                        } else {
                          AppCubit.get(context).createFeedPost(
                              postText: postText,
                              postDate: DateTime.now().toLocal().toString(),
                              context: context);
                          AppCubit.get(context).createPost(
                              postText: postText,
                              postDate: DateTime.now().toLocal().toString(),
                              context: context);
                        }
                        AppCubit.get(context).clearPostImagesList();
                        postText = '';
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Post now'),
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/buildPostItem.dart';
import 'package:social_app/shared/styles/iconBroken.dart';

import '../models/postModel.dart';

class ModifyPostScreen extends StatelessWidget {
  PostModel postModel;

  ModifyPostScreen({Key? key, required this.postModel}) : super(key: key);

  bool whileCreatingPost = false;
  TextEditingController textEditingController = TextEditingController();
  String postText = '';

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        textEditingController.text = postModel.postText;
        // var postModel = AppCubit.get(context).loginModel;
        // var postImageFile = AppCubit.get(context).postImageFile;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Modify post'),
            actions: [
              TextButton(
                onPressed: () {
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
                const SizedBox(
                  height: 10,
                ),
                modifyPostItem(
                  text: textEditingController.text,
                  postModel: postModel,
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
                      onChanged: (inputText) {},
                      onFieldSubmitted: (text) {
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
                // if (postImageFile != null)
                //   Stack(
                //     alignment: AlignmentDirectional.topEnd,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Image(
                //           image: FileImage(postImageFile),
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //       CircleAvatar(
                //         backgroundColor: Colors.deepPurple.withOpacity(.8),
                //         child: IconButton(
                //           onPressed: () {
                //             dialogMessage(
                //               context: context,
                //               title: const Text(
                //                 'remove',
                //                 style: TextStyle(color: Colors.red),
                //               ),
                //               content: const Text(
                //                 'Are you sure deleting this photo?',
                //                 style: TextStyle(
                //                   fontSize: 14.0,
                //                 ),
                //               ),
                //               actions: [
                //                 OutlinedButton(
                //                   onPressed: () {
                //                     Navigator.pop(context);
                //                   },
                //                   child: const Text('Cancel'),
                //                 ),
                //                 OutlinedButton(
                //                   onPressed: () {
                //                     setState(() {
                //                       AppCubit.get(context).undoGetPostImage(
                //                           postImageFile.lastAccessed());
                //                       Navigator.pop(context);
                //                     });
                //                   },
                //                   child: const Text(
                //                     'Ok',
                //                     style: TextStyle(color: Colors.red),
                //                   ),
                //                 ),
                //               ],
                //             );
                //           },
                //           icon: const Icon(IconBroken.Close_Square),
                //         ),
                //       ),
                //     ],
                //   ),
                // Center(
                //     child: Padding(
                //       padding: const EdgeInsets.all(12.0),
                //       child: ElevatedButton(
                //         onPressed: () {
                //           if (postText != '' ||
                //               postImageFile!= null) {
                //             if (postImageFile != null) {
                //               AppCubit.get(context).uploadPostWithImage(
                //                 postText: postText,
                //                 postDate: DateTime.now().toLocal().toString(),
                //               );
                //             } else {
                //               AppCubit.get(context).createFeedPost(
                //                   postText: postText,
                //                   postDate: DateTime.now().toLocal().toString(),
                //                   context: context);
                //               // AppCubit.get(context).createPost(
                //               //     postText: postText,
                //               //     postDate: DateTime.now().toLocal().toString(),
                //               //     context: context);
                //             }
                //             AppCubit.get(context).clearPostImagesList();
                //             postText = '';
                //             Navigator.pop(context);
                //           }
                //         },
                //         child: const Text('Post now'),
                //       ),
                //     )),
              ],
            ),
          ),
        );
      },
    );
  }
}

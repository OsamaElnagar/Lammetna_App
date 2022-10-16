import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:social_app/models/loginModel.dart';
import 'package:social_app/models/postModel.dart';
import 'package:social_app/modules/commentScreen.dart';
import 'package:social_app/modules/profileScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import '../../demo/videoPost.dart';
import '../bloc/AppCubit/cubit.dart';
import '../styles/iconBroken.dart';

Widget buildPostItem({
  context,
  required PostModel postModel,
  index,
  required Widget moreVert,
}) {
  double iconSize = 33;
  String postDate = postModel.postDate;
  postDate = DateFormat.yMMMMEEEEd().format(DateTime.parse(postDate));
  var cubit = AppCubit.get(context);

  return Card(
    margin: EdgeInsetsDirectional.zero,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 2, right: 2, bottom: 4, top: 4),
          child: InkWell(
            onTap: () {
              pint('Profile no:$index clicked');
              pint(postModel.postUid);

              if (postModel.postUid == cubit.loginModel!.uId) {
                navigateTo(context, const ProfileScreen());
              } else {
                cubit.searchForUser(uId: postModel.postUid, context: context);
              }
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.deepPurple,
                  child: CircleAvatar(
                    radius: 29.0,
                    backgroundImage: NetworkImage(postModel.profileImage),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        postModel.name,
                        style: GoogleFonts.aclonica(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        postDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          height: .6,
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                moreVert
                // IconButton(
                //   onPressed: () {
                //     showMenu(
                //         context: context,
                //         position: const RelativeRect.fromLTRB(20, 100, 0, 0),
                //         color: Theme.of(context).scaffoldBackgroundColor,
                //         elevation: 20.0,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //         items: [
                //           const PopupMenuItem(
                //             child: SizedBox(
                //               width: 100,
                //               child: Text('data 1'),
                //             ),
                //           ),
                //           const PopupMenuItem(
                //             child: Text(
                //               'data 2',
                //               style: TextStyle(),
                //             ),
                //           ),
                //           const PopupMenuItem(
                //             child: Text('data 3'),
                //           ),
                //           const PopupMenuItem(
                //             child: Text('data 4'),
                //           ),
                //         ]);
                //   },
                //   icon: const Icon(
                //     Icons.more_vert,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        if (postModel.postText != '')
          //If I have a text whether I have an image or not.
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: ReadMoreText(
              postModel.postText,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        const SizedBox(
          height: 4,
        ),
        if (postModel.postImage != '')
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              InkWell(
                onTap: () {
                  showBottomSheet(
                    backgroundColor: Colors.black.withOpacity(.9),
                    context: context,
                    builder: (context) => SizedBox(
                      height: MediaQuery.of(context).size.height - 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.more_vert,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Image(
                              image: NetworkImage(postModel.postImage!),
                            ),
                          ),
                          if (postModel.postText != '')
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                postModel.postText,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white,
                                ),
                                maxLines:3,
                                overflow: TextOverflow.ellipsis,

                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Container(
                              color: Colors.black12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(cubit.feedPostId[index])
                                            .collection('likes')
                                            .doc(cubit.loginModel!.uId)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Icon(
                                              IconBroken.Heart,
                                            );
                                          }
                                          if (snapshot.data!.exists) {
                                            return InkWell(
                                              onTap: () {
                                                cubit.likeFeedPost(
                                                    feedPostId:
                                                        cubit.feedPostId[index],
                                                    liked: true);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  IconBroken.Heart,
                                                  color: Colors.red,
                                                  size: iconSize,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return InkWell(
                                              onTap: () {
                                                cubit.likeFeedPost(
                                                    feedPostId:
                                                        cubit.feedPostId[index],
                                                    liked: false);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  IconBroken.Heart,
                                                  color: Colors.grey,
                                                  size: iconSize,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(cubit.feedPostId[index])
                                            .collection('likes')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!.docs.length.toString(),
                                              style: const TextStyle(color: Colors.white),
                                            );
                                          } else {
                                            return const Text(
                                              '0',
                                              style: TextStyle(color: Colors.white),
                                            );
                                          }
                                        },
                                      ),
                                      const Text('likes',
                                          style:  TextStyle(color: Colors.white)),


                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          postIndex = index;
                                          cubit.getComments(
                                              feedPostId:
                                              cubit.feedPostId[index]);
                                          // cubit.getStoredReply(postId: cubit.feedPostId[index]);
                                          navigateTo(
                                              context, const CommentsScreen());
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            IconBroken.More_Square,
                                            color: Colors.green,
                                            size: iconSize,
                                          ),
                                        ),
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(cubit.feedPostId[index])
                                            .collection('comments')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!.docs.length.toString(),
                                              style: const TextStyle(color: Colors.white),
                                            );
                                          } else {
                                            return const Text(
                                              '0',
                                              style: TextStyle(color: Colors.white),
                                            );
                                          }
                                        },
                                      ),
                                      const Text('comments',
                                          style:  TextStyle(color: Colors.white)),


                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            IconBroken.Send,
                                            color: Colors.blue,
                                            size: iconSize,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        postModel.postShares.toString(),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      const Text('shares',
                                          style:  TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Image(
                  image: NetworkImage(postModel.postImage!),
                  fit: BoxFit.cover,
                  height: 380,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                    ));
                    // You can use LinearProgressIndicator or CircularProgressIndicator instead
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Text('Some errors occurred!'),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 55.0,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(cubit.feedPostId[index])
                              .collection('likes')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!.docs.length.toString(),
                                style: const TextStyle(color: Colors.white),
                              );
                            } else {
                              return const Text(
                                '0',
                                style: TextStyle(color: Colors.white),
                              );
                            }
                          },
                        ),
                        const Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(cubit.feedPostId[index])
                              .collection('comments')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!.docs.length.toString(),
                                style: const TextStyle(color: Colors.white),
                              );
                            } else {
                              return const Text(
                                '0',
                                style: TextStyle(color: Colors.white),
                              );
                            }
                          },
                        ),
                        const Icon(
                          IconBroken.More_Square,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          postModel.postShares.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Icon(
                          IconBroken.Send,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        if (postModel.videoLink != '')
          InkWell(
            child: VideoPost(
              videoLink: postModel.videoLink!,
            ),
          ),
        //Reactions Bar/////////////////////////////////🔽🔽🔽
        if (postModel.postImage != '')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(cubit.feedPostId[index])
                    .collection('likes')
                    .doc(cubit.loginModel!.uId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Icon(
                      IconBroken.Heart,
                    );
                  }
                  if (snapshot.data!.exists) {
                    return InkWell(
                      onTap: () {
                        cubit.likeFeedPost(
                            feedPostId: cubit.feedPostId[index], liked: true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: iconSize,
                        ),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        cubit.likeFeedPost(
                            feedPostId: cubit.feedPostId[index],
                            liked: false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          IconBroken.Heart,
                          color: Colors.grey,
                          size: iconSize,
                        ),
                      ),
                    );
                  }
                },
              ),
              InkWell(
                onTap: () {
                  postIndex = index;
                  cubit.getComments(feedPostId: cubit.feedPostId[index]);
                  // cubit.getStoredReply(postId: cubit.feedPostId[index]);
                  navigateTo(context, const CommentsScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    IconBroken.More_Square,
                    color: Colors.green,
                    size: iconSize,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    IconBroken.Send,
                    color: Colors.blue,
                    size: iconSize,
                  ),
                ),
              ),
            ],
          ),
        if (postModel.postText != '' && postModel.postImage == '')
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(cubit.feedPostId[index])
                        .collection('likes')
                        .doc(cubit.loginModel!.uId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Icon(
                          IconBroken.Heart,
                        );
                      }
                      if (snapshot.data!.exists) {
                        return InkWell(
                          onTap: () {
                            cubit.likeFeedPost(
                                feedPostId: cubit.feedPostId[index],
                                liked: true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              IconBroken.Heart,
                              color: Colors.red,
                              size: iconSize,
                            ),
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            cubit.likeFeedPost(
                                feedPostId: cubit.feedPostId[index],
                                liked: false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              IconBroken.Heart,
                              color: Colors.grey,
                              size: iconSize,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(cubit.feedPostId[index])
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!.docs.length.toString(),
                          style: const TextStyle(color: Colors.red),
                        );
                      } else {
                        return const Text(
                          '0',
                          style: TextStyle(color: Colors.red),
                        );
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      postIndex = index;
                      cubit.getComments(
                          feedPostId: cubit.feedPostId[index]);
                      // cubit.getStoredReply(postId: cubit.feedPostId[commentIndex]);
                      navigateTo(context, const CommentsScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        IconBroken.More_Square,
                        color: Colors.green,
                        size: iconSize,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(cubit.feedPostId[index])
                        .collection('comments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!.docs.length.toString(),
                          style: const TextStyle(color: Colors.green),
                        );
                      } else {
                        return const Text(
                          '0',
                          style: TextStyle(color: Colors.green),
                        );
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        IconBroken.Send,
                        color: Colors.blue,
                        size: iconSize,
                      ),
                    ),
                  ),
                  Text(
                    postModel.postShares.toString(),
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        //Reactions Bar/////////////////////////////////🔼🔼🔼
      ],
    ),
  );
}

Widget testPostItem({context, required String text, required LoginModel loginModel}) {
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 0.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4, top: 4),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34.0,
                backgroundColor: Colors.deepPurple,
                child: CircleAvatar(
                  radius: 32.0,
                  backgroundImage: NetworkImage(loginModel.profileImage),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loginModel.name,
                      style: GoogleFonts.aclonica(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(DateTime.now().toString())
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.More_Circle,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        if (AppCubit.get(context).postImageFile != null)
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              Image(
                image: FileImage(AppCubit.get(context).postImageFile!),
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 55.0,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          '10K',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          '10K',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          IconBroken.More_Square,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          '10K',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          IconBroken.Send,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Heart,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.More_Square,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Send,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildProfilePostItem({
  context,
  required PostModel postModel,
  index,
  required Widget moreVert,
}) {
  double iconSize = 33;
  var cubit = AppCubit.get(context);
  String postDate = postModel.postDate;
  postDate = DateFormat.yMMMMEEEEd().format(DateTime.parse(postDate));

  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 2, right: 2, bottom: 4, top: 4),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.deepPurple,
                  child: CircleAvatar(
                    radius: 29.0,
                    backgroundImage: NetworkImage(postModel.profileImage),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        postModel.name,
                        style: GoogleFonts.aclonica(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        postDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          height: .6,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                moreVert
                // const Spacer(),
                // IconButton(
                //   onPressed: () {
                //     showMenu(
                //         context: context,
                //         position: const RelativeRect.fromLTRB(20, 100, 0, 0),
                //         color: Theme.of(context).scaffoldBackgroundColor,
                //         elevation: 20.0,
                //         items: [
                //           const PopupMenuItem(
                //             child: SizedBox(
                //               width: 100,
                //               child: Text('data 1'),
                //             ),
                //           ),
                //           const PopupMenuItem(
                //             child: Text(
                //               'data 2',
                //               style: TextStyle(),
                //             ),
                //           ),
                //           const PopupMenuItem(
                //             child: Text('data 3'),
                //           ),
                //           const PopupMenuItem(
                //             child: Text('data 4'),
                //           ),
                //         ]);
                //   },
                //   icon: const Icon(
                //     IconBroken.More_Circle,
                //   ),
                // ),
              ],
            ),
          ),
          if (postModel.postText != '')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                postModel.postText,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          const SizedBox(
            height: 4,
          ),
          if (postModel.postImage != '')
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Image(
                  image: NetworkImage(postModel.postImage!),
                  fit: BoxFit.cover,
                  height: 380,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                    ));
                    // You can use LinearProgressIndicator or CircularProgressIndicator instead
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Text('Some errors occurred!'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 55.0,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(cubit.feedPostId[index])
                                .collection('likes')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(color: Colors.white),
                                );
                              } else {
                                return const Text(
                                  '0',
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                            },
                          ),
                          const Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(cubit.feedPostId[index])
                                .collection('comments')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(color: Colors.white),
                                );
                              } else {
                                return const Text(
                                  '0',
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                            },
                          ),
                          const Icon(
                            IconBroken.More_Square,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            postModel.postShares.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Icon(
                            IconBroken.Send,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (postModel.postImage != '')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(cubit.feedPostId[index])
                      .collection('likes')
                      .doc(cubit.loginModel!.uId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Icon(
                        IconBroken.Heart,
                      );
                    }
                    if (snapshot.data!.exists) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: iconSize,
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          IconBroken.Heart,
                          color: Colors.grey,
                          size: iconSize,
                        ),
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    IconBroken.More_Square,
                    color: Colors.green,
                    size: iconSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    IconBroken.Send,
                    color: Colors.blue,
                    size: iconSize,
                  ),
                ),
              ],
            ),
          if (postModel.postText != '' && postModel.postImage == '')
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(cubit.feedPostId[index])
                            .collection('likes')
                            .doc(cubit.loginModel!.uId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Icon(
                              IconBroken.Heart,
                            );
                          }
                          if (snapshot.data!.exists) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                IconBroken.Heart,
                                color: Colors.red,
                                size: iconSize,
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                IconBroken.Heart,
                                color: Colors.grey,
                                size: iconSize,
                              ),
                            );
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          IconBroken.More_Square,
                          color: Colors.green,
                          size: iconSize,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          IconBroken.Send,
                          color: Colors.blue,
                          size: iconSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 55.0,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //////////////////
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(cubit.feedPostId[index])
                                .collection('likes')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text(
                                  '0',
                                  style: TextStyle(color: Colors.white),
                                );
                              } else {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(color: Colors.white),
                                );
                              }
                            },
                          ),
                          //////////////////
                          const Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(cubit.feedPostId[index])
                                .collection('comments')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text(
                                  '0',
                                  style: TextStyle(color: Colors.white),
                                );
                              } else {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(color: Colors.white),
                                );
                              }
                            },
                          ),
                          const Icon(
                            IconBroken.More_Square,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            postModel.postShares.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Icon(
                            IconBroken.Send,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}

Widget buildVisitedProfilePostItem({
  context,
  required PostModel postModel,
  index,
}) {
  double iconSize = 33;
  var cubit = AppCubit.get(context);
  String postDate = postModel.postDate;
  postDate = DateFormat.yMMMMEEEEd().format(DateTime.parse(postDate));

  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.only(left: 2, right: 2, bottom: 4, top: 4),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.deepPurple,
                  child: CircleAvatar(
                    radius: 29.0,
                    backgroundImage: NetworkImage(postModel.profileImage),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        postModel.name,
                        style: GoogleFonts.aclonica(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        postDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          height: .6,
                        ),
                      ),
                    ],
                  ),
                ),
                // const Spacer(),
                // IconButton(
                //   onPressed: () {
                //     showMenu(
                //         context: context,
                //         position: const RelativeRect.fromLTRB(20, 100, 0, 0),
                //         color: Theme.of(context).scaffoldBackgroundColor,
                //         elevation: 20.0,
                //         items: [
                //           const PopupMenuItem(
                //             child: SizedBox(
                //               width: 100,
                //               child: Text('data 1'),
                //             ),
                //           ),
                //           const PopupMenuItem(
                //             child: Text(
                //               'data 2',
                //               style: TextStyle(),
                //             ),
                //           ),
                //           const PopupMenuItem(
                //             child: Text('data 3'),
                //           ),
                //           const PopupMenuItem(
                //             child: Text('data 4'),
                //           ),
                //         ]);
                //   },
                //   icon: const Icon(
                //     IconBroken.More_Circle,
                //   ),
                // ),
              ],
            ),
          ),
          if (postModel.postText != '')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                postModel.postText,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          const SizedBox(
            height: 4,
          ),
          if (postModel.postImage != '')
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Image(
                  image: NetworkImage(postModel.postImage!),
                  fit: BoxFit.cover,
                  height: 380,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ));
                    // You can use LinearProgressIndicator or CircularProgressIndicator instead
                  },
                  errorBuilder: (context, error, stackTrace) =>
                  const Text('Some errors occurred!'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 55.0,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(cubit.feedPostId[index])
                                .collection('likes')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(color: Colors.white),
                                );
                              } else {
                                return const Text(
                                  '0',
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                            },
                          ),
                          const Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(cubit.feedPostId[index])
                                .collection('comments')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(color: Colors.white),
                                );
                              } else {
                                return const Text(
                                  '0',
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                            },
                          ),
                          const Icon(
                            IconBroken.More_Square,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            postModel.postShares.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Icon(
                            IconBroken.Send,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (postModel.postImage != '')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(cubit.feedPostId[index])
                      .collection('likes')
                      .doc(cubit.loginModel!.uId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Icon(
                        IconBroken.Heart,
                      );
                    }
                    if (snapshot.data!.exists) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: iconSize,
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          IconBroken.Heart,
                          color: Colors.grey,
                          size: iconSize,
                        ),
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    IconBroken.More_Square,
                    color: Colors.green,
                    size: iconSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    IconBroken.Send,
                    color: Colors.blue,
                    size: iconSize,
                  ),
                ),
              ],
            ),
          if (postModel.postText != '' && postModel.postImage == '')
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(cubit.feedPostId[index])
                            .collection('likes')
                            .doc(cubit.loginModel!.uId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Icon(
                              IconBroken.Heart,
                            );
                          }
                          if (snapshot.data!.exists) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                IconBroken.Heart,
                                color: Colors.red,
                                size: iconSize,
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                IconBroken.Heart,
                                color: Colors.grey,
                                size: iconSize,
                              ),
                            );
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          IconBroken.More_Square,
                          color: Colors.green,
                          size: iconSize,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          IconBroken.Send,
                          color: Colors.blue,
                          size: iconSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 55.0,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //////////////////
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(cubit.feedPostId[index])
                                .collection('likes')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text(
                                  '0',
                                  style: TextStyle(color: Colors.white),
                                );
                              } else {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(color: Colors.white),
                                );
                              }
                            },
                          ),
                          //////////////////
                          const Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(cubit.feedPostId[index])
                                .collection('comments')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text(
                                  '0',
                                  style: TextStyle(color: Colors.white),
                                );
                              } else {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(color: Colors.white),
                                );
                              }
                            },
                          ),
                          const Icon(
                            IconBroken.More_Square,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            postModel.postShares.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Icon(
                            IconBroken.Send,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}


Widget modifyPostItem({context, required String text, required  PostModel postModel}) {


  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 10.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4, top: 4),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34.0,
                backgroundColor: Colors.deepPurple,
                child: CircleAvatar(
                  radius: 32.0,
                  backgroundImage: NetworkImage(postModel.profileImage),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postModel.name,
                      style: GoogleFonts.aclonica(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text( postModel.postDate)
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                child: IconButton(
                  onPressed: () {
                    FocusScope.of(context)
                        .requestFocus(modifyPostTextNode);
                  },
                  icon: const Icon(
                    IconBroken.Edit,
                  ),
                ),
              ),
              Expanded(
                child : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        if (postModel.postImage != '')
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Image(
                image: NetworkImage(postModel.postImage!),
                fit: BoxFit.cover,
                height: 330,
                width: double.infinity,
              ),
              CircleAvatar(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    IconBroken.Edit,
                  ),
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Heart,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.More_Square,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Send,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

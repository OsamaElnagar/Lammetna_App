import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/loginModel.dart';
import 'package:social_app/models/postModel.dart';
import 'package:social_app/modules/coomentScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import '../bloc/AppCubit/cubit.dart';
import '../styles/iconBroken.dart';

Widget buildPostItem({context, required PostModel postModel, index}) {
  double iconSize = 33;
  var likedForFirstTime = false;
/////////////////////////////////////////////
  String postDate = postModel.postDate;
  postDate = DateFormat.yMMMMEEEEd().format(DateTime.parse(postDate));

/////////////////////////////////////////////

  var cubit = AppCubit.get(context);
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
            padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4, top: 4),
            child: InkWell(
              onTap: (){
                pint('Profile no:$index clicked' );
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
                        SizedBox(
                          height: 6,
                        ),
                        Text(postDate,style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          height: .6,
                        ),)
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showMenu(
                          context: context,
                          position: const RelativeRect.fromLTRB(20, 100, 0, 0),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          elevation: 20.0,
                          items: [
                            const PopupMenuItem(
                              child: SizedBox(
                                width: 100,
                                child: Text('data 1'),
                              ),
                            ),
                            const PopupMenuItem(
                              child: Text(
                                'data 2',
                                style: TextStyle(),
                              ),
                            ),
                            const PopupMenuItem(
                              child: Text('data 3'),
                            ),
                            const PopupMenuItem(
                              child: Text('data 4'),
                            ),
                          ]);
                    },
                    icon: const Icon(
                      IconBroken.More_Circle,
                    ),
                  ),
                ],
              ),
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
                              feedPostId: cubit.feedPostId[index], liked: false);
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
                      InkWell(
                        onTap: () {
                          postIndex = index;
                          cubit.getComments(feedPostId: cubit.feedPostId[index]);
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
        ],
      ),
    ),
  );
}

Widget testPostItem(
    {context, required String text, required LoginModel loginModel}) {
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

Widget buildProfilePostItem({context, required PostModel postModel, index}) {
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
            padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4, top: 4),
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
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        postDate,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          height: .6,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(20, 100, 0, 0),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        elevation: 20.0,
                        items: [
                          const PopupMenuItem(
                            child: SizedBox(
                              width: 100,
                              child: Text('data 1'),
                            ),
                          ),
                          const PopupMenuItem(
                            child: Text(
                              'data 2',
                              style: TextStyle(),
                            ),
                          ),
                          const PopupMenuItem(
                            child: Text('data 3'),
                          ),
                          const PopupMenuItem(
                            child: Text('data 4'),
                          ),
                        ]);
                  },
                  icon: const Icon(
                    IconBroken.More_Circle,
                  ),
                ),
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

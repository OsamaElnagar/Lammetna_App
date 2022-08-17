import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/commentReplyModel.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import '../../models/commentModel.dart';
import '../../modules/replyCommentScreen.dart';
import '../bloc/AppCubit/cubit.dart';
import '../styles/iconBroken.dart';

Widget buildCommentItem(
    {required BuildContext context,
    required CommentModel commentModel,
    required Widget replyWidget,
    index}) {
  var cubit = AppCubit.get(context);
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      // color: Colors.black.withOpacity(.2),
    ),
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 4.0,
              right: 2.0,
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(commentModel.profileImage),
            ),
          ),
          Expanded(
            child: Container(
              alignment: AlignmentDirectional.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(.7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      commentModel.name,
                                      style: GoogleFonts.aclonica(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    commentModel.commentText,
                                    style: GoogleFonts.aclonica(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 20,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(.7),
                            ),
                            child: const Icon(
                              IconBroken.More_Circle,
                              color: Colors.white,
                              size: 22.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 3,bottom: 3),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Text(
                              'like',
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              /////////////////////////////////
                              commentIndex = index;
                              cubit.getCommentsReply(
                                  postId: cubit.feedPostId[postIndex],
                                  commentId: cubit.commentId[commentIndex]);
                              navigateTo(context, const ReplyScreen());
                            },
                            child: const Text(
                              'replay',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    replyWidget,
                    // StreamBuilder<DocumentSnapshot>(
                    //   stream: FirebaseFirestore.instance
                    //       .collection('posts')
                    //       .doc(cubit.feedPostId[postIndex])
                    //       .collection('reply')
                    //       .doc(cubit.replyId[index])
                    //       .snapshots(),
                    //   builder: (context, snapshot) {
                    //     if (!snapshot.hasData) {
                    //       return const Text(
                    //         '0 replies',
                    //         style: TextStyle(color: Colors.black),
                    //       );
                    //     }
                    //     if (snapshot.data!.exists) {
                    //       return InkWell(
                    //         onTap: () {},
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(4.0),
                    //           child: StreamBuilder<QuerySnapshot>(
                    //             stream: FirebaseFirestore.instance
                    //                 .collection('posts')
                    //                 .doc(cubit.feedPostId[index])
                    //                 .collection('reply')
                    //                 .snapshots(),
                    //             builder: (context, snapshot) {
                    //               if (snapshot.hasData) {
                    //                 return Text(
                    //                   '${snapshot.data!.docs.length.toString()} replies',
                    //                   style:
                    //                       const TextStyle(color: Colors.black),
                    //                 );
                    //               } else {
                    //                 return const Text(
                    //                   '0 replies',
                    //                   style: TextStyle(color: Colors.black),
                    //                 );
                    //               }
                    //             },
                    //           ),
                    //         ),
                    //       );
                    //     } else {
                    //       return Container();
                    //     }
                    //
                    //   },
                    // ),
                    // reply widget//////////////////////////////////////
                    // if (cubit.storedReply.isNotEmpty)
                    //   ListView.separated(
                    //     shrinkWrap: true,
                    //     physics: const BouncingScrollPhysics(),
                    //     itemBuilder: (context, index) => buildReplyItem(
                    //         context: context,
                    //         commentReplyModel: cubit.commentsReply[index]),
                    //     separatorBuilder: (context, index) => Padding(
                    //       padding: const EdgeInsets.only(
                    //           left: 28.0, right: 28.0, top: 5, bottom: 5),
                    //       child: Container(
                    //         height: 1,
                    //         width: double.infinity,
                    //         color: Colors.grey[300],
                    //       ),
                    //     ),
                    //     itemCount: cubit.commentsReply.length,
                    //   ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildCommentFieldItem({
  required TextEditingController commentController,
  required BuildContext context,
  Function(String)? onChanged,
  required String commentText,
  required index,
}) {
  var cubit = AppCubit.get(context);
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.black54),
            child: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: 90,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cubit.getCameraCommentImage();
                                        },
                                        icon: const Icon(IconBroken.Camera),
                                      ),
                                      const Text('Camera'),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cubit.getGalleryCommentImage();
                                        },
                                        icon: const Icon(IconBroken.Image_2),
                                      ),
                                      const Text('Gallery'),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Icon(
                      IconBroken.Image,
                    ),
                  ),
                  hintText: 'Type a comment..',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(20),
                    left: Radius.circular(20),
                  ))),
              style: const TextStyle(
                color: Colors.white,
              ),
              cursorColor: Colors.deepPurple,
              onChanged: onChanged,
              onFieldSubmitted: (v) {},
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          child: InkWell(
            onTap: () {
              if (commentText != '' || cubit.commentImageFile != null) {
                var date = DateTime.now();
                String commentDate = DateFormat.yMMMMd().format(date);
                if (cubit.commentImageFile != null) {
                  cubit.createCommentWithImage(
                      feedPostId: cubit.feedPostId[index],
                      commentText: commentText,
                      commentDate: commentDate);
                } else {
                  cubit.createComment(
                    feedPostId: cubit.feedPostId[index],
                    commentText: commentText,
                    commentDate: commentDate,
                  );
                }
              }
              FocusScope.of(context).unfocus();
              commentController.clear();
            },
            child: const Icon(IconBroken.Send),
          ),
        ),
      ),
    ],
  );
}

Row buildReplyItem({
  required BuildContext context,
  required CommentReplyModel commentReplyModel,
  index,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(commentReplyModel.profileImage)),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            right: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(.7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                commentReplyModel.name,
                                style: GoogleFonts.aclonica(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              commentReplyModel.replyText,
                              style: GoogleFonts.aclonica(
                                color: Colors.white,
                                fontSize: 10.0,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 20,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(.7),
                      ),
                      child: const Icon(
                        IconBroken.More_Circle,
                        color: Colors.white,
                        size: 22.0,
                      ),
                    ),
                  ),
                ],
              ),
              //almost will be disabled...!
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      'like',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // InkWell(
                  //   onTap: () {},
                  //   child: const Text(
                  //     'replay',
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

FocusNode nodeFirst = FocusNode();
FocusNode nodeSecond = FocusNode();

Widget buildCommentReplyFieldItem({
  required TextEditingController replyController,
  required BuildContext context,
  Function(String)? onChanged,
  required String replyText,
  required index,
}) {
  var cubit = AppCubit.get(context);

  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.black54),
            child: TextFormField(
              focusNode: nodeFirst,
              autofocus: true,
              controller: replyController,
              decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: 90,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cubit.getCameraCommentReplyImage();
                                        },
                                        icon: const Icon(IconBroken.Camera),
                                      ),
                                      const Text('Camera'),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cubit.getGalleryCommentReplyImage();
                                        },
                                        icon: const Icon(IconBroken.Image_2),
                                      ),
                                      const Text('Gallery'),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Icon(
                      IconBroken.Image,
                    ),
                  ),
                  hintText: 'Type a reply',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(20),
                    left: Radius.circular(20),
                  ))),
              style: const TextStyle(
                color: Colors.white,
              ),
              cursorColor: Colors.deepPurple,
              onChanged: onChanged,
              onFieldSubmitted: (v) {},
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          child: InkWell(
            onTap: () {
              if (replyText != '' || cubit.commentReplyImageFile != null) {
                var date = DateTime.now();
                String replyDate = DateFormat.yMMMMd().format(date);
                if (cubit.commentImageFile != null) {
                  cubit.createCommentReplyWithImage(
                    postId: cubit.feedPostId[postIndex],
                    commentId: cubit.commentId[index],
                    commentReplyText: replyText,
                    commentReplyDate: replyDate,
                  );
                  cubit.storeReplyWithImage(
                    postId: cubit.feedPostId[postIndex],
                    commentReplyText: replyText,
                    commentReplyDate: replyDate,
                  );
                } else {
                  cubit.createCommentReply(
                    postId: cubit.feedPostId[postIndex],
                    replyText: replyText,
                    replyDate: replyDate,
                    commentId: cubit.commentId[index],
                  );
                  cubit.storeReply(
                    postId: cubit.feedPostId[postIndex],
                    replyText: replyText,
                    replyDate: replyDate,
                    context: context,
                  );
                }
              }
              FocusScope.of(context).unfocus();
              replyController.clear();
            },
            child: const Icon(IconBroken.Send),
          ),
        ),
      ),
    ],
  );
}

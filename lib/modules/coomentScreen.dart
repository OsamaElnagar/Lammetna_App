import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/modules/replyCommentScreen.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/constants.dart';
import '../shared/components/buildCommentItem.dart';
import '../shared/components/components.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();
  String commentText = '';
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('comments'),
            elevation: 1.0,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              ConditionalBuilder(
                builder: (context) => Expanded(
                  child: SingleChildScrollView(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buildCommentItem(
                          context: context,
                          commentModel: AppCubit.get(context).comments[index],
                          index: index,
                          replyWidget:  StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(cubit.feedPostId[postIndex])
                                .collection('comments')
                                .doc(cubit.commentId[index])
                                .collection('reply')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                              if (snapshot.data!.docs.isNotEmpty) {
                                return InkWell(
                                  onTap: (){
                                    commentIndex = index;
                                    cubit.getCommentsReply(
                                        postId: cubit.feedPostId[postIndex],
                                        commentId: cubit.commentId[commentIndex]);
                                    navigateTo(context, const ReplyScreen());
                                  },
                                  child: Text(
                                    '${snapshot.data!.docs.length.toString()} replies',
                                    style: const TextStyle(
                                        color: Colors.blue),
                                  ),
                                );
                              }
                              else {
                                return Container();
                              }
                              }
                              return Container();
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 28.0, right: 28.0, top: 5, bottom: 5),
                          child: Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey[300],
                          ),
                        );
                      },
                      itemCount: AppCubit.get(context).comments.length,
                    ),
                  ),
                ),
                condition: AppCubit.get(context).comments.isNotEmpty,
                fallback: (context) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.comments_disabled,
                          size: 140,
                          color: Colors.black54,
                        ),
                        Text(
                          'No comments here yet, be the first to comment.',
                          style: GoogleFonts.lobster(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              buildCommentFieldItem(
                commentController: commentController,
                context: context,
                onChanged: (inputText) {
                  setState(() {
                    commentText = inputText;
                  });
                },
                commentText: commentText,
                index: postIndex,
              ),
            ],
          ),
        );
      },
    );
  }
}

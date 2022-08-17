import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/constants.dart';
import '../models/commentModel.dart';
import '../shared/components/buildCommentItem.dart';

class ReplyScreen extends StatefulWidget {
  const ReplyScreen({Key? key}) : super(key: key);

  @override
  State<ReplyScreen> createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  TextEditingController replyController = TextEditingController();
  String replyText = '';
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
            title: const Text('replies'),
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
              repliedCommentItem(
                context: context,
                commentModel: cubit.comments[commentIndex],
              ),
              const SizedBox(height: 5,),
              ConditionalBuilder(
                builder: (context) => Expanded(
                  child: SingleChildScrollView(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildReplyItem(
                              context: context,
                              commentReplyModel: cubit.commentsReply[index],
                              index: index),
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
                      itemCount: cubit.commentsReply.length,
                    ),
                  ),
                ),
                condition: cubit.commentsReply.isNotEmpty,
                fallback: (context) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.quickreply_rounded,
                          size: 140,
                          color: Colors.black54,
                        ),
                        Text(
                          'No replies here yet, be the first to reply.',
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
              buildCommentReplyFieldItem(
                replyController: replyController,
                context: context,
                onChanged: (inputText) {
                  setState(() {
                    replyText = inputText;
                  });
                },
                replyText: replyText,
                index: commentIndex,
              ),
            ],
          ),
        );
      },
    );
  }

}

Widget repliedCommentItem(
    {required BuildContext context,
      required CommentModel commentModel,
      index}) {

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
       color: Colors.black.withOpacity(.2),
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
                      ],
                    ),
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
                        InkWell(
                          onTap: ()
                          {
                            FocusScope.of(context).requestFocus(nodeFirst);
                          },
                          child: const Text(
                            'replay',
                          ),
                        ),
                      ],
                    ),
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
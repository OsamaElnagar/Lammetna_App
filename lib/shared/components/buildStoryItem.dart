import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/models/loginModel.dart';
import 'package:social_app/models/storyModel.dart';
import 'package:social_app/modules/fullSDisp.dart';
import 'package:social_app/modules/storyScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/iconBroken.dart';
import 'constants.dart';


Widget buildStoryItem({
  required StoryModel storyModel,
  required int index,
  required BuildContext context,
}) {
  return InkWell(
    onTap: () {
      storyIndex = index;
      pint(storyIndex.toString());
      navigateTo(context,const FullScreenStory());
    },
    child: Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        if (storyModel.storyImage != '')
          Container(
            height: 250,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(storyModel.storyImage!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        if (storyModel.storyText != '' && storyModel.storyImage == '')
          Container(
            height: 250,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(storyModel.storyText,
                  style: GoogleFonts.actor(
                      fontSize: 16.0, fontWeight: FontWeight.w500)),
            )),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black.withOpacity(.7),
            foregroundImage: NetworkImage(storyModel.profileImage),
          ),
        ),
      ],
    ),
  );
}

Widget buildFirstStoryItem({ required LoginModel loginModel, context}) {
  return Stack(
    alignment: AlignmentDirectional.center,
    children: [
      ConditionalBuilder(
        condition: loginModel.profileImage.isNotEmpty,
        builder:(context)=> Container(
          height: 250,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: NetworkImage(loginModel.profileImage), fit: BoxFit.cover),
          ),
        ),
        fallback:(context)=> const Center(child: CircularProgressIndicator()),
      ),
      CircleAvatar(
        radius: 30,
        backgroundColor: Colors.black.withOpacity(.7),
        child: GestureDetector(
          onTap: () {
            navigateTo(context, const NewStoryScreen());
          },
          child: const Icon(
            IconBroken.Paper_Plus,
            size: 60,
          ),
        ),
      ),
    ],
  );
}

Widget gestureItem({required Function() onTap, icon,required Color iconColor}) {
  return Container(
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.black.withOpacity(.7),
    ),
    child: GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: iconColor,
        size: 40,
      ),
    ),
  );
}

CircleBorder d() {
  return const CircleBorder(
    side: BorderSide(width: 2),
  );
}

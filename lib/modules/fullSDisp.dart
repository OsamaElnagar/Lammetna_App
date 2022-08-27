import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import '../models/storyModel.dart';
import '../shared/components/constants.dart';

class FullScreenStory extends StatelessWidget {
  const FullScreenStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(color: Colors.black.withOpacity(.7)),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return storiesAvatar(
                      storyModel: cubit.stories[index],
                      index: index,
                      context: context,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 8,
                    );
                  },
                  itemCount: cubit.stories.length,
                ),
              ),
              buildSliderStoryItem(
                storyModel: cubit.stories[storyIndex],
                context: context,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSliderStoryItem({required StoryModel storyModel, context}) {
    String storyDate = storyModel.storyDate;
    storyDate = DateFormat.yMMMMEEEEd().format(DateTime.parse(storyDate));
    return Expanded(
      child: Column(
        children: [
          if (storyModel.storyImage != '')
            SizedBox(
              height: 500,
              child: Stack(
                children: [
                  Image(
                    image: NetworkImage(
                      storyModel.storyImage!,
                    ),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 500,
                  ),
                   if (storyIndex > 0)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: swipeLeft(context: context),
                    ),
                  if (storyIndex < AppCubit.get(context).stories.length - 1)
                    Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: swipeRight(context: context)),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(.6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            storyDate,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (storyModel.storyText != '' && storyModel.storyImage != '')
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(.7),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    storyModel.storyText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          if (storyModel.storyText != '' && storyModel.storyImage == '')
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black87,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          storyModel.storyText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (storyIndex > 0)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: swipeLeft(context: context),
                    ),
                  if (storyIndex < AppCubit.get(context).stories.length - 1)
                    Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: swipeRight(context: context)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(.6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          storyDate,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Widget storiesAvatar({
  required StoryModel storyModel,
  required int index,
  required BuildContext context,
}) {
  return InkWell(
    onTap: () {
      AppCubit.get(context).updateStoryIndex(index: index);
      pint(storyIndex.toString());
    },
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          if (storyIndex == index)
            CircleAvatar(
              radius: 38.0,
              backgroundColor: Colors.deepPurple,
              child: CircleAvatar(
                radius: 35.0,
                backgroundImage: NetworkImage(storyModel.profileImage),
              ),
            ),
          if (storyIndex != index)
            CircleAvatar(
              radius: 35.0,
              backgroundImage: NetworkImage(storyModel.profileImage),
            ),
          Text(
            storyModel.name,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 3,
          ),
          if (storyIndex == index) storyIndicator(index: index),
        ],
      ),
    ),
  );
}

Widget storyIndicator({
  required int index,
}) {
  return Container(
    width: 77.0,
    height: 3.5,
    decoration: BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

Widget swipeLeft({context}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.5),
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: IconButton(
        onPressed: () {
          // AppCubit.get(context).swipeLeft();
          // pint(storyIndex.toString());
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 30,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget swipeRight({context}) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.black.withOpacity(.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: IconButton(
        onPressed: () {
          // AppCubit.get(context).swipeRight();
          // pint(storyIndex.toString());
        },
        icon: const Icon(
          Icons.arrow_forward_ios,
          size: 30,
          color: Colors.white,
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/buildStoryItem.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/iconBroken.dart';

class NewStoryScreen extends StatefulWidget {
  const NewStoryScreen({Key? key}) : super(key: key);

  @override
  State<NewStoryScreen> createState() => _NewStoryScreenState();
}

class _NewStoryScreenState extends State<NewStoryScreen> {
  bool whileCreatingStory = false;
  TextEditingController textEditingController = TextEditingController();
  String storyText = '';
  bool wannaAddStoryText = false;
@override
  void dispose() {
  textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var storyImageFile = AppCubit.get(context).storyImageFile;
        FocusNode txtStoryNode = FocusNode();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create new story'),
            actions: [
              IconButton(
                onPressed: () {
                  if (storyImageFile != null || storyText != '') {
                    if (storyImageFile != null) {
                      AppCubit.get(context).createStoryWithImage(
                          storyText: storyText, storyDate: DateTime.now().toLocal().toString());
                    }else{
                      AppCubit.get(context).createStory(storyDate: DateTime.now().toLocal().toString(), storyText: storyText);
                    }
                  }
                  storyText = '';
                  AppCubit.get(context).getStory();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check_circle_sharp),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(state is AppCreateStoryLoadingState||state is AppCreateStoryImageLoadingState)
                  const LinearProgressIndicator(),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: gestureItem(
                            onTap: () {
                              setState(() {
                                wannaAddStoryText = false;
                              });
                              AppCubit.get(context).getGalleryStoryImage();
                            },
                            icon: IconBroken.Image,
                            iconColor: Colors.amber,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: gestureItem(
                              onTap: () {
                                setState(() {
                                  wannaAddStoryText = false;
                                });
                                AppCubit.get(context).getCameraStoryImage();
                              },
                              icon: IconBroken.Camera,
                            iconColor: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: gestureItem(
                              onTap: () {
                                setState(() {
                                  wannaAddStoryText = !wannaAddStoryText;
                                });
                                FocusScope.of(context)
                                    .requestFocus(txtStoryNode);
                              },
                              icon: IconBroken.Edit_Square,
                            iconColor: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (wannaAddStoryText)
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: textEditingController,
                        focusNode: txtStoryNode,
                        keyboardType: TextInputType.text,
                        onChanged: (inputText) {
                          setState(() {
                            storyText = inputText;
                          });
                        },
                        onFieldSubmitted: (text) {
                          setState(() {
                            FocusScope.of(context)
                                .unfocus();
                            whileCreatingStory = true;
                          });
                        },
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (storyImageFile != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: FileImage(storyImageFile),
                          fit: BoxFit.cover,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(.4),
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
                                    AppCubit.get(context).undoGetStoryImage();
                                    Navigator.pop(context);
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('i will ask for storage permission \nfrom user to disp local images here'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.all(4.0),
// child: Text(
// 'add one of these to your post',
// style: GoogleFonts.aclonica(
// fontSize: 12.0,
// fontWeight: FontWeight.w400,
// color: Colors.white),
// ),
// ),
// IconButton(
// onPressed: () {
// AppCubit.get(context).getGalleryPostImage();
// },
// icon: const Icon(
// IconBroken.Image,
// size: 40,
// color: Colors.yellow,
// ),
// ),
// IconButton(
// onPressed: () {
// AppCubit.get(context).getCameraPostImage();
// },
// icon: const Icon(
// IconBroken.Camera,
// size: 40,
// color: Colors.greenAccent,
// ),
// ),
// IconButton(
// onPressed: () {
// AppCubit.get(context).getCameraPostImage();
// },
// icon: const Icon(
// IconBroken.Play,
// color: Colors.blue,
// size: 40,
// ),
// ),
// IconButton(
// onPressed: () {},
// icon: const Icon(
// Icons.emoji_emotions_rounded,
// size: 40,
// color: Colors.yellow,
// ),
// ),
// ],
// ),

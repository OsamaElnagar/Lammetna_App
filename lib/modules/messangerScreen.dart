import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/loginModel.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/styles/iconBroken.dart';

import '../shared/components/buildChatItems.dart';

class MessengerScreen extends StatelessWidget {
  LoginModel loginModel;

  MessengerScreen({Key? key, required this.loginModel}) : super(key: key);

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      AppCubit.get(context).getMessages(receiverId: loginModel.uId);
      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 36,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(loginModel.profileImage),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                      child: Text(loginModel.name,
                          style: TextStyle(fontSize: 16.0),
                          overflow: TextOverflow.ellipsis)),
                ],
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  IconBroken.Arrow___Left_2,
                  size: 30,
                ),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(IconBroken.Call)),
                IconButton(
                    onPressed: () {}, icon: const Icon(IconBroken.Video)),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var messages = cubit.messages[index];
                          if (cubit.loginModel!.uId ==
                              cubit.messages[index].senderId) {
                            return buildSentMessageItem(chatsModel: messages);
                          }
                          return buildReceivedMessageItem(chatsModel: messages);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: cubit.messages.length),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (cubit.messageImageFile != null)
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          width: 280,
                          height: 350,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                             ),
                          child: Image(
                            image: FileImage(cubit.messageImageFile!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                              radius: 20,
                              child: IconButton(
                                  onPressed: () {
                                    cubit.undoGetMessageImage();
                                  },
                                  icon: const Icon(Icons.close))),
                        )
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black54),
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                    backgroundColor: Colors.black54,
                                        context: context,
                                        builder: (context) {
                                          return SizedBox(
                                            height: 90,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        cubit
                                                            .getCameraMessageImage();
                                                      },
                                                      icon: const Icon(
                                                          IconBroken.Camera,
                                                        size: 35,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    const Text('Camera',
                                                      style: TextStyle(color: Colors.blue),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Column(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        cubit
                                                            .getGalleryMessageImage();
                                                      },
                                                      icon: const Icon(
                                                          IconBroken.Image_2,
                                                        size: 35,
                                                        color: Colors.deepPurple,),
                                                    ),
                                                    const Text('Gallery',
                                                      style: TextStyle(color: Colors.deepPurple),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: const Icon(
                                    IconBroken.Image,
                                    color: Colors.white,
                                  ),
                                ),
                                hintText: 'Type your message',
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
                            onFieldSubmitted: (v) {},
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: IconButton(onPressed: () {

                          if (cubit.messageImageFile != null ||
                              messageController.text != '') {
                            if (cubit.messageImageFile != null) {
                              cubit.sendMessageWithImage(
                                receiverId: loginModel.uId,
                                textMessage: messageController.text,
                                messageDateTime:   DateTime.now().toLocal().toString(),
                              );
                              cubit.undoGetMessageImage();
                            } else {
                              cubit.senMessage(
                                receiverId: loginModel.uId,
                                textMessage: messageController.text,
                                messageDateTime:  DateTime.now().toLocal().toString(),
                              );
                              cubit.undoGetMessageImage();
                            }
                          }
                          messageController.clear();
                          FocusScope.of(context).unfocus();
                        },  icon: const Icon(IconBroken.Send,color: Colors.white,), ),
                      ),
                    ),
                    const SizedBox(
                      width:10,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

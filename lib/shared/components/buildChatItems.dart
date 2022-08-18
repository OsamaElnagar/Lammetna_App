import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/chatModel.dart';
import 'package:social_app/models/loginModel.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import '../styles/iconBroken.dart';

Widget buildMessengerFieldItem({
  required TextEditingController messageController,
  required BuildContext context,
  Function(String)? onChanged,
  required String messageText,
  required LoginModel loginModel,
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
              controller: messageController,
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
                                          cubit.getCameraMessageImage();
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
                                          cubit.getGalleryMessageImage();
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
              if (cubit.messageImageFile != null || messageText != '') {
                if (cubit.messageImageFile != null) {
                  cubit.sendMessageWithImage(
                    receiverId: loginModel.uId,
                    textMessage: messageText,
                    messageDateTime: DateTime.now().toLocal().toString(),
                  );
                } else {
                  cubit.senMessage(
                    receiverId: loginModel.uId,
                    textMessage: messageText,
                    messageDateTime:DateTime.now().toLocal().toString(),
                  );
                }
              }
              messageController.clear();
              FocusScope.of(context).unfocus();
            },
            child: const Icon(IconBroken.Send),
          ),
        ),
      ),
    ],
  );
}

Widget buildSentMessageItem({required ChatsModel chatsModel}) {
  var date = DateTime.now();
  String messageDateTime = chatsModel.messageDateTime;
  messageDateTime = DateFormat.E().add_jm().format(date);
  // ==> 'Thu, 5/23/2013 10:21:47 AM'
  return Align(
    alignment: AlignmentDirectional.topEnd,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.deepPurple[400],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(40),
              topEnd: Radius.circular(0),
              topStart: Radius.circular(10),
              bottomStart: Radius.circular(10),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 20.0, top: 8.0, bottom: 8.0),
              child: Text(
                chatsModel.textMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 2.0, right: 20.0, top: 8.0, bottom: 8.0),
              child: Text(
                messageDateTime.substring(3),
                style: const TextStyle(color: Colors.grey,fontSize: 10,height: .5),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildReceivedMessageItem({required ChatsModel chatsModel}) {
  var date = DateTime.now();
  String messageDateTime = chatsModel.messageDateTime;
  messageDateTime = DateFormat.E().add_jm().format(date);
  // ==> 'Thu, 5/23/2013 10:21:47 AM'
  return Align(
    alignment: AlignmentDirectional.topStart,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(0),
              bottomStart: Radius.circular(40),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                chatsModel.textMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ),

            // i will send the time without formating and
            // when i get it i will formate it before displaying it.
            //////////////////////////////////////////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.only(
                  left:20.0 , right: 2.0, top: 8.0, bottom: 8.0),
              child: Text(
                messageDateTime.substring(3),
                style: const TextStyle(color: Colors.grey,fontSize:10,height: .5 ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

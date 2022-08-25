import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/models/loginModel.dart';
import 'package:social_app/modules/messengerScreen.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/iconBroken.dart';
import '../shared/components/constants.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        FocusNode searchUserNode = FocusNode();
        TextEditingController textEditingController = TextEditingController();

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                if (wannaSearchForUser)
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: textEditingController,
                        focusNode: searchUserNode,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            hintText: 'Search for a user',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(20),
                              left: Radius.circular(20),
                            ))),
                        onChanged: (inputText) {
                          setState(() {});
                        },
                        onFieldSubmitted: (text) {
                          setState(() {
                            FocusScope.of(context).unfocus();
                          });
                        },
                      ),
                    ),
                  ),
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => buildChatItem(
                      loginModel: AppCubit.get(context).allUsers[index],
                      index: index),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 2,
                  ),
                  itemCount: AppCubit.get(context).allUsers.length,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildChatItem({required LoginModel loginModel, required int index}) {
    return InkWell(
      onTap: () {
       navigateTo(context, MessengerScreen(loginModel: loginModel,));
      },
      child: Card(
        margin: EdgeInsets.zero,
        // color: Colors.deepPurple.withOpacity(.4),
        child: Padding(
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
                    ///////////////////////////
                    // i will display here th last message
                    const Text('Last Message')
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
      ),
    );
  }
}

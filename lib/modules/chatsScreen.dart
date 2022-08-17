import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/models/loginModel.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/iconBroken.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // List<LoginModel> lista =[
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        //   LoginModel(name: 'name', phone: 'phone', email: 'email', bio: 'bio', profileImage: 'profileImage', profileCover: 'profileCover', uId: ''),
        // ];
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          return buildChatItem(
                              loginModel: AppCubit.get(context).allUsers[index],
                              index: index);
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
                        itemCount: AppCubit.get(context).allUsers.length),
                  ),
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
        pint(index.toString());
      },
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.deepPurple,
        elevation: 15,
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
                    Text('Last Message')
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

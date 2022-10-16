import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/AppCubit/states.dart';
import '../shared/components/components.dart';
import '../shared/styles/iconBroken.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  double bottomSheetHeight = 350;
  bool wannaEditName = false;
  bool wannaEditPhone = false;
  bool wannaEditBio = false;
  bool wannaEditEmail = false;
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  FocusNode nameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode bioNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var profileModel = AppCubit.get(context).loginModel;
        var profileImageFile = AppCubit.get(context).profileImageFile;
        var coverImageFile = AppCubit.get(context).coverImageFile;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile Modify'),
            actions: [
              TextButton(
                onPressed: () {
                  if (nameController.text != '' ||
                      phoneController.text != '' ||
                      emailController.text != '' ||
                      bioController.text != '') {
                    cubit.updateProfile(
                      name: nameController.text != ''
                          ? nameController.text
                          : profileModel!.name,
                      phone: phoneController.text != ''
                          ? phoneController.text
                          : profileModel!.phone,
                      email: emailController.text != ''
                          ? emailController.text
                          : profileModel!.email,
                      bio: bioController.text != ''
                          ? bioController.text
                          : profileModel!.bio,
                    );
                  }

                  cubit.getUserData();
                  if (state is AppGetUserDataSuccessState) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Update Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      if (state is AppUpdateProfileLoadingState ||
                          state is AppUpdateCoverImageLoadingState ||
                          state is AppUpdateProfileImageLoadingState)
                        const LinearProgressIndicator(
                          color: Colors.deepPurple,
                          value: 50,
                        ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      //here is the profile image and cover.
                      SizedBox(
                        width: double.infinity,
                        height: 210,
                        child: Stack(
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      topLeft: Radius.circular(5),
                                    ),
                                  ),
                                  width: double.infinity,
                                  height: 160,
                                  child: Card(
                                    color: Colors.deepPurple,
                                    child: Image(
                                      image: NetworkImage(
                                          profileModel!.profileCover),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Container(
                                          height: 70,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    'Gallery',
                                                    style: GoogleFonts.lobster(
                                                        fontSize: 20,
                                                        color:
                                                            Colors.deepPurple),
                                                  ),
                                                  const SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        cubit
                                                            .getGalleryCoverImage();
                                                      },
                                                      child: const Icon(
                                                          IconBroken.Image_2,
                                                          color:
                                                              Colors.yellow)),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 20.0,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    'Camera',
                                                    style: GoogleFonts.lobster(
                                                        fontSize: 20,
                                                        color:
                                                            Colors.deepPurple),
                                                  ),
                                                  const SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        cubit
                                                            .getCameraCoverImage();
                                                      },
                                                      child: const Icon(
                                                        IconBroken.Camera,
                                                        color: Colors.blue,
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          Colors.deepPurple.withOpacity(.8),
                                      child: const Icon(IconBroken.Camera),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                child: CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  radius: 65,
                                  child: CircleAvatar(
                                    radius: 62,
                                    backgroundImage:
                                        NetworkImage(profileModel.profileImage),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(.25, 1.0),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Container(
                                        height: 70,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Gallery',
                                                  style: GoogleFonts.lobster(
                                                      fontSize: 20,
                                                      color: Colors.deepPurple),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      cubit
                                                          .getGalleryProfileImage();
                                                    },
                                                    child: const Icon(
                                                        IconBroken.Image_2,
                                                        color: Colors.yellow)),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Camera',
                                                  style: GoogleFonts.lobster(
                                                      fontSize: 20,
                                                      color: Colors.deepPurple),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      cubit
                                                          .getCameraProfileImage();
                                                    },
                                                    child: const Icon(
                                                      IconBroken.Camera,
                                                      color: Colors.blue,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        Colors.deepPurple.withOpacity(.8),
                                    child: const Icon(IconBroken.Camera),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      if (profileImageFile != null || coverImageFile != null)
                        Row(
                          children: [
                            if (profileImageFile != null)
                              TextButton(
                                onPressed: () {
                                  cubit.updateProfileImage(
                                    name: nameController.text != ''
                                        ? nameController.text
                                        : profileModel.name,
                                    phone: phoneController.text != ''
                                        ? phoneController.text
                                        : profileModel.phone,
                                    email: emailController.text != ''
                                        ? emailController.text
                                        : profileModel.email,
                                    bio: bioController.text != ''
                                        ? bioController.text
                                        : profileModel.bio,
                                  );
                                  cubit.undoGetProfileImage();
                                },
                                child: const Text(
                                    'Use this photo as profile image'),
                              ),
                            if (coverImageFile != null)
                              TextButton(
                                onPressed: () {
                                  cubit.updateProfileCover(
                                    name: nameController.text != ''
                                        ? nameController.text
                                        : profileModel.name,
                                    phone: phoneController.text != ''
                                        ? phoneController.text
                                        : profileModel.phone,
                                    email: emailController.text != ''
                                        ? emailController.text
                                        : profileModel.email,
                                    bio: bioController.text != ''
                                        ? bioController.text
                                        : profileModel.bio,
                                  );
                                  cubit.undoGetCoverImage();
                                },
                                child:
                                    const Text('Use this photo as cover image'),
                              ),
                          ],
                        ),
                      if (profileImageFile != null)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(
                                image: FileImage(profileImageFile),
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
                                          setState(() {
                                            AppCubit.get(context)
                                                .undoGetProfileImage();
                                            Navigator.pop(context);
                                          });
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
                      if (coverImageFile != null)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(
                                image: FileImage(coverImageFile),
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
                                          setState(() {
                                            AppCubit.get(context)
                                                .undoGetCoverImage();
                                            Navigator.pop(context);
                                          });
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
                      //////////////////////////////////////////////////////
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepPurple.withOpacity(.8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profileModel.name,
                                    style: GoogleFonts.actor(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(nameNode);
                                    },
                                    icon: const Icon(
                                      IconBroken.Edit,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profileModel.phone,
                                    style: GoogleFonts.actor(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(phoneNode);
                                    },
                                    icon: const Icon(
                                      IconBroken.Edit,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Text(
                                        profileModel.bio,
                                        style: GoogleFonts.actor(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(bioNode);
                                    },
                                    icon: const Icon(
                                      IconBroken.Edit,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profileModel.email,
                                    style: GoogleFonts.actor(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(emailNode);
                                    },
                                    icon: const Icon(
                                      IconBroken.Edit,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        width: 280,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepPurple.withOpacity(.8)),
                        child: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          focusNode: nameNode,
                          decoration: const InputDecoration(
                              hintText: 'Type a name..',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(20),
                                left: Radius.circular(20),
                              ))),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.deepPurple,
                          // onChanged: onChanged,
                          onFieldSubmitted: (v) {},
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: 280,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepPurple.withOpacity(.8)),
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          focusNode: phoneNode,
                          decoration: const InputDecoration(
                              hintText: 'Type a phone',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(20),
                                left: Radius.circular(20),
                              ))),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.deepPurple,
                          // onChanged: onChanged,
                          onFieldSubmitted: (v) {},
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: 280,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepPurple.withOpacity(.8)),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: emailNode,
                          decoration: const InputDecoration(
                              hintText: 'Type an email',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(20),
                                left: Radius.circular(20),
                              ))),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.deepPurple,
                          // onChanged: onChanged,
                          onFieldSubmitted: (v) {},
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: 280,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepPurple.withOpacity(.8)),
                        child: TextFormField(
                          controller: bioController,
                          keyboardType: TextInputType.text,
                          focusNode: bioNode,
                          decoration: const InputDecoration(
                              hintText: 'Type your bio',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(20),
                                left: Radius.circular(20),
                              ))),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.deepPurple,
                          // onChanged: onChanged,
                          onFieldSubmitted: (v) {},
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

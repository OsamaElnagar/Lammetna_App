import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/homeLayout/homeLayout.dart';
import 'package:social_app/modules/loginScreen.dart';
import 'package:social_app/shared/bloc/registerCubit/cubit.dart';
import 'package:social_app/shared/bloc/registerCubit/states.dart';
import 'package:social_app/shared/components/components.dart';

import '../shared/bloc/loginCubit/cubit.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(RegisterInitState()),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterCreateUserSuccessState) {
            navigate2(context, const LoginScreen());
            showToast(msg: 'Joined successfully', state: ToastStates.success);
          }
          if(state is RegisterCreateUserErrorState){
            showToast(msg: 'Invalid data', state: ToastStates.error);

          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  const Image(
                    image: AssetImage('assets/images/f.jpg'),
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              alignment: AlignmentDirectional.centerStart,
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black.withOpacity(.55),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Register',
                                      style: GoogleFonts.aclonica(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Register to new account and start a new journey full of fun.',
                                      style: GoogleFonts.abel(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: AlignmentDirectional.centerStart,
                              width: 60,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.55),
                              ),
                            ),
                            Container(
                              alignment: AlignmentDirectional.centerStart,
                              width: double.infinity,
                              // height: 280,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black.withOpacity(.55),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'name',
                                      style: GoogleFonts.abel(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        cursorColor: Colors.red,
                                        controller: nameController,
                                        keyboardType: TextInputType.name,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return ' name must not be empty';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          label: Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Text(
                                              'name',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'phone',
                                      style: GoogleFonts.abel(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        cursorColor: Colors.red,
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return ' phone must not be empty';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          label: Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Text(
                                              'phone',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'email',
                                      style: GoogleFonts.abel(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        cursorColor: Colors.red,
                                        controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return ' Email must not be empty';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          label: Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Text(
                                              'email',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'password',
                                      style: GoogleFonts.abel(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: passwordController,
                                        cursorColor: Colors.red,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        onFieldSubmitted: (value) {
                                          if (formKey.currentState!
                                              .validate()) {
                                            RegisterCubit.get(context)
                                                .userRegister(
                                              name: nameController.text,
                                              phone: phoneController.text,
                                              email: emailController.text,
                                              password: passwordController.text,
                                            );
                                          }
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return ' Password must not be empty';
                                          }
                                          return null;
                                        },
                                        obscureText:
                                            RegisterCubit.get(context).isShown,
                                        decoration: InputDecoration(
                                          label: const Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Text(
                                              'password',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              RegisterCubit.get(context)
                                                  .changePasswordVisibility();
                                            },
                                            icon: Icon(
                                              RegisterCubit.get(context)
                                                  .visible,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    ConditionalBuilder(
                                      condition: state
                                          is! RegisterCreateUserLoadingState,
                                      fallback: (context) => Stack(
                                        children: [
                                          Center(
                                            child: gradientButton(
                                              title: Text(
                                                'Register'.toUpperCase(),
                                                style: GoogleFonts.aclonica(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              context: context,
                                            ),
                                          ),
                                          Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor:
                                                  Colors.black.withOpacity(.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                      builder: (context) => gradientButton(
                                        title: Text(
                                          'REGISTER',
                                          style: GoogleFonts.aclonica(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        context: context,
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            RegisterCubit.get(context)
                                                .userRegister(
                                              name: nameController.text.replaceAll(' ', ''),
                                              phone: phoneController.text,
                                              email: emailController.text,
                                              password: passwordController.text,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: AlignmentDirectional.centerStart,
                              width: 60,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.55),
                              ),
                            ),
                            Container(
                              alignment: AlignmentDirectional.centerStart,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black.withOpacity(.55),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Already have an account?',
                                      style: GoogleFonts.aclonica(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        navigate2(context, LoginScreen());
                                      },
                                      child: Text(
                                        'Sign In',
                                        style: GoogleFonts.aclonica(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
        },
      ),
    );
  }
}

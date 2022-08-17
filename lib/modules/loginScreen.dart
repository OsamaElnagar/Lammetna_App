import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/modules/registerScreen.dart';
import 'package:social_app/modules/rsetPassword.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/bloc/loginCubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import '../homeLayout/homeLayout.dart';
import '../shared/bloc/loginCubit/cubit.dart';
import '../shared/components/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => LoginCubit(LoginInitialState()),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveLoginData(key: 'uid', value: state.uId);
            uId = CacheHelper.getData('uid');
            AppCubit.get(context).getUserData();
            navigate2(context, const HomeLayout());
            showToast(msg: 'login successfully', state: ToastStates.success);
          }
          if (state is LoginErrorState) {
            showToast(msg: 'Wrong email or password', state: ToastStates.error);
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
                              height: 280,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black.withOpacity(.55),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Login',
                                      style: GoogleFonts.aclonica(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Login to your account to bring back a smile to the world. ',
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black.withOpacity(.55),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
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
                                        onFieldSubmitted: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return ' Password must not be empty';
                                          }
                                          return null;
                                        },
                                        obscureText:
                                            LoginCubit.get(context).isShown,
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
                                              LoginCubit.get(context)
                                                  .changePasswordVisibility();
                                            },
                                            icon: Icon(
                                              LoginCubit.get(context).visible,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        navigateTo(
                                            context, ResetPasswordScreen());
                                      },
                                      child: const Text(
                                        'forgot password?',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    ////////////////////
                                    ConditionalBuilder(
                                      condition: state is! LoginLoadingState,
                                      fallback: (context) => Stack(
                                        children: [
                                          Center(
                                            child: gradientButton(
                                              title: Text(
                                                'LOGIN',
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
                                          'LOGIN',
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
                                            LoginCubit.get(context).userLogin(
                                              email: emailController.text
                                                  .replaceAll(' ', '')
                                                  .toString(),
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
                                      'New to this community?',
                                      style: GoogleFonts.aclonica(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        navigate2(context, RegisterScreen());
                                      },
                                      child: Text(
                                        'Sign Up',
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

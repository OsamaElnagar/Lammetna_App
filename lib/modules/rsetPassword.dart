import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/modules/loginScreen.dart';
import 'package:social_app/modules/registerScreen.dart';
import 'package:social_app/shared/bloc/loginCubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import '../shared/bloc/loginCubit/cubit.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => LoginCubit(LoginInitialState()),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
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
                                      'Reset Your Password',
                                      style: GoogleFonts.aclonica(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Don\'t be worry, follow the instructions and it will be all set.',
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
                                    ConditionalBuilder(
                                      condition: state
                                          is! LoginResetPasswordLoadingState,
                                      fallback: (context) => Stack(
                                        children: [
                                          Center(
                                            child: gradientButton(
                                              title: Text(
                                                'RESET',
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
                                          'RESET',
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
                                            LoginCubit.get(context)
                                                .resetPassword(
                                              context: context,
                                                    email: emailController.text
                                                        .replaceAll(' ', '').toString());
                                          }
                                          FocusScope.of(context).unfocus();
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
                                      'Back to login screen!',
                                      style: GoogleFonts.aclonica(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        navigate2(context, const LoginScreen());
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

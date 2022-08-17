import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/modules/loginScreen.dart';
import '../network/local/cache_helper.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

Future navigate2(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

void showToast({
  required String msg,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 12.0);
}

enum ToastStates { success, error, warning }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.warning:
      color = Colors.yellow;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
  }
  return color;
}

void signOut(context) {
  CacheHelper.removeData(key: 'uId').then((value) {
    if (value) {
      navigate2(context, const LoginScreen());
    }
  });
}

void clearPref(context) {
  CacheHelper.clearData().then((value) {
    // if (value) {
    //   navigate2(context, const OnBoarding());
    // }
  });
}

void printFulltext(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((element) {
    debugPrint(element.group(0));
  });
}



void pint(String text) {
  debugPrint(text);
}

// عايزه تتظبط لسه
Widget emailFormField(
    TextEditingController  emailController,
    ) => TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ' Email must not be empty';
        }
        return null;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text('email'),
        prefixIcon: Icon(
          Icons.email_outlined,
        ),
      ),
    );

void dialogMessage({
  required BuildContext context,
  required Widget title,
  required Widget content,
  required List<Widget> actions,
}) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: title,
        content: content,
        actions: actions,
      ));
}

Widget gradientBlueButton({
  required BuildContext context,
  Function()? onPressed,
  required Widget title,
}) {
  return Container(
    clipBehavior: Clip.antiAlias,
    width: 100,
    height: 40,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          colors: [
            Colors.blue[400]!,
            Colors.indigo,

          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )),
    child: MaterialButton(
      onPressed: onPressed,
      child: title,
    ),
  );
}
Widget gradientBWButton({
  required BuildContext context,
  Function()? onPressed,
  required Widget title,
}) {
  return Container(
    clipBehavior: Clip.antiAlias,
    width: MediaQuery.of(context).size.width,
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: const LinearGradient(
          colors: [
            Colors.white,
            Colors.black,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )),
    child: MaterialButton(
      onPressed: onPressed,
      child: title,
    ),
  );
}
Widget gradientRGButton({
  required BuildContext context,
  Function()? onPressed,
  required Widget title,
}) {
  return Container(
    clipBehavior: Clip.antiAlias,
    width:100,
    height: 40,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          colors: [
            Colors.orange,
            Colors.redAccent[700]!,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )),
    child: MaterialButton(
      onPressed: onPressed,
      child: title,
    ),
  );
}

Widget gradientButton({
  required BuildContext context,
  Function()? onPressed,
  required Widget title,
}) {
  return Container(
    clipBehavior: Clip.antiAlias,
    width:190,
    height: 40,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple,
            Colors.redAccent[700]!,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )),
    child: MaterialButton(
      onPressed: onPressed,
      child: title,
    ),
  );
}


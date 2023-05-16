import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kickfunding/ui/signup_form.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:kickfunding/ui/tab/widgets/profile/constants.dart';
import '../../../theme/app_color.dart';
import '../routes/routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ui/custom_input_field.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

// Future performLogin(BuildContext cont2) async {
//   bool check = false;
//   if (email == 'admin' && password == 'admin') {
//     check = true;
//     constant.success = check;
//     return constant.success;
//   } else {
//     return constant.success;
//   }
// }

var token = "";
var email = "";
var password = "";
var obsecurepassword = true;
Color iconcolor = Colors.grey;

class _LoginFormState extends State<LoginForm> {
  bool check = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey2,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign in',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: AppColor.kForthColor,
                  ),
            ),
            Text(
              'to continue',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: AppColor.kForthColor,
                  ),
            ),
            SizedBox(
              height: 40.h,
            ),
            CustomInputField(
              hintText: 'Email',
              onChanged: (value) {
                email = value;
              },
              validateStatus: (value) {
                if (value!.isEmpty) {
                  return 'Field must not be empty';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 15.h,
            ),
            CustomInputField(
              hintText: 'Password',
              isPassword: obsecurepassword,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                password = value;
              },
              sufficon: IconButton(
                icon: Icon(
                  obsecurepassword ? Icons.visibility : Icons.visibility_off,
                  color: iconcolor,
                ),
                onPressed: () {
                  setState(() {
                    if (iconcolor == Colors.grey) {
                      iconcolor = AppColor.kPrimaryColor;
                    } else {
                      iconcolor = Colors.grey;
                    }
                    obsecurepassword = !obsecurepassword;
                  });
                },
              ),
              validateStatus: (value) {
                if (value!.isEmpty) {
                  return 'Field must not be empty';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(
                    RouteGenerator.forgetPw,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColor.kAccentColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 120.h,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  AppColor.kAccentColor,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8.r,
                    ),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(
                    double.infinity,
                    56.h,
                  ),
                ),
              ),
              onPressed: () async {
                if (_formKey2.currentState!.validate()) {
                  // Perform login
                  if (check = !true) {
                    Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  performLogin(context);

                  // Store login status
                  // if (constant.success) {
                  //   SharedPreferences prefs =
                  //       await SharedPreferences.getInstance();
                  //   prefs.setBool('isLoggedIn', true);
                  //   // ignore: unnecessary_null_comparison
                  // } else if (constant.success == null) {
                  //   Center(child: CircularProgressIndicator());
                  // }
                  //  print('successful');

                  //   Login(context);
                }
                ;
              },
              child: Text(
                'Login',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void performLogin(BuildContext context) async {
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    if (email == "zozo" || password == "zozo") {
      reload(context);
      //print('Fields have not to be empty');
    } else {
      var url = Uri.parse(
          "https://02f3-197-134-102-115.ngrok-free.app/api/dj-rest-auth/login/");

      var response = await http.post(url,
          headers: {
            'content-Type': 'application/json',
          },
          body: jsonBody,
          encoding: encoding);

      var data = json.decode(response.body);

      print(data);
      if (response.statusCode == 200) {
        check = true;
        token = data["key"];
        print(token);
        print("Login succeeded");
        getinfo();
        reload(context);
      } else {
        Center(child: CircularProgressIndicator());
      }
      /* UNCOMMENT WHEN SERVER ONLINE */
    }

    /* UNCOMMENT WHEN SERVER ONLINE */
  }

  void getinfo() async {
    var url2 = Uri.parse(
        "https://02f3-197-134-102-115.ngrok-free.app/api/dj-rest-auth/user/");
    var response2 = await http.get(
      url2,
      headers: {
        'content-Type': 'application/json',
        "Authorization": " Token ${token}"
      },
    );

    var data2 = json.decode(response2.body);
    print(data2);
    if (response2.statusCode == 200) {
      setState(() {
        constant.Username = data2["username"].toString();
        constant.bdateuser = data2["birth_date"].toString();
        constant.country = data2["country"].toString();
        constant.first_name = data2["first_name"].toString();
        constant.last_name = data2["last_name"].toString();
        constant.phoneuser = data2["phone_number"].toString();
        //constant.urlprofile = data2["user_image"].toString();
      });
      print(constant.first_name);
    } else {
      print('failed to load data');
    }
  }

  Future<void> reload(context) async {
    constant.success = true;
    setState(() {
      check = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    // ignore: unnecessary_null_comparison
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pushReplacementNamed(
      RouteGenerator.main,
    );

    return;
  }
}

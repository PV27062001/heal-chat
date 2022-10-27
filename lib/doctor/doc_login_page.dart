import 'package:heal_chat/doctor/doc_signup_page.dart';
import 'package:heal_chat/pages/chat_room_page.dart';
import 'package:heal_chat/pages/user_login_page.dart';

import 'package:heal_chat/pages/user_signup_page.dart';
import 'package:heal_chat/userauthentication/user_auth.dart';
import 'package:heal_chat/sizeConfig/size_config.dart';
import 'package:flutter/material.dart';

class dLoginPage extends StatefulWidget {
  const dLoginPage({Key? key}) : super(key: key);

  @override
  _dLoginPageState createState() => _dLoginPageState();
}

class _dLoginPageState extends State<dLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isloading = false;
  late Authentication _transaction;

  @override
  void initState() {
    super.initState();
    _transaction = Authentication();
  }

  onsignIn() {
    if (_formKey.currentState!.validate()) {
      _transaction.docLoginWithEmailAndPassword(_email.text, _password.text);
      setState(() {
        isloading = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatRoom(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloading
            ? Center(
                // ignore: avoid_unnecessary_containers
                child: Container(
                child: const CircularProgressIndicator(),
              ))
            : Container(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            child: Icon(
                              Icons.medical_services,
                              size: 50,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          TextFormField(
                            validator: (value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)
                                  ? null
                                  : "Please Enter a valid email_ID";
                            },
                            controller: _email,
                            decoration: const InputDecoration(
                              label: Text("Email_Id"),
                              hintText: "Enter Email Id",
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          TextFormField(
                            // validator: (value) {
                            //   return value!.length <= 6
                            //       ? null
                            //       : "Password must be greater then 6";
                            // },
                            obscureText: true,
                            controller: _password,
                            decoration: const InputDecoration(
                              label: Text("Password"),
                              hintText: "Password",
                              prefixIcon: Icon(Icons.password),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          TextButton(
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 25.0,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              primary: Colors.white,
                              shape: const BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            onPressed: () {
                              onsignIn();
                            },
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          InkWell(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const dSignUpPage(),
                              ),
                            ),
                            child: const Text(
                              "New Doctor? Sign up",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          InkWell(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            ),
                            child: const Text(
                              "Return to user login",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}

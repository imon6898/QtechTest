import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qtechtest/view/auth_pages/registration_page.dart';
import 'package:qtechtest/widget/CustomTextField.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/api_controller.dart';
import '../../model/login_model.dart';
import '../../splash_screen.dart';
import '../../widget/common_button.dart';
import '../../widget/common_methods.dart';
import '../dashboard.dart';

class LoginPage extends StatefulWidget {
  final String domain;

  const LoginPage({Key? key, required this.domain}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  //final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isLoading = false;

  //TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Color(0xFF100C94),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'TEMP Mail',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 1,),
            Material(
              elevation: 0,
              color: Color(0xfff5f5f5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF100C94),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18.0,top: 10),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            Material(
              elevation: 0,
              color: Color(0xFF100C94),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFields(
                              controller: emailController,
                              hintText: 'Enter Email',
                              disableOrEnable: true,
                              borderColor: 0xFFBCC2C2,
                              filled: false,
                              prefixIcon: Icons.mail,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text('@${widget.domain}', style: TextStyle(color: Colors.black),),
                        ],
                      ),
                      SizedBox(height: 10),
                      CustomTextFields(
                        controller: passwordController,
                        hintText: 'Enter Password',
                        disableOrEnable: true,
                        borderColor: 0xFFBCC2C2,
                        filled: false,
                        prefixIcon: Icons.password,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: !isPasswordVisible,
                        keyboardType: TextInputType.text,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          child: CommonButton(
                            btnText: "Login",
                            onPressed: () {
                              ApiController.signIn(widget.domain, emailController, passwordController, context);
                            },

                            loading: _isLoading,
                          ),
                        ),
                      ),


                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              String domain = widget.domain;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegistrationPage(domain: domain)),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Text(
                                  " Create",
                                  style: TextStyle(color: Color(0xff1a2450), fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qtechtest/view/auth_pages/login_page.dart';
import 'package:http/http.dart' as http;
import '../../controller/api_controller.dart';
import '../../widget/CustomTextField.dart';
import '../../widget/common_button.dart';
import '../../widget/common_methods.dart';

class RegistrationPage extends StatefulWidget {
  final String domain;

  const RegistrationPage({super.key, required this.domain});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isLoading = false;



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
                      "Create Email Account",
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
                              controller: userNameController,
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
                            btnText: "Create",
                            onPressed: () {
                              ApiController.registrationIn(widget.domain, userNameController, passwordController, context);
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage(domain: domain)),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Text(
                                  " Login",
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

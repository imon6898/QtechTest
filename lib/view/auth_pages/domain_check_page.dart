import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qtechtest/view/auth_pages/login_page.dart';
import 'package:qtechtest/widget/CustomTextField.dart';

import '../../controller/api_controller.dart';

class DomainPage extends StatefulWidget {
  const DomainPage({Key? key}) : super(key: key);

  @override
  State<DomainPage> createState() => _DomainPageState();
}

class _DomainPageState extends State<DomainPage> {
  final domaininitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ApiController.fetchDomains(1, domaininitController);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Color(0xFF100C94),
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
                      "Available Domain",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            String domain = domaininitController.text;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage(domain: domain)),
                            );
                          },
                          child: Text(
                            "Tap to create account or login",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      CustomTextFields(
                        controller: domaininitController,
                        hintText: 'Domain',
                        disableOrEnable: false,
                        borderColor: 0xFFBCC2C2,
                        filled: false,
                        prefixIcon: Icons.mail,
                        keyboardType: TextInputType.text,
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
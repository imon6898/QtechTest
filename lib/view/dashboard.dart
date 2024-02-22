import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:qtechtest/view/auth_pages/domain_check_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/api_controller.dart';
import '../model/account_details_model.dart';
import '../model/inboxes_model.dart';
import '../model/login_model.dart';
import '../splash_screen.dart';
import '../widget/custom_card.dart';

class DashBoard extends StatefulWidget {
  final LoginModel? loginModel;
  const DashBoard({super.key, this.loginModel});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  Account? _account;
  Future<InboxesModel>? _futureInboxes;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch account details
      Account? account = await ApiController.fetchAccountDetails(widget.loginModel);
      setState(() {
        _account = account;
      });

      // Fetch inboxes
      Future<InboxesModel> futureInboxes = ApiController.fetchInboxes(widget.loginModel);
      setState(() {
        _futureInboxes = futureInboxes;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
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

        actions: [
          IconButton(
            icon: Icon(Icons.logout,color: Colors.white,),
            onPressed: _logout,
          ),
        ],

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
                      "${_account?.address ?? "Welcome"}",
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
                      Text("Messages", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),

                      SizedBox(height: 20),

                      FutureBuilder<InboxesModel>(
                        future: _futureInboxes,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError || snapshot.data == null) {
                            return Center(child: Text('Error: Failed to fetch data'));
                          } else {
                            final inboxes = snapshot.data!.hydraMember ?? [];
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 260, // Adjust height as needed
                              child: ListView.builder(
                                itemCount: inboxes.length,
                                itemBuilder: (context, index) {
                                  final inbox = inboxes[index];
                                  final bool isSeen = inbox.seen ?? false;
                                  String formattedUpdatedAt = DateFormat('dd/MMM/yyyy HH:mm:ss').format(inbox.updatedAt ?? DateTime.now());

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: CustomCard(
                                      line1: inbox.from?.address ?? '',
                                      line2: inbox.to != null && inbox.to!.isNotEmpty ? inbox.to![0].address ?? '' : '',
                                      line3: formattedUpdatedAt,
                                      line4: inbox.subject ?? '',
                                      line5: inbox.intro ?? '',
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
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
  }

  Future<void> _logout() async {
    // Clear any user data or session tokens
    // For example, if using SharedPreferences:
    await Hive.close();
    await Hive.deleteBoxFromDisk('loginData');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();// Clear all saved data

    // Navigate back to the login page
    Get.offAll(() => DomainPage()); // Replace LoginPage() with your login page widget
  }

}

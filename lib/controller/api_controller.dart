import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qtechtest/model/account_details_model.dart';
import 'package:qtechtest/model/inboxes_model.dart';
import 'package:qtechtest/model/login_model.dart';

import '../view/auth_pages/login_page.dart';
import '../view/dashboard.dart';
import '../widget/common_methods.dart';


class ApiController {
  static bool _isLoading = false;
  static List<Map<String, String>> _userCredentialsList = [];

  static Future<void> fetchDomains(int page, TextEditingController domaininitController) async {
    var url = Uri.parse('https://api.mail.tm/domains?page=$page');
    var headers = {
      'accept': 'application/ld+json',
    };

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> domainList = jsonResponse['hydra:member'];
      // Assuming there's only one domain in the list
      String domain = domainList[0]['domain'];
      domaininitController.text = domain;
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  static Future<void> registrationIn(String domain, TextEditingController userNameController, TextEditingController passwordController, BuildContext context) async {
    CommonMethods cMethods = CommonMethods();
    try {
      var headers = {
        'Accept': 'application/ld+json',
        'Content-Type': 'application/ld+json',
      };
      var body = json.encode({
        "address": '${userNameController.text}@$domain',
        "password": passwordController.text,
      });

      var response = await http.post(
        Uri.parse('https://api.mail.tm/accounts'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        print('Registration successful');
        // Show a snackbar message indicating successful registration
        cMethods.displaySnackBarGreen("Registration successful", context);
        // Navigate to the login page after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(domain: domain)),
        );
      } else {
        print('Registration failed: ${response.reasonPhrase}');
        // Display an error message to the user
        cMethods.displaySnackBarRed("Registration failed: ${response.reasonPhrase}", context);
      }
    } catch (error) {
      print('Error during registration: $error');
      // Display an error message to the user
      cMethods.displaySnackBarRed("Error during registration: $error", context);
    }
  }

  static Future<void> signIn(String domain, TextEditingController emailController, TextEditingController passwordController, BuildContext context) async {
    CommonMethods cMethods = CommonMethods();
    _isLoading = true;
    try {
      var url = Uri.parse('${BaseUrl.baseUrl}/token');
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      var body = json.encode({
        "address": '${emailController.text}@$domain',
        "password": passwordController.text,
      });

      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var loginModel = LoginModel.fromJson(jsonResponse);
        saveLoginData(loginModel);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashBoard(loginModel: loginModel)),
        );
        cMethods.displaySnackBarGreen("Login successful", context);
      } else {
        print('Login failed: ${response.reasonPhrase}');
        cMethods.displaySnackBarRed("Login Failed", context);
      }
    } catch (error) {
      print('Error during login: $error');
    }
    _isLoading = false;
  }

  static Future<Account?> fetchAccountDetails(LoginModel? loginModel) async {
    if (loginModel == null || loginModel.token == null) {
      throw Exception('LoginModel or token is null');
    }

    final String apiUrl = '${BaseUrl.baseUrl}/me';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'accept': 'application/ld+json',
          'Authorization': 'Bearer ${loginModel.token!}',
        },
      );

      print('Request Headers: ${response.request!.headers}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Fetched account details: $responseData');
        return Account.fromJson(responseData);
      } else {
        throw Exception('Failed to load account details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching account details: $e');
      return null;
    }
  }

  static Future<InboxesModel> fetchInboxes(LoginModel? loginModel) async {
    if (loginModel == null || loginModel.token == null) {
      throw Exception('LoginModel or token is null');
    }

    var headers = {
      'Authorization': 'Bearer ${loginModel.token!}',
    };
    var request = http.Request('GET', Uri.parse('${BaseUrl.baseUrl}/messages?page=1'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Parse the response using the InboxesModel.fromJson method
      final String responseBody = await response.stream.bytesToString();
      return inboxesModelFromJson(responseBody);
    } else {
      // Handle error
      throw Exception('Failed to fetch inboxes: ${response.reasonPhrase}');
    }
  }


  static Future<void> saveCredentials(String userName, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);

    var status = await Permission.storage.request();
    if (status.isGranted) {
      prefs.setString('password', password);
      Map<String, String> credentials = {'userName': userName, 'password': password};
      _userCredentialsList.add(credentials);
      prefs.setString('userCredentialsList', json.encode(_userCredentialsList));
    } else {
      print('Permission not granted to save password.');
    }
  }

  static Future<void> loadCredentials(TextEditingController emailController, TextEditingController passwordController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString('userName') ?? '';
    passwordController.text = prefs.getString('password') ?? '';
  }

  static Future<void> saveLoginData(LoginModel loginData) async {
    var box = await Hive.openBox('loginData');
    String jsonData = json.encode(loginData.toJson());
    box.put('userData', jsonData);
  }
}


class BaseUrl {
  static const String baseUrl = 'https://api.mail.tm';
  static const String TOKEN = 'Token';
}
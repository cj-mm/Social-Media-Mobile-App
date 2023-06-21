import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../model/user_model.dart';

class UserNetworkHelper {
  bool testOutput = false;

  /*
  Desc: login a user (post request)
  Params:
  - username: a String for user's username
  - password: a String for user's password
  Return type: Future<String>
  */
  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      testOutput = json.decode(response.body)["success"];

      var body = jsonDecode(response.body);
      Login data = Login.fromJson(body["data"]);
      return data.token;
    } else if (jsonDecode(response.body)["message"].toString() ==
            "user doesn't exists" ||
        jsonDecode(response.body)["message"].toString() ==
            "password is incorrect") {
      return jsonDecode(response.body)["message"].toString();
    } else {
      // print(jsonDecode(response.body)["message"].toString());
      throw Exception('Failed to login');
    }
  }

  /*
  Desc: signup/register a user (post request)
  Params:
  - username: a String for user's username
  - password: a String for user's password
  - firstName: a String for user's first name
  - lastName: a String for user's last name
  Return type: Future<User>
  */
  Future<User> signup(String username, String password, String firstName,
      String lastName) async {
    final response = await http.post(
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer Zxi!!YbZ4R9GmJJ!h5tJ9E5mghwo4mpBs@*!BLoT6MFLHdMfUA%'
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'firstName': firstName,
        'lastName': lastName
      }),
    );

    if (response.statusCode == 200) {
      testOutput = json.decode(response.body)["success"];

      return User.fromJson(jsonDecode(response.body)["data"]);
    } else if (jsonDecode(response.body)["message"].toString() ==
        "user exists") {
      User holder = User(firstName: "", lastName: "", date: 0, updated: 0);
      return holder;
    } else {
      throw Exception('Failed to register');
    }
  }

  /*
  Desc: view a user profile (get request)
  Params:
  - token: a String used for authorization
  - username: a String to determine which user to view
  Return type: Future<User>
  */
  Future<User> viewprofile(String token, String username) async {
    final response = await http.get(
        Uri.parse(
            'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user/$username'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      testOutput = json.decode(response.body)["success"];

      return User.fromJson(jsonDecode(response.body)["data"]);
    } else {
      throw Exception('Failed to view profile');
    }
  }

  /*
  Desc: logout a user (post request)
  Params:
  - token: a String used for authorization
  Return type: Future<void>
  */
  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{}),
    );

    if (response.statusCode == 200) {
      testOutput = json.decode(response.body)["success"];

      print(jsonDecode(response.body).toString());
    } else {
      throw Exception('Failed to logout');
    }
  }

  /*
  Desc: update user's name (put request)
  Params:
  - token: a String used for authorization
  - username: a String to determine which user to update
  - firstName: a String updated first name
  - lastName: a String updated last name
  - oldPassword: a String user password
  Return type: Future<User>
  */
  Future<User> updateName(
      String token, String username, String firstName, String lastName) async {
    final response = await http.put(
      Uri.parse(
          'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user/$username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
          <String, String>{'firstName': firstName, 'lastName': lastName}),
    );

    if (response.statusCode == 200) {
      testOutput = json.decode(response.body)["success"];

      return User.fromJson(jsonDecode(response.body)["data"]);
    } else {
      print(jsonDecode(response.body)["message"].toString());
      throw Exception('Failed to update profile');
    }
  }

  /*
  Desc: update user's [assword] (put request)
  Params:
  - token: a String used for authorization
  - username: a String to determine which user to update
  - oldPassword: a String user old password
  - newPassword: a String updated password
  Return type: Future<User>
  */
  Future<String> updatePassword(String token, String username,
      String oldPassword, String newPassword) async {
    final response = await http.put(
      Uri.parse(
          'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user/$username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      testOutput = json.decode(response.body)["success"];

      return "success";
    } else if (jsonDecode(response.body)["message"]
                .toString() == 
            "cannot have same password for old and new" ||
        jsonDecode(response.body)["message"].toString() ==
            "old password is incorrect") {
      return jsonDecode(response.body)["message"].toString();
    } else {
      print(jsonDecode(response.body)["message"].toString());
      throw Exception('Failed to update profile');
    }
  }
}

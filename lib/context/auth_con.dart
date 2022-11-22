// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:doctor_appointment/helpers/authLogic.dart';
import 'package:doctor_appointment/navigation/auth_stack.dart';
import 'package:doctor_appointment/navigation/user_stack.dart';
import 'package:doctor_appointment/screens/login.dart';
import 'package:doctor_appointment/screens/sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class User {
  String _name = '';
  String _email = '';
  String _photoUrl = '';

  String get name => _name;

  set setName(String name) {
    _name = name;
  }

  String get getEmail => _email;

  set setEmail(String email) {
    _email = email;
  }

  String get photoUrl => _photoUrl;

  set setphotoUrl(String photo) {
    _photoUrl = photo;
  }
}

class AuthContext with ChangeNotifier, DiagnosticableTreeMixin {
  bool _authState = false;
  User user = User();
  bool get authState => _authState;

  void setAuthorized() {
    _authState = true;
    notifyListeners();
  }

  String hashPassword(String data) {
    var bytes1 = utf8.encode(data); // data being hashed
    var digest1 = sha256.convert(bytes1);
    return digest1.toString();
  }

  void setUserData(dynamic userData) {
    user.setName = userData["NAME"];
    user.setEmail = userData["EMAIL"];
    user.setphotoUrl = userData["IMG_URL"];
    notifyListeners();
  }

  void setUserImage(String img) {
    user.setphotoUrl = img;
    notifyListeners();
  }

  void logOut(BuildContext context) {
    user = User();
    AuthLogic.removeCredentials();
    notifyListeners();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return const AuthStack();
    }), (r) {
      return false;
    });
  }

  void updateUserName(String fname, String lname, String email) async {
    Uri url = Uri.http('192.168.1.3', '/wp/api/users/update_name.php');
    var data = {'name': fname + ' ' + lname, 'email': email};
    var response = await http.post(url, body: data);
    print(response);
    if (response.statusCode == 200) {
      var msg = json.decode(response.body);
      if (msg['message'] == 'success') {
        setUserData(msg['user_data']);
      }
    }
  }

  Future<void> signUpEmailAndPass(String fname, String lname, String email,
      String pass, String cpass, BuildContext context) async {
    Uri url = Uri.http('192.168.1.3', '/wp/api/users/auth/signup.php');
    var hashedPass = hashPassword(pass);
    var data = {
      'name': fname + ' ' + lname,
      'password': hashedPass,
      'email': email
    };
    var response = await http.post(url, body: json.encode(data));
    if (response.statusCode == 200) {
      var msg = json.decode(response.body);
      print(msg);
      if (msg['message'] == 'success') {
        var store = AuthLogic(msg['token']);
        if (store.generatedKey != '') {
          AuthLogic.putUserCredInSecureStorage(
              {'password': hashedPass, 'email': email});
          setUserData(msg['user_data']);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const Login();
          }), (r) {
            return false;
          });
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('There was an error in authentication'),
              content: const Text('Error Hash Didnt match'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const SignUp();
                    }), (r) {
                      return false;
                    })
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Authentication Error'),
            content: const Text('User Already Present'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> loginWithEmailAndPassword(
      String email, String pass, BuildContext cntx) async {
    Uri url = Uri.http('192.168.1.3', '/wp/api/users/auth/login.php');
    var hashedPass = hashPassword(pass);
    var passWord = await AuthLogic.encryptUsingEncKey(hashedPass);
    var data = {'password': passWord, 'email': email};
    print(data);
    var response = await http.post(url, body: json.encode(data));
    if (response.statusCode == 200) {
      var msg = json.decode(response.body);
      print(msg);
      if (msg['message'] == 'success') {
        var store = AuthLogic(msg['token']);
        if (store.generatedKey != '') {
          AuthLogic.putUserCredInSecureStorage(
              {'password': hashedPass, 'email': email});
          setUserData(msg['user_data']);
          Navigator.pushAndRemoveUntil(cntx,
              MaterialPageRoute(builder: (BuildContext context) {
            return const UserStack();
          }), (r) {
            return false;
          });
        }
      } else {
        AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => {print('Gay')},
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => {print('Gay')},
              child: const Text('OK'),
            ),
          ],
        );
      }
    }
  }

  Future<void> oAuthLogin(BuildContext cntx) async {
    Uri url = Uri.http('192.168.1.3', '/wp/api/users/auth/oAuth.php');
    var userCred = await AuthLogic.getUserCredInSecureStorage();
    if (userCred['password'] == '') return;
    var passWord = await AuthLogic.encryptUsingStoredKey(userCred['password']!);
    var data = {'password': passWord, 'email': userCred['email']};
    print(data);
    var response = await http.post(url, body: json.encode(data));
    if (response.statusCode == 200) {
      var msg = json.decode(response.body);
      print(msg);
      if (msg['message'] == 'success') {
        var store = AuthLogic(msg['token']);
        if (store.generatedKey != '') {
          setUserData(msg['user_data']);
          Navigator.pushAndRemoveUntil(cntx,
              MaterialPageRoute(builder: (BuildContext context) {
            return const UserStack();
          }), (r) {
            return false;
          });
        }
      } else {
        AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => {print('Gay')},
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => {print('Gay')},
              child: const Text('OK'),
            ),
          ],
        );
      }
    }
  }
}

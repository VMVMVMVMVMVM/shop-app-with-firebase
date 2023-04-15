

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



import 'dart:async';

import '../screens/product_overview_screen.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;
  late Timer _authTimer;
  // bool get isAuth {
  // return token != null;
  // }

  //String? get token {
  //if (expiryDate != null &&
  // expiryDate.isAfter(DateTime.now()) &&
  //token != null) ;
  //{
  // return _token;
  //}
  //return null;
  //}

  // Future<void> _authenticate(
  //   String email, String password, String urlSegment) async {
  //const url =
  //  'https://identitytoolkit.googleapis.com/v1/accounts:urlSegment?key=AIzaSyC2W_Mb_SOvoM3_j2jC80OIeRkHbycWem0';
  //try {
  // final response = await http.post(
  // Uri.parse(url),
  //body: json.encode(
  //{
  //'email': email,
  //'password': password,
  //'returnSecureToken': true,
  //},
  //),
  //);
  //final responseData = json.decode(response.body);
  //} catch (error) {
  //throw error;
  //}
  //}

  Future<void> signup(String email, String password) async {
    //  _authenticate(email, password, 'signUp');
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC2W_Mb_SOvoM3_j2jC80OIeRkHbycWem0';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    print(json.decode(response.body));
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    //_authenticate(email, password, 'signInWithPassword');
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
          (value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return ProductsOverviewScreen();
            },
          ),
        );
      },
    );
    //  const url =
    //  'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC2W_Mb_SOvoM3_j2jC80OIeRkHbycWem0';
    // final response = await http.post(
    // Uri.parse(url),
    //body: json.encode(
    //{
    //'email': email,
    //'password': password,
    //'returnSecureToken': true,
    //}
    //),
    //);
    //print(json.decode(response.body));

  }
  void logOut(){
    _token = '';
    _expiryDate = '' as DateTime;
    _userId = '';
    notifyListeners();
  }
  void _autoLogout() {
    if(_authTimer != null){
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer= Timer(Duration(seconds: 3 ), logOut);
  }
}

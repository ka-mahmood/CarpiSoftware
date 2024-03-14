import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart'; 

// ignore: must_be_immutable

class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {

  @override
  Widget build(BuildContext context) {
  
  if (loginStatus == 'true') {
    print('passes into next');
      Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
  }

    // var theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Account Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
          backgroundColor: Colors.black12,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
              child: const Text("Log out", style:TextStyle(fontWeight: FontWeight.w100)),
              onPressed: () {
                recordLogin(false);
                Phoenix.rebirth(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  recordLogin(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('login', status.toString());
  }
}
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable

class StartupPage extends StatefulWidget {
  @override
  State<StartupPage> createState() => _StartupPage();
}

// String loginStatus = '';

class _StartupPage extends State<StartupPage> {
  String loginStatus = '';
  @override
  void initState() {
    super.initState();
    AsyncSnapshot.waiting();
    checkLogin();
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
  
  if (loginStatus == 'true') {
    print('passes into next');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    });
  }

  // placeholder authentication for email
  Future signIn() async {
      if (_formKey.currentState!.validate()) {
        if (_emailController.text == "carpi.rehab@gmail.com") { 
          if (_passwordController.text == "password") {
            ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text("Logged In Successfully"),
                duration: Duration(milliseconds: 750),
              ),
            ).closed.whenComplete(
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              )            
            );
            recordLogin(true);

          } else {
            ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text("Incorrect password."),
                duration: Duration(milliseconds: 750),
              ),);
          }
        } else {
            ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text("No such user exists."),
                duration: Duration(milliseconds: 750),
              ),);
        }
      }
    }

    var theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
          backgroundColor: Colors.black12,
        ),
        body: Form(
          key: _formKey,
          child: Container(
            color: theme.colorScheme.background,
            child: SafeArea (
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material (
                    color: theme.colorScheme.background,
                    child: Column (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Text(
                            "Carpi",
                            style: TextStyle(color: theme.colorScheme.primary, fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          
                          Text(
                            "Rehabilitation",
                            style: TextStyle(color: theme.colorScheme.primary, fontSize: 30, fontWeight: FontWeight.w100),
                          ),
          
                          SizedBox(
                            width: 200.0,
                            child: Image.asset('assets/logo.png')
                            ), //   <--- image
                        ]
                      ),
                  ),
                  // email field
                  Material (
                    color: theme.colorScheme.background,
                    child : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300.0,
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        controller: _emailController,
                        style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w100),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email'),
                      ),
                      ),
                    ),
                  ),
          
                  // password field
                  Material (
                    color: theme.colorScheme.background,
                    child : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300.0,
                        child: TextField(
                          style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w100),
                          controller: _passwordController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                      
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password'),
      
                        ),
                      ),
                    ),
                  ),
          
                  // login button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: FloatingActionButton.extended(
                        icon: Icon(Icons.login),
                        label: const Text("Log in", style:TextStyle(fontWeight: FontWeight.w100)),
                        onPressed: () {
                          signIn();             
                        },
                      ),
                    ),
                  ),
          
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ElevatedButton(
                        child: const Text("Not registered? Sign up here.", style:TextStyle(fontWeight: FontWeight.w100)),
                        onPressed: () {           
                        },
                      ),
                    ),
                  ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  recordLogin(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    loginStatus = status.toString();
    prefs.setString('login', status.toString());
  }
  
  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loginStatus = (prefs.getString('login') ?? '');
    });  
  }


}
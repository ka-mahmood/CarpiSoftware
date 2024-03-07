import 'package:flutter/material.dart';
import 'main.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
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
                      width: 300.0,
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
                  decoration: InputDecoration(
                    hintText: 'Email',
                      hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            width: 0, 
                            style: BorderStyle.none,
                        ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                  ),
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
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 0, 
                              style: BorderStyle.none,
                          ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
            ),

            // login button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
                  child: const Text("Log in", style:TextStyle(fontWeight: FontWeight.w100)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );              
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
                  child: const Text("Get started", style:TextStyle(fontWeight: FontWeight.w100)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );              
                  },
                ),
              ),
            ),
        ],
        ),
      ),
    );
  }

}

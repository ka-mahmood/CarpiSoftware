import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart'; // side navigation bar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Title',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark, 
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Carpi Rehabilitation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(); // returns _MyHomePageState
  // _MainViewState createState() => _MainViewState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  List<Widget> views = const [
    Center(
      child: Text('Dashboard'),
    ),
    Center(
      child: Text('Exercise')
    ),
    Center(
      child: Text('Progress')
    ),
    Center(
      child: Text('Account'),
    ),
    Center(
      child: Text('Settings'),
    ),
  ];

  /// The currently selected index of the bar
  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            
          SideNavigationBar(
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
              ),
              SideNavigationBarItem(
                icon: Icons.waving_hand_rounded,
                label: 'Exercise',
              ),
              SideNavigationBarItem(
                icon: Icons.trending_up,
                label: 'Progress',
              ),
              SideNavigationBarItem(
                icon: Icons.person,
                label: 'Account',
              ),
              SideNavigationBarItem(
                icon: Icons.settings,
                label: 'Settings',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),

          /// Make it take the rest of the available width
          Expanded(
            child: views.elementAt(selectedIndex),
          )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



// class _MainViewState extends State<MyHomePage> {

//   // available views
//   List<Widget> views = const [
//     Center(
//       child: Text('Dashboard'),
//     ),
//     Center(
//       child: Text('Exercise')
//     ),
//     Center(
//       child: Text('Progress')
//     ),
//     Center(
//       child: Text('Account'),
//     ),
//     Center(
//       child: Text('Settings'),
//     ),
//   ];

//   /// The currently selected index of the bar
//   int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           /// Pretty similar to the BottomNavigationBar!
//           SideNavigationBar(
//             selectedIndex: selectedIndex,
//             items: const [
//               SideNavigationBarItem(
//                 icon: Icons.dashboard,
//                 label: 'Dashboard',
//               ),
//               SideNavigationBarItem(
//                 icon: Icons.waving_hand_rounded,
//                 label: 'Exercise',
//               ),
//               SideNavigationBarItem(
//                 icon: Icons.trending_up,
//                 label: 'Progress',
//               ),
//               SideNavigationBarItem(
//                 icon: Icons.person,
//                 label: 'Account',
//               ),
//               SideNavigationBarItem(
//                 icon: Icons.settings,
//                 label: 'Settings',
//               ),
//             ],
//             onTap: (index) {
//               setState(() {
//                 selectedIndex = index;
//               });
//             },
//           ),

//           /// Make it take the rest of the available width
//           Expanded(
//             child: views.elementAt(selectedIndex),
//           )
//         ],
//       ),
//     );
//   }
// }

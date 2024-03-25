// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart'; 
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

// import the self-made classes
import 'exercise_page.dart';
import 'login_page.dart';
import 'dashboard_page.dart';
import 'progress_page.dart';
import 'account.dart';


// Future<void> _configureLocalTimeZone() async {
//   tz.initializeTimeZones();
//   // ignore: unnecessary_nullable_for_final_variable_declarations
// tz.setLocalLocation(tz.getLocation(await FlutterTimezone.getLocalTimezone()));
//   // final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
//   // tz.setLocalLocation(tz.getLocation(timeZoneName!));
// }

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await _configureLocalTimeZone();
  
  await localNotifier.setup(
    appName: 'Carpi Windows',
    shortcutPolicy: ShortcutPolicy.requireCreate,
  );

  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

String loginStatus = ''; // global var to hold login status

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

  final textTheme = Theme.of(context).textTheme;
    return MaterialApp(    
        title: 'Carpi App',
        darkTheme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(),  
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        themeMode: ThemeMode.dark, 
        debugShowCheckedModeBanner: false,
        home: StartupPage(),
        
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    // switching for the app navigation bar
    List<dynamic> pageClass = [
      Dashboard(),
      PrescribedExercises(),
      Progress(),
      AccountPage(),
    ];

    // switching for the side navigation bar
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = Dashboard();
      case 1:
        page = PrescribedExercises();
      case 2:
        page = Progress();
      case 3:
        page = AccountPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.background,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: selectedIndex,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home),
            label: 'Dashboard',
            labelStyle: TextStyle(color: colorScheme.onBackground)
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.front_hand),
            label: 'Routine',
            labelStyle: TextStyle(color: colorScheme.onBackground)
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.trending_up),
            label: 'Progress',
            labelStyle: TextStyle(color: colorScheme.onBackground)
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person_2),
            label: 'Account',
            labelStyle: TextStyle(color: colorScheme.onBackground)
          ),
        ],
        color: Colors.black12,
        buttonBackgroundColor: Colors.black12,
        backgroundColor: colorScheme.background,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Container(
        color: colorScheme.background,
        child: Center(
          child: pageClass[selectedIndex],
        )
      )
    );  
          } else { // this is the programmed side bar
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 800,
                    backgroundColor: Colors.black12,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.front_hand),
                        label: Text('Exercises'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.trending_up),
                        label: Text('Progress'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_2),
                        label: Text('Account'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      )
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Carpi App',
        darkTheme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(),  
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        themeMode: ThemeMode.dark, 
        debugShowCheckedModeBanner: false,
        home: StartupPage(),
    ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
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
    List<dynamic> _page = [
      Dashboard(),
      PrescribedExercises(),
      Progress(),
      StartupPage(),
    ];

    // switching for the side navigation bar
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = Dashboard();
        break;
      case 1:
        page = PrescribedExercises();
        break;
      case 2:
        page = Progress();
        break;
      case 3:
        page = StartupPage();
        break;
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
            label: 'Exercise',
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
          child: _page[selectedIndex],
        )
      )
    );  
          } else { // this is the programmed side bar
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 750,
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
      ),
      
    );
  }
}

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

class GeneratorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.background,
      child: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: HistoryListView(),
              ),
              SizedBox(height: 10),
              BigCard(pair: pair),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      appState.toggleFavorite();
                    },
                    icon: Icon(icon),
                    label: Text('Like'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      appState.getNext();
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          // Make sure that the compound word wraps correctly when the window
          // is too narrow.
          child: MergeSemantics(
            child: Wrap(
              children: [
                Text(
                  pair.first,
                  style: style.copyWith(fontWeight: FontWeight.w200),
                ),
                Text(
                  pair.second,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PrescribedExercises extends StatelessWidget {

    @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double newheight = height - padding.top - padding.bottom;

    return SafeArea (
      child: SizedBox(
        width: width,
        height: newheight,
        child: SingleChildScrollView(
              child: Column (
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Your',
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 30
                              )
                            ),
                            TextSpan(
                              text: ' Exercises',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 30
                              )
                            ),
                          ]
                        )
                      ),
                    ),
                  ),
        
                  Padding( // insert an element
                    padding: const EdgeInsets.all(10.0),
                    child: Card (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      child: Image.network(
                        'https://carpirehab.files.wordpress.com/2023/12/draft-1.webp',
                        width: width,
                        // height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
        
                  Padding( // insert an element
                    padding: const EdgeInsets.all(10.0),
                    child: Card (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      child: Image.network(
                        'https://carpirehab.files.wordpress.com/2024/02/1000019337.jpg',
                        width: width,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
        
                  Padding( // insert an element
                    padding: const EdgeInsets.all(10.0),
                    child: Card (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      child: Image.network(
                        'https://carpirehab.files.wordpress.com/2024/01/image.png',
                        width: width,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
        
        
              ],
              ),
            ),
      ),
    );
  }
}   

class Dashboard extends StatelessWidget {

    @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double newheight = height - padding.top - padding.bottom;

    return SafeArea (
      child: SizedBox(
        width: width,
        height: newheight,
        child: SingleChildScrollView(
              child: Column (
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Dashboard',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 30
                              )
                            ),
                          ]
                        )
                      ),
                    ),
                  ),
        
                  Padding( // insert an element
                    padding: const EdgeInsets.all(10.0),
                    child: Card (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      child: Image.network(
                        'https://carpirehab.files.wordpress.com/2023/12/pexels-photo-8386755.jpeg',
                        width: width,
                        // height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
        
                  Padding( // insert an element
                    padding: const EdgeInsets.all(10.0),
                    child: Card (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      child: Image.network(
                        'https://carpirehab.files.wordpress.com/2023/12/pexels-photo-3059748.jpeg',
                        width: width,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
        
                  Padding( // insert an element
                    padding: const EdgeInsets.all(10.0),
                    child: Card (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      child: Image.network(
                        'https://carpirehab.files.wordpress.com/2023/12/handstuff.webp?w=2000&h=',
                        width: width,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
        
        
              ],
              ),
            ),
      ),
    );
  }
}   

class Progress extends StatelessWidget {

    @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double newheight = height - padding.top - padding.bottom;

    return SafeArea (
      child: SizedBox(
        width: width,
        height: newheight,
        child: SingleChildScrollView(
              child: Column (
                children: [
                  
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 0, 10),                    
                    child: SizedBox(
                      width: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Progress',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 30
                              ),
                            ),                            
                          ]
                        )
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),                    
                    child: SizedBox(
                      width: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Take a look at your improvement.',
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16
                              ),
                            ),                            
                          ]
                        )
                      ),
                    ),
                  ),        
                  Padding( // insert an element
                    padding: const EdgeInsets.all(10.0),
                    child: Card (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      child: Image.network(
                        'https://carpirehab.files.wordpress.com/2023/12/hand_landmarks.png?w=2000&h=',
                        width: width,
                        // height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
        
                  Padding( // insert an element
                    padding: const EdgeInsets.all(10.0),
                    child: Card (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      child: Image.network(
                        'https://carpirehab.files.wordpress.com/2023/12/full_fdp_design.png?w=2000&h=',
                        width: width,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
        
                  Padding( // insert an element
                    padding: const EdgeInsets.all(10.0),
                    child: Card (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      child: Image.network(
                        'https://carpirehab.files.wordpress.com/2023/12/image-5.png?w=2000&h=',
                        width: width,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
        
        
              ],
              ),
            ),
      ),
    );
  }
}   


class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Text('You have '
                '${appState.favorites.length} favorites:'),
          ),
          Expanded(
            // Make better use of wide windows with a grid.
            child: GridView(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 400 / 80,
              ),
              children: [
                for (var pair in appState.favorites)
                  ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                      color: theme.colorScheme.primary,
                      onPressed: () {
                        appState.removeFavorite(pair);
                      },
                    ),
                    title: Text(
                      pair.asLowerCase,
                      semanticsLabel: pair.asPascalCase,
                    ),
                  ),
              ],
            ),
          ),
        ],
      )
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: appState.favorites.contains(pair)
                    ? Icon(Icons.favorite, size: 12)
                    : SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

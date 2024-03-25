
import 'package:carpi_windows_app/start_exercise.dart';
import 'package:flutter/material.dart';
import 'package:awesome_circular_chart/awesome_circular_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'exercise_page.dart';
import 'dart:convert';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _Dashboard();
}
  

List<ExerciseCardModel> _cardModelList = [];

List<double> progressVal = [0];

class _Dashboard extends State<Dashboard> {
    final _controller = ScrollController();
    double get maxHeight => 200 + MediaQuery.of(context).padding.top;
    double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;
    bool isEmpty = false;
    final GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey<AnimatedCircularChartState>();
    List<CircularStackEntry> data = <CircularStackEntry>[
    CircularStackEntry(
    <CircularSegmentEntry>[
      CircularSegmentEntry(progressVal[0], Colors.green, rankKey: 'Q1'),
      CircularSegmentEntry(1-progressVal[0], Colors.black12, rankKey: 'Q2'),
    ],
    rankKey: 'Quarterly Profits',
  ),
  ];

  @override
  void initState() {
    // make some pre-build exercises
    readCardsIn();
    // getCompletionValue();
    super.initState();
  }  
  
  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
        readCardsIn();
    getCompletionValue();

    double width = MediaQuery.of(context).size.width;
    var colorScheme = Theme.of(context).colorScheme;


    return Scaffold (
        backgroundColor: colorScheme.background,
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          _snapAppbar();
          return false;
        },
                child: CustomScrollView(
  
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller,
          slivers: [

            SliverAppBar(

              automaticallyImplyLeading: false,
              // foregroundColor: colorScheme.primary,
              pinned: true,
              stretch: true,
              flexibleSpace: Header(
                maxHeight: maxHeight,
                minHeight: minHeight,
              ),
              expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => 
                drawProgressChart(colorScheme, width),
              childCount: 1,
              ),
            )
          ],
        ),
      ),
    
      );
  }

  Padding drawProgressChart(ColorScheme colorScheme, double width) {
    return Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column (
                children: [
                  Padding( // insert an element
                    padding: const EdgeInsets.all(10.0),
                    child: Card (
                      color: colorScheme.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      child: Column(
                        children: [
                          SizedBox(width: width, height: 10,),
                          Text("Exercise Progress", style: TextStyle(color: colorScheme.onBackground, fontSize: 24),),
                          getProgChart(),
                          TextButton(child:Text("Continue exercise", style:TextStyle(fontSize: 14)), onPressed: () {
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => StartExercise()));                  

                            },
                          ),
                        ],
                      ),
                    ),
                  ),
      
                ],  
              ),
              );
  }

  AnimatedCircularChart getProgChart() {
    return AnimatedCircularChart(
                          key: _chartKey,
                          size: const Size(300.0, 300.0),
                          initialChartData: data,
                          chartType: CircularChartType.Radial,
                          edgeStyle: SegmentEdgeStyle.round,
                          holeLabel: (progressVal[0].isNaN)? '${(0).roundToDouble()}%':'${(progressVal[0]*100).roundToDouble()}%',
                          labelStyle: TextStyle(color: Colors.green, fontSize: 50,),
                          duration: Duration(milliseconds: 100),
                        );
  }
  
    void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset =
          _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _controller.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }
  Future<void> readCardsIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload(); 
    List<String>? decodedCardString = prefs.getStringList('cards');
    List<ExerciseCardModel> decodedCards = 
                  decodedCardString!.map((card)
                  => ExerciseCardModel.fromJson(json.decode(card))).toList();
    setState(() {
      _cardModelList = decodedCards;   
    });
  }

  void getCompletionValue() {
    int completionNum = 0;
    for (var i = 0; i < _cardModelList.length; i++) {
      if (_cardModelList[i].completed == true) {
        completionNum += 1;
      }
    }
    setState(() {
        progressVal[0] = completionNum/_cardModelList.length;
        data = <CircularStackEntry>[
        CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(progressVal[0], Colors.green, rankKey: 'Q1'),
          CircularSegmentEntry(1-progressVal[0], Colors.black12, rankKey: 'Q2'),
        ],
        rankKey: 'Quarterly Profits',
        ),
      ];
    });
     _chartKey.currentState?.updateData(data);
  }
}

class Header extends StatelessWidget {
  final double maxHeight;
  final double minHeight;

  const Header({super.key, required this.maxHeight, required this.minHeight});

  @override
  Widget build(BuildContext context) {

  var colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final expandRatio = _calculateExpandRatio(constraints);
            final animation = AlwaysStoppedAnimation(expandRatio);
        
            return Stack(
              fit: StackFit.expand,
              
              children: [
                // _buildImage(),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.background,
                  ),            
                ),
                _buildTitle(animation),
              ],
            );
          },
        ),
      ),
    );
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio =
        (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;
    return expandRatio;
  }

  Align _buildTitle(Animation<double> animation) {
    return Align(
      alignment: AlignmentTween(
              begin: Alignment.bottomLeft, end: Alignment.center,)
          .evaluate(animation),
      child: Container(
        margin: EdgeInsets.only(bottom: 10, left: 50, right: 20),
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
                text: ' Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30
                )
              ),
            ]
          )
        ),
      ),
    );
  }
  
}

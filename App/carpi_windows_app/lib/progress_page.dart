import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'exercise_page.dart';
import 'dart:convert';

List<ExerciseCardModel> _cardModelList = [];

class Progress extends StatefulWidget {
  Progress({super.key});

  final Color barBackgroundColor =
      Color(0xff404E5C);
  final Color barColor = Color(0xff998FC7);
  final Color touchedBarColor = Color(0xffFAC05E);

  @override
  State<StatefulWidget> createState() => _Progress();
}

class _Progress extends State<Progress> {

  final _controller = ScrollController();
  double get maxHeight => 200 + MediaQuery.of(context).padding.top;
  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;
  bool isEmpty = false;
  Color cardBgColor = Colors.black;
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  double numCompletedToday = 0;


  double getCompletionValue() {
    int completionNum = 0;
    for (var i = 0; i < _cardModelList.length; i++) {
      if (_cardModelList[i].completed == true) {
        completionNum += 1;
      }
    }
    return completionNum/_cardModelList.length;
  }

  @override
  void initState() {
    super.initState();
    readCardsIn();
    numCompletedToday = getCompletionValue();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
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
                (context, index) {
                  if (index == 0) {
                    return Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: (consistencyGraph(colorScheme)));
                  } else if (index == 1) {
                    return Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: (romGraph(colorScheme)));     
                  } else if (index == 2) {
                    return Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: (strengthGraph(colorScheme)));
                  }
                  return null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Card consistencyGraph (ColorScheme colorScheme) {
    return Card(
          color: colorScheme.background,
          child: Padding( // insert an element
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Stack(
              children: <Widget>[
                RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Exercise Consistency',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20
                          ),
                        ),                            
                      ]
                    )
                  ),
                  
                Column (
                  children: <Widget> [
                SizedBox(
                  height: 300,
            child: AspectRatio(
              aspectRatio: 3,                  
              child: Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      left: 12,
                      top: 40,
                      bottom: 0,
                    ),
                    child: BarChart(
                      mainBarData(),
                    ),
                  ),
                ),
                ),
                    TextButton(onPressed: () {}, child: Text("See more"),),
                  ],
                ),
              ],
            )
          ),
        );
  }

  Card romGraph(ColorScheme colorScheme) {
    return Card(
      color: colorScheme.background,
      child: Padding( // insert an element
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Stack(
          children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Range of Motion',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20
                        ),
                      ),                            
                    ]
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(right: 40, left: 40, top: 30, bottom: 30),
                  child: Text.rich(
                      TextSpan(
                          text:
                              "Target",
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.line_axis,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                          ]),
                          style: TextStyle(color: Colors.white),
                      ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 40, left: 100, top: 30, bottom: 40),
                  child: Text.rich(
                      TextSpan(
                          text:
                              "Actual",
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.line_axis,
                                color: Colors.cyan,
                                size: 20,
                              ),
                            ),
                          ]),
                          style: TextStyle(color: Colors.white),
                      ),
                ),
            Column (
              children: <Widget> [
                SizedBox(
                  height: 400,
            child: AspectRatio(
              aspectRatio: 2.2,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 0,
                  left: 0,
                  top: 55,
                  bottom: 0,
                ),
                child: LineChart(
                  mainProgressChartData(),
                ),
              ),
              ),
            ),
                TextButton(onPressed: () {}, child: Text("See more"),),
              ],
            ),
            SizedBox(
              width: 60,
              height: 34,
            ),

          ],
        )
      ),
    );
  }

  Card strengthGraph(ColorScheme colorScheme) {
    return Card(
      color: colorScheme.background,
      child: Padding( // insert an element
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Stack(
          
          children: <Widget>[
                Container(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Strength',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20
                          ),
                        ),                            
                      ]
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 40, left: 40, top: 30, bottom: 40),
                  child: Text.rich(
                      TextSpan(
                          text:
                              "Target",
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.line_axis,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ]),
                          style: TextStyle(color: Colors.white),
                      ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 40, left: 100, top: 30, bottom: 40),
                  child: Text.rich(
                      TextSpan(
                          text:
                              "Actual",
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.line_axis,
                                color: Colors.cyan,
                                size: 20,
                              ),
                            ),
                          ]),
                          style: TextStyle(color: Colors.white),
                      ),
                ),
            Column (
              children: <Widget> [
                SizedBox(
                  height: 400,
            child: AspectRatio(
              aspectRatio: 2.2,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 0,
                  left: 0,
                  top: 55,
                  bottom: 0,
                ),
                child: LineChart(
                  mainStrengthChartData(),
                ),
              ),
            ),
                ),
                TextButton(onPressed: () {}, child: Text("See more"),),
              ],
            ),                              

            SizedBox(
              width: 60,
              height: 34,
            ),
          ],
        )
      ),
    );
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

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset =
          _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _controller.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
                   
        BarChartRodData(
          toY: isTouched ? y + 0.2 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 10, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 5, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 1, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 9, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, getCompletionValue()*10, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          
          tooltipBgColor: Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
          tooltipMargin: 0,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'March 19';
              case 1:
                weekDay = 'March 20';
              case 2:
                weekDay = 'March 21';
              case 3:
                weekDay = 'March 22';
              case 4:
                weekDay = 'March 23';
              case 5:
                weekDay = 'March 24';
              case 6:
                weekDay = 'March 25';
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY).toInt().toString(),
                  style: TextStyle(
                    color: widget.touchedBarColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "/10 exercises",
                  style: TextStyle(
                    color: widget.touchedBarColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),

        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w200,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 6:
        text = const Text('M', style: TextStyle(color:Colors.green, fontWeight: FontWeight.bold, fontSize: 14));
      case 5:
        text = const Text('T', style: style);
      case 4:
        text = const Text('W', style: style);
      case 3:
        text = const Text('T', style: style);
      case 2:
        text = const Text('F', style: style);
      case 1:
        text = const Text('S', style: style);
      case 0:
        text = const Text('S', style: style);
      default:
        text = const Text('', style: style);
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.white,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0°';
      case 15:
        text = '15°';
      case 30:
        text = '30°';
      case 45:
        text = '45°';
      case 60:
        text = '60°';
      case 75:
        text = '75°';
      case 90:
        text = '90°';
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);  
  }

  Widget leftStrengthWidgets(double value, TitleMeta meta) {
    
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.white,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
      case 20:
        text = '20%';
      case 30:
        text = '30%';
      case 40:
        text = '40%';
      case 50:
        text = '50%';
      case 60:
        text = '60%';
      case 80:
        text = '80%';
      case 100:
        text = '100%';
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);  
  }


  LineChartData mainProgressChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 15,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.blueGrey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.blueGrey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(

          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.blueGrey),
      ),
      minX: 0,
      maxX: 6,
      // minY: 0,
      // maxY: 90,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 30),
            FlSpot(3, 35),
            FlSpot(5, 42),
            FlSpot(6, 45),
          ],
          isCurved: true,

          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        ),

        LineChartBarData(
          color: Colors.green, 
          spots: const [
            FlSpot(0, 30),
            FlSpot(6, 60),
          ],
          isCurved: true,

          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),


      ],
    );
  }

  LineChartData mainStrengthChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 15,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.blueGrey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.blueGrey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(

          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftStrengthWidgets,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.blueGrey),
      ),
      minX: 0,
      maxX: 6,
      // minY: 0,
      // maxY: 90,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 30),
            FlSpot(3, 35),
            FlSpot(5, 42),
            FlSpot(6, 45),
          ],
          isCurved: true,

          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        ),

        LineChartBarData(
          color: Colors.red, 
          spots: const [
            FlSpot(0, 35),
            FlSpot(6, 45),
          ],
          isCurved: true,

          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),


      ],
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
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
                text: ' Progress',
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

import 'package:flutter/material.dart';
import 'package:awesome_circular_chart/awesome_circular_chart.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _Dashboard();
}
  
const progressVal = 0.751;

class _Dashboard extends State<Dashboard> {
    final _controller = ScrollController();
    double get maxHeight => 200 + MediaQuery.of(context).padding.top;
    double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;
    bool isEmpty = false;
    Color cardBgColor = Colors.black;
    final GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey<AnimatedCircularChartState>();
    List<CircularStackEntry> data = <CircularStackEntry>[
    CircularStackEntry(
    <CircularSegmentEntry>[
      CircularSegmentEntry(progressVal, Colors.green, rankKey: 'Q1'),
      CircularSegmentEntry(1-progressVal, Colors.black12, rankKey: 'Q2'),
    ],
    rankKey: 'Quarterly Profits',
  ),
];
  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
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
                (context, index) {
                  if (index == 0 ) {
                  return Column (
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
                            AnimatedCircularChart(
                              key: _chartKey,
                              size: const Size(300.0, 300.0),
                              initialChartData: data,
                              chartType: CircularChartType.Radial,
                              edgeStyle: SegmentEdgeStyle.round,
                              holeLabel: '${progressVal*100}%',
                              labelStyle: TextStyle(color: Colors.green, fontSize: 50,),
                              duration: Duration(milliseconds: 500),
                            ),
                            TextButton(child:Text("Continue exercise", style:TextStyle(fontSize: 14)), onPressed: () {},),
                          ],
                        ),
                      ),
                    ),
        
                  ],  
                );                  
              }
              },
              ),
            )
          ],
        ),
      ),
    
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

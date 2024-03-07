import 'package:flutter/material.dart';


class PrescribedExercises extends StatefulWidget {
  @override
  _SliverAppBarSnapState createState() => _SliverAppBarSnapState();
}

class _SliverAppBarSnapState extends State<PrescribedExercises> {
  final _controller = ScrollController();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;
  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;
  bool isEmpty = false;

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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      
                      Transform.translate(
                        offset: Offset(-10, -10),
                        child: PopupMenuButton(
                          icon: Icon(Icons.more_vert,color: colorScheme.onBackground), // add this line
                          itemBuilder: (_) => <PopupMenuItem<String>>[
                            PopupMenuItem<String>(
                              value: 'report',
                              child: Container(
                                  width: 100,
                                  // height: 30,
                                  child: Text(
                                    "Add exercise",
                                    style: TextStyle(color: colorScheme.onBackground),
                                  )
                              ),
                            ),
                      
                                ],
                                onSelected: (index) async {
                                  switch (index) {
                                    case 'report':
                                    // showDialog(
                                    //     barrierDismissible: true,
                                    //     context: context,
                                    //     builder: (context) => ReportUser(
                                    //       currentUser: widget.sender,
                                    //       seconduser: widget.second,
                                    //     )).then((value) => Navigator.pop(ct))
                      break;
                                  }
                                })
                      ),
                    ],
                  ),
                ),
              ),

            ),
            if (!isEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildCard(index);
                  },
                ),
              )
            else
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    "List is empty",
                    style: TextStyle(
                      color: colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Card _buildCard(int index) {
    var colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: Colors.black12,
      elevation: 4,
      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Text("Item $index", style:TextStyle(color:colorScheme.onBackground)),
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

  const Header({Key? key, required this.maxHeight, required this.minHeight}) : super(key: key);

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
                  ),            ),
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
        margin: EdgeInsets.only(bottom: 10, left: 20),
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
    );
  }
}

// class PrescribedExercises extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     // var theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     var padding = MediaQuery.of(context).padding;
//     double newheight = height - padding.top - padding.bottom;

//     return SafeArea (
//       child: SizedBox(
//         width: width,
//         height: newheight,
//         child: CustomScrollView(
//           slivers: <Widget>[
//             SliverAppBar(
//               pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
            //     title: RichText(
            //       text: TextSpan(
            //         children: <InlineSpan>[
            //           TextSpan(
            //             text: 'Your',
            //             style: TextStyle(
            //               fontWeight: FontWeight.w100,
            //               fontSize: 20
            //             )
            //           ),
            //           TextSpan(
            //             text: ' Exercises',
            //             style: TextStyle(
            //               fontWeight: FontWeight.w600,
            //               fontSize: 20
            //             )
            //           ),
            //         ]
            //       )
            //     ),
            //   ),

            // ),

              
//           ],

//               // child: Column (
//               //   children: [
                
//               //     Padding(
//               //       padding: EdgeInsets.fromLTRB(0, 20, 0, 20),                    
//               //       child: SizedBox(
//               //         // width: double.infinity,
//               //         child: RichText(
//               //           text: TextSpan(
//               //             children: <InlineSpan>[
//               //               TextSpan(
//               //                 text: 'Your',
//               //                 style: TextStyle(
//               //                   fontWeight: FontWeight.w100,
//               //                   fontSize: 30
//               //                 )
//               //               ),
//               //               TextSpan(
//               //                 text: ' Exercises',
//               //                 style: TextStyle(
//               //                   fontWeight: FontWeight.w600,
//               //                   fontSize: 30
//               //                 )
//               //               ),
//               //             ]
//               //           )
//               //         ),
//               //       ),
//               //     ),
        
//               //     Padding( // insert an element
//               //       padding: const EdgeInsets.all(10.0),
//               //       child: Card (
//               //         shape: RoundedRectangleBorder(
//               //           borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
//               //         ),
//               //         clipBehavior: Clip.antiAlias,
//               //         elevation: 5.0,
//               //         child: Image.network(
//               //           'https://carpirehab.files.wordpress.com/2023/12/draft-1.webp',
//               //           width: width,
//               //           // height: 250,
//               //           fit: BoxFit.contain,
//               //         ),
//               //       ),
//               //     ),
        
//               //     Padding( // insert an element
//               //       padding: const EdgeInsets.all(10.0),
//               //       child: Card (
//               //         shape: RoundedRectangleBorder(
//               //           borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
//               //         ),
//               //         clipBehavior: Clip.antiAlias,
//               //         elevation: 5.0,
//               //         child: Image.network(
//               //           'https://carpirehab.files.wordpress.com/2024/02/1000019337.jpg',
//               //           width: width,
//               //           // height: 250,
//               //           fit: BoxFit.contain,
//               //         ),
//               //       ),
//               //     ),
        
//               //     Padding( // insert an element
//               //       padding: const EdgeInsets.all(10.0),
//               //       child: Card (
//               //         shape: RoundedRectangleBorder(
//               //           borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
//               //         ),
//               //         clipBehavior: Clip.antiAlias,
//               //         elevation: 5.0,
//               //         child: Image.network(
//               //           'https://carpirehab.files.wordpress.com/2024/01/image.png',
//               //           width: width,
//               //           // height: 250,
//               //           fit: BoxFit.contain,
//               //         ),
//               //       ),
//               //     ),
        
      
//               //   ],
//               // ),
//             ),
//       ),
//     );
//   }
// }   

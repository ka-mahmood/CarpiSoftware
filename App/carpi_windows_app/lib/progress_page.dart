import 'package:flutter/material.dart';

class Progress extends StatelessWidget {

    @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
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
                        'https://carpirehab.files.wordpress.com/2023/12/image-5.png?w=2000&h=',
                        width: width,
                        // height: 250,
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

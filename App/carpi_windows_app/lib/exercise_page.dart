import 'package:flutter/material.dart';

class PrescribedExercises extends StatelessWidget {

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
                        'https://carpirehab.files.wordpress.com/2024/01/image.png',
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

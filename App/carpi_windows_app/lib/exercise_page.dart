import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// List<ExerciseCardModel> _cardModelList = []; // make a global variable
List<ExerciseCardModel> _cardModelList = [];

class PrescribedExercises extends StatefulWidget {
  @override
  _PrescribedExercises createState() => _PrescribedExercises();
}

class _PrescribedExercises extends State<PrescribedExercises> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _controller = ScrollController();
  double get maxHeight => 200 + MediaQuery.of(context).padding.top;
  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;
  bool isEmpty = false;
  Color cardBgColor = Colors.black;

  Future<void> readCardsIn() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      List<String>? decodedCardString = prefs.getStringList("cards");
      List<ExerciseCardModel> decodedCards = 
                    decodedCardString!.map((card)
                    => ExerciseCardModel.fromJson(json.decode(card))).toList();
      _cardModelList = decodedCards;
    });
  }
  
  Future<void> writeCards() async {
    final SharedPreferences prefs = await _prefs;

    setState(() async {
      List<String> encodedCards = _cardModelList.map((card)=>json.encode(card.toJson())).toList();
      prefs.setStringList("cards", encodedCards);

      await prefs.setStringList('cards', encodedCards);
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    readCardsIn();
    // _cardList.add(addExercise(context, "test", "test desc"));

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    
                    Transform.translate(
                      offset: Offset(-10, -10),
                      child: PopupMenuButton(
                        icon: Icon(Icons.more_vert,color: colorScheme.onBackground), // add this line
                        itemBuilder: (_) => <PopupMenuItem<String>>[

                          PopupMenuItem<String>(
                            value: 'add routine',
                            child: SizedBox(
                                width: 100,
                                // height: 30,
                                child: Text(
                                  "Add routine",
                                  style: TextStyle(color: colorScheme.onBackground),
                                )
                            ),
                          ),
                        ],

                        onSelected: (index) async {
                          switch (index) {
                            case 'add routine':    
                              showDataAlert(context);   
                          }
                        })
                    ),
                  ],
                ),
              ),

            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < _cardModelList.length) {
                    return makeExerciseCardModel(_cardModelList[index], context);
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

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset =
          _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _controller.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }

  Widget makeExerciseCardModel (ExerciseCardModel cardModel, BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.background,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.play_arrow),
              color: Colors.green,
              splashColor: Colors.black12,
              onPressed: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) => RunExercisePage(exercise: cardModel)));

                // run the routine
              },
              ),
            title: Text(cardModel.exerciseName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 0, 20.0),
            child: Text(
              ("Sets: ${cardModel.sets}"),
              style: TextStyle(color: colorScheme.onBackground),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 0, 20.0),
            child: Text(
              ("Reps: ${cardModel.reps}"),
              style: TextStyle(color: colorScheme.onBackground),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 0, 20.0),
            child: Text(
              cardModel.description,
              style: TextStyle(color: colorScheme.onBackground),
            )
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  _cardModelList.remove(cardModel);
                  setState(() {}); 
                },
              ),
              
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDataAlert(context, 
                  index: _cardModelList.indexOf(cardModel),
                  reps: cardModel.reps, 
                  sets: cardModel.sets, 
                  exerciseName: cardModel.exerciseName, 
                  duration: cardModel.duration, 
                  description: cardModel.description);
                },
              ),
            ],
          ),
      
        ],
      
      )
    );
  }

  showDataAlert(BuildContext context, {
    int index = 0,
    int reps = 0,
    int sets = 0,
    String exerciseName = "",
    int duration = 0,
    String description = "",
    String promptText = "Add a custom exercise", 
  }
  
  ) async {

    bool editing = false;
    if (exerciseName != "") {
      editing = true;
      promptText = "Edit exercise";
    }

    var colorScheme = Theme.of(context).colorScheme; 

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 10.0,
            ),

            title: Text(
              promptText,
              style: TextStyle(fontSize: 24.0, color: colorScheme.onBackground),
            ),
            content: Container(
              height: 400,
              width: 500,
              color: Colors.black12,
              child: SingleChildScrollView(

                padding: const EdgeInsets.all(8.0),
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      
                      child: TextFormField(
                        style: TextStyle(color: colorScheme.onBackground),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter exercise name',
                            labelText: 'Exercise name'),
                        initialValue: exerciseName,
                        onChanged: (value) { exerciseName = value; },
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: TextStyle(color: colorScheme.onBackground),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Sets',
                            labelText: 'Sets'),
                        initialValue: sets.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                        onChanged: (value) { sets = int.parse(value); },
                      ),
                    ),
                    
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Repetitions',
                            labelText: 'Reps',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                        style: TextStyle(color: colorScheme.onBackground),
                        initialValue: reps.toString(),
                        onChanged: (value) { reps = int.parse(value); },
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Duration',
                            labelText: 'Time',
                            suffixText: "seconds",
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                        style: TextStyle(color: colorScheme.onBackground),
                        initialValue: duration.toString(),
                        onChanged: (value) { duration = int.parse(value); },
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Description',
                            labelText: 'Description',
                        ),
                        style: TextStyle(color: colorScheme.onBackground),
                        initialValue: description,
                        maxLines: 5,
                        onChanged: (value) { description = value; },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: const Text("Cancel", style:TextStyle(color:Colors.red)),
                            onPressed: () {Navigator.of(context).pop();},
                          ),
                          
                          ElevatedButton(
                            child: const Text("Submit"),
                            onPressed: () {
                              if (!editing) {
                                _cardModelList.add(ExerciseCardModel(exerciseName: exerciseName, 
                                                                      description: description, 
                                                                      reps: reps, 
                                                                      sets: sets, 
                                                                      duration: duration, 
                                                                      weight: 0, 
                                                                      videoLink: ""));  
                              } else if (index < _cardModelList.length) {
                                _cardModelList[index].exerciseName = exerciseName;
                                _cardModelList[index].description = description;
                                _cardModelList[index].reps = reps;
                                _cardModelList[index].sets = sets;
                                _cardModelList[index].duration = duration;
                              }
                              writeCards();
                              setState(() {}); 
                              Navigator.of(context).pop(); 
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
                text: ' Routines',
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

class RunExercisePage extends StatelessWidget {
  // run the exercises - this will be the 'workout' screen
  final ExerciseCardModel exercise;
  RunExercisePage({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(exercise.exerciseName, style: TextStyle(fontSize: 16)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),

          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'This is the home page',
              style: TextStyle(fontSize: 24),
            ),
            IconButton(
              icon: Icon(Icons.notification_add),
              onPressed: () {

                //vibrate
                Clipboard.setData(ClipboardData(text: ''));
                HapticFeedback.lightImpact();
                // send notification

              },
            ),
          ],
        ),
      ),
    );
  }
}

// alert/show dialogue function for adding custom exercise
class ExerciseCardModel {

  // the variables
  String exerciseName, description, videoLink;
  int reps, sets, duration, weight;

  
  ExerciseCardModel({required this.exerciseName, required this.description,
                    required this.reps, required this.sets, required this.duration, 
                    required this.weight, required this.videoLink});

  factory ExerciseCardModel.fromJson(Map<String, dynamic> jsonData) {
    return ExerciseCardModel(
      exerciseName: jsonData['name'],
      description: jsonData['description'],
      videoLink: jsonData['link'],
      sets: jsonData['sets'],
      reps: jsonData['reps'],
      duration: jsonData['duration'],
      weight: jsonData['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
    'name': exerciseName,
    'description': description,
    'link': videoLink,

    'reps': reps,
    'sets': sets,
    'duration': duration,
    'weight': weight,
    };
  }

  

}
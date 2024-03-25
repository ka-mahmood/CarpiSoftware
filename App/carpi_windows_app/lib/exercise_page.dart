import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reorderables/reorderables.dart';

List<ExerciseCardModel> _cardModelList = [
  ExerciseCardModel(exerciseName: "Wrist Flexion", 
    description: "This exercise will help with moving your hand towards your forearm. Do this with weights, as tolerated.", 
    reps: 12, 
    sets: 3, 
    duration: 11, 
    weight: 0, 
    videoLink: "rDqYtzYE-n8",
    completed: false),
    ExerciseCardModel(exerciseName: "Wrist Extension", 
      description: "This exercise will help with moving your hand away from your forearm. Do this with weights, as tolerated.", 
      reps: 8, 
      sets: 3, 
      duration: 5, 
      weight: 0, 
      videoLink: "6TtkRqPjmsg",
      completed: false),
    ExerciseCardModel(exerciseName: "Radial deviation", 
      description: "This exercise will help with moving your hand side to side. Keep your palm open and rotate your hand towards you.", 
      reps: 10, 
      sets: 2, 
      duration: 10, 
      weight: 0, 
      videoLink: "",
      completed: false),
    ExerciseCardModel(exerciseName: "Ulnar deviation", 
      description: "This exercise will help with moving your hand side to side. Keep your palm open and rotate your hand away from you.", 
      reps: 10, 
      sets: 2, 
      duration: 10, 
      weight: 0, 
      videoLink: "",
      completed: false),
    ExerciseCardModel(exerciseName: "Supination", 
      description: "Rotate your arm along the elbow so that your palm faces up.", 
      reps: 5, 
      sets: 3, 
      duration: 20, 
      weight: 0, 
      videoLink: "",
      completed: false),
    ExerciseCardModel(exerciseName: "Pronation", 
      description: "Rotate your arm along the elbow so that your palm faces up.", 
      reps: 5, 
      sets: 3, 
      duration: 30, 
      weight: 0, 
      videoLink: "",
      completed: false),
    ExerciseCardModel(exerciseName: "Fingers flexion", 
      description: "Move your fingers towards your palm.", 
      reps: 10, 
      sets: 2, 
      duration: 10, 
      weight: 0, 
      videoLink: "",
      completed: false),
    ExerciseCardModel(exerciseName: "Fingers extension", 
      description: "Move your fingers away from your palm.", 
      reps: 10, 
      sets: 2, 
      duration: 10, 
      weight: 0, 
      videoLink: "",
      completed: false),
    ExerciseCardModel(exerciseName: "Thumb range of motion", 
      description: "Move your thumb towards your palm and hold.", 
      reps: 10, 
      sets: 2, 
      duration: 25, 
      weight: 0, 
      videoLink: "",
      completed: false),
    ExerciseCardModel(exerciseName: "Wrist rolls", 
      description: "Slowly move your wrist in a circle.", 
      reps: 5, 
      sets: 2, 
      duration: 10, 
      weight: 0, 
      videoLink: "",
      completed: false),
  ];

class PrescribedExercises extends StatefulWidget {
  @override
  State<PrescribedExercises> createState() => _PrescribedExercises();
}

class _PrescribedExercises extends State<PrescribedExercises> {

  final _controller = ScrollController();
  double get maxHeight => 200 + MediaQuery.of(context).padding.top;
  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;
  bool isEmpty = false;
  Color cardBgColor = Colors.black;
  bool hideCompleted = true;

  @override
  void initState() {
    // make some pre-build exercises
    readCardsIn();
    writeCards();
    super.initState();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
    ExerciseCardModel row = _cardModelList.removeAt(oldIndex);
    _cardModelList.insert(newIndex, row);
    });
    writeCards();
  }

  @override
  Widget build(BuildContext context) {
    // readCardsIn();
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                                        Transform.translate(
                      offset: Offset(-10, -10),
                      child: IconButton(
                        icon: !hideCompleted? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                        onPressed: () {
                          if (hideCompleted) {
                            setState(() {
                              hideCompleted = false;
                            });
                          } else {
                            setState(() {
                              hideCompleted = true;
                            });
                          }
                        },
                      ),

                    ),
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
                                  "Add exercise",
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

            ReorderableSliverList(
              onReorder: _onReorder,
              delegate: ReorderableSliverChildBuilderDelegate(
              (BuildContext context, int index) => 
              Container(
                  child: hideCompleted? 
                      !_cardModelList[index].completed? 
                        Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: makeExerciseCardModel(_cardModelList[index], context)) : null : 
                        Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: makeExerciseCardModel(_cardModelList[index], context)),
              ),
              childCount: _cardModelList.length,
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

  String getIndex(ExerciseCardModel cardModel) {
    return ((_cardModelList.indexOf(cardModel))+1).toString();
  }

  Widget makeExerciseCardModel (ExerciseCardModel cardModel, BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    TextStyle style = TextStyle(color: !cardModel.completed? colorScheme.onBackground : Colors.grey[600]);
    return Card(
      color: !cardModel.completed? colorScheme.background : Colors.grey[800],
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: !cardModel.completed? Text(
              getIndex(cardModel),
              style: TextStyle(color: Colors.red, fontSize: 20),
              ) : Icon(Icons.check, color: Colors.green,),
            title: Text(cardModel.exerciseName, style: TextStyle(color: !cardModel.completed? colorScheme.onBackground:Colors.grey[600], fontSize: 20, fontWeight: FontWeight.w100)),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 0, 20.0),
            child: Text(
              ("Sets: ${cardModel.sets}"),
              style: style,
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 0, 20.0),
            child: Text(
              ("Reps: ${cardModel.reps}"),
              style: style,
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 0, 20.0),
            child: Text(
              ("Duration: ${cardModel.duration} seconds per rep"),
              style: style,
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 0, 20.0),
            child: Text(
              cardModel.description,
              style: style,
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
                  writeCards();
                  // readCardsIn();
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


              IconButton(
                icon: Icon(cardModel.completed? Icons.close :Icons.check, color: Colors.green,),
                color: Colors.green,
                onPressed: () {
                  var index = _cardModelList.indexOf(cardModel);
                  if (!cardModel.completed) {
                  _cardModelList[index].completed = true;
                    print("changed to completed");
                  } else {
                  _cardModelList[index].completed = false;
                    print("changed to not completed");
                  }
                  writeCards();
                  setState(() {}); 
                },
              ),

            ],
          ),
      
        ],
      
      )
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

  Future<void> writeCards() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedCards = _cardModelList.map((card)=>json.encode(card.toJson())).toList();
    prefs.setStringList('cards', encodedCards);
    await prefs.setStringList('cards', encodedCards);
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
              height: 550,
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
                              if (exerciseName == "") {
                                exerciseName = "Unnamed exercise";
                              }
                              if (!editing) {
                                _cardModelList.add(ExerciseCardModel(exerciseName: exerciseName, 
                                                                      description: description, 
                                                                      reps: reps, 
                                                                      sets: sets, 
                                                                      duration: duration, 
                                                                      weight: 0, 
                                                                      videoLink: "", completed: false));  
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
                text: ' Routine',
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

// alert/show dialogue function for adding custom exercise
class ExerciseCardModel {

  // the variables
  String exerciseName, description, videoLink;
  int reps, sets, duration, weight;
  bool completed;

  
  ExerciseCardModel({required this.exerciseName, required this.description,
                    required this.reps, required this.sets, required this.duration, 
                    required this.weight, required this.videoLink, required this.completed});
  
  factory ExerciseCardModel.fromJson(Map<String, dynamic> jsonData) {
    return ExerciseCardModel(
      exerciseName: jsonData['name'],
      description: jsonData['description'],
      videoLink: jsonData['link'],
      sets: jsonData['sets'],
      reps: jsonData['reps'],
      duration: jsonData['duration'],
      weight: jsonData['weight'],
      completed: jsonData['completed'],
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

    'completed': completed,

    };
  }
}

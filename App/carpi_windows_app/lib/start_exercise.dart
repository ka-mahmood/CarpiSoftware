import 'dart:convert';

import 'package:carpi_windows_app/exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

List<ExerciseCardModel> _cardModelList = [];
List<ExerciseCardModel> _uncompletedCardModelList = [];

class StartExercise extends StatefulWidget {
  StartExercise({super.key});
  @override
  // ignore: no_logic_in_create_state
  State<StartExercise> createState() => _StartExercise();
}

class _StartExercise extends State<StartExercise> with TrayListener {
  // run the exercises - this will be the 'workout' screen
  _StartExercise();

  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  double _duration = 10;
  final CountDownController _cntcontroller = CountDownController();
  final List<String> _ids = [
    '6TtkRqPjmsg',
    'bVicAeQgUWA',
    'Eiqov24BiPA',
    'WCwhor0vCew',
    'ODRv5dQ9MYQ',
    'ODRv5dQ9MYQ',
    'IF7siMxAW_E',
    'IF7siMxAW_E',
    'IF7siMxAW_E',
    'DvRl7ETT5JA',
  ];

    final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];

  @override
  void initState() {
    // make some pre-build exercises
    readCardsIn();
    // setState(() {
      _uncompletedCardModelList = exercisesLeft(_cardModelList);
    // });
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text("Exercise", style: TextStyle(fontSize: 16)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),

        ],
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_uncompletedCardModelList.first.exerciseName, style: TextStyle(fontSize: 30, color: Colors.white),),
              )
            ),
            Card(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                topActions: <Widget>[
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      _controller.metadata.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    onPressed: () {
                      print('Settings Tapped!');
                    },
                  ),
                ],
                onReady: () {
                  _isPlayerReady = true;
                },
                onEnded: (data) {
                  _controller
                      .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
                    ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Next exercise started')));
                    },        
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Sets: 1/" + _uncompletedCardModelList.first.sets.toString(), style: TextStyle(fontSize: 30, color: Colors.white),),
              )
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Reps: 1/" + _uncompletedCardModelList.first.reps.toString(), style: TextStyle(fontSize: 30, color: Colors.white),),
              )
            ),
            // Card(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getCircularCountDownTimer(),
              ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text("Start"),
                onPressed: () =>
                    _cntcontroller.restart(duration: (_duration).round()),
              ),
              const SizedBox(width: 10, height: 100),
              TextButton(
                child: Text("Pause"),
                onPressed: () => _cntcontroller.pause(),
              ),
              const SizedBox(width: 10, height: 100),
              TextButton(
                child: Text("Resume"),
                onPressed: () => _cntcontroller.resume(),
              ),
              const SizedBox(width: 10, height: 100),
              TextButton(
                child: Text("Restart"),
                onPressed: () =>
                    _cntcontroller.restart(duration: (_duration).round()),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
  
  List<ExerciseCardModel> exercisesLeft(List<ExerciseCardModel> inputModel) {
    for (int i = 0; i < inputModel.length; i++) {
      if (inputModel[i].completed == true) {
        inputModel.removeAt(i);
      }
    }
    print(inputModel.length);
    return inputModel;
  }

  List<String> exercisesLeftNames(List<ExerciseCardModel> inputModel) {
    List<String> stringList = List<String>.filled(inputModel.length, "0", growable: true); 
    for (var i; i < inputModel.length; i++) {
      setState(() {
        stringList[i] = inputModel[i].exerciseName;
      });
    }
    return stringList;
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


  CircularCountDownTimer getCircularCountDownTimer() {
    return CircularCountDownTimer(
      duration: (_duration).round(),
      initialDuration: 0,
      controller: _cntcontroller,
      width: MediaQuery.of(context).size.width / 5,
      height: MediaQuery.of(context).size.height / 5,
      ringColor: Colors.grey[700]!,
      ringGradient: null,
      fillColor: Colors.green,
      fillGradient: null,
      backgroundColor: Colors.black54,
      backgroundGradient: null,
      strokeWidth: 20.0,
      strokeCap: StrokeCap.round,
      textStyle: const TextStyle(
        fontSize: 33.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textFormat: CountdownTextFormat.S,
      isReverse: false,
      isReverseAnimation: false,
      isTimerTextShown: true,
      autoStart: false,
      onStart: () {
        debugPrint('Countdown Started');
      },
      onComplete: () {
        debugPrint('Countdown Ended');
      },
    );
  }

}
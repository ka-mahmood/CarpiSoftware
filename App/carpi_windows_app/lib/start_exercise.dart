import 'dart:convert';

import 'package:carpi_windows_app/exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

List<ExerciseCardModel> _cardModelList = [];

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

  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];

  @override
  void initState() {
    // make some pre-build exercises
    readCardsIn();
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
            // Card(
            //   child: YoutubePlayer(
            //     controller: _controller,
            //     showVideoProgressIndicator: true,
            //     progressIndicatorColor: Colors.blueAccent,
            //     topActions: <Widget>[
            //       const SizedBox(width: 8.0),
            //       Expanded(
            //         child: Text(
            //           _controller.metadata.title,
            //           style: const TextStyle(
            //             color: Colors.white,
            //             fontSize: 18.0,
            //           ),
            //           overflow: TextOverflow.ellipsis,
            //           maxLines: 1,
            //         ),
            //       ),
            //       IconButton(
            //         icon: const Icon(
            //           Icons.settings,
            //           color: Colors.white,
            //           size: 25.0,
            //         ),
            //         onPressed: () {
            //           print('Settings Tapped!');
            //         },
            //       ),
            //     ],
            //     onReady: () {
            //       _isPlayerReady = true;
            //     },
            //     onEnded: (data) {
            //       _controller
            //           .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
            //         ScaffoldMessenger.of(context).showSnackBar(
            //               const SnackBar(content: Text('Next video started')));
            //         },        
            //   ),
            // ),
            Text(
              'This is the exercise page',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
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

  Future<void> writeCards() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedCards = _cardModelList.map((card)=>json.encode(card.toJson())).toList();
    prefs.setStringList('cards', encodedCards);
    await prefs.setStringList('cards', encodedCards);
  }


}
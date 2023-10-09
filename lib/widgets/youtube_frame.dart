import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meditation4/carousel.dart';
import 'package:meditation4/widgets/start_stop_fav_section.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../Service/Auth_Service.dart';
import '../SignUpPage.dart';
import '../charts.dart';
import 'video_list_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'meta_data_section.dart';
import 'play_pause_button_bar.dart';
import 'player_state_section.dart';
import 'source_input_section.dart';

class YoutubeAppDemo extends StatefulWidget {
  final String listName;
  const YoutubeAppDemo({required this.listName, super.key});
  // ignore: unnecessary_this

  @override
  // ignore: library_private_types_in_public_api
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  //final Stream<QuerySnapshot<List<String>>> _stream = FirebaseFirestore.instance.collection('VideoList') as Stream<QuerySnapshot<List<String>>>;
  late YoutubePlayerController _controller;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // DatabaseReference ref = FirebaseDatabase.instance.ref("VideoList");
  //final _videoIds = FirebaseDatabase.instance.ref('VideoList/URL').orderByValue();

  final store = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  late bool startButton, endButton;

  //final List<String> _videoIds =
  CollectionReference newCollection =
      FirebaseFirestore.instance.collection('VideoList');
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('VideoList').snapshots();

  @override
  initState() {
    super.initState();
    // developer.log(widget.listName, name: "SEVERE");
    //developer.log("working", name: "Test");
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );
    //  Future<List<String>> playlist = _controller.listName;

    _controller.setFullScreenListener(
      (isFullScreen) {
        //  log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );

    // _controller.playlist()

    // _controller.cuePlaylist(list: _videoIds);

    Future<Null> data;
    List<String> myList = [];

    data = newCollection
        .where('CATEGORY', isEqualTo: widget.listName)
        .get()
        .then((event) {
      for (final doc in event.docs) {
        developer.log('${doc.id}=>${doc.data()}', name: "SEVERE");
        developer.log(doc.get("URL"), name: "FINALLY");
        myList.add(doc.get("URL").toString());
      }
    });
    developer.log(newCollection.doc('URL').toString(), name: "SEVERE");

    _controller.loadPlaylist(
      //list: _videoIds,
      list: myList,
      listType: ListType.playlist,
      startSeconds: 136,
    );
  }

  @override
  build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 27, 40, 62),
            title: const Text('Saira Creations Concentration Videos'),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => const Carousel()),
                    (route) => false)),
            //  actions: const [VideoPlaylistIconButton()],
            actions: [
              IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    //await AuthClass().signOut();

                    //await _auth.signOut();
                    _signOut();

                    // Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const SignUpPage(null)),
                        (route) => false);
                  }),
              IconButton(
                icon: const Icon(Icons.query_stats),
                onPressed: () => {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Charts(
                              listName: widget.listName,
                            )),
                    //(route) => false)
                  )
                },
              ),
            ],
          ),
          /*body: LayoutBuilder(
            builder: (context, constraints) {
              if (kIsWeb && constraints.maxWidth > 750) {
                return Column(
                  //Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          player,
                          StartStopFavBar(),
                          //   const VideoPositionIndicator(),
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    const Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                          //child: Controls(),
                          ),
                    ),
                  ],
                );
              } */
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 27, 40, 62),
                  Color.fromARGB(255, 146, 110, 124)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (kIsWeb && constraints.maxWidth > 750) {
                  return Container(
                    width: screenWidth,
                    height: screenHeight,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Align(
                                alignment: Alignment.center,
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Column(
                                    children: [
                                      player, /*StartStopFavBar()*/
                                    ],
                                  ),
                                )
                                //   const VideoPositionIndicator(),
                                ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Column(children: [
                              const Controls(),
                              const Spacer(),
                              StartStopFavBar(),
                              const Spacer(),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView(
                  children: [
                    player,
                    //  const VideoPositionIndicator(),
                    const Controls(),
                    StartStopFavBar(),
                    const Spacer(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

_signOut() async {
  await FirebaseAuth.instance.signOut();
}

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  StartStopFavBar(visStart, visStop),
        ],
      ),
    );
  }
}

///
class Controls extends StatelessWidget {
  ///
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MetaDataSection(),
          // _space,
          // SourceInputSection(),
          // _space,
          PlayPauseButtonBar(),
          // _space,
          // const VideoPositionSeeker(),
          // _space,
          //PlayerStateSection(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}

///
class VideoPlaylistIconButton extends StatelessWidget {
  ///
  const VideoPlaylistIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    return IconButton(
      onPressed: () async {
        controller.pauseVideo();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VideoListPage(),
          ),
        );
        controller.playVideo();
      },
      icon: const Icon(Icons.playlist_play_sharp),
    );
  }
}

///
class VideoPositionIndicator extends StatelessWidget {
  ///
  const VideoPositionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    return StreamBuilder<YoutubeVideoState>(
      stream: controller.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inMilliseconds ?? 0;
        final duration = controller.metadata.duration.inMilliseconds;

        return LinearProgressIndicator(
          value: duration == 0 ? 0 : position / duration,
          minHeight: 1,
        );
      },
    );
  }
}

///
class VideoPositionSeeker extends StatelessWidget {
  ///
  const VideoPositionSeeker({super.key});

  @override
  Widget build(BuildContext context) {
    var value = 0.0;

    return Row(
      children: [
        const Text(
          'Seek',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: StreamBuilder<YoutubeVideoState>(
            stream: context.ytController.videoStateStream,
            initialData: const YoutubeVideoState(),
            builder: (context, snapshot) {
              final position = snapshot.data?.position.inSeconds ?? 0;
              final duration = context.ytController.metadata.duration.inSeconds;

              value = position == 0 || duration == 0 ? 0 : position / duration;

              return StatefulBuilder(
                builder: (context, setState) {
                  return Slider(
                    value: value,
                    onChanged: (positionFraction) {
                      value = positionFraction;
                      setState(() {});

                      context.ytController.seekTo(
                        seconds: (value * duration).toDouble(),
                        allowSeekAhead: true,
                      );
                    },
                    min: 0,
                    max: 1,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

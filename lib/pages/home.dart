import 'package:flutter/material.dart';
import 'package:ovrsr/pages/video_select.dart';
import 'package:ovrsr/utils/apptheme.dart';
import 'package:ovrsr/widgets/main_drawer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _videoId; // Default video ID = 'vFJ8cWhbTGA'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Home'),
          ],
        ),
        actions: [
          Image.asset(
            'assets/images/Logo_Light.png',
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: SizedBox(
          height: 1000,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    PlayerWidget(
                        videoId: _videoId), // Pass videoId to PlayerWidget
                    const Divider(),
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(0, 128, 109, 0),
                        foregroundColor: AppTheme.light,
                      ),
                      onPressed: () async {
                        // Navigate to VideoSelectPage and await result
                        final result = await Navigator.of(context).push<String>(
                          MaterialPageRoute(
                            builder: (context) => const VideoSelectPage(),
                          ),
                        );
                        // Update _videoId with the returned video ID
                        if (result != null) {
                          setState(() {
                            _videoId = result;
                          });
                        }
                      },
                      child: const Text('Video Select'),
                    ),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(0, 128, 109, 0),
                          foregroundColor: AppTheme.light,
                        ),
                        onPressed: () async {
                          // Navigate to VideoSelectPage and await result
                          final result =
                              await Navigator.of(context).push<String>(
                            MaterialPageRoute(
                              builder: (context) => const VideoSelectPage(),
                            ),
                          );
                          // Update _videoId with the returned video ID
                          if (result != null) {
                            setState(() {
                              _videoId = result;
                            });
                          }
                        },
                        child: const Text('Video Select'),
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(child: PlayerWidget(videoId: _videoId)),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class PlayerWidget extends StatelessWidget {
  final String? videoId; // Receive videoId as a parameter

  const PlayerWidget({Key? key, this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (videoId == null) {
      return YoutubePlayer(
        key: UniqueKey(), // Add a UniqueKey here
        controller: YoutubePlayerController.fromVideoId(
          videoId: 'B4-L2nfGcuE',
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
          ),
        ),
        aspectRatio: 16 / 9,
      );
    }
    return YoutubePlayer(
      key: UniqueKey(), // Add a UniqueKey here
      controller: YoutubePlayerController.fromVideoId(
        videoId: videoId!,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      ),
      aspectRatio: 16 / 9,
    );
  }
}

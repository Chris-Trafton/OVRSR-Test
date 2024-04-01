import 'package:flutter/material.dart';
import 'package:ovrsr/utils/apptheme.dart';
import 'package:ovrsr/widgets/main_drawer.dart';

class VideoSelectPage extends StatefulWidget {
  const VideoSelectPage({Key? key}) : super(key: key);

  @override
  State<VideoSelectPage> createState() => _VideoSelectPageState();
}

class _VideoSelectPageState extends State<VideoSelectPage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Video Select'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Enter Video ID',
                      ),
                      style: const TextStyle(
                          color: AppTheme.light,
                          decoration: TextDecoration.underline,
                          decorationColor: AppTheme.light)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(0, 128, 109, 0),
                foregroundColor: AppTheme.light,
              ),
              onPressed: () {
                // Retrieve the video ID entered by the user
                String videoId = _controller.text.trim();
                // Pass the video ID back to the previous screen
                Navigator.pop(context, videoId);
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}

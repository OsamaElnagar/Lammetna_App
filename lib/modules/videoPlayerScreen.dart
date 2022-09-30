import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../shared/bloc/AppCubit/cubit.dart';


class VideoPlayerScreen extends StatefulWidget {


  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  VideoPlayerController? _controller2;
  late Future<void> _initializeVideoPlayerFuture;
  File? videoFile;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    _controller2!.dispose();

    super.dispose();
  }

  getVideo() async {
    XFile? video = await ImagePicker().pickVideo(
      source: ImageSource.camera,
    );
    videoFile = File(video!.path);
    if (video != null) {
      setState(() {
        _controller2 = VideoPlayerController.file(File(video.path))
          ..initialize();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // FutureBuilder(
            //   future: _initializeVideoPlayerFuture,
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       // If the VideoPlayerController has finished initialization, use
            //       // the data it provides to limit the aspect ratio of the video.
            //       return AspectRatio(
            //         aspectRatio: _controller.value.aspectRatio,
            //         // Use the VideoPlayer widget to display the video.
            //         child: Stack(
            //           alignment: Alignment.center,
            //           children: [
            //             VideoPlayer(_controller),
            //             CircleAvatar(
            //              child:  FloatingActionButton(
            //                onPressed: () {
            //                  AppCubit.get(context).playPauseVideo(_controller);
            //                },
            //                // Display the correct icon depending on the state of the player.
            //                child: Icon(
            //                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            //                ),
            //              ),
            //             ),
            //           ],
            //         ),
            //       );
            //     } else {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //   },
            // ),
            // const SizedBox(
            //   height: 5,
            // ),
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (_controller2 != null) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller2!.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(_controller2!),
                        Opacity(
                          opacity: .6,
                          child: CircleAvatar(
                            child: FloatingActionButton(
                              onPressed: () {
                                AppCubit.get(context)
                                    .playPauseVideo(_controller2!);
                              },
                              // Display the correct icon depending on the state of the player.
                              child: Icon(
                                _controller2!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getVideo();
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

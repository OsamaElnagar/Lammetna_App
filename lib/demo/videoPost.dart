import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  final File? videoFile;
  final String videoLink;

  const VideoPost({Key? key, this.videoFile, required this.videoLink})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.contentUri(Uri.parse(widget.videoLink));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: false,
      looping: false,
      // routePageBuilder: (BuildContext context, Animation<double> animation,
      //     Animation<double> secondAnimation, provider) {
      //   return AnimatedBuilder(
      //     animation: animation,
      //     builder: (BuildContext context, Widget? child) {
      //       return VideoScaffold(
      //         child: Container(
      //           alignment: Alignment.center,
      //           color: Colors.black,
      //           padding: const EdgeInsets.all(8.0),
      //           child: provider,
      //         ),
      //       );
      //     },
      //   );
      // },
      // Try playing around with some of these other options:
      showControls: true,
      errorBuilder: (context, errorMessage) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.6),
          ),
          child: Text(
            errorMessage,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blue,
        handleColor: Colors.yellow,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.black.withOpacity(.4),
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _videoPlayerController.value.aspectRatio,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}

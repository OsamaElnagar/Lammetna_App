import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:social_app/shared/bloc/AppCubit/cubit.dart';
import 'package:social_app/shared/components/buildVideoScaffold.dart';
import 'package:video_player/video_player.dart';

class ChewieDemo extends StatefulWidget {
  final File? videoFile;
  final String videoLink;

  const ChewieDemo({Key? key, this.videoFile, required this.videoLink})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChewieDemoState();
}

class _ChewieDemoState extends State<ChewieDemo> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.videoFile != null) {
      _videoPlayerController =
          VideoPlayerController.file(AppCubit.get(context).postVideoFile!);
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          autoPlay: false,
          looping: false,
          routePageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondAnimation, provider) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return VideoScaffold(
                  child: Scaffold(
                    body: Container(
                      alignment: Alignment.center,
                      color: Colors.black,
                      child: provider,
                    ),
                  ),
                );
              },
            );
          }
          // Try playing around with some of these other options:

          // showControls: false,
          // materialProgressColors: ChewieProgressColors(
          //   playedColor: Colors.red,
          //   handleColor: Colors.blue,
          //   backgroundColor: Colors.grey,
          //   bufferedColor: Colors.lightGreen,
          // ),
          // placeholder: Container(
          //   color: Colors.grey,
          // ),
          // autoInitialize: true,
          );
    } else {
      _videoPlayerController =
          VideoPlayerController.contentUri(Uri.parse(widget.videoLink));
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: true,
        looping: false,
        routePageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondAnimation, provider) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return VideoScaffold(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  padding: const EdgeInsets.all(8.0),
                  child: provider,
                ),
              );
            },
          );
        },
        // Try playing around with some of these other options:
        showControls: true,
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
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Chewie(
              controller: _chewieController,
            ),
          ),
          // MaterialButton(
          //   elevation: 0,
          //   color: Colors.blue,
          //   onPressed: () {
          //
          //     _chewieController.enterFullScreen();
          //   },
          //   child: const Text('Fullscreen'),
          // ),
        ],
      ),
    );
  }
}

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieCard extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  ChewieCard({
    @required this.videoPlayerController,
    this.looping,
    Key key,
  }) : super(key: key);

  @override
  _ChewieCardState createState() => _ChewieCardState();
}

class _ChewieCardState extends State<ChewieCard> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      showControls: false,
      showControlsOnInitialize: false,
      autoInitialize: true,
      looping: widget.looping,
      autoPlay: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Icon(Icons.error_outline, color: Colors.white,),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
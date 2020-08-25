import 'package:flutter/material.dart';

class FullImage extends StatefulWidget {
  final String imageLink;
  FullImage({@required this.imageLink});
  @override
  _FullImageState createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image.network(
          widget.imageLink,
          alignment: Alignment.center,
          fit: BoxFit.fill,
          errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
            return Icon(Icons.error_outline, color: Colors.white,);
          },
        ),
      ),
    );
  }
}

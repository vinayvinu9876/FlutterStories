import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stories/chewiecard.dart';
import 'package:stories/fullscreenimage.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Stories'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool initialised = false;
  void initialiseApp()async{
    await Firebase.initializeApp().whenComplete(() => setState((){
      initialised = true;
    }));
  }

  @override
  void initState() {
    initialiseApp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Container(
          child: initialised?StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Stories').snapshots(),
              builder: (context, snapshot) {
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                    color: Colors.transparent,
                    child: Center(
                      child: (snapshot.data.docs[index].get('image') == 1)
                      // if it's equal to 1 than it's an image if it's equal to 2 than it's a video
                          ? Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => FullImage(imageLink: snapshot.data.docs[index].get('link'),),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      var begin = Offset(0.0, 1.0);
                                      var end = Offset.zero;
                                      var curve = Curves.ease;

                                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                 );
                                },
                                child: Image.network(
                                    snapshot.data.docs[index].get('link'),
                                    alignment: Alignment.center,
                                    fit: BoxFit.fill,
                                    errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                      return Icon(Icons.error_outline, color: Colors.white,);
                                    },
                                  ),
                              ),
                            ),
                          )
                          : ChewieCard(
                              videoPlayerController:
                                  VideoPlayerController.network(snapshot.data.docs[index].get('link')),
                              looping: true,
                            ),
                    ),
                  ),
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(2, index.isEven ? 2 : 1),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                );
              }):Container(),
        ),
      ),
    );
  }
}

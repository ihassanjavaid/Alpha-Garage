import 'package:alphagarage/components/speedDialButton.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


// ignore: must_be_immutable
class ImageView extends StatefulWidget {

  String imageRef;

  ImageView(imageReference){
    this.imageRef = imageReference;
  }

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown,
        ),
        backgroundColor: Colors.white,
        title: AutoSizeText(
          'Foto',
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: kAppBarTextStyle,
        ),
        centerTitle: false,
      ),
      body: Center(
        child:  PhotoView(
          imageProvider: NetworkImage(widget.imageRef),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: 4.0,
        ),
      ),
      floatingActionButton: SpeedDialButton().showUserSpeedDial(context),
    );
  }
}



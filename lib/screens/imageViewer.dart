import 'package:alphagarage/components/speedDialButton.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:zoomable_image/zoomable_image.dart';

const String imageRef = '';

class ImageView extends StatefulWidget {

  ImageView({imageReference: imageRef});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    print("IMAGE REFF");
    print(imageRef);
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
        child: Container(
          child: ZoomableImage(
            NetworkImage(imageRef),
          ),
        ),
      ),
      floatingActionButton: SpeedDialButton().showUserSpeedDial(context),
    );
  }
}

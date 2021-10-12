import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_video_picker/video_widget.dart';
import 'package:video_player/video_player.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int lastTap = 0;
  int consecutiveTaps = 0;
  List<XFile>? _imageFileList;
  XFile? _videoFile;
  int index = 0;
  bool _show = false;
  bool isVideo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Video Picker'),
      ),
      body: GestureDetector(
        onTap: () async {
          int now = DateTime.now().millisecondsSinceEpoch;
          if (now - lastTap < 1000) {
            consecutiveTaps++;
            if (consecutiveTaps == 3) {
              try {
                final ImagePicker _picker = ImagePicker();
                final pickedFileList = await _picker.pickMultiImage();
                final video =
                    await _picker.pickVideo(source: ImageSource.gallery);
                setState(() {
                  _imageFileList = pickedFileList;
                  _videoFile = video;
                  _show = true;
                });
                print('Length: ${_imageFileList!.length}');
              } catch (e) {
                print(e.toString());
              }
            }
          } else {
            consecutiveTaps = 0;
          }
          lastTap = now;
        },
        child: Center(
          child: Container(
            width: double.infinity,
            height: 200,
            color: Colors.green,
            alignment: Alignment.center,
            child: (_show)
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        if (index == 0) {
                          index = 1;
                        } else {
                          if (_imageFileList!.length == 2) index = 0;
                        }
                      });
                      print(index);
                    },
                    onDoubleTap: () {
                      setState(() {
                        isVideo = !isVideo;
                      });
                    },
                    child: (isVideo)
                        ? VideoWidget(path: _videoFile!.path)
                        : Image.file(
                            File(_imageFileList![index].path),
                            fit: BoxFit.cover,
                          ),
                  )
                : const Icon(Icons.attachment_sharp),
          ),
        ),
      ),
    );
  }
}

// https://stackoverflow.com/questions/60658738/how-to-create-triple-click-button-in-flutter
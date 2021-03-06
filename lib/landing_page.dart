import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_video_picker/video_widget.dart';
import 'package:file_picker/src/file_picker_io.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  int lastTap = 0;
  int consecutiveTaps = 0;
  int index = 0;
  List<PlatformFile> _files = <PlatformFile>[];
  bool isVideo = false;
  @override
  Widget build(BuildContext context) {
    void _onTap() async {
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - lastTap < 1000) {
        consecutiveTaps++;
        if (consecutiveTaps == 2) {
          final FilePickerResult? _result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.custom,
            allowedExtensions: ['jpeg', 'jpg', 'mp4', 'mov'],
          );
          if (_result == null) {
            setState(() {});
            return;
          }
          _files.clear();
          _files = _result.files;
        }
      } else {
        consecutiveTaps = 0;
        if (_files.isNotEmpty) {
          index++;
          if (index == _files.length) {
            setState(() {
              index = 0;
            });
            // return;
          }
        }
      }
      lastTap = now;
      setState(() {});
    }

    return GestureDetector(
      onTap: _onTap,
      child: Scaffold(
        body: Center(
          child: (_files.isNotEmpty)
              ? (_files[index].extension == 'jpeg' ||
                      _files[index].extension == 'jpg')
                  ? Image.file(
                      File(_files[index].path!),
                      fit: BoxFit.cover,
                    )
                  : (_files[index].extension == 'mp4' ||
                          _files[index].extension == 'mov')
                      ? VideoWidget(
                          onDoubleTap: _onTap,
                          path: File(_files[index].path!),
                        )
                      : const Text('Invalid File Selected')
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'Welcome',
                      style:
                          TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tap anywhere Three time to select files',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// https://stackoverflow.com/questions/60658738/how-to-create-triple-click-button-in-flutter
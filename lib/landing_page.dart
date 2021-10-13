import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_video_picker/video_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int lastTap = 0;
  int consecutiveTaps = 0;
  int index = 0;
  List<PlatformFile> _files = <PlatformFile>[];
  bool isVideo = false;
  @override
  Widget build(BuildContext context) {
    void _onTap() {
      index++;
      if (index == _files.length) {
        index = 0;
        return;
      }
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Video Picker'),
      ),
      body: GestureDetector(
        onTap: () async {
          int now = DateTime.now().millisecondsSinceEpoch;
          if (now - lastTap < 1000) {
            consecutiveTaps++;
            if (consecutiveTaps == 2) {
              final FilePickerResult? _result =
                  await FilePicker.platform.pickFiles(
                allowMultiple: true,
                // type: FileType.any,
                // allowedExtensions: ['.jpeg', '.jpg', '.mp4', '.mov'],
              );
              if (_result == null) return;
              _files = _result.files;
              setState(() {});
              _files.forEach((element) {
                print(element.extension);
              });
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
            child: (_files.isNotEmpty)
                ? (_files[index].extension == '.jpeg' ||
                        _files[index].extension == '.jpg')
                    ? GestureDetector(
                        onTap: _onTap,
                        child: Image.file(
                          File(_files[index].path!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : (_files[index].extension == '.mp4' ||
                            _files[index].extension == '.mov')
                        ? GestureDetector(
                            onDoubleTap: _onTap,
                            child: VideoWidget(path: File(_files[index].path!)),
                          )
                        : GestureDetector(
                            onTap: _onTap,
                            child: const Text('Invalid File Selected'),
                          )
                : const Icon(Icons.attachment_sharp),
          ),
        ),
      ),
    );
  }
}

// https://stackoverflow.com/questions/60658738/how-to-create-triple-click-button-in-flutter
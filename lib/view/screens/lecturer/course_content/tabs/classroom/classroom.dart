import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/services%20and%20providers/messagestream.dart';
import 'package:path/path.dart';

final _firestore = FirebaseFirestore.instance;
User loggedinuser;
final _auth = FirebaseAuth.instance;
MessagesStream messageStream;
UploadTask uploadTask;
File file;
String pdf;
String path;
File audioFile;
String _filePath;

bool _isPlaying;
bool _isUploading;
bool _isRecorded;
bool _isRecording;



FlutterAudioRecorder _audioRecorder;

class LecturerClassroom extends StatefulWidget {
  @override
  _LecturerClassroomState createState() => _LecturerClassroomState();
}

class _LecturerClassroomState extends State<LecturerClassroom> {
  final messageTextController = TextEditingController();

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future uploadFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('imageURL/${basename(file.path)}}');
    uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() async {
      firebaseDownloadUrl = await storageReference.getDownloadURL();
    });
    print(firebaseDownloadUrl);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    path = result.files.single.path;
    setState(() => file = File(path));
    print(path);
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
   
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _onFileUploadButtonPressed() async {
      setState(() {
        _isUploading = true;
      });
      try {
        Reference storageReference = FirebaseStorage.instance.ref().child(
            _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length));
        UploadTask task = storageReference.putFile(File(_filePath));
        await task.whenComplete(() async {
          recordingURL = await storageReference.getDownloadURL();
        });
        print(recordingURL);
      } catch (error) {
        print('Error occured while uplaoding to Firebase ${error.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occured while uplaoding'),
          ),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }

    void _onRecordAgainButtonPressed() {
      setState(() {
        _isRecorded = false;
      });
    }

    // void _onPlayButtonPressed() async {
    //   if (!_isPlaying) {
    //     _isPlaying = true;
    //     _audioPlayer.play();
    //     _audioPlayer.fullPlaybackStateStream.listen((duration) {
    //       setState(() {
    //         _isPlaying = false;
    //       });
    //     });
    //   } else {
    //     _audioPlayer.pause();
    //     _isPlaying = false;
    //   }
    //   setState(() {});
    // }

    Future<void> _startRecording() async {
      final bool hasRecordingPermission =
          await FlutterAudioRecorder.hasPermissions;
      if (hasRecordingPermission) {
        Directory directory = await getApplicationDocumentsDirectory();
        String filepath = directory.path +
            '/' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.aac';
        _audioRecorder =
            FlutterAudioRecorder(filepath, audioFormat: AudioFormat.AAC);
        await _audioRecorder.initialized;
        _audioRecorder.start();
        _filePath = filepath;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(
            child: Text('Please enable recording permission'),
          ),
        ));
      }
    }

    Future<void> _onRecordButtonPressed() async {
      if (_isRecording) {
        _audioRecorder.stop();
        _isRecording = false;
        _isRecorded = true;
      } else {
        _isRecorded = false;
        _isRecording = true;
        await _startRecording();
      }
      setState(() {});
    }

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          body: Stack(
            children: [
              Image.asset(
                "assets/images/schoolbg.png",
                fit: BoxFit.fitHeight,
                color: Colors.white.withOpacity(0.8),
                colorBlendMode: BlendMode.screen,
                height: double.infinity,
              ),
              Column(
                children: <Widget>[
                  MessagesStream(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                await selectFile().whenComplete(() async {
                                  await uploadFile();
                                });
                                await _firestore.collection("Messages").add({
                                  "sender": loggedinuser.displayName,
                                  "imageURL": firebaseDownloadUrl,
                                  "timestamp": FieldValue.serverTimestamp()
                                });
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                              controller: messageTextController,
                              onChanged: (value) {
                                chattext = value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          _isRecorded
                              ? _isUploading
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.upload_file),
                                            onPressed: () async {
                                              await _onFileUploadButtonPressed();
                                              await _firestore
                                                  .collection("Messages")
                                                  .add({
                                                "sender":
                                                    loggedinuser.displayName,
                                                "audioURL": recordingURL,
                                                "timestamp":
                                                    FieldValue.serverTimestamp()
                                              });
                                            }),
                                      ],
                                    )
                              : IconButton(
                                  icon: _isRecording
                                      ? Icon(Icons.pause)
                                      : Icon(Icons.fiber_manual_record),
                                  onPressed: _onRecordButtonPressed,
                                ),
                          FloatingActionButton(
                            onPressed: () {
                              messageTextController.clear();
                              _firestore.collection("Messages").add({
                                "sender": loggedinuser.displayName,
                                "text": chattext,
                                "timestamp": FieldValue.serverTimestamp(),
                              });
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                            backgroundColor: Colors.orange,
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

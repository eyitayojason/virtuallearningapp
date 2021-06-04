import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/services%20and%20providers/model.dart';
import 'package:path/path.dart';

class Authentication with ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  String uemail;
  User loggedinuser;
  UploadTask uploadTask;
  File file;
  String url;
  String pdf;
  String videopath;
  String imagepath;
  bool isPressed = false;
  FireUser _userFromFirebaseUser(User user) {
    return user != null ? FireUser(user.uid) : null;
  }

  Future signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      loggedinuser = userCredential.user;

      return _userFromFirebaseUser(loggedinuser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpwithEmailandPassword(
      String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      await userCredential.user.updateProfile(displayName: displayName);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future uploadImageFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('imageURL/${basename(file.path)}}');
    uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() async {
      firebaseDownloadUrl = await storageReference.getDownloadURL();
    });
    print(firebaseDownloadUrl);
  }

  Future selectImageFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["jpg, jpeg, png"]);
    if (result == null) return;
    imagepath = result.files.single.path;
    file = File(imagepath);
  }

  Future uploadVideoFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('videoURL/${basename(file.path)}}');
    uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() async {
      firebasevideoURL = await storageReference.getDownloadURL();
    });
    print(firebasevideoURL);
  }

  Future selectVideoFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["mp4"]);
    if (result == null) return;
    videopath = result.files.single.path;
    file = File(videopath);
  }

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

  void playpauseicon() {
    isPressed = !isPressed;
  }

  void onPlayButtonPressed({@required String audio}) {
    // if (!isPlaying) {
    //   isPlaying = true;
    //   audioPlayer.play(
    //     audio,
    //   );
    //   audioPlayer.onPlayerCompletion.listen((duration) {
    //     isPlaying = false;
    //   });
    // } else {
    //   audioPlayer.stop();
    //   isPlaying = false;
    // }
  }

  Future<void> onFileUploadButtonPressed({
    BuildContext context,
  }) async {
    isUploading = true;

    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(
          filePath.substring(filePath.lastIndexOf('/'), filePath.length));
      UploadTask task = storageReference.putFile(File(filePath));
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
    }
    {
      isUploading = false;
      notifyListeners();
    }
  }

  Future<void> onRecordButtonPressed() async {
    if (isRecording) {
      audioRecorder.stop();
      isRecording = false;
      isRecorded = true;
    } else {
      isRecorded = false;
      isRecording = true;
      await _startRecording(recorder: audioRecorder);
    }
    notifyListeners();
  }

  Future<void> _startRecording(
      {FlutterAudioRecorder recorder, BuildContext context}) async {
    final bool hasRecordingPermission =
        await FlutterAudioRecorder.hasPermissions;
    if (hasRecordingPermission) {
      Directory directory = await getApplicationDocumentsDirectory();
      String fpath = directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac';
      audioRecorder = FlutterAudioRecorder(fpath, audioFormat: AudioFormat.AAC);
      await audioRecorder.initialized;
      audioRecorder.start();
      filePath = fpath;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
          child: Text('Please enable recording permission'),
        ),
      ));
    }
    notifyListeners();
  }

  Future selectContentFile() async {
    // ignore: unused_local_variable
    String contentpath;
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ["pdf", "doc", "docx"]);
    if (result == null) return;
    contentpath = result.files.single.path;
    file = File(contentpath);

    print(contentpath);
  }

  Future uploadContent() async {
    UploadTask _uploadTask;
    Reference storageReference =
        FirebaseStorage.instance.ref().child('fileURL/${basename(file.path)}}');
    _uploadTask = storageReference.putFile(file);
    await _uploadTask.whenComplete(() async {
      contentDownloadUrl = await storageReference.getDownloadURL();
    });
  }
}

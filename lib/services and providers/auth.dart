import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtuallearningapp/Models/NewsModel.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:path/path.dart';
import 'package:virtuallearningapp/view/screens/Firstscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}
enum authProblems { UserNotFound, PasswordNotValid, NetworkError }
enum PlayerState { stopped, playing, paused }

class Authentication with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  var data;

  String uemail;
  User loggedinuser;
  UploadTask uploadTask;
  File file;
  String url;
  String pdf;
  AuthResultStatus authResultStatus;
  String videopath;
  String imagepath;
  bool isPressed = false;

  Future<AuthResultStatus> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    loggedinuser = userCredential.user;
    return authResultStatus;
  }

  Future signUpwithEmailandPassword(String _email, String _password,
      String _displayName, String _matricStaffno, BuildContext context) async {
    User _user;

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email, password: _password);

    _user = userCredential.user;
    if (_user != null) {
      //add display name for just created user
      _user.updateDisplayName(_displayName);
      _user.updatePhotoURL(_matricStaffno);

      //get updated user
      await _user.reload();
      _user = _auth.currentUser;
      //print final version to console
      print("Registered user:");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup Sucess'),
        ),
      );

      Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => FirstScreen(),
        ),
      );

      FirebaseFirestore.instance.collection('users').doc(_user.uid).set({
        'userid': _user.uid,
        'matricNo': _matricStaffno,
        "displayName": _displayName
      }).catchError((e) {
        print(e);
      });
      await _auth.signOut();
    } else {
      print("Sign up failed");
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
    return firebaseDownloadUrl;
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

// getCurrentUser called in the main method
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

  Future<List<NewsDetail>> getNews() async {
    final List<NewsDetail> items = [];
    var apiKey =
        "https://newsapi.org/v2/top-headlines?country=ng&apiKey=bc9f48ec79d5429fbb1c9e1fcf7ff7a1";
    http.Response response = await http.get(
      Uri.parse(apiKey),
    );
    Map<String, dynamic> responseData = json.decode(response.body);
    responseData['articles'].forEach((newsDetail) {
      final NewsDetail news = NewsDetail(
          description: newsDetail['description'],
          title: newsDetail['title'],
          url: newsDetail['urlToImage']);

      items.add(news);
      notifyListeners();
    });
    return items;
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

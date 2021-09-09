import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtuallearningapp/main.dart';
import 'package:virtuallearningapp/services%20and%20providers/model.dart';
import 'package:path/path.dart';
import 'package:virtuallearningapp/view/screens/student/course_content/course_content.dart';

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

class Authentication with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  AuthResultStatus _status;
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
  FireUser _userFromFirebaseUser(User user) {
    return user != null ? FireUser(user.uid) : null;
  }

  Future<AuthResultStatus> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    loggedinuser = userCredential.user;
    return authResultStatus;
  }

  Future signUpwithEmailandPassword(String email, String password,
      String displayName, String matricStaffno) async {
    User user;

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'userid': user.uid,
      'matricNo': matricStaffno,
      "displayName": displayName
    }).catchError((e) {
      print(e);
    });

    return _userFromFirebaseUser(user);
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

class AuthExceptionHandler {
  static handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        status = AuthResultStatus.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
        status = AuthResultStatus.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
        status = AuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been registered. Please login or reset your password.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}

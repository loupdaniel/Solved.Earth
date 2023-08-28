import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageStoreMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late int index;

  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  Future<String> imageToStorage(Uint8List file, int index) async {
    String id = const Uuid().v1();

    // !! need to receive $userId and $challengeId
    Reference ref = _storage
        .ref()
        .child('users/$currentUserUid/${index.toString()}/')
        .child(id); // To specify the folder names for the post and post id
    // !! _storage.ref().child("users/" + $userId + $challengeId + id);

    // Reference is an object that represents a reference to a file or a directory in a cloud storage service such as firebase storage

    UploadTask uploadTask = ref.putData(
        file); // UploadTask is an object that represents a task for uploading a file to a cloud storage service such as firebase storage
    TaskSnapshot snapshot = await uploadTask; // Can monitor the upload progress
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //! Replaced the Future type from Future<String> to Future<Object>
  String baseUrl = dotenv.env['BASE_URL'].toString();

  Future<String> uploadPost(
      String description, Uint8List file, int index) async {
    String res = 'Some Error Occurred';
    String neterror = 'Network Error Occurred';

    String apiUrl =
        '$baseUrl/upload-images?username=$currentUserUid&challenge_name=recycle';
    Uri uri = Uri.parse(apiUrl);

    // Handle the API response
    Future<String> handleApiResponse(Response<dynamic> response) async {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBodyMap = response.data;
        if (responseBodyMap["success"] == true) {
          try {
            String photoUrl = await imageToStorage(file, index);
            String postId = const Uuid().v1();

            Post post = Post(
              //description: description,
              postId: postId,
              datePublished: DateTime.now(),
              postUrl: photoUrl,
            );
            _firestore
                .collection('users/$currentUserUid/${index.toString()}/')
                .doc(postId)
                .set(
                  post.toJson(),
                );
            res = 'success';
          } catch (err) {
            res = err.toString();
          }
          return res;
        } else {
          res = 'Missing values: ${responseBodyMap["missing"].toString()}';
          return res; // Returns missing values
        }
      } else {
        return neterror;
      }
    }

    //send api request in dio
    var dio = Dio();
    dio.options.connectTimeout = const Duration(
        seconds:
            5); //If the connect time from the server is longer than 5 seconds, return connectTimeout Exception
    dio.options.receiveTimeout = const Duration(
        seconds:
            5); //If the receive time from the server is longer than 5 seconds, return receiveTimeout Exception

    var formData = FormData.fromMap({
      'file':
          MultipartFile.fromBytes(file, filename: 'file${index.toString()}.png')
    });

    try {
      var response = await dio.postUri(uri, data: formData);
      return handleApiResponse(response);
    } catch (e) {
      print(e);
      return '서버와 통신 실패';
    }
  }
}

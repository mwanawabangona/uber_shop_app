import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Function to pick image gallery or camera

  pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No image selected or captured');
    }
  }

  //Function to upload a image to firebase storage

  _uploadImageToSorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('profileImages').child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> createNewUser(
    String email,
    String fullName,
    String password,
    Uint8List? image,
  ) async {
    String res = 'Some Error Occured';

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String downloadUrl = await _uploadImageToSorage(image);

      await _firestore.collection('buyers').doc(userCredential.user!.uid).set({
        'email': email,
        'profileImageUrl': downloadUrl,
        'fullName': fullName,
        'buyerId': userCredential.user!.uid,
      });

      res = 'Account created successfully';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //Function to sign in user

  Future<String>loginUser(String email, String password)async{
    String res = 'Some Error Occured';

    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'Logged in successfully';
    }catch(e){
      res = e.toString();
    }
    return res;
  }
}

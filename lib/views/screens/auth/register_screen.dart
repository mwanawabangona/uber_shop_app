import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uber_shop_app/controllers/auth_controller.dart';
import 'package:uber_shop_app/views/screens/auth/login_screen.dart';

class registerScreen extends StatefulWidget {
  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  // const registerScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController _authController = AuthController();

  bool _isLoading = false;

  late String email;

  late String fullName;

  late String password;

  Uint8List? profileImage;

  selectImageGallery() async {
    Uint8List img = await _authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      profileImage = img;
    });
  }

  selectCameraImage() async {
    Uint8List img = await _authController.pickProfileImage(ImageSource.camera);

    setState(() {
      profileImage = img;
    });
  }

  registeredUser() async {
    if (profileImage != null) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        String res = await _authController.createNewUser(
          email,
          fullName,
          password,
          profileImage,
        );
        setState(() {
          _isLoading = false;
        });
        if (res == 'Account created successfully') {
          setState(() {
            _isLoading = true;
          });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) {
          //     return loginScreen();
          //   }),
          // );
          Get.to(loginScreen());
          Get.snackbar(
            'Account created successfully',
            'Account created successfully',
            icon: Icon(
              Icons.message,
              color: Colors.white,
            ),
          );
        } else {
          Get.snackbar(
            'error occured',
            res.toString(),
            icon: Icon(
              Icons.message,
              color: Colors.white,
            ),
          );
        }
      }
      Get.snackbar('Form', 'form field is not valid',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(15.0),
          icon: Icon(
            Icons.message,
            color: Colors.white,
          ),
          snackPosition: SnackPosition.BOTTOM);
    } else
      Get.snackbar('No Image', 'Please select a image or Capture a image',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(15.0),
          icon: Icon(
            Icons.message,
            color: Colors.white,
          ),
          snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Text(
                    'SignUp Screen',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3.5,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Stack(
                    children: [
                      profileImage == null
                          ? CircleAvatar(
                              radius: 60.0,
                              child: Icon(
                                Icons.person,
                                size: 70.0,
                              ),
                            )
                          : CircleAvatar(
                              radius: 60.0,
                              backgroundImage: MemoryImage(profileImage!),
                            ),
                      Positioned(
                        right: 0,
                        top: 15,
                        child: IconButton(
                          onPressed: () {
                            selectImageGallery();
                          },
                          icon: Icon(CupertinoIcons.photo),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email address';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'Enter your email address',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    onChanged: (value) {
                      fullName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      registeredUser();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                      ),
                      child: Center(
                        child: _isLoading? CircularProgressIndicator(color: Colors.white,): Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Already Have An Account?'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authRef = FirebaseAuth.instance;
  var _isLoading = false;
  final storageRef = FirebaseStorage.instance.ref();

  void _submitAuthForm(String email, String username, String pw, File? image,
      AuthMode authMode, BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (authMode == AuthMode.Login) {
        authResult = await authRef.signInWithEmailAndPassword(
          email: email,
          password: pw,
        );
      } else {
        authResult = await authRef.createUserWithEmailAndPassword(
          email: email,
          password: pw,
        );

        final uploadRef =
            storageRef.child("user_images").child(authResult.user.uid + ".jpg");

        await uploadRef.putFile(image);

        final imageUrl = await uploadRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user.uid)
            .set({
          'username': username,
          'email': email,
          'imageUrl': imageUrl,
        });
      }
    } on PlatformException catch (error) {
      var message = 'An error occured, please check your credentials';
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AuthForm(_isLoading, _submitAuthForm),
    );
  }
}

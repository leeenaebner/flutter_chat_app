import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

enum AuthMode { Login, Signup }

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String username,
    String pw,
    File? image,
    AuthMode authMode,
    BuildContext context,
  ) _submitForm;

  final bool isLoading;

  AuthForm(this.isLoading, this._submitForm);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPW = '';
  File? _userImage;
  var _authMode = AuthMode.Login;

  @override
  Widget build(BuildContext context) {
    void _trySubmit() {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();

      if (_authMode == AuthMode.Signup && _userImage == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No image picked")));
        return;
      }

      if (isValid) {
        _formKey.currentState!.save();
      }
      widget._submitForm(
          _userEmail, _userName, _userPW, _userImage, _authMode, context);
    }

    void _pickImage(File pickedImage) {
      _userImage = pickedImage;
    }

    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_authMode == AuthMode.Signup) UserImagePicker(_pickImage),
                  TextFormField(
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: ValueKey("email"),
                    decoration: InputDecoration(labelText: "Email address"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty || !val.contains('@')) {
                        return "Not a valid email address";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _userEmail = val!.trim();
                    },
                  ),
                  if (_authMode != AuthMode.Login)
                    TextFormField(
                      key: ValueKey("username"),
                      enableSuggestions: false,
                      decoration: InputDecoration(labelText: "Username"),
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val!.isEmpty || val.length < 4) {
                          return "Username is too short";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _userName = val!.trim();
                      },
                    ),
                  TextFormField(
                    key: ValueKey("pw"),
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 8) {
                        return "Password is too short";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _userPW = val!;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: _trySubmit,
                          child: Text(
                              _authMode == AuthMode.Login ? "Login" : "Signup"),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              primary: Theme.of(context).buttonColor),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _authMode == AuthMode.Login
                                  ? _authMode = AuthMode.Signup
                                  : _authMode = AuthMode.Login;
                            });
                          },
                          child: Text(
                            _authMode == AuthMode.Login
                                ? "Create new account"
                                : "Switch to Login",
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor),
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

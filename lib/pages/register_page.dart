// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/widgets/custom_button.dart';
import 'package:notesapp/widgets/text_input_container.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  bool isPasswordShown = false;

  bool isRePasswordShown = false;

  bool isCheckbox = false;

  String idTerbaru = '';

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _rePasswordController = TextEditingController();

  bool isLoading = false;

  Future register() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (!passwordConfirm()) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text(
                  'Passwords do not match. Please check your password confirmation.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      addUserDetails(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
      );
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Register Akun Berhasil'),
            content: Text('Silahkan login ke dalam aplikasi'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle registration errors.
      String errorMessage = "";

      if (e is FirebaseAuthException) {
        // Firebase Authentication error codes.
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Email already exists. Please use a different one.';
            break;
          case 'weak-password':
            errorMessage = 'Password is too weak. Choose a stronger password.';
            break;
          default:
            errorMessage = 'Error during registration: ${e.message}';
            break;
        }
      } else {
        errorMessage = 'Error during registration: $e';
      }

      // Show an alert dialog with the error message.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Failed'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK')),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future addUserDetails(String firstName, String lastName, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
    }).then((DocumentReference doc) {
      idTerbaru = doc.id;
    });
  }

  bool passwordConfirm() {
    if (_passwordController.text.trim() == _rePasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  void tooglePasswordVisibility() {
    setState(() {
      isPasswordShown = !isPasswordShown;
    });
  }

  void toogleRePasswordVisibility() {
    setState(() {
      isRePasswordShown = !isRePasswordShown;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _focusScopeNode.unfocus();
        },
        child: FocusScope(
          node: _focusScopeNode,
          child: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 20,
                    ),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create new\naccount',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 87,
                                  height: 4,
                                  color: const Color(0xffED193F),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  width: 8,
                                  height: 4,
                                  color: const Color(0xffED193F),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 48,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextInputContainer(
                              obscureText: false,
                              sizeWidth:
                                  MediaQuery.of(context).size.width / 2 - 48,
                              hintText: 'First Name',
                              isIconEmpty: true,
                              controller: _firstNameController,
                            ),
                            TextInputContainer(
                              obscureText: false,
                              sizeWidth:
                                  MediaQuery.of(context).size.width / 2 - 48,
                              hintText: 'Last Name',
                              isIconEmpty: true,
                              controller: _lastNameController,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        TextInputContainer(
                          obscureText: false,
                          sizeWidth: MediaQuery.of(context).size.width - 48,
                          hintText: 'Email',
                          isIconEmpty: true,
                          controller: _emailController,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        TextInputContainer(
                            obscureText: isPasswordShown ? false : true,
                            sizeWidth: MediaQuery.of(context).size.width - 48,
                            hintText: 'Password',
                            isIconEmpty: false,
                            iconName: isPasswordShown
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                            controller: _passwordController,
                            isPasswordShwon: tooglePasswordVisibility),
                        const SizedBox(
                          height: 32,
                        ),
                        TextInputContainer(
                            obscureText: isRePasswordShown ? false : true,
                            sizeWidth: MediaQuery.of(context).size.width - 48,
                            hintText: 'Re Password',
                            isIconEmpty: false,
                            iconName: isRePasswordShown
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                            controller: _rePasswordController,
                            isPasswordShwon: toogleRePasswordVisibility),
                        const SizedBox(
                          height: 32,
                        ),
                        CustomButton(
                            color: Color(0xffFFC107),
                            title: 'Register',
                            width: MediaQuery.of(context).size.width - 48,
                            onPress: register),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff94959B),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff2972FF),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black
                      .withOpacity(0.5), // Latar belakang semi-transparan
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 3,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

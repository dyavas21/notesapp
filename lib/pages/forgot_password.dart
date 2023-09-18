import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/widgets/custom_button.dart';
import 'package:notesapp/widgets/text_input_container.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  final TextEditingController _emailController = TextEditingController();

  bool isLoading = false;

  Future passwordReset() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Reset Password Berhasil'),
            content: Text('Password reset link sent! Check your email'),
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
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Reset Password Gagal'),
            content: Text(e.message.toString()),
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Forgot your\naccount',
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
                                  color: Color(0xffED193F),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  width: 8,
                                  height: 4,
                                  color: Color(0xffED193F),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 48,
                        ),
                        TextInputContainer(
                          obscureText: false,
                          sizeWidth: MediaQuery.of(context).size.width - 48,
                          hintText: 'Email',
                          isIconEmpty: true,
                          controller: _emailController,
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        CustomButton(
                            color: Color(0xffFFC107),
                            title: 'Reset Password',
                            width: MediaQuery.of(context).size.width - 48,
                            onPress: passwordReset),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/pages/forgot_password.dart';
import 'package:notesapp/pages/home_page.dart';
import 'package:notesapp/pages/register_page.dart';
import 'package:notesapp/widgets/custom_button.dart';
import 'package:notesapp/widgets/text_input_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  bool isPasswordShown = false;

  bool isCheckbox = false;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  Future login() async {
    try {
      setState(() {
        isLoading = true; // Tampilkan loading saat proses login dimulai.
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      // Handle kesalahan login di sini
      String errorMessage = "";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Email tidak ditemukan.';
            break;
          case 'wrong-password':
            errorMessage = 'Password salah.';
            break;
          default:
            errorMessage = 'Terjadi kesalahan saat login.';
            break;
        }
      } else {
        errorMessage = 'Terjadi kesalahan saat login.';
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Gagal'),
            content: Text(errorMessage),
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

  void togglePasswordVisibility() {
    setState(() {
      isPasswordShown = !isPasswordShown;
    });
  }

  void toogleCheckBox() {
    setState(() {
      isCheckbox = !isCheckbox;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
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
                              'Login to your\naccount',
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
                        TextInputContainer(
                            obscureText: isPasswordShown ? false : true,
                            sizeWidth: MediaQuery.of(context).size.width - 48,
                            hintText: 'Password',
                            isIconEmpty: false,
                            iconName: isPasswordShown
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                            controller: _passwordController,
                            isPasswordShwon: togglePasswordVisibility),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(),
                                    ));
                              },
                              child: Text(
                                'Forgot Password',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff2972FF),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomButton(
                            color: Color(0xffFFC107),
                            title: 'Login',
                            width: MediaQuery.of(context).size.width - 48,
                            onPress: login),
                        SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff94959B),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Register',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff2972FF),
                                ),
                              ),
                            ),
                          ],
                        ),
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

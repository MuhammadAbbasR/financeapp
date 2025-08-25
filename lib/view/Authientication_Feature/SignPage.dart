import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../confi/NavigationServices.dart';
import '../../confi/routes/routesname.dart';
import '../../service/AuthienticationService.dart';
import '../../widget/snackbar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final authVM = Provider.of<AuthViewModel>(context);
    return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [Colors.black, Colors.black, Colors.black])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Sign up",
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Welcome",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ]),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(children: [
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Light shadow
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: "Enter your name",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      //  authVM.isLoading
                      //  ? CircularProgressIndicator()
                      // :
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            showSnackBar(
                              context,
                              "Email and password are required",
                              isSuccess: false,
                            );
                            return;
                          }

                          try {
                            final user = await AuthService().signUpWithEmail(
                              email: email,
                              password: password,
                            );

                            if (user != null) {
                              showSnackBar(context, "Sign up successful");
                              NavigatorServices.GoTo(RoutesName.home_route);
                            } else {
                              showSnackBar(context, "Sign up unsuccessful",
                                  isSuccess: false);
                            }
                          } catch (e) {
                            showSnackBar(context, e.toString(), isSuccess: false);
                          }
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          NavigatorServices.GoTo(RoutesName.login_route);
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
}

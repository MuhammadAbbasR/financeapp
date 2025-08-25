import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../confi/NavigationServices.dart';
import '../../confi/routes/routesname.dart';
import '../../service/AuthienticationService.dart';
import '../../widget/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                child: Column(children: [
                  Text("Login",
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
                              controller: emailController,
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
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      //  authVM.isLoading
                      //      ? CircularProgressIndicator()
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

                            final user = await AuthService().signInWithEmail(
                              email: email,
                              password: password,
                            );

                            if (user != null) {
                              // Login successful
                              showSnackBar(context, "Login successful");
                              NavigatorServices.GoTo(RoutesName.home_route);
                            } else {
                              // This case occurs if signInWithEmail returns null
                              showSnackBar(context, "Login unsuccessful",
                                  isSuccess: false);
                            }
                          } catch (e) {

                            showSnackBar(context, e.toString(), isSuccess: false);
                          }
                        }

                        // }
                        ,
                        child: const Text(
                          'Login',
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
                          NavigatorServices.GoTo(RoutesName.signup_route);
                        },
                        child: const Text(
                          'Dont  have an account? Sign up',
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
}

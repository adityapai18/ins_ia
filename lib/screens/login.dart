import 'package:doctor_appointment/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../context/auth_con.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: initWidget(),
        ),
      ),
    );
  }

  Widget initWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
        ),
        const Center(
          child: Text(
            'Welcome Back',
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        ),
        const Center(
          child: Text(
            'Let us get to know you better!',
            style: TextStyle(color: Constants.GRAY, fontSize: 16),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 25),
          child: form(), // form
        ),
      ],
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   margin: const EdgeInsets.only(top: 50),
          // ),
          Lottie.asset('assets/login.json'),
          customInput((text) {
            if (text == null || text.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          }, 'Email', emailController),
          customInput((text) {
            if (text == null || text.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          }, 'Password', pwdController),
          Container(
            margin: const EdgeInsets.only(top: 25),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  context.read<AuthContext>().loginWithEmailAndPassword(
                      emailController.text, pwdController.text, context);
                }
              },
              child: const Text('LOGIN'),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(240, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40, bottom: 20),
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    'Dont have an account? ',
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const SignUp();
                      }));
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(color: Color(0xffFF7360)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget customInput(String? Function(String?)? validation, String label,
      TextEditingController cntrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Constants.GRAY,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            validator: validation,
            obscureText: label == 'Password' || label == 'Confirm Password',
            enableSuggestions:
                label != 'Password' || label == 'Confirm Password',
            autocorrect: label != 'Password' || label == 'Confirm Password',
            controller: cntrl,
            decoration: InputDecoration(
              border: InputBorder.none,
              label: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}

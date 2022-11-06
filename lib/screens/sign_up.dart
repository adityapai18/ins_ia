import 'package:doctor_appointment/constants/constants.dart';
import 'package:doctor_appointment/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../context/auth_con.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final cpwdController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  bool checkBox = false;
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
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: const [
              Text(
                'Welcome To ',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                'MyDoctor',
                style: TextStyle(fontSize: 30, color: Constants.PRIMARY_COLOR),
              )
            ],
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
          child: form(),
        ) // form
      ],
    );
  }

  Widget form() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customInput((text) {
              if (text == null || text.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            }, 'First Name', fnameController),
            customInput((text) {
              if (text == null || text.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            }, 'Last Name', lnameController),
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
            customInput((text) {
              if (text == null || text.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            }, 'Confirm Password', cpwdController),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Checkbox(
                    value: checkBox,
                    checkColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          checkBox = value;
                        }
                      });
                    },
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      const Text('By Clicking the here I agree to MyDoctor’s'),
                      Row(children: const [
                        Text('Terms of Service ',
                            style: TextStyle(color: Constants.PRIMARY_COLOR)),
                        Text('and '),
                        Text('Privacy Policy',
                            style: TextStyle(color: Constants.PRIMARY_COLOR)),
                      ])
                    ],
                  ),
                ],
              ),
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
                    context.read<AuthContext>().signUpEmailAndPass(
                        fnameController.text,
                        lnameController.text,
                        emailController.text,
                        pwdController.text,
                        cpwdController.text,
                        context);
                  }
                },
                child: const Text('SIGN UP'),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(240, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                            (route) => false);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Color(0xffFF7360)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
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
            controller: cntrl,
            obscureText: label == 'Password' || label == 'Confirm Password',
            enableSuggestions:
                label != 'Password' || label == 'Confirm Password',
            autocorrect: label != 'Password' || label == 'Confirm Password',
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

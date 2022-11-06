import 'package:doctor_appointment/helpers/authLogic.dart';
import 'package:doctor_appointment/navigation/auth_stack.dart';
import 'package:doctor_appointment/navigation/user_stack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../context/auth_con.dart';
import '../screens/sign_up.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  bool isAuthenticated = false;
  @override
  void initState() {
    super.initState();
    oAUthLogin();
  }

  void oAUthLogin() {
    context.read<AuthContext>().oAuthLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthenticated) return const AuthStack();
    return const UserStack();
  }
}

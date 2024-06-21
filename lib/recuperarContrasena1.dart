import 'package:flutter/material.dart';
import 'package:luchosoft/constants.dart';
import 'package:luchosoft/recuperarContrasena.dart';

class Recuperarcontrasena1 extends StatelessWidget {
  const Recuperarcontrasena1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBagroundColor,
      appBar: buildAppBar(),
      body: const RecuperarContrasena(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text('Recuperar contraseña', style: TextStyle(color: kPrimaryColor),),
      backgroundColor: kBagroundColor,
      centerTitle: false,
    );
  }
}
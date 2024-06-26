import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luchosoft/constants.dart';
import 'package:luchosoft/pedidos/pedidos_screen.dart';
import 'package:luchosoft/recuperarContrasena1.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Acceso());
}

class Acceso extends StatefulWidget {
  const Acceso({super.key});

  @override
  State<Acceso> createState() => _MainAppState();
}

class _MainAppState extends State<Acceso> {
  var sentinela = true;
  bool isFirstTime = true;

  final GlobalKey<FormState> formUsuario = GlobalKey<FormState>();
  final usuarioIngresado = TextEditingController();
  final contrasenaIngresada = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    checkFirstTime();
  }

  Future<void> checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      setState(() {
        isFirstTime = false;
      });
    }
  }

  Future<void> updateFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', false);
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('https://api-luchosoft-mysql.onrender.com/auth/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'contraseña': password,
      }),
    );

    if (response.statusCode == 200) {
      final route = MaterialPageRoute(builder: (context) => const PedidosScreen());
      Navigator.pushReplacement(context, route);
    } else {
      final errorMsg = json.decode(response.body)['msg'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: Text(errorMsg),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: !sentinela
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  bagroundLogin2,
                  bagroundLogin2,
                  bagroundLogin4,
                ],
              )),
              child: SafeArea(
                child: ListView(
                  children: [
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Text(
                      isFirstTime ? '¡Hola!' : '¡Hola de nuevo!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: kTextColor,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Bienvenido a Donde Lucho\nIngresa tu correo y contraseña',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, color: kTextColor2, height: 1.2),
                    ),
                    SizedBox(height: size.height * 0.09),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        child: Form(
                          key: formUsuario,
                          child: Column(children: [
                            TextFormField(
                              controller: usuarioIngresado,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 16),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15)),
                                  hintText: 'Correo',
                                  hintStyle: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 13,
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.white,
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'El Correo es requerido!';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: size.height * 0.04),
                            TextFormField(
                              controller: contrasenaIngresada,
                              keyboardType: TextInputType.text,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 16),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15)),
                                hintText: 'Contraseña',
                                hintStyle: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 13,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.black12,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'La contraseña es requerida!';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: size.height * 0.04),
                            GestureDetector(
                                onTap: () {
                                  if (!formUsuario.currentState!.validate()) {
                                    print('Formulario no válido');
                                  } else {
                                    // Ejecutar la función login con los datos del formulario
                                    final email = usuarioIngresado.text;
                                    final password = contrasenaIngresada.text;
                                    login(email, password);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: size.width,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          color: buttonColorLogin,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Ingresar',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Recuperarcontrasena1(),
                                  ),
                                );
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 0, top: 20),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle( 
                                    decoration: TextDecoration
                                        .underline, // Esto subraya el texto
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ))
                  ],
                ),
              ),
            ),
    );
  }
}

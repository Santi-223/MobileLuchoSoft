import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luchosoft/acceso.dart';
import 'package:luchosoft/constants.dart';

class RecuperarContrasena extends StatefulWidget {
  const RecuperarContrasena({super.key});

  @override
  State<RecuperarContrasena> createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasena> {
  bool isLoading = false;
  final GlobalKey<FormState> formUsuario = GlobalKey<FormState>();
  final usuarioIngresado = TextEditingController();

  Future<void> sendData(String email) async {
    setState(() {
      isLoading = true;
    });

    final apiUrl = Uri.parse(
        'https://api-luchosoft-mysql.onrender.com/configuracion/enviarCorreo');

    final response = await http.post(
      apiUrl,
      body: jsonEncode({
        'email': email,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    var jsonResponse = json.decode(response.body);

    setState(() {
      isLoading = false;
    });

    if (jsonResponse['msg'] == 'Error, el email no se encuentra registrado.') {
      print('Respuesta de la API: ${jsonResponse['msg']}');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alerta'),
              content: Text(jsonResponse['msg']),
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
    } else {
      print('Respuesta de la API: ${jsonResponse['msg']}');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alerta'),
              content: Text(jsonResponse['msg']),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    final route =
                        MaterialPageRoute(builder: (context) => Acceso());
                    Navigator.push(context, route);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
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
                ),
              ),
              child: SafeArea(
                child: ListView(
                  children: [
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Ingresa tu correo de recuperación.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: kTextColor2,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: size.height * 0.09),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ),
                      child: Form(
                        key: formUsuario,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: usuarioIngresado,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 16,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: 'Correo',
                                hintStyle: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 13,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'El Correo es requerido!';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: size.height * 0.04),
                            GestureDetector(
                              onTap: () {
                                if (formUsuario.currentState!.validate()) {
                                  sendData(usuarioIngresado.text);
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  children: [
                                    Container(
                                      width: size.width,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        color: buttonColorLogin,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Recuperar contraseña',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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

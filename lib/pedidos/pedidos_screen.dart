import 'package:flutter/material.dart';
import 'package:luchosoft/constants.dart';
import 'package:luchosoft/body.dart';
import 'package:luchosoft/acceso.dart'; // Asegúrate de importar la pantalla de acceso

class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBagroundColor,
      appBar: buildAppBar(context), // Pasa el contexto a buildAppBar
      body: const Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text(
        'Pedidos',
        style: TextStyle(color: kPrimaryColor),
      ),
      backgroundColor: kBagroundColor,
      centerTitle: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout),
          color: kPrimaryColor,
          onPressed: () {
            _showLogoutConfirmationDialog(context);
          },
        ),
      ],
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación de Cierre de Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cerrar Sesión'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Acceso()),
                );
                // Aquí puedes agregar la lógica para cerrar sesión, como limpiar tokens de usuario, etc.
              },
            ),
          ],
        );
      },
    );
  }
}

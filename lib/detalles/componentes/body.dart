import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luchosoft/constants.dart';
import 'package:http/http.dart' as http;

class Body2 extends StatefulWidget {
  final int idCliente; // Especifica el tipo de `idCliente`
  final int idPedido;
  const Body2({super.key, required this.idCliente, required this.idPedido});

  @override
  State<Body2> createState() => _Body2State();
}

class _Body2State extends State<Body2> {
  List<dynamic> detalles = [];
  List<dynamic> cliente = [];
  late final int idCliente;
  late final int idPedido;

  @override
  void initState() {
    super.initState();
    idCliente = widget.idCliente;
    idPedido = widget.idPedido;
    fetchDetalles();
    fetchCliente();
  }

  Future<void> fetchDetalles() async {
    final response = await http.get(Uri.parse(
        'https://api-luchosoft-mysql.onrender.com/ventas/pedidos_productos/pedidos/${idPedido}'));
    if (response.statusCode == 200) {
      List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        detalles = decodedData;
      });
    } else {
      print('Error fetching data: ${response.body}');
    }
  }

  Future<void> fetchCliente() async {
    final response = await http.get(Uri.parse(
        'https://api-luchosoft-mysql.onrender.com/ventas/clientes/${idCliente}'));
    if (response.statusCode == 200) {
      List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        cliente = decodedData;
      });
    } else {
      print('Error fetching data: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(idPedido);
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          decoration: const BoxDecoration(
            color: kBagroundColor2,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            // Cambié a Column sin const
            children: [
              const Text('Información del Cliente: '),
              const Text('Información del Cliente: '),
              Card(
                elevation: 20,
                child: Column(
                  children: [
                    ListTile(
                      leading: Text(
                          'Nombre: '), 
                    ),
                    const Divider(),
                    ListTile(
                      leading: Text(
                        'Cédula: $idCliente',
                      ),
                    ),
                    const Divider(),
                    cliente.length > 2 // Check if more data exists (optional)
                        ? ListTile(
                            leading: Text(
                                'Teléfono: '), // Access phone number using key
                          )
                        : const SizedBox(), // Placeholder if no phone number key
                    const Divider(),
                    // Add more ListTile widgets for other relevant customer information (if available)
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Detalle pedido: '),
              Card(
                elevation: 20,
                child: ListView.builder(
                  shrinkWrap: true, // Makes the list view fit its content
                  itemCount: detalles.length,
                  itemBuilder: (context, index) {
                    // Access details of each item in detalles
                    final detalle = detalles[index];
                    int nombreProducto =
                        detalle['id_producto']; // Replace with actual key
                    int cantidad =
                        detalle['cantidad_producto']; // Replace with actual key
                    int precioUnitario =
                        detalle['subtotal']; // Replace with actual key

                    return ListTile(
                      title: Text(
                          'Producto: $nombreProducto\nCantidad: $cantidad'),
                      subtitle: Text('Subtotal: \$ $precioUnitario'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

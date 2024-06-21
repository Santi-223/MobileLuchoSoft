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
  Map<String, dynamic>? cliente; // Cambiado a un mapa para almacenar detalles del cliente
  Map<int, String> productos = {}; // Almacenar productos con id_producto como clave
  late final int idCliente;
  late final int idPedido;
  bool isLoading = true; // Estado para controlar el indicador de progreso

  @override
  void initState() {
    super.initState();
    idCliente = widget.idCliente;
    idPedido = widget.idPedido;
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchProductos();
    await fetchDetalles();
    await fetchCliente();
    setState(() {
      isLoading = false; // Datos cargados, se oculta el indicador de progreso
    });
  }

  Future<void> fetchProductos() async {
    final response = await http.get(Uri.parse('https://api-luchosoft-mysql.onrender.com/ventas2/productos'));
    if (response.statusCode == 200) {
      List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        productos = {for (var producto in decodedData) producto['id_producto']: producto['nombre_producto']};
      });
    } else {
      print('Error fetching products: ${response.body}');
    }
  }

  Future<void> fetchDetalles() async {
    final response = await http.get(Uri.parse(
        'https://api-luchosoft-mysql.onrender.com/ventas/pedidos_productos/pedidos/$idPedido'));
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
        'https://api-luchosoft-mysql.onrender.com/ventas/clientes/$idCliente'));
    if (response.statusCode == 200) {
      List<dynamic> decodedData = json.decode(response.body);
      if (decodedData.isNotEmpty) {
        setState(() {
          cliente = decodedData[0]; // Almacena el primer objeto del array
        });
      }
    } else {
      print('Error fetching data: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(idPedido);
    return isLoading
        ? Center(
            child: CircularProgressIndicator(), // Muestra el indicador de progreso mientras carga
          )
        : SingleChildScrollView(
            child: Column(
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
                    children: [
                      const Text('Información del Cliente: '),
                      Card(
                        elevation: 20,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Text('Nombre: '),
                              title: Text(cliente != null ? cliente!['nombre_cliente'] : 'Cargando...'),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Text('Cédula:'),
                              title: Text('$idCliente'),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Text('Teléfono:'),
                              title: Text(cliente != null ? cliente!['telefono_cliente'] : 'Cargando...'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text('Detalle pedido: '),
                      Card(
                        elevation: 20,
                        child: Container(
                          height: 300.0, // Set a fixed height for the list container
                          child: ListView.builder(
                            itemCount: detalles.length,
                            itemBuilder: (context, index) {
                              final detalle = detalles[index];
                              int idProducto = detalle['id_producto'];
                              int cantidad = detalle['cantidad_producto'];
                              int precioUnitario = detalle['subtotal'];
                              String nombreProducto = productos[idProducto] ?? 'Producto desconocido';

                              return ListTile(
                                title: Text(
                                    'Producto: $nombreProducto\nCantidad: $cantidad'),
                                subtitle: Text('Subtotal: \$ $precioUnitario'),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

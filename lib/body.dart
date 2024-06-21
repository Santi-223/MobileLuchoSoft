import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart'; // Importar la biblioteca intl
import 'package:luchosoft/constants.dart';
import 'package:luchosoft/detalles/detalles_screen.dart';
import 'package:luchosoft/pedidos/components/pedidos_card.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget { 
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<dynamic> pedidos = [];
  List<dynamic> filteredData = [];
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0; // Índice del elemento seleccionado
  List<String> categories = ['Pendientes', 'Cancelados', 'Vendidos'];

  @override
  void initState() {
    super.initState();
    fetchPedidos();
  }

  Future<void> fetchPedidos() async {
    final response = await http.get(
        Uri.parse('https://api-luchosoft-mysql.onrender.com/ventas/pedidos'));
    if (response.statusCode == 200) {
      List<dynamic> decodedData = json.decode(response.body);

      // Formatear las fechas de los pedidos al formato deseado
      final DateFormat apiDateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
      final DateFormat desiredDateFormat = DateFormat('MM/dd/yyyy');

      decodedData.forEach((pedido) {
        if (pedido['fecha_pedido'] != null) {
          DateTime formattedDate = apiDateFormat.parse(pedido['fecha_pedido']);
          pedido['fecha_pedido'] = desiredDateFormat.format(formattedDate);
        }
      });

      setState(() {
        pedidos = decodedData;
        applyFilters();
      });
    } else {
      // Handle error
    }
  }

  void applyFilters() {
    String query = searchController.text.toLowerCase();
    int estado = selectedIndex + 1;

    List<dynamic> filteredList = pedidos.where((item) {
      bool matchesEstado = item['estado_pedido'] == estado;
      bool matchesQuery =
          item['observaciones'].toString().toLowerCase().contains(query) ||
              item['id_pedido'].toString().contains(query) ||
              item['id_cliente'].toString().contains(query) ||
              item['fecha_pedido'].toString().contains(query);

      return matchesEstado && matchesQuery;
    }).toList();

    setState(() {
      filteredData = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 4,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 228, 200, 200).withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              onChanged: (value) {
                applyFilters();
              },
              controller: searchController,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                icon: SvgPicture.asset("assets/icons/search.svg"),
                hintText: 'Buscar',
                hintStyle: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    applyFilters();
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: kDefaultPadding,
                    right: index == categories.length - 1 ? kDefaultPadding : 0,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  decoration: BoxDecoration(
                    color: index == selectedIndex
                        ? const Color.fromARGB(255, 228, 200, 200)
                            .withOpacity(0.4)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    categories[index],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPadding / 2),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 70),
                  decoration: const BoxDecoration(
                    color: kBagroundColor2,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    return PedidosCard(
                      itemIndex: index + 1, // Mostrar el índice comenzando en 1
                      id_pedido: filteredData[index]['id_pedido'],
                      observaciones: filteredData[index]['observaciones'],
                      id_cliente: filteredData[index]['id_cliente'],
                      fecha_pedido: filteredData[index]
                          ['fecha_pedido'], // Usar la fecha formateada
                      total_pedido: filteredData[index]['total_pedido'],
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetallesScreen(
                              idCliente: filteredData[index]['id_cliente'],
                              idPedido: filteredData[index]['id_pedido'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

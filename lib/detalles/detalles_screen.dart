import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:luchosoft/constants.dart';
import 'package:luchosoft/detalles/componentes/body.dart';

class DetallesScreen extends StatefulWidget {
  final int idCliente;
  final int idPedido;
  const DetallesScreen(
      {Key? key, required this.idCliente, required this.idPedido})
      : super(key: key);

  @override
  _DetallesScreenState createState() => _DetallesScreenState();
}

class _DetallesScreenState extends State<DetallesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBagroundColor,
      appBar: buildAppBar(context),
      body: Body2(idCliente: widget.idCliente, idPedido: widget.idPedido),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kBagroundColor,
      elevation: 0,
      leading: IconButton(
        padding: EdgeInsets.only(left: kDefaultPadding),
        icon: SvgPicture.asset("assets/icons/flecha-izquierda.svg"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Salir'.toUpperCase(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

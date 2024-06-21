import 'package:flutter/material.dart';
import 'package:luchosoft/constants.dart';


class PedidosCard extends StatelessWidget {
  final int itemIndex;

  //funcion para traer los datos
  final id_pedido;
  final observaciones;
  final id_cliente;
  final fecha_pedido;
  final total_pedido;
  final VoidCallback press;

  const PedidosCard({
    Key? key,
    required this.itemIndex,
    required this.id_pedido,
    required this.observaciones,
    required this.id_cliente,
    required this.fecha_pedido,
    required this.total_pedido,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      elevation: 5,
      child: Container(
        height: 136,
        child: InkWell(
          onTap: press,
          child: Stack(
            children: [
              // Background container for the card
              Container(
                decoration: const BoxDecoration(
                  color: kBagroundColor2,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          child: Text(id_pedido.toString()),
                        ),
                      ],
                    ),
                    const SizedBox(width: kDefaultPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cliente Asociado: ${id_cliente}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'Feha del Pedido: $fecha_pedido',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'Descripción: ${observaciones}',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding * 1.5,
                                vertical: kDefaultPadding / 4,
                              ),
                              decoration: const BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(22),
                                  topLeft: Radius.circular(22),
                                ),
                              ),
                              child: Text(
                                'Total: \$${total_pedido}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

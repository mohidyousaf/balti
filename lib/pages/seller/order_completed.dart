import 'package:balti_app/models/order.dart';
import 'package:balti_app/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../utils/size_config.dart';
import '../../widgets/custom_icon_button.dart';

class OrderCompleted extends StatefulWidget {
  const OrderCompleted({Key? key, required this.userId}) : super(key: key);

  final String userId;
  @override
  State<OrderCompleted> createState() => _OrderCompletedState();
}

class _OrderCompletedState extends State<OrderCompleted> {
  late Future<void> getCompletedOrders;
  @override
  void initState() {
    super.initState();
    // context.watch<BusinessesList>().getBusinesses(phoneNumber);
    getCompletedOrders = Provider.of<Orders>(context, listen: false)
        .getOrdersByStatus("Completed", widget.userId);
    // if (mounted) {
    //   await Provider.of<UserCart>(context, listen: false).getProducts();
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    List<Order> orders =
        Provider.of<Orders>(context, listen: false).approvalOrders;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffffffff),
          leading: Padding(
            padding: EdgeInsets.only(left: mediaQuery.size.width * 0.032),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              iconSize: mediaQuery.size.width * 0.08,
              onPressed: () {},
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: mediaQuery.size.width * 0.032),
              child: IconButton(
                icon: const Icon(Icons.swap_horiz),
                color: Colors.black,
                iconSize: mediaQuery.size.width * 0.08,
                onPressed: () {},
              ),
            ),
          ]),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.only(
              left: mediaQuery.size.width * 0.05,
              top: mediaQuery.size.width * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Completed",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: mediaQuery.size.height * 0.040,
                    fontFamily: "Poppins"),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.02,
              ),
              FutureBuilder(
                  future: getCompletedOrders,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        // height: mediaQuery.size.height * 0.43,
                        alignment: Alignment.topLeft,
                        child: context.watch<Orders>().completedOrders.isEmpty
                            ? Center(
                                child: Text(
                                "No Orders",
                                style: TextStyle(
                                    fontSize: mediaQuery.size.width * 0.05,
                                    color: Colors.black),
                              ))
                            : Expanded(
                                child: Column(
                                    children: context
                                        .watch<Orders>()
                                        .completedOrders
                                        .map((e) => orderDetailsCard(
                                            mediaQuery,
                                            e.userName,
                                            "address",
                                            e.quantity,
                                            e.price,
                                            e.id,
                                            Provider.of<Orders>(context,
                                                listen: false),
                                            context))
                                        .toList())),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })
            ],
          ),
        ),
      ]),
    );
  }
}

Widget orderDetailsCard(
    mediaQuery, name, address, quantity, price, id, caller, context) {
  return Card(
    margin: EdgeInsets.only(
        top: mediaQuery.size.height * 0.01,
        right: mediaQuery.size.width * 0.03),
    elevation: 5.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: mediaQuery.size.height * 0.01),
                    child: Text('${name}\'s Order',
                        style: TextStyle(
                            letterSpacing: 0.08,
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${address}',
                      style: TextStyle(
                          letterSpacing: 0.06,
                          fontSize: mediaQuery.size.width * 0.04,
                          fontWeight: FontWeight.w300)),
                  quantity <= 1
                      ? Text('${quantity} item',
                          style: TextStyle(
                            letterSpacing: 0.08,
                            fontSize: mediaQuery.size.width * 0.035,
                          ))
                      : Text('${quantity} items',
                          style: TextStyle(
                            letterSpacing: 0.08,
                            fontSize: mediaQuery.size.width * 0.035,
                          )),
                ],
              ),
              Align(
                child: Container(
                  child: Text(
                    'Rs. $price',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2F9469),
                        fontSize: 17),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}

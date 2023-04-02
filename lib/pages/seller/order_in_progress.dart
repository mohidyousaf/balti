import 'package:balti_app/models/order.dart';
import 'package:balti_app/models/product.dart';
import 'package:balti_app/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../utils/size_config.dart';

class OrdersInProgress extends StatefulWidget {
  const OrdersInProgress({Key? key, required this.userId}) : super(key: key);

  final String userId;
  @override
  State<OrdersInProgress> createState() => _OrdersInProgressState();
}

class _OrdersInProgressState extends State<OrdersInProgress> {
  late Future<void> getProgressedOrders;
  @override
  void initState() {
    super.initState();
    // context.watch<BusinessesList>().getBusinesses(phoneNumber);
    getProgressedOrders = Provider.of<Orders>(context, listen: false)
        .getOrdersByStatus("In Processing", widget.userId);
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
                "In Progress",
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
                  future: getProgressedOrders,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      log.wtf(context.watch<Orders>().processedOrders);
                      return Container(
                        // height: mediaQuery.size.height * 0.43,
                        alignment: Alignment.topLeft,
                        child: context.watch<Orders>().processedOrders.isEmpty
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
                                        .processedOrders
                                        .map((e) => orderDetailsCard(
                                            mediaQuery,
                                            e.userName,
                                            "address",
                                            e.quantity,
                                            e.price,
                                            e.id,
                                            Provider.of<Orders>(context,
                                                listen: false),
                                            context,
                                            Provider.of<Orders>(context,
                                                    listen: false)
                                                .getSpecificOrderProduct(
                                                    e.id, "Progress")))
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
    mediaQuery, name, address, quantity, price, id, caller, context, products) {
  List<Product> filteredProducts = [];
  List<String> ids = [];
  for (var i = 0; i < products.length; i++) {
    log.wtf("id", products[i].id);
    if (!ids.contains(products[i].id)) {
      filteredProducts.add(products[i]);
      ids.add(products[i].id);
    }
  }
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
          Container(
            height: mediaQuery.size.height * .15,
            margin: EdgeInsets.only(
              left: SizeConfig.screenWidth / 36,
            ),
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // shrinkWrap: true,
              // physics: const ScrollPhysics(),
              itemCount: filteredProducts.length,
              itemBuilder: (BuildContext context, int i) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: mediaQuery.size.width * 0.5,
                      height: mediaQuery.size.height * 0.1,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            filteredProducts[i].imageUrl,
                            colorBlendMode: BlendMode.dstATop,
                            color: Colors.white.withOpacity(0.9),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${products[i].name}'),
                        Text('PKR ${products[i].price}'),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  width: mediaQuery.size.width * 0.30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:
                          const Color.fromARGB(193, 27, 209, 161), // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () async {
                      await caller.updateOrderStatus(id, "Completed");
                      Navigator.pop(context);
                    },
                    child: Text('Complete'),
                  )),
            ],
          )
        ],
      ),
    ),
  );
}

import 'package:balti_app/pages/seller/edit_product.dart';
import 'package:balti_app/pages/user/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:balti_app/models/product.dart';

import '../utils/size_config.dart';

var log = Logger();

class ProductCardCopy extends StatefulWidget {
  const ProductCardCopy(
      {Key? key,
      required this.id,
      required this.productName,
      required this.imageUrl,
      required this.delay,
      required this.price,
      required this.isFav,
      required this.images,
      required this.userId,
      required this.businessId,
      required this.productId})
      : super(key: key);

  final String id;
  final String productName;
  final String delay;
  final String imageUrl;
  final double price;
  final bool isFav;
  final List<String> images;
  final String userId;
  final String businessId;
  final String productId;

  @override
  State<ProductCardCopy> createState() => _ProductCardCopyState();
}

class _ProductCardCopyState extends State<ProductCardCopy> {
  bool isIcon = false;
  @override
  Widget build(BuildContext context) {
    Product product = Product(
        id: widget.id,
        name: widget.productName,
        businessId: widget.businessId,
        description: "",
        price: widget.price,
        rating: 0,
        duration: 0,
        imageUrl: widget.imageUrl,
        images: widget.images,
        videos: []);

    log.d("In Product", product.name);
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditProduct(product: product, userId: widget.userId)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  16,
                ),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.blue,
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            widget.imageUrl,
                            colorBlendMode: BlendMode.dstATop,
                            color: Colors.white.withOpacity(0.9),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Positioned(
                      top: SizeConfig.screenHeight / 48.3333,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.screenHeight / 362.5,
                          horizontal: SizeConfig.screenWidth / 120,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFEFE),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: Colors.black,
                              size: 8,
                            ),
                            SizedBox(width: SizeConfig.screenWidth / 240),
                            Text(
                              widget.delay,
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenWidth / 51.429,
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: SizeConfig.screenWidth / 3,
                      child: Text(
                        widget.productName,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                    Text(
                      'PKR ${widget.price}',
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                isIcon
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          log.d(isIcon);
                          setState(() {
                            isIcon = !isIcon;
                          });
                        },
                        // ignore: prefer_const_constructors
                        icon: const Icon(
                          size: 20,
                          Icons.favorite,
                          color: Color(0xffb74093),
                        ))
                    : IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          log.d(isIcon);
                          setState(() {
                            isIcon = !isIcon;
                          });
                        },
                        // ignore: prefer_const_constructors
                        icon: const Icon(
                          size: 20,
                          Icons.favorite_border_sharp,
                        ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:balti_app/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../widgets/product_card.dart';
import '../restaurant_card.dart';
import '../../models/business.dart';
import '../../models/product.dart';
import '../../providers/business_provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/size_config.dart';

var log = Logger();

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  late Future<void> getBusinesses;
  late Future<void> getProducts;
  @override
  void initState() {
    super.initState();
    getBusinesses =
        Provider.of<Businesses>(context, listen: false).fetchAndSetBusinesses();
    getProducts =
        Provider.of<Products>(context, listen: false).findAllProducts();
    Future.delayed(const Duration(seconds: 0), () async {
      await Provider.of<Location>(context, listen: false)
          .setLocation()
          .then((value) => setState(() {
                getBusinesses = Provider.of<Businesses>(context, listen: false)
                    .getAllBusinessesInRadius(
                        Provider.of<Location>(context, listen: false).lng,
                        Provider.of<Location>(context, listen: false).lat);
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return FutureBuilder(
        future: getBusinesses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Business> businesses = context.watch<Businesses>().businesses;
            Provider.of<Products>(context, listen: false)
                .filterProducts(businesses.map((e) => e.id).toList());
            List<Product> products = context.watch<Products>().filteredProducts;
            return SafeArea(
              child: context.watch<Businesses>().businesses.isEmpty
                  ? Center(
                      child: Text(
                      "No Businesses",
                      style: TextStyle(
                          fontSize: mediaQuery.size.width * 0.05,
                          color: Colors.black),
                    ))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: SizeConfig.screenHeight / 29,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.screenWidth / 24),
                            child: const Text(
                              'Trending near you',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight / 72.5,
                          ),
                          Container(
                            height: SizeConfig.screenHeight / 4.53125,
                            margin: EdgeInsets.only(
                              left: SizeConfig.screenWidth / 36,
                            ),
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: businesses.length,
                              itemBuilder: (BuildContext ctx, int i) {
                                return RestaurantCard(
                                  restaurantName: businesses[i].name,
                                  imagePath: businesses[i].imageUrl,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight / 29,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.screenWidth / 24),
                            child: const Text(
                              'Top products',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight / 72.5,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: SizeConfig.screenWidth / 36,
                              right: SizeConfig.screenWidth / 36,
                              bottom: SizeConfig.screenHeight / 72.5,
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1 / 1.08,
                                crossAxisSpacing: SizeConfig.screenWidth / 24,
                                mainAxisSpacing:
                                    SizeConfig.screenHeight / 48.33,
                              ),
                              itemCount: products.length,
                              itemBuilder: (BuildContext ctx, int i) {
                                return ProductCard(
                                  productName: products[i].name,
                                  price: products[i].price,
                                  delay: '${products[i].duration.toInt()} min',
                                  isFav: false,
                                  imageUrl: products[i].images[0] ??
                                      'assets/images/food_1.jpeg',
                                  images: products[i].images,
                                  userId: "63d134f3ae6ba6c5e178e3ca",
                                  businessId: products[i].businessId,
                                  productId: products[i].id,
                                );
                              },
                            ),
                          ),
                          // Gridview for top products
                        ],
                      ),
                    ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

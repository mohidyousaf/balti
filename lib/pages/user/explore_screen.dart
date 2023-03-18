import 'package:balti_app/providers/location_provider.dart';
import 'package:balti_app/widgets/DashScreensContent/searchBar.dart';
import 'package:balti_app/widgets/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:balti_app/themes/colors.dart';
import 'package:balti_app/themes/fonts.dart';
import 'package:balti_app/themes/spacingAndBorders.dart';
import '../../../widgets/product_card.dart';
import '../../models/business.dart';
import '../../models/product.dart';
import '../../providers/business_provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/size_config.dart';

class ExploreBody extends StatefulWidget {
  const ExploreBody({
    Key? key,
  }) : super(key: key);

  @override
  State<ExploreBody> createState() => _ExploreBodyState();
}

class _ExploreBodyState extends State<ExploreBody> {
  late Future<void> getBusinesses;
  late Future<void> getProducts;
  @override
  void initState() {
    super.initState();
    getProducts =
        Provider.of<Products>(context, listen: false).findAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return FutureBuilder(
        future: getProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Product> products = context.watch<Products>().products;
            return SafeArea(
              child: context.watch<Businesses>().businesses.isEmpty
                  ? Center(
                      child: Text(
                      "No Businesses",
                      style: TextStyle(
                          fontSize: mediaQuery.size.width * 0.05,
                          color: Color.fromARGB(255, 255, 255, 255)),
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
                              'Explore products',
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
                            child: products.isEmpty
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1 / 1.08,
                                      crossAxisSpacing:
                                          SizeConfig.screenWidth / 24,
                                      mainAxisSpacing:
                                          SizeConfig.screenHeight / 48.33,
                                    ),
                                    itemCount: products.length,
                                    itemBuilder: (BuildContext ctx, int i) {
                                      return ProductCard(
                                        productName: products[i].name,
                                        price: products[i].price,
                                        delay:
                                            '${products[i].duration.toInt()} min',
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

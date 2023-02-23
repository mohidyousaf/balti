import 'package:balti_app/models/order.dart';
import 'package:balti_app/pages/seller/add_business.dart';
import 'package:balti_app/pages/seller/add_product.dart';
import 'package:balti_app/pages/seller/business_list.dart';
import 'package:balti_app/pages/seller/feedback.dart';
import 'package:balti_app/pages/seller/order_approval.dart';
import 'package:balti_app/pages/seller/order_completed.dart';
import 'package:balti_app/pages/seller/order_in_progress.dart';
import 'package:balti_app/pages/seller/order_list.dart';
import 'package:balti_app/pages/seller/seller_dashboard.dart';
import 'package:balti_app/pages/user/cart_screen.dart';
import 'package:balti_app/providers/cart_provider.dart';
import 'package:balti_app/providers/order_provider.dart';
import 'package:balti_app/widgets/DashScreensContent/business_detail.dart';
import 'package:balti_app/widgets/DashScreensContent/home_body.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'pages/auth/signup_screen.dart';
import 'pages/seller/edit_product.dart';
import 'pages/user/edit_profile_screen.dart';
import 'pages/user/explore_screen.dart';
import 'pages/user/map_screen.dart';
import 'pages/user/product_detail_screen.dart';
import 'pages/user/settings_screen.dart';
import 'pages/user/user_dash_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/business_provider.dart';
import 'providers/location_provider.dart';
import 'providers/product_provider.dart';
import 'providers/feedback_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'globals.dart' as globals;

var log = Logger();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    initPlatform();
    // sendnotification();
  }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Businesses>(
          create: (_) => Businesses(
            // authToken: '',
            businesses: [],
            userId: '',
          ),
          update: (ctx, auth, previousBusinesses) => Businesses(
            // authToken: 'auth.token!',
            businesses: previousBusinesses == null
                ? []
                : previousBusinesses.getBusinesses,
            userId: auth.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(
                // authToken: ''
                orders: [],
                // orderItems: [],
                userId: ''),
            update: ((context, value, previous) => Orders(
                //  authToken: authToken,
                orders: previous == null ? [] : previous.getOrder,
                //  orderItems: orderItems,
                userId: value.userId))),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(
            authToken: '',
            products: [],
            userId: '',
          ),
          update: (ctx, auth, previousProducts) => Products(
            authToken: 'auth.token!',
            products:
                previousProducts == null ? [] : previousProducts.getProducts,
            userId: auth.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, FeedbackItems>(
          create: (_) => FeedbackItems(
            authToken: '',
            businessFeedback: [],
            productFeedback: [],
            userId: '',
          ),
          update: (ctx, auth, previousFeebackItems) => FeedbackItems(
            authToken: 'auth.token!',
            businessFeedback: previousFeebackItems == null
                ? []
                : previousFeebackItems.getBusinessFeedback,
            productFeedback: previousFeebackItems == null
                ? []
                : previousFeebackItems.getProductFeedback,
            userId: auth.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, UserCart>(
          create: (_) => UserCart(
            authToken: '',
            cartProducts: [],
            userId: '63d134f3ae6ba6c5e178e3ca',
          ),
          update: (ctx, auth, previousCartProducts) => UserCart(
            authToken: 'auth.token!',
            cartProducts: previousCartProducts == null
                ? []
                : previousCartProducts.getCartProducts,
            userId: "63d134f3ae6ba6c5e178e3ca",
          ),
        ),
        ChangeNotifierProvider<Location>(
          create: (_) => Location(),
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        return MaterialApp(
          title: 'Balti App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color.fromARGB(193, 27, 209, 161),
            fontFamily: 'Poppins',
            textTheme: const TextTheme(
              headline3: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              labelMedium: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              subtitle2: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          routes: {
            '/': (ctx) => const UserDashScreen(
                // userId: "61607aa83335d4dd8e75ddc7",
                ),
            '/home': (ctx) => const HomeScreenBody(),
            // '/': (ctx) => const FeedBack(),
            // SignUpScreen.routeName: (ctx) => const SignUpScreen(),
            MapScreen.routeName: (context) => const MapScreen()
          },
        );
      }),
    );
  }
}

Future<void> initPlatform() async {
  try {
    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.setAppId("085fe5f1-7940-4ee0-8447-704b42ae861d");
    print("Getting DeviceState");
    OneSignal.shared.getDeviceState().then((deviceState) {
      log.wtf("DeviceState: ${deviceState?.jsonRepresentation()}");
      String? token = deviceState != null ? deviceState.userId : "";
      globals.notifToken = token;
      log.d(globals.notifToken);
    });

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  } catch (e) {
    print(e);
  }
}

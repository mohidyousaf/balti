import 'package:flutter/cupertino.dart';

class AppBorderRadius{

  // All Corners
  static const BorderRadius all_10 = BorderRadius.all(Radius.circular(10.0));
  static const BorderRadius all_15 = BorderRadius.all(Radius.circular(15.0));
  static const BorderRadius all_20 = BorderRadius.all(Radius.circular(20.0));
  static const BorderRadius all_25 = BorderRadius.all(Radius.circular(25.0));
  static const BorderRadius all_30 = BorderRadius.all(Radius.circular(30.0));
  static const BorderRadius all_50 = BorderRadius.all(Radius.circular(50.0));

  // Top Only
  static const BorderRadius top_10 = BorderRadius.only(
    topRight: Radius.circular(10),
    topLeft: Radius.circular(10)
  );
  static const BorderRadius top_15 = BorderRadius.only(
      topRight: Radius.circular(15),
      topLeft: Radius.circular(15)
  );
  static const BorderRadius top_20 = BorderRadius.only(
      topRight: Radius.circular(20),
      topLeft: Radius.circular(20)
  );
  static const BorderRadius top_25 = BorderRadius.only(
      topRight: Radius.circular(25),
      topLeft: Radius.circular(25)
  );
  static const BorderRadius top_30 = BorderRadius.only(
      topRight: Radius.circular(30),
      topLeft: Radius.circular(30)
  );

  // Bottom Only
  static const BorderRadius bottom_10 = BorderRadius.only(
      bottomRight: Radius.circular(10),
      bottomLeft: Radius.circular(10)
  );
  static const BorderRadius bottom_15 = BorderRadius.only(
      bottomRight: Radius.circular(15),
      bottomLeft: Radius.circular(15)
  );
  static const BorderRadius bottom_20 = BorderRadius.only(
      bottomRight: Radius.circular(20),
      bottomLeft: Radius.circular(20)
  );
  static const BorderRadius bottom_25 = BorderRadius.only(
      bottomRight: Radius.circular(25),
      bottomLeft: Radius.circular(25)
  );
  static const BorderRadius bottom_30 = BorderRadius.only(
      bottomRight: Radius.circular(30),
      bottomLeft: Radius.circular(30)
  );
}

class AppPadding {

}
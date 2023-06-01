import 'package:balti_app/providers/business_provider.dart';
import 'package:flutter/material.dart';
import 'package:balti_app/themes/colors.dart';
import 'package:balti_app/themes/fonts.dart';
import 'package:balti_app/themes/spacingAndBorders.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

var log = Logger();

class SearchBarContainer extends StatelessWidget {
  BuildContext context;
  SearchBarContainer({required this.context});
  @override
  Widget build(BuildContext context) {
    return SearchBar();
  }
}

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        // height: 30,
        decoration: const BoxDecoration(
          borderRadius: AppBorderRadius.all_20,
        ),
        // padding: EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          onChanged: (text) {
            setState(() {
              print(text);
              log.wtf(text);
              Provider.of<Businesses>(context, listen: false)
                  .filterBusinesses(text);
            });
            // BlocProvider.of<ShopBloc>(context).add(widget.event(text));
          },
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.search,
              color: AppColor.gray_light,
            ),
            contentPadding: EdgeInsets.all(10),
            fillColor: AppColor.gray_transparent,
            filled: true,
            hintText: 'Search',
            hintStyle: AppFont.bodySmall(AppColor.gray_light),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.primary),
                borderRadius: AppBorderRadius.all_10),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.gray_transparent),
                borderRadius: AppBorderRadius.all_10),
          ),
        ),
      );
    });
  }
}

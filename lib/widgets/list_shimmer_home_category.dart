import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmerHomeCategory extends StatelessWidget {
  const ListShimmerHomeCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('in shimmer');
    return SingleChildScrollView(
      child: Row(
        children: List<Widget>.generate(
          2,
          (int index) => Expanded(
            child: _item(context),
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context) {
    // print('in shimmer Container');
    return Container(
      height: 75.0,
      margin: EdgeInsets.only(right: 8.0, left: 8.0),
      width: 250.0,
      // padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade100,
        highlightColor: Colors.grey.shade300,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}

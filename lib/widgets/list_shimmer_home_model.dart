import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmerHomeModel extends StatelessWidget {
  const ListShimmerHomeModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return Padding(
      padding: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 10.0,
      ),
      child: Container(
        height: 280.0,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade100,
          highlightColor: Colors.grey.shade300,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }
}

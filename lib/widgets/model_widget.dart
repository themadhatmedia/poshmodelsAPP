import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/model_detail.dart';

class ModelWidget extends StatelessWidget {
  final model;
  final String from;
  ModelWidget(this.model, this.from);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ModelDetail(model, from));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4.0,
        child: Stack(
          children: <Widget>[
            Hero(
              tag: '$from-${model['post_id']}',
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: model['modelImage'],
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 50.0,
                color: Colors.black45,
                child: Center(
                  child: Text(
                    model['post_title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

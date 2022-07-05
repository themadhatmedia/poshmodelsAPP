import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../connection/remote_services.dart';
import '../controllers/home_controller.dart';
import '../utils/utils.dart';

class ModelDetail extends StatefulWidget {
  final model;
  final String from;
  ModelDetail(this.model, this.from);

  @override
  State<ModelDetail> createState() => _ModelDetailState();
}

class _ModelDetailState extends State<ModelDetail> {
  final HomeController controller = Get.put(HomeController());
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController message = TextEditingController();

  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: 100), () {
    //   controller.getModelImages(widget.model['id']);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppUtils.primaryColor,
      backgroundColor: Color(0XFF333333),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            Hero(
              tag: '${widget.from}-${widget.model['post_id']}',
              child: CarouselSlider.builder(
                itemCount: widget.model['mediaList'].length,
                itemBuilder: (BuildContext context, int index, int pageViewIndex) {
                  var image = widget.model['mediaList'][index];
                  return CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: image,
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  aspectRatio: 0.8,
                  autoPlay: true,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 60.0,
              color: Colors.black45,
              child: Center(
                child: Text(
                  widget.model['post_title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
            DetailContainer(
              AppUtils.primaryColor,
              'Height',
              widget.model['height'] == null || widget.model['height'] == '' ? 'N/A' : widget.model['height'],
            ),
            DetailContainer(
              AppUtils.secondaryColor,
              'Bust',
              widget.model['bust'] == null || widget.model['bust'] == '' ? 'N/A' : widget.model['bust'],
            ),
            DetailContainer(
              AppUtils.primaryColor,
              'Cup Size',
              widget.model['cup-size'] == null || widget.model['cup-size'] == '' ? 'N/A' : widget.model['cup-size'],
            ),
            DetailContainer(
              AppUtils.secondaryColor,
              'Waist',
              widget.model['waist'] == null || widget.model['waist'] == '' ? 'N/A' : widget.model['waist'],
            ),
            DetailContainer(
              AppUtils.primaryColor,
              'Hips',
              widget.model['hips'] == null || widget.model['hips'] == '' ? 'N/A' : widget.model['hips'],
            ),
            DetailContainer(
              AppUtils.secondaryColor,
              'Eye Color',
              widget.model['eye-color'] == null || widget.model['eye-color'] == '' ? 'N/A' : widget.model['eye-color'],
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Book This Model',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: name,
                style: TextStyle(
                  fontSize: 20.0,
                  color: AppUtils.labelColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Your Name',
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: phone,
                style: TextStyle(
                  fontSize: 20.0,
                  color: AppUtils.labelColor,
                ),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: email,
                style: TextStyle(
                  fontSize: 20.0,
                  color: AppUtils.labelColor,
                ),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: message,
                style: TextStyle(
                  fontSize: 20.0,
                  color: AppUtils.labelColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Booking Details',
                ),
                minLines: 5,
                maxLines: 7,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (name.text.isEmpty) {
                      RemoteServices().showToast('Please enter name');
                    } else if (phone.text.isEmpty) {
                      RemoteServices().showToast('Please enter phone number');
                    } else if (email.text.isEmpty || !GetUtils.isEmail(email.text)) {
                      RemoteServices().showToast('Please enter proper email');
                    } else if (message.text.isEmpty) {
                      RemoteServices().showToast('Please enter booking details');
                    } else {
                      var sendBookingRequest = await RemoteServices().sendBookingRequest(widget.model['post_id'].toString(), name.text, email.text, phone.text, message.text);
                      print('sendBookingRequest: $sendBookingRequest');
                      if (sendBookingRequest != null) {
                        if (sendBookingRequest['success'] != null && sendBookingRequest['success']) {
                          RemoteServices().showToast('Your booking request sent successfully');
                          name.clear();
                          phone.clear();
                          email.clear();
                          message.clear();
                          setState(() {});
                        } else if (sendBookingRequest['success'] != null && !sendBookingRequest['success']) {
                          RemoteServices().showToast(sendBookingRequest['message']);
                        }
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppUtils().borderColor),
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailContainer extends StatelessWidget {
  final Color bgColor;
  final String left;
  final String right;
  DetailContainer(this.bgColor, this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              left,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              right,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as mydio;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class RemoteServices {
  static var baseURL = 'https://poshmodelagency.com/wp-json/wp/v2';
  static var customBaseURL = 'https://poshmodelagency.com/wp-json/posh/v2';
  // static var fieldsURL = 'https://agaphey.com/wp-json'; // https://agaphey.com/wp-json/buddypress/v1/xprofile/fields
  static var client = http.Client();
  static var header = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  late ProgressDialog pr;
  final box = GetStorage('poshmodels');

  void showToast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      // backgroundColor: Colors.red,
      // textColor: Colors.white,
      // fontSize: 16.0,
    );
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      showToast('No internet connection');
      return false;
    }
    return false;
  }

  ProgressDialog showDialog({customMsg}) {
    pr = ProgressDialog(
      Get.context!,
      type: ProgressDialogType.normal,
      isDismissible: true,
      showLogs: false,
      customBody: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              width: 20.0,
            ),
            Text(
              customMsg ?? 'Processing please wait...',
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    pr.style(
      backgroundColor: Colors.white,
    );
    return pr;
  }

  void showResponseCodeMsg({errorCode}) {
    var pr = RemoteServices().showDialog();
    if (pr.isShowing()) pr.hide();
    if (errorCode != null && errorCode == 500) {
      showToast('Something is wrong at our end! Please try again later');
    } else if (errorCode != null && errorCode == 404) {
      showToast('Service Not Found');
    } else {
      // showToast(AppUtils().snackbarErrorMessage);
    }
  }

  Future getCategories() async {
    if (await checkInternet()) {
      var response = await client.get(
        Uri.parse('$baseURL/modeling-categories'),
        headers: header,
      );
      print('getCategories.statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        var jsonString = response.body;
        return json.decode(jsonString);
      } else if (response.statusCode == 500) {
        print('getCategories');
        showResponseCodeMsg(errorCode: 500);
        return null;
      } else if (response.statusCode == 400) {
        var jsonString = response.body;
        var res = json.decode(jsonString);
        showToast(res['message']);
        return res;
      } else {
        showResponseCodeMsg(errorCode: response.statusCode);
        return null;
      }
    } else {
      return null;
    }
  }

  Future getModels(page) async {
    if (await checkInternet()) {
      var response = await client.get(
        Uri.parse('$baseURL/posh-models?per_page=12&page=$page&order=asc&orderby=title'),
        headers: header,
      );
      print('getModels.statusCode: ${response.statusCode}');
      print('URL: $baseURL/posh-models?per_page=12&page=$page&order=asc&orderby=title');
      if (response.statusCode == 200) {
        var jsonString = response.body;
        return json.decode(jsonString);
      } else if (response.statusCode == 401) {
        return 'no-data';
      } else if (response.statusCode == 500) {
        print('getModels');
        showResponseCodeMsg(errorCode: 500);
        return null;
      } else if (response.statusCode == 400) {
        return 'no-data';
      } else {
        showResponseCodeMsg(errorCode: response.statusCode);
        return null;
      }
    } else {
      return null;
    }
  }

  Future getModelsCustom(page, search) async {
    if (await checkInternet()) {
      var response = await client.get(
        Uri.parse('$customBaseURL/poshmodel_search?per_page=12&page=$page&order=asc&orderby=title&search=$search'),
        headers: header,
      );
      print('getModelsCustom.statusCode: ${response.statusCode}');
      print('URL: $customBaseURL/poshmodel_search?per_page=12&page=$page&order=asc&orderby=title&search=$search');
      if (response.statusCode == 200) {
        var jsonString = response.body;
        return json.decode(jsonString);
      } else if (response.statusCode == 401) {
        return 'no-data';
      } else if (response.statusCode == 500) {
        print('getModelsCustom');
        showResponseCodeMsg(errorCode: 500);
        return null;
      } else if (response.statusCode == 400) {
        return 'no-data';
      } else {
        showResponseCodeMsg(errorCode: response.statusCode);
        return null;
      }
    } else {
      return null;
    }
  }

  Future getMedia(mediaId) async {
    if (await checkInternet()) {
      var response = await client.get(
        Uri.parse('$baseURL/media/$mediaId'),
        headers: header,
      );
      print('getMedia.statusCode: $baseURL/media/$mediaId - ${response.statusCode}');
      if (response.statusCode == 200) {
        var jsonString = response.body;
        return json.decode(jsonString);
      } else if (response.statusCode == 500) {
        print('getMedia');
        showResponseCodeMsg(errorCode: 500);
        return null;
      } else if (response.statusCode == 400) {
        var jsonString = response.body;
        var res = json.decode(jsonString);
        showToast(res['message']);
        return res;
      } else {
        showResponseCodeMsg(errorCode: response.statusCode);
        return null;
      }
    } else {
      return null;
    }
  }

  Future getModelsByCategory(categoryId, page) async {
    if (await checkInternet()) {
      var response = await client.get(
        Uri.parse('$baseURL/posh-models?per_page=12&modeling-categories=$categoryId&page=$page&order=asc&orderby=title'),
        headers: header,
      );
      print('getModelsByCategory.statusCode: ${response.statusCode}');
      print('URL: $baseURL/posh-models?per_page=12&modeling-categories=$categoryId&page=$page&order=asc&orderby=title');
      if (response.statusCode == 200) {
        var jsonString = response.body;
        return json.decode(jsonString);
      } else if (response.statusCode == 500) {
        print('getModelsByCategory');
        showResponseCodeMsg(errorCode: 500);
        return null;
      } else if (response.statusCode == 400) {
        return 'no-data';
      } else {
        showResponseCodeMsg(errorCode: response.statusCode);
        return null;
      }
    } else {
      return null;
    }
  }

  Future getModelsByCategoryCustom(categoryId, page, search) async {
    if (await checkInternet()) {
      var response = await client.get(
        Uri.parse('$customBaseURL/poshmodel_category_search?per_page=12&category=$categoryId&page=$page&order=asc&orderby=title&search=$search'),
        headers: header,
      );
      print('getModelsByCategoryCustom.statusCode: ${response.statusCode}');
      print('URL: $customBaseURL/poshmodel_category_search?per_page=12&category=$categoryId&page=$page&order=asc&orderby=title&search=$search');
      if (response.statusCode == 200) {
        var jsonString = response.body;
        return json.decode(jsonString);
      } else if (response.statusCode == 500) {
        print('getModelsByCategoryCustom');
        showResponseCodeMsg(errorCode: 500);
        return null;
      } else if (response.statusCode == 400) {
        return 'no-data';
      } else {
        showResponseCodeMsg(errorCode: response.statusCode);
        return null;
      }
    } else {
      return null;
    }
  }

  Future getModelImages(modelId) async {
    if (await checkInternet()) {
      var response = await client.post(
        Uri.parse('$customBaseURL/poshmodel_images'),
        headers: header,
        body: jsonEncode(
          <String, String>{
            'pid': modelId.toString(),
          },
        ),
      );
      print('getModelImages.statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        var jsonString = response.body;
        return json.decode(jsonString);
      } else if (response.statusCode == 500) {
        print('getModelImages');
        showResponseCodeMsg(errorCode: 500);
        return null;
      } else if (response.statusCode == 400) {
        var jsonString = response.body;
        var res = json.decode(jsonString);
        showToast(res['message']);
        return res;
      } else {
        showResponseCodeMsg(errorCode: response.statusCode);
        return null;
      }
    } else {
      return null;
    }
  }

  Future sendBookingRequest(postId, name, email, phone, message) async {
    var pr = RemoteServices().showDialog();
    header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': box.read('cookie'),
    };
    print(Uri.parse('$customBaseURL/save_form'));
    if (await checkInternet()) {
      await pr.show();
      var dio = mydio.Dio();
      dio.options.headers['content-Type'] = 'multipart/form-data';
      dio.options.headers['Cookie'] = box.read('cookie');

      var formData = mydio.FormData.fromMap({
        'post_id': postId,
        'name': name,
        'email': email,
        'phone': phone,
        'message': message,
      });

      var response = await dio.post(
        '$customBaseURL/save_form',
        data: formData,
      );

      print('sendBookingRequest.statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        await pr.hide();
        var jsonString = response.data;
        return jsonString;
      } else if (response.statusCode == 500) {
        await pr.hide();
        print('sendBookingRequest');
        showResponseCodeMsg(errorCode: 500);
        return null;
      } else {
        await pr.hide();
        showResponseCodeMsg(errorCode: response.statusCode);
        return null;
      }
    } else {
      await pr.hide();
      return null;
    }
  }
}

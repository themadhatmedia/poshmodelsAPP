import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../connection/remote_services.dart';
import '../utils/utils.dart';

class HomeController extends GetxController {
  var pr = RemoteServices().showDialog();
  var isGettingCategories = true.obs;
  var isGettingCategoryModel = true.obs;
  var isGettingModels = true.obs;
  var isGettingModelImages = true.obs;
  var categoryList = [].obs;
  var categoryModelList = [].obs;
  var modelsList = [].obs;
  var galleryList = [].obs;
  var searchingModels = false.obs;
  var searchingCateoryModels = false.obs;
  final TextEditingController search = TextEditingController();
  final TextEditingController searchCategoryModel = TextEditingController();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  RefreshController categoryRefreshController = RefreshController(initialRefresh: false);
  var page = 1.obs;
  var catPage = 1.obs;

  void getCategories() async {
    try {
      isGettingCategories(true);
      categoryList.clear();
      var res = await RemoteServices().getCategories();
      print('getCategories: $res');
      if (res != null) {
        for (var i = 0; i < res.length; i++) {
          var cat = res[i];
          categoryList.add(cat);
        }
        isGettingCategories(false);
      } else {
        isGettingCategories(false);
      }
    } catch (e) {
      isGettingCategories(false);
      print(e.toString());
      RemoteServices().showToast(AppUtils().snackbarErrorMessage);
    }
  }

  void getModels() async {
    try {
      if (page.value == 1) isGettingModels(true);
      if (page.value == 1) modelsList.clear();
      var res = await RemoteServices().getModelsCustom(page.value, search.text);
      print('getModels: $res');
      if (res != null && res['data']['results'] != null) {
        for (var i = 0; i < res['data']['results'].length; i++) {
          var model = res['data']['results'][i];
          // var primaryImage = model['meta']['primary-image'];
          var thumbnail = 'https://i.ibb.co/RcmBjHg/mannequin-5885693-960-720.webp';
          var getMedia = await RemoteServices().getModelImages(model['post_id']);
          var mediaList = [];
          if (getMedia != null && getMedia['success']) {
            if (getMedia['data']['images'] != null) thumbnail = getMedia['data']['images']['pimage'];
            for (final images in getMedia['data']['images'].entries) {
              // final key = images.key;
              final value = images.value;
              // print('key: $key');
              // print('image: $value');
              mediaList.add(value);
            }
          }
          model['modelImage'] = thumbnail;
          model['mediaList'] = mediaList;
          modelsList.add(model);
        }
        if (page.value == 1) isGettingModels(false);
        page.value++;
        refreshController.loadComplete();
        refreshController.refreshCompleted();
      } else {
        if (page.value == 1) isGettingModels(false);
        refreshController.loadComplete();
        refreshController.refreshCompleted();
        refreshController.loadNoData();
      }
    } catch (e) {
      if (page.value == 1) isGettingModels(false);
      refreshController.loadComplete();
      refreshController.refreshCompleted();
      refreshController.loadNoData();
      print(e.toString());
      RemoteServices().showToast(AppUtils().snackbarErrorMessage);
    }
  }

  void getModelsByCategory(categoryId) async {
    try {
      if (catPage.value == 1) isGettingCategoryModel(true);
      if (catPage.value == 1) categoryModelList.clear();
      var res = await RemoteServices().getModelsByCategoryCustom(categoryId, catPage.value, searchCategoryModel.text);
      print('getModelsByCategory: $res');
      if (res != null && res['data']['results'] != null) {
        for (var i = 0; i < res['data']['results'].length; i++) {
          var model = res['data']['results'][i];
          // var primaryImage = model['meta']['primary-image'];
          var thumbnail = 'https://i.ibb.co/RcmBjHg/mannequin-5885693-960-720.webp';
          var mediaList = [];
          var getMedia = await RemoteServices().getModelImages(model['post_id']);
          if (getMedia != null && getMedia['success']) {
            if (getMedia['data']['images'] != null) thumbnail = getMedia['data']['images']['pimage'];
            for (final images in getMedia['data']['images'].entries) {
              // final key = images.key;
              final value = images.value;
              // print('key: $key');
              // print('image: $value');
              mediaList.add(value);
            }
          }
          model['modelImage'] = thumbnail;
          model['mediaList'] = mediaList;
          categoryModelList.add(model);
        }
        if (catPage.value == 1) isGettingCategoryModel(false);
        catPage.value++;
        categoryRefreshController.loadComplete();
        categoryRefreshController.refreshCompleted();
      } else {
        if (catPage.value == 1) isGettingCategoryModel(false);
        categoryRefreshController.loadComplete();
        categoryRefreshController.refreshCompleted();
        categoryRefreshController.loadNoData();
      }
    } catch (e) {
      if (catPage.value == 1) isGettingCategoryModel(false);
      categoryRefreshController.loadComplete();
      categoryRefreshController.refreshCompleted();
      categoryRefreshController.loadNoData();
      print(e.toString());
      RemoteServices().showToast(AppUtils().snackbarErrorMessage);
    }
  }

  void getModelImages(modelId) async {
    try {
      isGettingModelImages(true);
      galleryList.clear();
      var res = await RemoteServices().getModelImages(modelId);
      print('getModelImages: $res');
      if (res != null && res['success']) {
        for (final images in res['data']['images'].entries) {
          final key = images.key;
          final value = images.value;
          print('key: $key');
          print('image: $value');
          galleryList.add(value);
        }
        isGettingModelImages(false);
      } else {
        isGettingModelImages(false);
      }
    } catch (e) {
      isGettingModelImages(false);
      print(e.toString());
      RemoteServices().showToast(AppUtils().snackbarErrorMessage);
    }
  }
}

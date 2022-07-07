import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/home_controller.dart';
import '../utils/utils.dart';
import '../widgets/list_shimmer_home_model.dart';
import '../widgets/model_widget.dart';

class CategoryModels extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  CategoryModels(this.categoryId, this.categoryName);

  @override
  State<CategoryModels> createState() => _CategoryModelsState();
}

class _CategoryModelsState extends State<CategoryModels> {
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () {
      controller.catPage(1);
      controller.searchCategoryModel.clear();
      controller.searchingCateoryModels(false);
      controller.getModelsByCategory(widget.categoryId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF333333),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          print('search model');
          // Future.delayed(Duration(milliseconds: 500), () {
          //   setState(() {
          //     autoFocus = true;
          //   });
          // });
          await showGeneralDialog(
            barrierLabel: "Label",
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionDuration: Duration(milliseconds: 700),
            context: context,
            pageBuilder: (context, anim1, anim2) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.75,
                  width: MediaQuery.of(context).size.width,
                  child: Scaffold(
                    backgroundColor: Colors.grey.shade200,
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 12.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Search Model',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 30.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextField(
                              controller: controller.searchCategoryModel,
                              // autofocus: autoFocus,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: AppUtils.labelColor,
                              ),
                              decoration: InputDecoration(
                                // labelText: 'Search',
                                hintText: 'type model name...',
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        controller.catPage(1);
                                        controller.searchCategoryModel.clear();
                                        controller.getModelsByCategory(widget.categoryId);
                                        controller.searchingCateoryModels(false);
                                        Get.back();
                                        setState(() {});
                                      },
                                      child: Text(
                                        'Reset Search',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        controller.catPage(1);
                                        controller.getModelsByCategory(widget.categoryId);
                                        Get.back();
                                        controller.searchingCateoryModels(true);
                                        setState(() {});
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                                      ),
                                      child: Text(
                                        'Search',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            transitionBuilder: (context, anim1, anim2, child) {
              return SlideTransition(
                position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                child: child,
              );
            },
          );
        },
        child: Container(
          height: 70.0,
          color: AppUtils.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                color: Colors.white,
                size: 30.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'Search Model',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            /// title container
            Container(
              margin: const EdgeInsets.only(
                top: 20.0,
                left: 15.0,
                right: 15.0,
                bottom: 20.0,
              ),
              child: Center(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    Spacer(),
                    Text(
                      widget.categoryName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 33.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),

            Obx(() {
              return Visibility(
                visible: !controller.searchingCateoryModels.value && controller.searchCategoryModel.text.isEmpty ? false : true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 0.0),
                  child: Text(
                    'Search results for: ${controller.searchCategoryModel.text}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),

            /// models container
            Obx(() {
              if (controller.isGettingCategoryModel.value) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 20.0),
                    ListShimmerHomeModel(),
                    SizedBox(height: 20.0),
                    ListShimmerHomeModel(),
                    SizedBox(height: 20.0),
                    ListShimmerHomeModel(),
                    SizedBox(height: 20.0),
                    ListShimmerHomeModel(),
                  ],
                );
              } else if (controller.categoryModelList.isEmpty) {
                return Container(
                  height: MediaQuery.of(context).size.height - 200.0,
                  child: Center(
                    child: Text(
                      'No Model Found',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return Container(
                height: MediaQuery.of(context).size.height - 120.0,
                child: SmartRefresher(
                  controller: controller.categoryRefreshController,
                  footer: ClassicFooter(
                    loadingText: 'Loading more data',
                    noDataText: 'No more data available',
                    loadStyle: LoadStyle.ShowAlways,
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () async {
                    print('onRefresh');
                    controller.catPage(1);
                    controller.getModelsByCategory(widget.categoryId);
                  },
                  onLoading: () async {
                    print('onLoading');
                    controller.getModelsByCategory(widget.categoryId);
                  },
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(15.0),
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.75,
                    children: [
                      ...controller.categoryModelList.map((model) {
                        return ModelWidget(model, 'category');
                      }),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

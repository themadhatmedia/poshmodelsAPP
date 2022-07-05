import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/home_controller.dart';
import '../utils/utils.dart';
import '../widgets/list_shimmer_home_category.dart';
import '../widgets/list_shimmer_home_model.dart';
import '../widgets/model_widget.dart';
import 'category_models.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());
  bool autoFocus = false;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () {
      controller.searchingModels(false);
      controller.getCategories();
      controller.getModels();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppUtils.primaryColor,
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
                              controller: controller.search,
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
                                        controller.page(1);
                                        controller.search.clear();
                                        controller.getModels();
                                        controller.searchingModels(false);
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
                                        controller.page(1);
                                        controller.getModels();
                                        controller.searchingModels(true);
                                        Get.back();
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
            /// logo container
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Image.asset(
                'assets/images/logo.png',
                height: 80.0,
                width: 80.0,
              ),
            ),

            /// category container
            // Padding(
            //   padding: const EdgeInsets.only(
            //     top: 10.0,
            //     left: 15.0,
            //     right: 15.0,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text(
            //         'Model Categories',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //           fontSize: 25.0,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              height: 75.0,
              child: Obx(() {
                if (controller.isGettingCategories.value) {
                  return ListShimmerHomeCategory();
                } else if (controller.categoryList.isEmpty) {
                  return Container(
                    height: 75.0,
                    child: Center(
                      child: Text(
                        'No Category Found',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(left: 15.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var category = controller.categoryList[index];

                    return Container(
                      margin: EdgeInsets.only(right: 8.0, bottom: 8.0),
                      width: 250.0,
                      child: GestureDetector(
                        onTap: () {
                          controller.catPage(1);
                          Get.to(CategoryModels(category['id'].toString(), category['name'].toString().capitalize!));
                        },
                        child: Card(
                          elevation: 4.0,
                          color: AppUtils.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: ListTile(
                            title: Text(
                              category['name'].toString().capitalize!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            /// models container
            // Padding(
            //   padding: const EdgeInsets.only(
            //     top: 25.0,
            //     left: 15.0,
            //     right: 15.0,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text(
            //         'Models',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //           fontSize: 25.0,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Obx(() {
              return Visibility(
                visible: !controller.searchingModels.value && controller.search.text.isEmpty ? false : true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 0.0),
                  child: Text(
                    'Search results for: ${controller.search.text}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
            Obx(() {
              if (controller.isGettingModels.value) {
                return Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListShimmerHomeModel(),
                      SizedBox(height: 20.0),
                      ListShimmerHomeModel(),
                      SizedBox(height: 20.0),
                      ListShimmerHomeModel(),
                    ],
                  ),
                );
              } else if (controller.modelsList.isEmpty) {
                return Container(
                  height: MediaQuery.of(context).size.height - 250.0,
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
                height: MediaQuery.of(context).size.height - 320.0,
                // margin: EdgeInsets.only(top: 10.0),
                child: SmartRefresher(
                  controller: controller.refreshController,
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
                    controller.page(1);
                    controller.getModels();
                  },
                  onLoading: () async {
                    print('onLoading');
                    controller.getModels();
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
                      ...controller.modelsList.map((model) {
                        return ModelWidget(model, 'home');
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

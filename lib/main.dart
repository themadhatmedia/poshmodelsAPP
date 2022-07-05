import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'utils/utils.dart';
import 'views/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('poshmodels');
  runApp(PoshModels());
}

class PoshModels extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => MaterialClassicHeader(
        backgroundColor: Colors.white,
        color: AppUtils.primaryColor,
      ),
      headerTriggerDistance: 80.0,
      springDescription: SpringDescription(
        stiffness: 170,
        damping: 16,
        mass: 1.9,
      ),
      maxOverScrollExtent: 100,
      maxUnderScrollExtent: 0,
      enableLoadingWhenFailed: true,
      hideFooterWhenNotFull: true,
      enableBallisticLoad: true,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: GetMaterialApp(
          title: 'Posh Models',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: AppUtils.primaryColor,
            textTheme: GoogleFonts.montserratTextTheme(),
            // fontFamily: 'SFProText',
            // textTheme: GoogleFonts.nunitoSansTextTheme(),
            inputDecorationTheme: InputDecorationTheme(
              isDense: false,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIconColor: AppUtils.labelColor,
              errorStyle: TextStyle(
                fontSize: 15.0,
              ),
              hintStyle: TextStyle(
                color: AppUtils.labelColor,
                fontSize: 20.0,
              ),
              labelStyle: TextStyle(
                color: AppUtils.labelColor,
                fontSize: 20.0,
              ),
              // contentPadding: EdgeInsets.symmetric(
              //   vertical: 18.0,
              //   horizontal: 10.0,
              // ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppUtils().borderColor,
                ),
                // borderRadius: BorderRadius.circular(30.0),
                borderRadius: BorderRadius.zero,
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppUtils().borderColor,
                ),
                // borderRadius: BorderRadius.circular(30.0),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppUtils().borderColor,
                ),
                // borderRadius: BorderRadius.circular(30.0),
                borderRadius: BorderRadius.zero,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppUtils().borderColor,
                ),
                borderRadius: BorderRadius.zero,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor: MaterialStateProperty.all(AppUtils.primaryColor),
                elevation: MaterialStateProperty.all(0.0),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(
                    vertical: 18.0,
                  ),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                // side: MaterialStateProperty.all(
                //   BorderSide(
                //     color: AppUtils().borderColor,
                //     width: 1.5,
                //   ),
                // ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ),
          builder: (context, widget) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: ResponsiveWrapper.builder(
              ScrollConfiguration(
                behavior: MyBehavior(),
                child: widget!,
              ),
              maxWidth: 1200,
              minWidth: 480,
              defaultScale: true,
              debugLog: false,
              breakpoints: [
                const ResponsiveBreakpoint.resize(480, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ],
            ),
          ),
          home: HomePage(),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

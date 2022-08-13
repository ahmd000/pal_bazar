import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pal_bazar/configers/images_config.dart';
import 'package:pal_bazar/helpers/helpers.dart';
import 'package:pal_bazar/screens/nav_bar_screens/info_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../helpers/dialog_helper.dart';

import '../helpers/fb_notifications.dart';
import '../widgets/text_app.dart';

class PersistentBottomNavBarScreen extends StatefulWidget {
  const PersistentBottomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<PersistentBottomNavBarScreen> createState() =>
      _PersistentBottomNavBarScreenState();
}

class _PersistentBottomNavBarScreenState
    extends State<PersistentBottomNavBarScreen> with Helpers, showDialogHelper , FbNotifications {
  late PersistentTabController _controller;

  DateTime timeBackPressed = DateTime.now();
  bool isLoading = false;
  bool  hasInternet = false  ;
  late WebViewController webViewControllerController;

  late WebViewController controller;
  late StreamSubscription _streamSubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
void forgroundMessage(){
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.senderId}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    requestNotificationPermissions();
    initializeForegroundNotificationForAndroid();
    manageNotificationAction();




    forgroundMessage();

    _controller = PersistentTabController(initialIndex: 1);

FirebaseMessaging.instance.getToken().then((value) {
  print(" token is    ${value}") ;
});

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity(); }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
    print(result);
    if (result == ConnectivityResult.wifi ||result == ConnectivityResult.mobile ) {
      setState(() {
        hasInternet = true;
      });
    }
  }

  List<Widget> _buildScreens() {
    return [
      homeWebViewScreen(),
       ordersDonScreen(),
      const InfoScreen(),
    ];
  }

  Widget ordersDonScreen() {
    return hasInternet == true
        ? WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: multiPages,
            onPageStarted: (s) {
              setState(() {
                isLoading = true;
              });
            },
            onPageFinished: (f) {
              setState(() {
                isLoading = false;
              });
            },
            onWebViewCreated: (controller) {
              this.controller = controller;
            },
            zoomEnabled: true,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            allowsInlineMediaPlayback: true,
            debuggingEnabled: false,
            gestureNavigationEnabled: true,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith("https://wa.me/")) {
                print(request.url);
                launch(request.url);
                return NavigationDecision.prevent;
              } else if (!Platform.isIOS) {
                if (request.url.contains("twitter")) {
                  launch(request.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              } else if (request.url.contains("instagram")) {
                launch(request.url);
                return NavigationDecision.prevent;
              } else if (request.url.contains("snapchat")) {
                launch(request.url);
                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            })
        : noConnection();
  }

  Center noConnection() {
    return Center(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(noInternet),
            TextApp(
              text: "لايوجد اتصال بالانترنت!",
              fontSize: 30.sp,
              fontColor: Colors.lightGreen,
            )
          ],
        ),
      ),
    );
  }

  homeWebViewScreen() {



    return hasInternet ==true
        ? WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: mainPage,
            onPageStarted: (s) {
              setState(() {
                isLoading = true;
              });
            },
            gestureRecognizers: Set()
              ..add(
                  Factory<TapGestureRecognizer>(() => TapGestureRecognizer())),
            onPageFinished: (f) {
              setState(() {
                isLoading = false;
              });
            },
            onWebViewCreated: (controller) {
              this.controller = controller;
            },
            zoomEnabled: true,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            allowsInlineMediaPlayback: true,
            debuggingEnabled: false,
            gestureNavigationEnabled: true,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith("https://wa.me/")) {
                print(request.url);
                launch(request.url);
                return NavigationDecision.prevent;
              } else if (!Platform.isIOS) {
                if (request.url.contains("twitter")) {
                  launch(request.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              } else if (request.url.contains("instagram")) {
                launch(request.url);
                return NavigationDecision.prevent;
              } else if (request.url.contains("snapchat")) {
                launch(request.url);
                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            })
        : noConnection();
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),

        title: ("الصفحة الرئيسية"),
        activeColorPrimary: Colors.green,
        inactiveIcon: Icon(
          Icons.home_outlined,
          color: Colors.grey.shade400,
        ),

        // inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        activeColorSecondary: Colors.grey,
        // inactiveColorSecondary: Colors.grey,
        icon: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        title: ("سلة الشراء"),
        textStyle: TextStyle(fontSize: 13.sp),
        iconSize: 30.sp,
        activeColorPrimary: Colors.green,

        onSelectedTabPressWhenNoScreensPushed: () {
          setState(() {
            multiPages = ordersScreen;
          });
          Navigator.pushReplacementNamed(context, "/NavBarScreen");
        },
        inactiveColorPrimary: Colors.grey,
        inactiveIcon: Icon(
          Icons.shopping_cart_outlined,
          color: Colors.grey.shade100,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.info),
        title: ("من نحن"),
        activeColorPrimary: Colors.green,
        onPressed: null,
        inactiveIcon: Icon(
          Icons.info_outlined,
          color: Colors.grey.shade400,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final differences = DateTime.now().difference(timeBackPressed);
        final isExitWarning = differences >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          if (await controller.canGoBack()) {
            controller.goBack();
            return false;
          }
          const msg = "يرجى الضغط مرة اخرى للخروج من البازار !";
          print(msg);
          showSnackBar(context: context, message: msg, error: false);
          return false;
        } else if (!isExitWarning) {
          return true;
        }
        return false;
      },
      child: Scaffold(
        drawer: buildDrawerApp(context),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(35.h),
          child: AppBar(
            backgroundColor: Colors.grey.shade200,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.green, size: 20.sp),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      multiPages = mainPage;
                    });
                    Navigator.pushReplacementNamed(context, "/NavBarScreen");
                  },
                  icon: const Icon(
                    Icons.home_outlined,
                    color: Colors.green,
                  ))
            ],
          ),
        ),
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.grey.shade300,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(15.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          hideNavigationBar: false,
          itemAnimationProperties: const ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),

            curve: Curves.easeInBack,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.easeOut,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style16,
        ),
      ),
    );
  }

  Drawer buildDrawerApp(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.sp),
          side: BorderSide(
            width: 4.sp,
            color: Colors.green.shade300,
          )),
      elevation: 10.sp,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 70.sp, horizontal: 20.sp),
        children: [
          Container(
            // backgroundImage: AssetImage("assets/images/logo.jpeg"  , ),
            height: 250.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.sp),
                image: const DecorationImage(
                    image: AssetImage(
                      "assets/images/logo.jpeg",
                    ),
                    fit: BoxFit.fill)),
          ),
          SizedBox(
            height: 30.h,
          ),
          ListTile(
            onTap: () {
              setState(() {
                multiPages = loginScreen;
              });
              Navigator.pushReplacementNamed(context, "/NavBarScreen");

              // Navigator.pop(context);
              // Navigator.pushNamed(context, "/login_screen");
            },
            leading: const Icon(
              Icons.login_outlined,
              color: Colors.green,
            ),
            title: const Text(
              "تسجيل الدخول",
              style: TextStyle(color: Colors.green),
            ),
          ),
          Divider(
            color: Colors.green.shade300,
          ),
          ListTile(
            onTap: () {
              setState(() {
                multiPages = signUpScreen;
              });
              Navigator.pushReplacementNamed(context, "/NavBarScreen");
              //  Navigator.pushNamed(context, "/signup_screen");
            },
            leading: const Icon(
              Icons.app_registration,
              color: Colors.green,
            ),
            title: const Text(
              "تسجيل جديد",
              style: TextStyle(color: Colors.green),
            ),
          ),
          Divider(
            color: Colors.green.shade300,
          ),
          ListTile(
            onTap: () {
              setState(() {
                multiPages = ordersScreen;
              });
              Navigator.pushReplacementNamed(context, "/NavBarScreen");
            },
            leading: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.green,
            ),
            title: const Text(
              "سلة الشراء",
              style: TextStyle(color: Colors.green),
            ),
          ),
          Divider(
            color: Colors.green.shade300,
          ),
          ListTile(
            onTap: () {
              // setState(() {
              //   _selectedIndex = 0;
              // });
              setState(() {
                multiPages = contactUs;
              });
              Navigator.pushReplacementNamed(context, "/NavBarScreen");
            },
            leading: const Icon(
              Icons.call_outlined,
              color: Colors.green,
            ),
            title: const Text(
              "تواصل معنا",
              style: TextStyle(color: Colors.green),
            ),
          ),
          Divider(
            color: Colors.green.shade300,
            height: 20.sp,
          ),
          ListTile(
            onTap: () {
              // setState(() {
              //   _selectedIndex = 0;
              // });
              Navigator.pop(context);
              // Navigator.pushNamed(context, "/call_info");
              showDialogExitApp(context);
            },
            leading: const Icon(
              Icons.logout,
              color: Colors.green,
            ),
            title: const Text(
              "الخروج من التطبيق ",
              style: TextStyle(color: Colors.green),
            ),
          ),
          Divider(
            color: Colors.green.shade300,
          ),
        ],
      ),
    );
  }

  void showDialogExitApp(BuildContext context) {
    showAlertDialog(
        context: context,
        title: "بازار فلسطين",
        content: Column(
          children: [
            Divider(
              color: Colors.green,
              height: 15.h,
            ),
            SizedBox(
              height: 20.h,
            ),
            const Center(
              child: Text(
                "هل تريد فعلا الخروج من البازار !",
              ),
            ),
            SizedBox(
              height: 20.sp,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else {
                      exit(0);
                    }
                  },
                  child: const Text("خروج"),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                )),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("الغاء"),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                )),
              ],
            )
          ],
        ));
  }
}


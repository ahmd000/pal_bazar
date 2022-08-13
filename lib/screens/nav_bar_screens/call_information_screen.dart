// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pal_bazar/configers/images_config.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import '../../helpers/fb_notifications.dart';
// import '../../helpers/helpers.dart';
//
// class CallInformationScreen extends StatefulWidget {
//   const CallInformationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CallInformationScreen> createState() => _CallInformationScreenState();
// }
//
// class _CallInformationScreenState extends State<CallInformationScreen>
//     with Helpers, FbNotifications {
//   @override
//   void initState() {
//     super.initState();
//     requestNotificationPermissions();
//     initializeForegroundNotificationForAndroid();
//   }
//
//   late WebViewController controller;
//   bool isLoading = true;
//   DateTime timeBackPressed = DateTime.now();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: const Color(0xff3e8e8e8),
//
//       appBar: AppBar(
//         backgroundColor: Colors.grey.shade400,
//         iconTheme: const IconThemeData(color: Colors.black),
//         centerTitle: true,
//         title: const Text(
//           "معلومات التواصل",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//
//       body: SafeArea(
//         child: Stack(
//           children: [
//             isLoading == false
//                 ? Container()
//                 : const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//             Container(
//               // padding: EdgeInsets.symmetric(
//               //   vertical: 16.sp,
//               // ),
//               child: WebView(
//                   javascriptMode: JavascriptMode.unrestricted,
//                   initialUrl: contactUs,
//                   onPageStarted: (s) {
//                     setState(() {
//                       isLoading = true;
//                     });
//                   },
//                   onPageFinished: (f) {
//                     setState(() {
//                       isLoading = false;
//                     });
//                   },
//                   onWebViewCreated: (controller) {
//                     this.controller = controller;
//                   },
//                   zoomEnabled: true,
//                   initialMediaPlaybackPolicy:
//                       AutoMediaPlaybackPolicy.always_allow,
//                   allowsInlineMediaPlayback: true,
//                   debuggingEnabled: false,
//                   gestureNavigationEnabled: true,
//                   navigationDelegate: (NavigationRequest request) {
//                     if (request.url.startsWith("https://wa.me/")) {
//                       print(request.url);
//                       launch(request.url);
//                       return NavigationDecision.prevent;
//                     } else if (request.url.contains("twitter")) {
//                       launch(request.url);
//                       return NavigationDecision.prevent;
//                     } else if (request.url.contains("instagram")) {
//                       launch(request.url);
//                       return NavigationDecision.prevent;
//                     } else if (request.url.contains("snapchat")) {
//                       launch(request.url);
//                       return NavigationDecision.prevent;
//                     } else {
//                       return NavigationDecision.navigate;
//                     }
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../business_tutorial.dart';
// import '../buy_sell_tutorial.dart';
// import '../events_tutorial.dart';
// import '../group_details_tutorial.dart';
// import '../groups_tutorial.dart';
// import '../jobs_tutorial.dart';
// import '../lost_found_tutorial.dart';
// import '../my_business_tutorial.dart';
// import '../news_tutorial.dart';
// import '../other_profile_tutorial.dart';
// import '../own_profile_tutorial.dart';
// import '../page_details_tutorial.dart';
// import '../pages_tutorial.dart';
// import '../polls_tutorial.dart';
//
// Future<void> handleOwnProfileTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasOwnProfileTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const OwnProfileTutorial(),
//         ),
//       );
//       await prefs.setBool('hasOwnProfileTutorial', true);
//   }
// }
//
// Future<void> handleOtherProfileTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasOtherProfileTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const OtherProfileTutorial(),
//         ),
//       );
//       await prefs.setBool('hasOtherProfileTutorial', true);
//   }
// }
//
// Future<void> handleNewsTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasNewsTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const NewsTutorial(),
//         ),
//       );
//       await prefs.setBool('hasNewsTutorial', true);
//   }
// }
//
// Future<void> handleBusinessTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasBusinessTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const BusinessTutorial(),
//         ),
//       );
//       await prefs.setBool('hasBusinessTutorial', true);
//   }
// }
//
// Future<void> handleMyBusinessTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasMyBusinessTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const MyBusinessTutorial(),
//         ),
//       );
//       await prefs.setBool('hasMyBusinessTutorial', true);
//   }
// }
//
// Future<void> handleExploresTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasMyBusinessTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const MyBusinessTutorial(),
//         ),
//       );
//       await prefs.setBool('hasMyBusinessTutorial', true);
//   }
// }
//
// Future<void> handlePollsTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasPollsTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const PollsTutorial(),
//         ),
//       );
//       await prefs.setBool('hasPollsTutorial', true);
//   }
// }
//
// Future<void> handleBuySellTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasBuySellTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const BuySellTutorial(),
//         ),
//       );
//       await prefs.setBool('hasBuySellTutorial', true);
//   }
// }
//
// Future<void> handleJobsTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasJobsTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const JobsTutorial(),
//         ),
//       );
//       await prefs.setBool('hasJobsTutorial', true);
//   }
// }
//
// Future<void> handleEventsTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasEventsTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const EventsTutorial(),
//         ),
//       );
//       await prefs.setBool('hasEventsTutorial', true);
//   }
// }
//
// Future<void> handleLostFoundTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasLostFoundTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const LostFoundTutorial(),
//         ),
//       );
//       await prefs.setBool('hasLostFoundTutorial', true);
//   }
// }
//
// Future<void> handlePagesTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasPagesTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const PagesTutorial(),
//         ),
//       );
//       await prefs.setBool('hasPagesTutorial', true);
//   }
// }
//
// Future<void> handleGroupsTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasGroupsTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (context) => const GroupsTutorial(),
//         ),
//       );
//       await prefs.setBool('hasGroupsTutorial', true);
//   }
// }
//
// Future<void> handlePageDetailsTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasPageDetailsTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//     Navigator.of(ctx).push(
//       MaterialPageRoute(
//         builder: (context) => const PageDetailsTutorial(),
//       ),
//     );
//     await prefs.setBool('hasPageDetailsTutorial', true);
//   }
// }
//
// Future<void> handleGroupDetailsTutorial(BuildContext ctx) async {
//   final prefs = await SharedPreferences.getInstance();
//   final hasSeenTutorial = prefs.getBool('hasGroupDetailsTutorial') ?? false;
//
//   if (!hasSeenTutorial) {
//     await Future.delayed(const Duration(seconds: 5));
//     Navigator.of(ctx).push(
//       MaterialPageRoute(
//         builder: (context) => const GroupDetailsTutorial(),
//       ),
//     );
//     await prefs.setBool('hasGroupDetailsTutorial', true);
//   }
// }

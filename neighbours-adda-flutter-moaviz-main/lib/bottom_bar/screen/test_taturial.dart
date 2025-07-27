// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:showcaseview/showcaseview.dart';
// //
// // class TestTutorialScreen extends StatefulWidget {
// //   const TestTutorialScreen({super.key});
// //   static const routeName = 'testTutorialScreen';
// //
// //   @override
// //   State<TestTutorialScreen> createState() => _TestTutorialScreenState();
// // }
// //
// // class _TestTutorialScreenState extends State<TestTutorialScreen> {
// //   // Tutorial showcase keys
// //   final GlobalKey _profileKey = GlobalKey();
// //   final GlobalKey _notificationKey = GlobalKey();
// //   final GlobalKey _postKey = GlobalKey();
// //   final GlobalKey _videoKey = GlobalKey();
// //   bool _showcaseStarted = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) => _checkFirstLaunch());
// //   }
// //
// //   Future<void> _checkFirstLaunch() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final firstTime = prefs.getBool('test_first_time') ?? true;
// //
// //     if (firstTime && mounted) {
// //       // Start showcase only if it hasn't been shown before
// //       ShowCaseWidget.of(context).startShowCase([
// //         _profileKey,
// //         _notificationKey,
// //         _postKey,
// //         _videoKey,
// //       ]);
// //       await prefs.setBool('test_first_time', false);
// //       setState(() => _showcaseStarted = true);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ShowCaseWidget(  // Wrap with ShowCaseWidget
// //       builder: (context) => Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Tutorial Demo'),
// //         ),
// //         body: Padding(
// //           padding: const EdgeInsets.all(20.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text('Neighborhood App Features',
// //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //               const SizedBox(height: 30),
// //               Row(
// //                 children: [
// //                   // Profile showcase
// //                   Showcase(
// //                     key: _profileKey,
// //                     title: 'Your Profile',
// //                     description: 'Manage your personal information and settings',
// //                     child: _buildFeatureCard(
// //                       icon: Icons.person,
// //                       label: 'Profile',
// //                       color: Colors.blue,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 20),
// //                   // Notification showcase
// //                   Showcase(
// //                     key: _notificationKey,
// //                     title: 'Notifications',
// //                     description: 'Stay updated with neighborhood activities',
// //                     child: _buildFeatureCard(
// //                       icon: Icons.notifications,
// //                       label: 'Alerts',
// //                       color: Colors.orange,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 30),
// //               // Post creation showcase
// //               Center(
// //                 child: Showcase(
// //                   key: _postKey,
// //                   title: 'Create Posts',
// //                   description: 'Share news and events with your neighbors',
// //                   child: _buildFeatureCard(
// //                     icon: Icons.post_add,
// //                     label: 'Create Post',
// //                     color: Colors.green,
// //                     width: 200,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         floatingActionButton: Showcase(
// //           key: _videoKey,
// //           title: 'Video Hub',
// //           description: 'Watch neighborhood videos and events',
// //           child: FloatingActionButton(
// //             onPressed: () {},
// //             backgroundColor: Colors.red,
// //             child: const Icon(Icons.videocam, size: 30),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFeatureCard({
// //     required IconData icon,
// //     required String label,
// //     required Color color,
// //     double width = 150,
// //   }) {
// //     return Container(
// //       width: width,
// //       height: 120,
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.2),
// //         borderRadius: BorderRadius.circular(15),
// //         border: Border.all(color: color, width: 2),
// //       ),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(icon, size: 40, color: color),
// //           const SizedBox(height: 10),
// //           Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:showcaseview/showcaseview.dart';
//
// class TestScreen extends StatefulWidget {
//   const TestScreen({super.key});
//
//   @override
//   State<TestScreen> createState() => _TestScreenState();
// }
//
// class _TestScreenState extends State<TestScreen> {
//   final GlobalKey _one = GlobalKey();
//   final GlobalKey _two = GlobalKey();
//   final GlobalKey _three = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//     // Showcase ko delay se start karwana
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ShowCaseWidget.of(context).startShowCase([_one, _two, _three]);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("TestScreen"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Showcase(
//               key: _one,
//               description: 'Yeh ek text hai jo user ko dikhaya gaya hai',
//               child: const Text(
//                 'Hello, User!',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Showcase(
//               key: _two,
//               description: 'Yeh ek button hai, is par click kar sakte ho.',
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: const Text("Click Me"),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Showcase(
//               key: _three,
//               description: 'Yeh ek icon hai, sirf dikhane ke liye.',
//               child: const Icon(Icons.star, size: 40, color: Colors.amber),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestTutorialScreen extends StatefulWidget {
  @override
  _TestTutorialScreenState createState() => _TestTutorialScreenState();
}

class _TestTutorialScreenState extends State<TestTutorialScreen> {
  bool _showTutorial = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('seenTestTutorial') ?? true;

    if (isFirstTime) {
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        _showTutorial = true;
      });
      prefs.setBool('seenTestTutorial', false);
    }
  }

  void _dismissTutorial() {
    setState(() {
      _showTutorial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMainContent(),
        if (_showTutorial) _buildTutorialOverlay(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Scaffold(
      appBar: AppBar(title: Text("Test Tutorial")),
      body: Center(
        child: Text(
          "Main Screen Content",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildTutorialOverlay() {
    return GestureDetector(
      onTap: _dismissTutorial,
      child: Stack(
        children: [
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // Tutorial text and indicators
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app, size: 80, color: Colors.white),
                SizedBox(height: 20),
                Text(
                  "Tap here to begin navigating!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _dismissTutorial,
                  child: Text("Got It"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

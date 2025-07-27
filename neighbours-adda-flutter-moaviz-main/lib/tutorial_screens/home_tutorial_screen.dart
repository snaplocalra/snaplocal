// import 'package:flutter/material.dart';
//
// class HomeTutorialScreen extends StatelessWidget {
//   const HomeTutorialScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Container(
//             height: double.infinity,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(image: AssetImage("assets/images/home/homebg.png"),fit: BoxFit.fill),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/utils/firebase_chat/widget/chat_icon_widget.dart';
import '../../common/utils/local_notification/widgets/notification_bell.dart';

class HomeTutorialScreen extends StatelessWidget {
  const HomeTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Stack(
            children: [
              Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "assets/images/home/homeTaturialBg.jpeg",
                    fit: BoxFit.fill,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                  ),

                  ///chat
                  Positioned(
                    top: 5,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NotificationBell(), ChatIconWidget(),
                      ],
                    ),
                  ),

                  ///Location
                  Positioned(
                    top: 61,
                    left: 10,
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/home/locationt.svg"),
                        SizedBox(width: 5,),
                        SvgPicture.asset("assets/images/home/locationSearcht.svg"),
                        SizedBox(width: 5,),
                        SvgPicture.asset("assets/images/home/postBtnt.svg"),
                      ],
                    ),
                  ),

                  ///Reels
                  Positioned(
                    bottom: 106,
                    right: 25,
                    child: SvgPicture.asset("assets/images/home/reelt.svg"),
                  ),

                  ///Badge
                  Positioned(
                    bottom: 178,
                    right: 5,
                    child: SvgPicture.asset("assets/images/home/badget.svg"),
                  ),

                  ///Globe
                  Positioned(
                    bottom: 214,
                    left: 57,
                    child: SvgPicture.asset("assets/images/home/globet.svg",height: 16,width: 16,),
                  ),

                  ///More
                  Positioned(
                    bottom: 22,
                    left: 143,
                    child: SvgPicture.asset("assets/images/home/moret.svg",height: 72,width: 72,),
                  ),


                  ///Explore
                  Positioned(
                    bottom: 4,
                    right: 12.5,
                    child: SvgPicture.asset("assets/images/home/exploret.svg",height: 52,width: 52,),
                  ),

                ],
              ),
              ///chat
              Positioned(
                right: 25,
                top: 45,
                child: SvgPicture.asset("assets/images/home/chatArrow.svg"),
              ),
              Positioned(
                right: 5,
                top: 135,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chats",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/home/dot.svg",height: 3,width: 3,),
                        Text(
                          " Local",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/home/dot.svg",height: 3,width: 3,),
                        Text(
                          " Connections",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/home/dot.svg",height: 3,width: 3,),
                        Text(
                          " Others",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              ///Location Text
              Positioned(
                left: 70,
                top: 0,
                child: SvgPicture.asset("assets/images/home/locationSearchArrow.svg"),
              ),
              Positioned(
                left: 160,
                top: 20,
                child: Text(
                  "Change Area \n& Radius",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),

              ///location Icon
              Positioned(
                top: 100,
                left: 22,
                child: SvgPicture.asset("assets/images/home/locationArrow.svg"),
              ),
              Positioned(
                left: 15,
                top: 160,
                child: Text(
                  "Saved\nLocation",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),

              ///PostBtn
              Positioned(
                top: 90,
                right: 85,
                child: SvgPicture.asset("assets/images/home/postArrow.svg"),
              ),
              Positioned(
                top: 143,
                right: 160,
                child: Text(
                  "Create a\nPost",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              ///Reels
              Positioned(
                bottom: 150,
                right: 40,
                child: SvgPicture.asset("assets/images/home/reelArrow.svg"),
              ),
              Positioned(
                bottom: 200,
                right: 100,
                child: Text(
                  "Short Videos",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              ///Badge
              Positioned(
                bottom: 200,
                right: 15,
                child: SvgPicture.asset("assets/images/home/moreArrow.svg"),
              ),
              Positioned(
                bottom: 250,
                right: 50,
                child: Text(
                  "Your Badge Level",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              ///Globe
              Positioned(
                bottom: 235,
                left: 60,
                child: Transform.rotate(
                    angle: 3.1416,
                    child: SvgPicture.asset("assets/images/home/locationArrow.svg")),
              ),
              Positioned(
                bottom: 300,
                left: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Post Visibility",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/home/dot.svg",height: 3,width: 3,),
                        Text(
                          " Public",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/home/dot.svg",height: 3,width: 3,),
                        Text(
                          " Connections",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/home/dot.svg",height: 3,width: 3,),
                        Text(
                          " Groups",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              ///More
              Positioned(
                bottom: 70,
                left: 100,
                child: SvgPicture.asset("assets/images/home/moreArrow.svg"),
              ),
              Positioned(
                bottom: 120,
                left: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "More Button",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Access all other features",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              ///Explore
              Positioned(
                bottom: 45,
                right: 64,
                child: SvgPicture.asset("assets/images/home/exploreArow.svg"),
              ),
              Positioned(
                bottom: 100,
                right: 100,
                child: Text(
                  "Explore All\nFeatures",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


// import 'dart:ui';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../../common/utils/firebase_chat/widget/chat_icon_widget.dart';
// import '../../common/utils/local_notification/widgets/notification_bell.dart';
// import '../../generated/codegen_loader.g.dart';
// import '../../utility/constant/application_colours.dart';
// import '../../utility/constant/assets_images.dart';
// import '../bottom_bar_modules/home/widgets/home_create_post_widget.dart';
//
// class HomeTutorialScreen extends StatelessWidget {
//   const HomeTutorialScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Stack(
//               fit: StackFit.expand,
//               children: [
//                 Image.asset(
//                   "assets/images/home/homeTaturialBg.jpeg",
//                   fit: BoxFit.fill,
//                 ),
//                 Container(
//                   color: Colors.black.withOpacity(0.7),
//                 ),
//                 Positioned(
//                   top: 5,
//                   right: 0,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       NotificationBell(), ChatIconWidget(),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 15,
//                   right: 90,
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           "Notification",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(width: 10,),
//                         Transform.rotate(
//                           angle: -1.5708, // -90 degrees in radians
//                           child: Image.asset(
//                             "assets/images/home/arrowUp.png",
//                             height: 20,
//                             width: 10,
//                             fit: BoxFit.fill,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 55,
//                   left: 0,
//                   right: 0,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     child: HomeCreatePostWidget(
//                       searchBoxHint: LocaleKeys.whatsHappeningNeighbor,
//                       onCreatePost: () {},
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 5,
//                   right: 17,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                           SVGAssetsImages.explore,
//                           height: 30,
//                           width: 30,
//                           colorFilter: ColorFilter.mode(Colors.white,BlendMode.srcIn,)
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         tr(LocaleKeys.explore),
//                         textAlign: TextAlign.center,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   right: 25,
//                   bottom: 115,
//                   child: Container(
//                     width: 57,
//                     height: 57,
//                     decoration: BoxDecoration(
//                       color: ApplicationColours.themeBlueColor,
//                       shape: BoxShape.circle,
//                       boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
//                     ),
//                     child: const Icon(Icons.play_arrow_outlined, color: Colors.white, size: 30),
//                   ),
//                 ),
//                 Positioned(
//                     top: 123,
//                     left: 55,
//                     child: SvgPicture.asset("assets/images/post/globe.svg",height: 20,width: 20,fit: BoxFit.fill,colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),)),
//                 Positioned(
//                   top: 130,
//                   left: 2,
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 12),
//                           child: Text(
//                             "Glob",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10,),
//                         Transform.rotate(
//                           angle: 4, // 210 degrees in radians
//                           child: Image.asset(
//                             "assets/images/home/arrowUp.png",
//                             height: 20,
//                             width: 10,
//                             fit: BoxFit.fill,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//               ],
//             ),
//             Positioned(
//               right: 38,
//               top: 35,
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 12),
//                     child: Text(
//                       "Chat",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10,),
//                   Transform.rotate(
//                     angle: 4.1111, // 250 degrees in radians
//                     child: Image.asset(
//                       "assets/images/home/arrowUp.png",
//                       height: 20,
//                       width: 10,
//                       fit: BoxFit.fill,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               right: 65,
//               top: 95,
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 12),
//                     child: Text(
//                       "Create Post",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10,),
//                   Transform.rotate(
//                     angle: 4, // 210 degrees in radians
//                     child: Image.asset(
//                       "assets/images/home/arrowUp.png",
//                       height: 20,
//                       width: 10,
//                       fit: BoxFit.fill,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               right: 160,
//               top: 108,
//               child: _buildTooltip("Add Location",false),
//             ),
//             Positioned(
//               bottom: 58,
//               right: 16,
//               child: _buildTooltip("Explore",true),
//             ),
//             Positioned(
//               bottom: 175,
//               right: 35,
//               child: _buildTooltip("Shorts",true),
//             ),
//             Positioned(
//               top: 168,
//               left: 45,
//               child: Column(
//                 children: [
//                   Text("General", style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 11)),
//                   SizedBox(height: 3),
//                   _buildTooltip("Category",false),
//                 ],
//               ),
//             ),
//             Positioned(
//               right: 35,
//               top: 170,
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 12),
//                     child: Text(
//                       "Badge",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10,),
//                   Transform.rotate(
//                     angle: 4, // 210 degrees in radians
//                     child: Image.asset(
//                       "assets/images/home/arrowUp.png",
//                       height: 20,
//                       width: 10,
//                       fit: BoxFit.fill,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// Widget _buildTooltip(String title,bool arrow) {
//   return Column(
//     children: [
//       if(!arrow)
//         Transform.rotate(
//           angle: 3.1416, // 180 degrees in radians
//           child: Image.asset(
//             "assets/images/home/arrowUp.png",
//             height: 20,
//             width: 10,
//             fit: BoxFit.fill,
//             color: Colors.white,
//           ),
//         ),
//       Text(title, style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white)),
//       if(arrow)
//         Padding(
//           padding: const EdgeInsets.only(top: 5.0),
//           child: Image.asset("assets/images/home/arrowUp.png",height: 20,width: 10,fit: BoxFit.fill,color: Colors.white,),
//         ),
//     ],
//   );
// }


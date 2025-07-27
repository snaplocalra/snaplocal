import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../common/social_media/profile/connections/widgets/conntection_action_button_v2.dart';
import '../common/utils/widgets/cicular_svg_button.dart';
import '../generated/codegen_loader.g.dart';
import '../utility/common/widgets/octagon_widget.dart';
import '../utility/constant/application_colours.dart';
import '../utility/constant/assets_images.dart';

class OwnProfileTutorial extends StatelessWidget {
  const OwnProfileTutorial({super.key});

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
                    "assets/images/profile/ownProfile.jpeg",
                    fit: BoxFit.fill,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ],
              ),

              ///Settings
              Positioned(
                top: 2,
                right: 10,
                child: CircularSvgButton(
                    svgImage:
                    SVGAssetsImages.settings,
                    iconSize: 20,
                    backgroundColor:
                    Colors.blue.shade50,),
              ),
              Positioned(
                right: 35,
                top: 20,
                child: SvgPicture.asset("assets/images/home/chatArrow.svg"),
              ),
              Positioned(
                right: 20,
                top: 110,
                child:  Text(
                  "Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),

              ///analytics
              Positioned(
                top: 421,
                left: 115,
                child: SizedBox(
                  width: 100,
                  child: ConnectionActionButtonV2(
                    onPressed: (){},
                    buttonName: LocaleKeys.analytics,
                    backgroundColor: ApplicationColours
                        .themeLightPinkColor,
                  ),
                ),
              ),
              Positioned(
                top: 340,
                left: 125,
                child: SvgPicture.asset("assets/images/home/locationSearchArrow.svg"),
              ),
              Positioned(
                top: 370,
                right: 40,
                child: Text(
                  "Analytics Button",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),

              ///SnapLocal Points
              Positioned(
                top: 640,
                left: 113,
                child: OctagonWidget(
                  shapeSize: 135,
                  borderWidth: 1,
                  borderColor: Colors.black,
                  child: Container(
                    color: ApplicationColours.themeBlueColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "25",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                "SNAP",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: ApplicationColours.themeBlueColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Text(
                              "LOCAL",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Points",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 90,
                left: 175,
                child: Transform.rotate(
                    angle: 3.1416,
                    child: SvgPicture.asset("assets/images/home/locationArrow.svg")),
              ),
              Positioned(
                bottom: 150,
                left: 160,
                child: Text(
                  "Points",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),

              ///Shares
              Positioned(
                bottom: 72,
                left: 45,
                child: OctagonWidget(
                  shapeSize: 82,
                  borderWidth: 1,
                  borderColor: Colors.black,
                  child: Container(
                    color: ApplicationColours.themeLightPinkColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "12",
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Shares",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 135,
                left: 35,
                child: SvgPicture.asset("assets/images/home/exploreArow.svg"),
              ),
              Positioned(
                bottom: 184,
                left: 10,
                child: Text(
                  "Shares",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),

              ///Shares
              Positioned(
                bottom: 72,
                right: 45,
                child: OctagonWidget(
                  shapeSize: 82,
                  borderWidth: 1,
                  borderColor: Colors.black,
                  child: Container(
                    color: ApplicationColours.themeGreenColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "1",
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Referrals",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 157,
                right: 85,
                child: Transform.rotate(
                    angle: 3.1416,
                    child: SvgPicture.asset("assets/images/home/locationArrow.svg")),
              ),
              Positioned(
                bottom: 215,
                right: 60,
                child: Text(
                  "Referrals",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),

              ///posts
              Positioned(
                bottom: -20,
                right: 5,
                child: OctagonWidget(
                  shapeSize: 82,
                  borderWidth: 1,
                  borderColor: Colors.black,
                  child: Container(
                    color: ApplicationColours.skyColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "3",
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Posts",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                right: 30,
                child: Transform.rotate(
                    angle: 3.1416,
                    child: SvgPicture.asset("assets/images/home/locationArrow.svg")),
              ),
              Positioned(
                bottom: 110,
                right: 5,
                child: Text(
                  "Posts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),

              ///Badge
              Positioned(
                top: 193,
                right: 20,
                child: SvgPicture.asset("assets/images/home/badget.svg",height: 40,width: 40,fit: BoxFit.contain,),
              ),
              Positioned(
                top: 220,
                right: 40,
                child: SvgPicture.asset("assets/images/home/postArrow.svg",height: 55,),
              ),
              Positioned(
                top: 260,
                right: 105,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Level Badge",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/home/dot.svg",height: 3,width: 3,),
                        Text(
                          " Silver",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/home/dot.svg",height: 3,width: 3,),
                        Text(
                          " Gold",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/home/dot.svg",height: 3,width: 3,),
                        Text(
                          " Star",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/home/dot.svg",height: 3,width: 3,),
                        Text(
                          " Prime",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
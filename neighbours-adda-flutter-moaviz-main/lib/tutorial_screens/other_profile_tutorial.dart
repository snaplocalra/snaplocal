import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../common/social_media/profile/connections/widgets/conntection_action_button_v2.dart';
import '../common/utils/widgets/cicular_svg_button.dart';
import '../generated/codegen_loader.g.dart';
import '../utility/common/widgets/octagon_widget.dart';
import '../utility/constant/application_colours.dart';
import '../utility/constant/assets_images.dart';

class OtherProfileTutorial extends StatelessWidget {
  const OtherProfileTutorial({super.key});

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
                    "assets/tutorials/otherProfile.jpeg",
                    fit: BoxFit.fill,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ],
              ),

              /// Follow and Connect
              Positioned(
                top: 462,
                left: 10,
                child: Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: ConnectionActionButtonV2(
                        onPressed: (){},
                        buttonName: "Connect",
                        backgroundColor: Colors.blueAccent.shade400,
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      child: ConnectionActionButtonV2(
                        onPressed: (){},
                        buttonName: "Follow",
                        backgroundColor: Colors.blueAccent.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              /// Connect
              Positioned(
                top: 370,
                left: 10,
                child: SvgPicture.asset("assets/images/home/locationSearchArrow.svg"),
              ),
              Positioned(
                top: 395,
                left: 90,
                child: Text(
                  "Connect",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              /// Follow
              Positioned(
                top: 370,
                left: 150,
                child: SvgPicture.asset("assets/images/home/locationSearchArrow.svg"),
              ),
              Positioned(
                top: 395,
                left: 230,
                child: Text(
                  "Follow",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),

              ///Snap Local Achievements
              Positioned(
                bottom: 130,
                right: MediaQuery.sizeOf(context).width*0.5,
                child: SvgPicture.asset("assets/images/home/locationArrow.svg"),
              ),
              Positioned(
                bottom: 105,
                left: 100,
                child: Text(
                  "Snap Local Achievements",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),


              ///Badge
              Positioned(
                top: 198,
                right: 20,
                child: SvgPicture.asset("assets/images/home/badget.svg",height: 41,width: 41,fit: BoxFit.contain,),
              ),
              Positioned(
                top: 240,
                right: 40,
                child: SvgPicture.asset("assets/images/home/postArrow.svg",height: 55,),
              ),
              Positioned(
                top: 280,
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
                          " etc",
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
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../common/utils/widgets/manage_post_action_button.dart';
import '../utility/constant/application_colours.dart';

class PagesTutorial extends StatelessWidget {
  const PagesTutorial({super.key});

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
                    "assets/tutorials/pages.jpeg",
                    fit: BoxFit.fill,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ],
              ),

              ///btn row
              Positioned(
                top: 117,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      margin: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ApplicationColours.themeBlueColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: ApplicationColours.themeBlueColor,
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text("Your Pages",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      margin: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100,
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text("Suggested",
                        style: TextStyle(
                          color: ApplicationColours.themeBlueColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      margin: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100,
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text("Favorite",
                        style: TextStyle(
                          color: ApplicationColours.themeBlueColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///Your Pages
              Positioned(
                top: 168,
                left: 50,
                child: SvgPicture.asset("assets/images/home/locationArrow.svg"),
              ),
              Positioned(
                left: 10,
                top: 230,
                child: Text(
                  "Your Pages",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              ///Suggested
              Positioned(
                left: 130,
                top: 165,
                child: SvgPicture.asset("assets/images/home/chatArrow.svg"),
              ),
              Positioned(
                left: 150,
                top: 255,
                child: Text(
                  "Suggested",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              ///favorite
              Positioned(
                top: 50,
                right: 100,
                child: SvgPicture.asset("assets/images/home/reelArrow.svg"),
              ),
              Positioned(
                top: 64,
                left: 120,
                child: Text(
                  "Favorites",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              ///Create Page Btn
              Positioned(
                bottom: 13.5,
                right: 15,
                child: ManagePostActionButton(
                  onPressed: () async {},
                  text: "  Create Page  ",
                ),
              ),
              Positioned(
                bottom: 40,
                right: 40,
                child: SvgPicture.asset("assets/images/home/reelArrow.svg"),
              ),
              Positioned(
                bottom: 90,
                right: 100,
                child: Text(
                  "Create Page",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utility/constant/application_colours.dart';

class PageDetailsTutorial extends StatelessWidget {
  const PageDetailsTutorial({super.key});

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
                    "assets/tutorials/pageDetails.jpeg",
                    fit: BoxFit.fill,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ],
              ),

              ///Star and More Btn
              Positioned(
                right: 6,
                top: 10,
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      margin: EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: AnimatedSwitcher(
                        duration:
                        const Duration(milliseconds: 500),
                        child:IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.star_border,
                            color: ApplicationColours.themeBlueColor,
                          ), onPressed: () {  },
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      width: 35,
                      margin: EdgeInsets.only(left: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: Icon(Icons.more_horiz,size: 24,color: Colors.black,),
                    ),
                  ],
                ),
              ),

              ///3 Dots
              Positioned(
                top: 50,
                right: 25,
                child: SvgPicture.asset("assets/images/home/locationArrow.svg"),
              ),
              Positioned(
                top: 110,
                right: 5,
                child: Text(
                  "Three Dots",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              ///Star Btn
              Positioned(
                right: 70,
                top: 45,
                child: SvgPicture.asset("assets/images/home/postArrow.svg"),
              ),
              Positioned(
                top: 100,
                right: 150,
                child: Text(
                  "Star Button",
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
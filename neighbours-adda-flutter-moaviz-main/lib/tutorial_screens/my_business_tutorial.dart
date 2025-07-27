import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../common/utils/analytics/model/analytics_module_type.dart';
import '../common/utils/analytics/widget/analytics_overview_button.dart';

class MyBusinessTutorial extends StatelessWidget {
  const MyBusinessTutorial({super.key});

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
                    "assets/tutorials/myBusinessPage.jpeg",
                    fit: BoxFit.fill,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ],
              ),
              ///Analytics Overview
                Positioned(
                  top: (MediaQuery.sizeOf(context).height*0.48)+25,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: AnalyticsOverviewButton(
                      height: 40,
                      textFontSize: 13,
                      moduleId: "1",
                      moduleType: AnalyticsModuleType.business,
                    ),
                  ),
                ),

              Positioned(
                top: (MediaQuery.sizeOf(context).height*0.6)-10,
                right: MediaQuery.sizeOf(context).width*0.5-5,
                child: SvgPicture.asset("assets/images/home/locationArrow.svg"),
              ),
              Positioned(
                top: (MediaQuery.sizeOf(context).height*0.7)-20,
                right: 90,
                child: Text(
                  "Analytics Overview Button",
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
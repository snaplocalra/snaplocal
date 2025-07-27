import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../bottom_bar/bottom_bar_modules/businesses/widgets/manage_business_buttons.dart';
import '../common/utils/location/model/location_type_enum.dart';
import '../common/utils/location/widgets/address_with_locate_me.dart';
import '../common/utils/widgets/cicular_svg_button.dart';
import '../common/utils/widgets/manage_post_action_button.dart';
import '../generated/codegen_loader.g.dart';
import '../utility/constant/application_colours.dart';
import '../utility/constant/assets_images.dart';

class BusinessTutorial extends StatelessWidget {
  const BusinessTutorial({super.key});

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
                    "assets/tutorials/businessPage.jpeg",
                    fit: BoxFit.fill,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ],
              ),

              ///Location
              Positioned(
                top: 130,
                left: 10,
                right: 10,
                child: AddressWithLocateMe(
                  is3D: true,
                  iconSize: 15,
                  iconTopPadding: 0,
                  locationType: LocationType.socialMedia,
                  contentMargin: EdgeInsets.zero,
                  height: 37,
                  decoration: BoxDecoration(
                    color:
                    ApplicationColours.skyColor.withOpacity(1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: null,
                ),
              ),
              Positioned(
                top: 180,
                right: MediaQuery.sizeOf(context).width*0.5,
                child: SvgPicture.asset("assets/images/home/locationArrow.svg"),
              ),
              Positioned(
                top: 240,
                right: MediaQuery.sizeOf(context).width*0.4,
                child: Text(
                  "Set Location",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),

              ///Filter Bnt
              Positioned(
                top: 70,
                right: 20,
                child: CircularSvgButton(
                  iconSize: 15,
                  svgImage: SVGAssetsImages.filter,
                  backgroundColor: ApplicationColours.themeBlueColor,
                  iconColor: Colors.white,
                ),
              ),
              Positioned(
                top: 30,
                right: 55,
                child: SvgPicture.asset("assets/images/home/exploreArow.svg"),
              ),
              Positioned(
                top: 20,
                right: 80,
                child: Text(
                  "Apply Filters",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),

              ///Create Bus
              Positioned(
                right: 5,
                bottom: 75,
                child: ManagePostActionButton(
                  text: tr(LocaleKeys.createBusinessPage),
                  backgroundColor: ApplicationColours.themeLightPinkColor, onPressed: () {  },
                ),
              ),

              Positioned(
                bottom: 93,
                right: 135,
                child: SvgPicture.asset("assets/images/home/exploreArow.svg"),
              ),
              Positioned(
                bottom: 145,
                right: 100,
                child: Text(
                  "Create Business Page",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
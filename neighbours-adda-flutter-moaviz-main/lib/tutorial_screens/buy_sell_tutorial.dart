import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../common/utils/location/model/location_type_enum.dart';
import '../common/utils/location/widgets/address_with_locate_me.dart';
import '../common/utils/widgets/manage_post_action_button.dart';
import '../generated/codegen_loader.g.dart';
import '../utility/constant/application_colours.dart';

class BuySellTutorial extends StatelessWidget {
  const BuySellTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: ManagePostActionButton(
          onPressed: () async {

          },
          text: tr(LocaleKeys.postSale),
        ),
      ),
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
                    "assets/tutorials/buySellPage.jpeg",
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

              ///Post Btn

              Positioned(
                bottom: 50,
                right: 40,
                child: SvgPicture.asset("assets/images/home/reelArrow.svg"),
              ),
              Positioned(
                bottom: 100,
                right: 100,
                child: Text(
                  "Post Item for Sale",
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
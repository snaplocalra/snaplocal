import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../bottom_bar/bottom_bar_modules/news/widget/news_language_change_popup.dart';
import '../bottom_bar/bottom_bar_modules/news/widget/square_button.dart';
import '../common/utils/location/model/location_type_enum.dart';
import '../common/utils/location/widgets/address_with_locate_me.dart';
import '../common/utils/widgets/cicular_svg_button.dart';
import '../generated/codegen_loader.g.dart';
import '../utility/constant/application_colours.dart';
import '../utility/constant/assets_images.dart';

class NewsTutorial extends StatelessWidget {
  const NewsTutorial({super.key});

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
                    "assets/tutorials/news.jpeg",
                    fit: BoxFit.fill,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ],
              ),

              ///Select Language
              Positioned(
                top: 10,
                right: 10,
                child: NewsLanguageChangePopUp(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          SVGAssetsImages.translateIcon,
                          height: 22,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            tr(LocaleKeys.changeLanguage),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 80,
                top: 40,
                child: SvgPicture.asset("assets/images/home/chatArrow.svg"),
              ),
              Positioned(
                right: 20,
                top: 130,
                child:  Text(
                  "Change Language",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),

              ///Location
              Positioned(
                top: 185,
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
                top: 230,
                right: 100,
                child: SvgPicture.asset("assets/images/home/locationArrow.svg"),
              ),
              Positioned(
                top: 290,
                right: 50,
                child: Text(
                  "Select Location",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),

              ///Post News
              Positioned(
                top: 240,
                left: 10,
                child: SquareButton(
                  onTap: (){},
                  svgSize: 12,
                  svgColor: Colors.white,
                  svgAsset: SVGAssetsImages
                      .joinChannel,
                  buttonText: tr(
                      LocaleKeys.postNews),
                  textColor:
                  Colors.white,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                      Colors.white,
                      width: 1.0,
                    ),
                    borderRadius:
                    BorderRadius
                        .circular(5),
                  ),
                ),
              ),
              Positioned(
                top: 270,
                left: 50,
                child: SvgPicture.asset("assets/images/home/locationArrow.svg"),
              ),
              Positioned(
                top: 330,
                left: 20,
                child: Text(
                  "Post News",
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
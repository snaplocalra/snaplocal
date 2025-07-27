import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/logic/news_location_type_selector/cubit/news_location_type_selector_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/logic/news_location_type_selector/cubit/news_location_type_selector_state.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class NewsLocationTypeSelectorWidget extends StatelessWidget {
  final bool enableGlobalNewsType;
  const NewsLocationTypeSelectorWidget({
    super.key,
    required this.enableGlobalNewsType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsLocationTypeSelectorCubit,
        NewsLocationTypeSelectorState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NewsLocationTypeButton(
              selectedValue: state.selectedLocationType,
              newsLocationType: NewsLocationTypeEnum.local,
              svgAsset: SVGAssetsImages.local,
            ),
            if (enableGlobalNewsType)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: NewsLocationTypeButton(
                  selectedValue: state.selectedLocationType,
                  newsLocationType: NewsLocationTypeEnum.global,
                  svgAsset: SVGAssetsImages.global,
                ),
              ),
          ],
        );
      },
    );
  }
}

class NewsLocationTypeButton extends StatelessWidget {
  final NewsLocationTypeEnum selectedValue;
  final NewsLocationTypeEnum newsLocationType;
  final String svgAsset;
  final double svgSize;

  const NewsLocationTypeButton({
    super.key,
    required this.selectedValue,
    required this.newsLocationType,
    required this.svgAsset,
    this.svgSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context
            .read<NewsLocationTypeSelectorCubit>()
            .switchType(newsLocationType);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: selectedValue == newsLocationType
              ? ApplicationColours.themeBlueColor
              : Colors.white,
          border: Border.all(
            color: ApplicationColours.themeBlueColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: SvgPicture.asset(
                svgAsset,
                height: svgSize,
                width: svgSize,
                colorFilter: selectedValue == newsLocationType
                    ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                    : null,
              ),
            ),
            Text(
              tr(newsLocationType.displayName),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selectedValue == newsLocationType
                    ? Colors.white
                    : ApplicationColours.themeBlueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

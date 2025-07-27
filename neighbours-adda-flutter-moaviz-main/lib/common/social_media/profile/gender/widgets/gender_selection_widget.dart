// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/common/social_media/profile/gender/logic/gender_selector/gender_selector_cubit.dart';
import 'package:snap_local/common/social_media/profile/gender/model/gender_enum.dart';

class GenderSelectionWidget extends StatelessWidget {
  final void Function(GenderEnum genderEnum) onGenderSelected;

  const GenderSelectionWidget({
    super.key,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenderSelectorCubit, GenderSelectorState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GenderWidget(
              name: GenderEnum.male.displayName,
              svgIcon: GenderEnum.male.svgIcon,
              isSelected: state.selectedGender == GenderEnum.male,
              onTap: () {
                onGenderSelected.call(GenderEnum.male);
              },
            ),
            const SizedBox(width: 10),
            GenderWidget(
              name: GenderEnum.female.displayName,
              svgIcon: GenderEnum.female.svgIcon,
              isSelected: state.selectedGender == GenderEnum.female,
              onTap: () {
                onGenderSelected.call(GenderEnum.female);
              },
            ),
            const SizedBox(width: 10),
            GenderWidget(
              name: GenderEnum.others.displayName,
              svgIcon: GenderEnum.others.svgIcon,
              isSelected: state.selectedGender == GenderEnum.others,
              onTap: () {
                onGenderSelected.call(GenderEnum.others);
              },
            ),
          ],
        );
      },
    );
  }
}

class GenderWidget extends StatelessWidget {
  final String name;
  final String svgIcon;
  final bool isSelected;
  final void Function() onTap;
  final Color? fillColor;
  const GenderWidget({
    super.key,
    required this.name,
    required this.svgIcon,
    required this.onTap,
    this.isSelected = false,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? Theme.of(context).primaryColor : Color(0x80F3F3F3),
            border: Border.all(color: const Color.fromRGBO(214, 209, 209, 1)),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                svgIcon,
                fit: BoxFit.fitWidth,
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 5),
              Text(
                tr(name),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

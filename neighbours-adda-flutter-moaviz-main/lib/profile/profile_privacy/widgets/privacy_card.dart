import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/profile/profile_privacy/models/profile_privacy_model.dart';
import 'package:snap_local/profile/profile_privacy/widgets/privacy_option_widget.dart';

class PrivacyCard extends StatelessWidget {
  final String privacyName;
  final String privacyDescription;
  final ProfilePrivacyEnum privacyEnum;
  final void Function(ProfilePrivacyEnum selectedPrivacy)
      onPrivacyOptionSelection;

  const PrivacyCard({
    super.key,
    required this.privacyName,
    required this.privacyDescription,
    required this.privacyEnum,
    required this.onPrivacyOptionSelection,
  });

  static final privacyOptionList = [
    ProfilePrivacyEnum.public,
    ProfilePrivacyEnum.nearByLocality,
    ProfilePrivacyEnum.yourConnections,
    ProfilePrivacyEnum.yourGroups,
    ProfilePrivacyEnum.noOne,
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(privacyName),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tr(privacyDescription),
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 5),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: PrivacyOptionWidget(
                name: privacyEnum.privacyName,
                description: privacyEnum.privacyDescription,
                svgIconPath: privacyEnum.svgIcon,
                isSelected: true,
              ),
              children: List<Widget>.generate(
                privacyOptionList.length,
                (index) {
                  final privacyOption = privacyOptionList[index];
                  return Visibility(
                    visible: privacyOption != privacyEnum,
                    child: Column(
                      children: [
                        const Divider(
                          color: Color.fromRGBO(112, 112, 112, 0.2),
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () =>
                              onPrivacyOptionSelection.call(privacyOption),
                          child: AbsorbPointer(
                            child: PrivacyOptionWidget(
                              name: privacyOption.privacyName,
                              svgIconPath: privacyOption.svgIcon,
                              description: privacyOption.privacyDescription,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

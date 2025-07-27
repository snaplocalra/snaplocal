import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/profile_privacy/logic/profile_privacy_manager/profile_privacy_manager_cubit.dart';
import 'package:snap_local/profile/profile_privacy/models/profile_privacy_model.dart';
import 'package:snap_local/profile/profile_privacy/widgets/privacy_card.dart';
import 'package:snap_local/profile/profile_privacy/widgets/profile_privacy_shimmer.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/widget/localization_builder.dart';

class ProfilePrivacyScreen extends StatefulWidget {
  static const routeName = 'profile_privacy';
  const ProfilePrivacyScreen({super.key});
  @override
  State<ProfilePrivacyScreen> createState() => _ProfilePrivacyScreenState();
}

class _ProfilePrivacyScreenState extends State<ProfilePrivacyScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfilePrivacyManagerCubit>().fetchPrivacySettings();
  }

  @override
  Widget build(BuildContext context) {
    return LanguageChangeBuilder(
      builder: (context, _) {
        return Scaffold(
          appBar: ThemeAppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            title: Text(
              tr(LocaleKeys.editPrivacy),
              style: TextStyle(color: ApplicationColours.themeBlueColor),
            ),
          ),
          body: BlocBuilder<ProfilePrivacyManagerCubit,
              ProfilePrivacyManagerState>(
            builder: (context, state) {
              final profilePrivacyModel = state.profilePrivacyModel;
              if (state.error != null) {
                return ErrorTextWidget(error: state.error!);
              } else if (state.dataLoading ||
                  !state.isProfilePrivacyModelAvailable) {
                return const ProfilePrivacyShimmer();
              } else {
                return ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    PrivacyCard(
                      privacyName: LocaleKeys.profilePicturePrivacy,
                      privacyDescription:
                          LocaleKeys.profilePicturePrivacyDescription,
                      privacyEnum: profilePrivacyModel!.profilePicturePrivacy,
                      onPrivacyOptionSelection: (selectedPrivacy) {
                        //update the privacy setting
                        context
                            .read<ProfilePrivacyManagerCubit>()
                            .updatePrivacySettings(ProfilePrivacyModel(
                              //assign the profilePicturePrivacy with the privacy option
                              profilePicturePrivacy: selectedPrivacy,
                              searchPrivacy: profilePrivacyModel.searchPrivacy,
                              chatPrivacy: profilePrivacyModel.chatPrivacy,
                            ));
                      },
                    ),
                    PrivacyCard(
                      privacyName: LocaleKeys.searchPrivacy,
                      privacyDescription: LocaleKeys.searchPrivacyDescription,
                      privacyEnum: profilePrivacyModel.searchPrivacy,
                      onPrivacyOptionSelection: (selectedPrivacy) {
                        //update the privacy setting
                        context
                            .read<ProfilePrivacyManagerCubit>()
                            .updatePrivacySettings(ProfilePrivacyModel(
                              profilePicturePrivacy:
                                  profilePrivacyModel.profilePicturePrivacy,
                              //assign the profilePicturePrivacy with the privacy option
                              searchPrivacy: selectedPrivacy,
                              chatPrivacy: profilePrivacyModel.chatPrivacy,
                            ));
                      },
                    ),
                    PrivacyCard(
                      privacyName: LocaleKeys.chatPrivacy,
                      privacyDescription: LocaleKeys.chatPrivacyDescription,
                      privacyEnum: profilePrivacyModel.chatPrivacy,
                      onPrivacyOptionSelection: (selectedPrivacy) {
                        //update the privacy setting
                        context
                            .read<ProfilePrivacyManagerCubit>()
                            .updatePrivacySettings(ProfilePrivacyModel(
                              profilePicturePrivacy:
                                  profilePrivacyModel.profilePicturePrivacy,
                              searchPrivacy: profilePrivacyModel.searchPrivacy,
                              //assign the profilePicturePrivacy with the privacy option
                              chatPrivacy: selectedPrivacy,
                            ));
                      },
                    ),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}

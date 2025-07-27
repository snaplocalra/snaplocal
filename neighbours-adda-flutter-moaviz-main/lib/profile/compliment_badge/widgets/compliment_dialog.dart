import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/compliment_badge/logic/compliment_badge/compliment_badge_cubit.dart';
import 'package:snap_local/profile/compliment_badge/logic/manage_compliment/manage_compliment_cubit.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_action_state.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_badge_model.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_type.dart';
import 'package:snap_local/profile/compliment_badge/repository/compliment_badge_repository.dart';
import 'package:snap_local/profile/compliment_badge/widgets/compliment_badge_widget.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';


class ComplimentDialog extends StatefulWidget {
  final ComplimentType complimentType;
  final String userId;
  const ComplimentDialog({
    super.key,
    required this.complimentType,
    required this.userId,
  });

  @override
  State<ComplimentDialog> createState() => _ComplimentDialogState();
}

class _ComplimentDialogState extends State<ComplimentDialog> {
  late ComplimentBadgeCubit complimentBadgeCubit =
  ComplimentBadgeCubit(ComplimentBadgeRepository());

  late bool isSender = widget.complimentType is SendCompliment;

  final ComplimentActionController complimentActionController =
  ComplimentActionController();

  void updateComplimentActionState(
      ComplimentBadgeModel selectedBadge,
      List<ComplimentBadgeModel> badges,
      ) {
    if (selectedBadge.isNewSelection) {
      complimentActionController.selectNewBadge();
    } else if (selectedBadge.isSelected) {
      complimentActionController.selectAlreadyAssignedBadge();
    } else {
      // Allow remove badge state
      // If there is no new selection
      //and there is any badge that is assigned and not selected
      bool allowRemove = false;
      for (var badge in badges) {
        if (badge.isNewSelection) {
          allowRemove = false;
          return;
        } else if (badge.isAssigned && !badge.isSelected) {
          allowRemove = true;
        }
      }
      if (allowRemove) {
        complimentActionController.removeBadge();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final complimentType = widget.complimentType;

    if (complimentType is SendCompliment) {
      complimentBadgeCubit.fetchComplimentBadgesSender(
          userId: complimentType.receiverId);
    } else {
      complimentBadgeCubit.fetchOwnProfileComplimentBadges();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: complimentBadgeCubit),
        BlocProvider(
            create: (context) =>
                ManageComplimentCubit(ComplimentBadgeRepository())),
      ],
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: size.height * 0.6,
            minHeight: size.height * 0.3,
          ),
          child: BlocBuilder<ComplimentBadgeCubit, ComplimentBadgeState>(
            builder: (context, complimentBadgeState) {
              if (complimentBadgeState is ComplimentBadgeError) {
                return ErrorTextWidget(error: complimentBadgeState.message);
              } else if (complimentBadgeState is ComplimentBadgeLoaded) {
                final logs = complimentBadgeState.complimentBadges;

                if (logs.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No badges found"),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      //heading
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          widget.complimentType.dialogHeadingText,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ApplicationColours.themeBlueColor,
                          ),
                        ),
                      ),

                      //Divider
                      const Divider(thickness: 2),

                      // Badges
                      Flexible(
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            final badge = logs[index];

                            return GestureDetector(
                              onTap: () {
                                //Badge selection
                                context
                                    .read<ComplimentBadgeCubit>()
                                    .selectBadge(
                                      selectionStrategy: widget
                                          .complimentType.selectionStrategy,
                                      badgeId: badge.id,
                                    );

                                //State update
                                updateComplimentActionState(badge, logs);
                              },
                              child: ComplimentBadgeWidget(
                                userId: widget.userId,
                                badge: badge,
                              ),
                            );
                          },
                        ),
                      ),

                      // Action button
                      BlocConsumer<ManageComplimentCubit,
                          ManageComplimentState>(
                        listener: (context, manageComplimentState) {
                          if (manageComplimentState
                                  is ManageComplimentRequestSuccess &&
                              Navigator.of(context).canPop()) {
                            //If the own profile badge is assigned successfully, then update the profile details
                            if (widget.complimentType is OwnProfileCompliment) {
                              context
                                  .read<ManageProfileDetailsBloc>()
                                  .add(FetchProfileDetails());
                            }
                            Navigator.pop(context);
                            final newSelectedBadges =
                            logs.where((e) => e.isSelected);
                            if(newSelectedBadges.isEmpty)
                              ThemeToast.successToast("Please assign atleast one badge");
                          }
                        },
                        builder: (context, manageComplimentState) {
                          final disableButton = logs
                              .where((e) =>
                                  e.isNewSelection ||
                                  (e.isAssigned && !e.isSelected))
                              .toList()
                              .isEmpty;

                          final newSelectedBadges =
                              logs.where((e) => e.isSelected);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ThemeElevatedButton(
                              disableButton: disableButton,
                              width: 150,
                              height: 40,
                              textFontSize: 12,
                              padding: EdgeInsets.zero,
                              backgroundColor:
                                  ApplicationColours.themeBlueColor,
                              showLoadingSpinner: manageComplimentState
                                  is ManageComplimentRequestLoading,
                              onPressed: () {
                                final complimentType = widget.complimentType;
                                if (complimentType is SendCompliment) {
                                  context
                                      .read<ManageComplimentCubit>()
                                      .sendCompliment(
                                        receiverId: complimentType.receiverId,
                                        badgeIdList: newSelectedBadges
                                            .map((e) => e.id)
                                            .toList(),
                                      );
                                } else {
                                  context
                                      .read<ManageComplimentCubit>()
                                      .setProfileBadge(
                                          badgeId: newSelectedBadges.first.id);
                                }
                              },
                              buttonName: isSender
                                  ? complimentActionController.state
                                          is RemoveComplimentBadgeState
                                      ? "Remove Badge"
                                      : "Send Badge"
                                  : "Add Badge",
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              } else {
                return const Center(
                  child: ThemeSpinner(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ComplimentView extends StatefulWidget {
  final ComplimentType complimentType;
  final String userId;
  const ComplimentView({
    super.key,
    required this.complimentType,
    required this.userId,
  });

  @override
  State<ComplimentView> createState() => _ComplimentViewState();
}

class _ComplimentViewState extends State<ComplimentView> {
  late ComplimentBadgeCubit complimentBadgeCubit =
      ComplimentBadgeCubit(ComplimentBadgeRepository());

  late bool isSender = widget.complimentType is SendCompliment;

  final ComplimentActionController complimentActionController =
      ComplimentActionController();

  void updateComplimentActionState(
    ComplimentBadgeModel selectedBadge,
    List<ComplimentBadgeModel> badges,
  ) {
    if (selectedBadge.isNewSelection) {
      complimentActionController.selectNewBadge();
    } else if (selectedBadge.isSelected) {
      complimentActionController.selectAlreadyAssignedBadge();
    } else {
      // Allow remove badge state
      // If there is no new selection
      //and there is any badge that is assigned and not selected
      bool allowRemove = false;
      for (var badge in badges) {
        if (badge.isNewSelection) {
          allowRemove = false;
          return;
        } else if (badge.isAssigned && !badge.isSelected) {
          allowRemove = true;
        }
      }
      if (allowRemove) {
        complimentActionController.removeBadge();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final complimentType = widget.complimentType;

    if (complimentType is SendCompliment) {
      complimentBadgeCubit.fetchComplimentBadgesSender(
          userId: complimentType.receiverId);
    } else {
      complimentBadgeCubit.fetchOwnProfileComplimentBadges();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: complimentBadgeCubit),
        BlocProvider(
            create: (context) =>
                ManageComplimentCubit(ComplimentBadgeRepository())),
      ],
      child: BlocBuilder<ComplimentBadgeCubit, ComplimentBadgeState>(
        builder: (context, complimentBadgeState) {
          if (complimentBadgeState is ComplimentBadgeError) {
            return ErrorTextWidget(error: complimentBadgeState.message);
          } else if (complimentBadgeState is ComplimentBadgeLoaded) {
            final logs = complimentBadgeState.complimentBadges;

            if (logs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No badges found"),
                ],
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(5),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final badge = logs[index];

                  return GestureDetector(
                    onTap: () {
                      //Badge selection
                      context
                          .read<ComplimentBadgeCubit>()
                          .selectBadge(
                            selectionStrategy: widget
                                .complimentType.selectionStrategy,
                            badgeId: badge.id,
                          );

                      //State update
                      updateComplimentActionState(badge, logs);
                    },
                    child: ComplimentBadgeViewWidget(
                      userId: widget.userId,
                      badge: badge,
                    ),
                  );
                },
              );
            }
          } else {
            return const Center(
              child: ThemeSpinner(),
            );
          }
        },
      ),
    );
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider.value(value: complimentBadgeCubit),
    //     BlocProvider(
    //         create: (context) =>
    //             ManageComplimentCubit(ComplimentBadgeRepository())),
    //   ],
    //   child: Dialog(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(20),
    //     ),
    //     child: ConstrainedBox(
    //       constraints: BoxConstraints(
    //         maxHeight: size.height * 0.6,
    //         minHeight: size.height * 0.3,
    //       ),
    //       child: BlocBuilder<ComplimentBadgeCubit, ComplimentBadgeState>(
    //         builder: (context, complimentBadgeState) {
    //           if (complimentBadgeState is ComplimentBadgeError) {
    //             return ErrorTextWidget(error: complimentBadgeState.message);
    //           } else if (complimentBadgeState is ComplimentBadgeLoaded) {
    //             final logs = complimentBadgeState.complimentBadges;
    //
    //             if (logs.isEmpty) {
    //               return Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   const Text("No badges found"),
    //                 ],
    //               );
    //             } else {
    //               return Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   const SizedBox(height: 10),
    //                   //heading
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(horizontal: 8),
    //                     child: Text(
    //                       widget.complimentType.dialogHeadingText,
    //                       style: TextStyle(
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.bold,
    //                         color: ApplicationColours.themeBlueColor,
    //                       ),
    //                     ),
    //                   ),
    //
    //                   //Divider
    //                   const Divider(thickness: 2),
    //
    //                   // Badges
    //                   Flexible(
    //                     child: GridView.builder(
    //                       shrinkWrap: true,
    //                       padding: const EdgeInsets.all(8),
    //                       gridDelegate:
    //                           const SliverGridDelegateWithFixedCrossAxisCount(
    //                         crossAxisCount: 3,
    //                         crossAxisSpacing: 6,
    //                         mainAxisSpacing: 15,
    //                         childAspectRatio: 0.9,
    //                       ),
    //                       itemCount: logs.length,
    //                       itemBuilder: (context, index) {
    //                         final badge = logs[index];
    //
    //                         return GestureDetector(
    //                           onTap: () {
    //                             //Badge selection
    //                             context
    //                                 .read<ComplimentBadgeCubit>()
    //                                 .selectBadge(
    //                                   selectionStrategy: widget
    //                                       .complimentType.selectionStrategy,
    //                                   badgeId: badge.id,
    //                                 );
    //
    //                             //State update
    //                             updateComplimentActionState(badge, logs);
    //                           },
    //                           child: ComplimentBadgeWidget(
    //                             userId: widget.userId,
    //                             badge: badge,
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                   ),
    //
    //                   // Action button
    //                   BlocConsumer<ManageComplimentCubit,
    //                       ManageComplimentState>(
    //                     listener: (context, manageComplimentState) {
    //                       if (manageComplimentState
    //                               is ManageComplimentRequestSuccess &&
    //                           Navigator.of(context).canPop()) {
    //                         //If the own profile badge is assigned successfully, then update the profile details
    //                         if (widget.complimentType is OwnProfileCompliment) {
    //                           context
    //                               .read<ManageProfileDetailsBloc>()
    //                               .add(FetchProfileDetails());
    //                         }
    //                         Navigator.pop(context);
    //                         final newSelectedBadges =
    //                         logs.where((e) => e.isSelected);
    //                         if(newSelectedBadges.isEmpty)
    //                           ThemeToast.successToast("Please assign atleast one badge");
    //                       }
    //                     },
    //                     builder: (context, manageComplimentState) {
    //                       final disableButton = logs
    //                           .where((e) =>
    //                               e.isNewSelection ||
    //                               (e.isAssigned && !e.isSelected))
    //                           .toList()
    //                           .isEmpty;
    //
    //                       final newSelectedBadges =
    //                           logs.where((e) => e.isSelected);
    //
    //                       return Padding(
    //                         padding: const EdgeInsets.symmetric(vertical: 10),
    //                         child: ThemeElevatedButton(
    //                           disableButton: disableButton,
    //                           width: 150,
    //                           height: 40,
    //                           textFontSize: 12,
    //                           padding: EdgeInsets.zero,
    //                           backgroundColor:
    //                               ApplicationColours.themeBlueColor,
    //                           showLoadingSpinner: manageComplimentState
    //                               is ManageComplimentRequestLoading,
    //                           onPressed: () {
    //                             final complimentType = widget.complimentType;
    //                             if (complimentType is SendCompliment) {
    //                               context
    //                                   .read<ManageComplimentCubit>()
    //                                   .sendCompliment(
    //                                     receiverId: complimentType.receiverId,
    //                                     badgeIdList: newSelectedBadges
    //                                         .map((e) => e.id)
    //                                         .toList(),
    //                                   );
    //                             } else {
    //                               context
    //                                   .read<ManageComplimentCubit>()
    //                                   .setProfileBadge(
    //                                       badgeId: newSelectedBadges.first.id);
    //                             }
    //                           },
    //                           buttonName: isSender
    //                               ? complimentActionController.state
    //                                       is RemoveComplimentBadgeState
    //                                   ? "Remove Badge"
    //                                   : "Send Badge"
    //                               : "Add Badge",
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ],
    //               );
    //             }
    //           } else {
    //             return const Center(
    //               child: ThemeSpinner(),
    //             );
    //           }
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}


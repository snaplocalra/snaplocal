import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:snap_local/common/review_module/logic/manage_rating/manage_rating_cubit.dart';
import 'package:snap_local/common/review_module/logic/rating_builder/rating_builder_cubit.dart';
import 'package:snap_local/common/review_module/model/add_rating_model.dart';
import 'package:snap_local/common/review_module/model/ratings_review_model.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/common/review_module/repository/ratings_review_repository.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';
import 'package:snap_local/utility/tools/text_field_validator.dart';

class GiveRatingWidget extends StatefulWidget {
  final CustomerReview? existingReview;
  final String postId;
  final RatingType ratingType;
  final Future Function()? refreshAfterReview;
  final ManageRatingCubit? manageRatingCubit;
  final Alignment saveButtonAlignment;
  const GiveRatingWidget({
    super.key,
    this.existingReview,
    required this.postId,
    required this.ratingType,

    ///After the review is submitted, this function will be called,
    ///then in the ManageRatingCubit, the emit state will call after this function is called
    this.refreshAfterReview,
    this.manageRatingCubit,
    this.saveButtonAlignment = Alignment.center,
  });

  @override
  State<GiveRatingWidget> createState() => _GiveRatingWidgetState();
}

class _GiveRatingWidgetState extends State<GiveRatingWidget> {
  bool get isEdit => widget.existingReview != null;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final reviewController = TextEditingController();
  final ratingBuilderCubit = RatingBuilderCubit();

  late ManageRatingCubit manageRatingCubit = widget.manageRatingCubit ??
      ManageRatingCubit(ratingsReviewRepository: RatingsReviewRepository());

  @override
  void dispose() {
    super.dispose();
    reviewController.dispose();
  }

  Future<void> refreshAfterReview() async {
    // reviewController.clear();
    // ratingBuilderCubit.resetRating();

    if (widget.refreshAfterReview != null) {
      await widget.refreshAfterReview!.call();
    }
  }

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      reviewController.text = widget.existingReview!.comment;
      ratingBuilderCubit.giveRating(widget.existingReview!.starRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ratingBuilderCubit),
        BlocProvider.value(value: manageRatingCubit),
      ],
      child: BlocBuilder<RatingBuilderCubit, RatingBuilderState>(
        builder: (context, ratingBuilderState) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(15),
            child: BlocBuilder<ManageRatingCubit, ManageRatingState>(
              builder: (context, manageRatingState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      tr(widget.ratingType.title),
                      style: const TextStyle(
                        color: Color.fromRGBO(0, 25, 104, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      tr(LocaleKeys.rateDialogDescription),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                            child: RatingStars(
                          value: ratingBuilderState.givenRating,
                          onValueChanged: manageRatingState.requestLoading
                              ? null
                              : (givenRating) {
                                  context
                                      .read<RatingBuilderCubit>()
                                      .giveRating(givenRating);
                                },
                          // starBuilder: (index, color) {
                          //   final isIndexSelected =
                          //       ratingBuilderState.givenRating.toInt() - 1 == index;

                          //   color = isIndexSelected
                          //       ? ApplicationColours.themeLightPinkColor
                          //       : color;

                          //   final double iconSize = isIndexSelected ? 44 : 35;
                          //   switch (index) {
                          //     case 0:
                          //       return SvgPicture.asset(
                          //         SVGAssetsImages.rating1,
                          //         colorFilter: ColorFilter.mode(
                          //           color!,
                          //           BlendMode.dstOut,
                          //         ),
                          //         height: iconSize,
                          //         width: iconSize,
                          //       );
                          //     case 1:
                          //       return SvgPicture.asset(
                          //         SVGAssetsImages.rating2,
                          //         colorFilter: ColorFilter.mode(
                          //           color!,
                          //           BlendMode.src,
                          //         ),
                          //         height: iconSize,
                          //         width: iconSize,
                          //       );
                          //     case 2:
                          //       return SvgPicture.asset(
                          //         SVGAssetsImages.rating3,
                          //         colorFilter: ColorFilter.mode(
                          //           color!,
                          //           BlendMode.src,
                          //         ),
                          //         height: iconSize,
                          //         width: iconSize,
                          //       );
                          //     case 3:
                          //       return SvgPicture.asset(
                          //         SVGAssetsImages.rating4,
                          //         colorFilter: ColorFilter.mode(
                          //           color!,
                          //           BlendMode.dstIn,
                          //         ),
                          //         height: iconSize,
                          //         width: iconSize,
                          //       );
                          //     case 4:
                          //       return SvgPicture.asset(
                          //         SVGAssetsImages.rating5,
                          //         colorFilter: ColorFilter.mode(
                          //           color!,
                          //           BlendMode.dstIn,
                          //         ),
                          //         height: iconSize,
                          //         width: iconSize,
                          //       );

                          //     default:
                          //       throw ("Invalid index for rating");
                          //   }
                          // },
                          starBuilder: (index, color) {
                            final isIndexSelected =
                                ratingBuilderState.givenRating.toInt() - 1 ==
                                    index;

                            color = isIndexSelected
                                ? ApplicationColours.themeLightPinkColor
                                : color;
                            return Icon(
                              Icons.star,
                              color: color,
                              size: isIndexSelected ? 40 : 35,
                            );
                          },
                          valueLabelVisibility: false,
                          starCount: 5,
                          starSize: 40,
                          maxValue: 5,
                          starSpacing: 0,
                          animationDuration: const Duration(milliseconds: 1000),
                          starOffColor: const Color(0xffe7e8ea),
                          starColor: const Color.fromRGBO(243, 141, 24, 1),
                        ))),
                    Form(
                      key: formkey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ThemeTextFormField(
                          enabled: !manageRatingState.requestLoading,
                          controller: reviewController,
                          minLines: 6,
                          maxLines: 10,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.newline,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          hint: tr(LocaleKeys.writeAReview),
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1,
                          ),
                          hintStyle: const TextStyle(fontSize: 14),
                          maxLength: TextFieldInputLength.reviewMaxLength,
                          validator: (value) =>
                              TextFieldValidator.standardValidatorWithMinLength(
                            value,
                            TextFieldInputLength.reviewMinLength,
                            isOptional: true,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Align(
                        alignment: widget.saveButtonAlignment,
                        child: ThemeElevatedButton(
                            showLoadingSpinner:
                                manageRatingState.requestLoading,
                            height: mqSize.height * 0.05,
                            padding: EdgeInsets.zero,
                            textFontSize: 12,
                            width: mqSize.width * 0.35,
                            backgroundColor: ApplicationColours.themeBlueColor,
                            buttonName: isEdit
                                ? tr(LocaleKeys.update)
                                : tr(LocaleKeys.submit),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (ratingBuilderState.givenRating == 0.0) {
                                ThemeToast.errorToast(
                                  "Please select a star rating",
                                );
                                return;
                              } else if (formkey.currentState!.validate()) {
                                final addRatingModel = AddRatingModel(
                                  id: widget.existingReview?.id,
                                  postId: widget.postId,
                                  comment: reviewController.text.trim(),
                                  rating: ratingBuilderState.givenRating,
                                  review: reviewController.text.trim(),
                                );
                                context.read<ManageRatingCubit>().saveReview(
                                      isEdit: isEdit,
                                      addRatingModel: addRatingModel,
                                      ratingType: widget.ratingType,
                                      refreshAfterReview: () async =>
                                          await refreshAfterReview(),
                                    );
                                return;
                              }
                            }),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

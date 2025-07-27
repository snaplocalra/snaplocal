import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/logic/poll_vote_manage/poll_vote_manage_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/poll_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_type_selector/poll_type_selector_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/utility/poll_option_colour.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class PollOptionBuilder extends StatelessWidget {
  final PollOptionModel pollOptionDetails;
  final bool hideResultUntilPollEnds;
  final bool disableOptionSelection;
  final PollTypeEnum pollType;
  final bool enablePollData;
  const PollOptionBuilder({
    super.key,
    required this.pollOptionDetails,
    required this.hideResultUntilPollEnds,
    required this.pollType,
    this.enablePollData = true,
    this.disableOptionSelection = false,
  });

  double _progressPercentage(int voteCount) {
    final result = (voteCount.toDouble() / pollOptionDetails.totalParticipants);
    return result.isNaN ? 0 : result;
  }

  @override
  Widget build(BuildContext context) {
    final pollOptions = pollOptionDetails.options;
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: pollOptions.length,
      itemBuilder: (context, index) {
        final pollOption = pollOptions[index];
        final votePercentage = _progressPercentage(pollOption.voteCount);
        return Padding(
          key: ValueKey(pollOption.optionId),
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: GestureDetector(
            onTap: disableOptionSelection
                ? null
                : () {
                    context.read<PollVoteManageCubit>().updateVote(
                        pollOption.optionId,
                        allowAnswerChange: true);
                  },
            child:
                pollType == PollTypeEnum.photo && pollOption.optionImage != null
                    ? PhotoPollOptionWidget(
                        color: getPollOptionColor(index),
                        progressValue: votePercentage,
                        text: pollOption.optionName,
                        voteCount: pollOption.voteCount,
                        showResult: !hideResultUntilPollEnds,
                        userSelectedOption: pollOption.userSelectedOption,
                        imageUrl: pollOption.optionImage!,
                        enablePollData: enablePollData,
                      )
                    : TextPollOptionWidget(
                        enablePollData: enablePollData,
                        color: getPollOptionColor(index),
                        progressValue: votePercentage,
                        text: pollOption.optionName,
                        voteCount: pollOption.voteCount,
                        showResult: !hideResultUntilPollEnds,
                        userSelectedOption: pollOption.userSelectedOption,
                      ),
          ),
        );
      },
    );
  }
}

//Text poll option widget
class TextPollOptionWidget extends StatelessWidget {
  final int voteCount;
  final String text;
  final double progressValue;
  final bool userSelectedOption;
  final bool showResult;
  final Color color;
  final bool enablePollData;
  const TextPollOptionWidget({
    super.key,
    required this.progressValue,
    required this.text,
    required this.voteCount,
    required this.userSelectedOption,
    required this.showResult,
    required this.color,
    required this.enablePollData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(225, 222, 249, 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.2, color: Colors.grey),
      ),
      height: 40,
      child: Stack(
        children: [
          LinearPercentIndicator(
            percent: enablePollData ? progressValue : 0,
            lineHeight: double.infinity,
            progressColor: color,
            backgroundColor: color.withOpacity(0.4),
            // voteCount > 0 ? color.withOpacity(0.4) : Colors.grey.shade100,
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //tick in circle for the selected option
                  Visibility(
                    visible: enablePollData && userSelectedOption,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.black45,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      text,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: enablePollData && showResult && progressValue > 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${(progressValue * 100).formatNumber()}%",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "$voteCount ${voteCount <= 1 ? LocaleKeys.vote : LocaleKeys.votes}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//photo poll option widget
class PhotoPollOptionWidget extends StatelessWidget {
  final int voteCount;
  final String text;
  final double progressValue;
  final bool userSelectedOption;
  final bool showResult;
  final Color color;
  final String imageUrl;
  final bool enablePollData;

  const PhotoPollOptionWidget({
    super.key,
    required this.progressValue,
    required this.text,
    required this.voteCount,
    required this.userSelectedOption,
    required this.showResult,
    required this.color,
    required this.imageUrl,
    required this.enablePollData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //photo
        NetworkImageCircleAvatar(
          imageurl: imageUrl,
          radius: 30,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //option name
              Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              //progress bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: LinearPercentIndicator(
                  percent: enablePollData ? progressValue : 0,
                  lineHeight: 30,
                  progressColor: color,
                  // backgroundColor: Colors.grey.withOpacity(0.1),
                  backgroundColor: color.withOpacity(0.4),

                  barRadius: const Radius.circular(5),
                  padding: EdgeInsets.zero,
                  center: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //tick in circle for the selected option
                        Visibility(
                          visible: enablePollData && userSelectedOption,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black45,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),

                        Visibility(
                          visible:
                              enablePollData && showResult && progressValue > 0,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "${(progressValue * 100).formatNumber()}%",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //count of votes
              Visibility(
                visible: enablePollData,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$voteCount ${voteCount <= 1 ? LocaleKeys.vote : LocaleKeys.votes}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/widgets/sales_post_short_details_grid_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/logic/saved_item/saved_item_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/widgets/saved_item_data_heading.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SavedMarketListBuilder extends StatelessWidget {
  final List<SalesPostShortDetailsModel> logs;
  final bool isAllType;

  const SavedMarketListBuilder({
    super.key,
    required this.logs,
    this.isAllType = false,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return (logs.isEmpty)
        ? isAllType
            ? const SizedBox.shrink()
            : SizedBox(
                height: mqSize.height * 0.6,
                child: const EmptyDataPlaceHolder(
                  emptyDataType: EmptyDataType.business,
                ),
              )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SavedItemDataHeading(
              visible: isAllType,
              text: LocaleKeys.marketAdda,
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(5),
              shrinkWrap: true,
              itemCount: logs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (BuildContext context, index) {
                final salesPostDetails = logs[index];
                return MultiBlocProvider(
                  key: ValueKey(salesPostDetails.id),
                  providers: [
                    BlocProvider(
                        create: (context) =>
                            PostActionCubit(PostActionRepository())),
                  ],
                  child: BlocListener<PostActionCubit, PostActionState>(
                    listener: (context, postActionState) {
                      if (postActionState.isDeleteRequestSuccess ||
                          (salesPostDetails.isSaved &&
                              postActionState.isSaveRequestLoading)) {
                        context.read<SavedItemCubit>().removeSalePost(index);
                      }
                    },
                    child: SalesPostShortDetailsGridWidget(
                      salesPostDetails: salesPostDetails,
                      onRemoveItem: () {
                        context.read<SavedItemCubit>().removeSalePost(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ]);
  }
}

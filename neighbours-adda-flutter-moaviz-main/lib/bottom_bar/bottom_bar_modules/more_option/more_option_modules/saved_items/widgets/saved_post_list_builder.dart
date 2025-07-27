import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/logic/saved_item/saved_item_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';

class SavedPostsListBuilder extends StatelessWidget {
  final ShowReactionCubit showReactionCubit;
  final List<SocialPostModel> logs;
  final bool isAllType;

  const SavedPostsListBuilder({
    super.key,
    required this.showReactionCubit,
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
                  emptyDataType: EmptyDataType.post,
                ),
              )
        : SocialPostListBuilder(
            socialPostList: logs,
            hideEmptyPlaceHolder: true,
            allowAction: false,
            onRemoveItemFromList: (index) {
              context.read<SavedItemCubit>().removePost(index);
            },
            onRemoveByUnsaved: (index) {
              context.read<SavedItemCubit>().removePost(index);
            },
          );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/master_category_selector_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/visibility_controller/visibility_controller_cubit.dart';
import 'package:snap_local/common/utils/widgets/animated_hide_widget.dart';

class MasterCategoryWidget extends StatelessWidget {
  const MasterCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisibilityControllerCubit, VisibilityControllerState>(
      builder: (context, visibilityControllerState) {
        return Column(
          children: [
            AnimatedHideWidget(
              visible: visibilityControllerState.isVisible,
              child: const MasterCategorySelectorWidget(),
            ),
            Visibility(
              visible: !visibilityControllerState.isVisible,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    context
                        .read<VisibilityControllerCubit>()
                        .changeVisibility(true);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.category_outlined),
                      const SizedBox(width: 5),
                      Text(tr(LocaleKeys.moreCategory)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

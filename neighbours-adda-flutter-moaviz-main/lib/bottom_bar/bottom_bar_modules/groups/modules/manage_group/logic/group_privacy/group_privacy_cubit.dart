import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/models/group_privacy_type_enum.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';

part 'group_privacy_state.dart';

class GroupPrivacyTypeCubit extends Cubit<GroupPrivacyTypeState> {
  GroupPrivacyTypeCubit()
      : super(
          GroupPrivacyTypeState(
            groupPrivacyTypesListModel: CategoryListModel(
              data: [
                CategoryModel(
                  id: GroupPrivacyStatus.public.jsonValue,
                  name: tr(GroupPrivacyStatus.public.dsiplayName),
                ),
                CategoryModel(
                  id: GroupPrivacyStatus.private.jsonValue,
                  name: tr(GroupPrivacyStatus.private.dsiplayName),
                ),
              ],
            ),
          ),
        );

  void selectGroupPrivacy(String groupPrivacyId) {
    if (state.groupPrivacyTypesListModel.data.isNotEmpty) {
      emit(state.copyWith(dataLoading: true));

      for (var groupPrivacyType in state.groupPrivacyTypesListModel.data) {
        if (groupPrivacyType.id == groupPrivacyId) {
          groupPrivacyType.isSelected = true;
        } else {
          groupPrivacyType.isSelected = false;
        }
      }

      emit(state.copyWith(
          groupPrivacyTypesListModel: state.groupPrivacyTypesListModel));
    }
  }
}

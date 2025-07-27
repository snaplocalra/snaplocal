import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/sales_post_manage_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/repository/manage_sales_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'manage_sales_post_state.dart';

class ManageSalesPostCubit extends Cubit<ManageSalesPostState> {
  final ManageSalesRepository manageSalesRepository;
  final MediaUploadRepository mediaUploadRepository;

  ManageSalesPostCubit({
    required this.manageSalesRepository,
    required this.mediaUploadRepository,
  }) : super(const ManageSalesPostState());

  ///This method can create and update the business
  Future<void> createOrUpdateSalesPost({
    required SalesPostManageModel salesPostManageModel,
    required List<MediaFileModel> pickedMediaList,

    //Edit mode
    required bool isEdit,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      if (pickedMediaList.isNotEmpty) {
        //Upload the picked media to server
        final mediaUploadResponse = await mediaUploadRepository.uploadMedia(
          mediaUploadType: MediaUploadType.market,
          mediaList: pickedMediaList,
        );

        //Add the server response image list in the data model
        salesPostManageModel.media.addAll(mediaUploadResponse.mediaList);
      }

      //manage sales post api call
      await manageSalesRepository.manageSalesPost(
        salesPostManageModel: salesPostManageModel,
        isEdit: isEdit,
      );

      emit(state.copyWith(isRequestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }
}

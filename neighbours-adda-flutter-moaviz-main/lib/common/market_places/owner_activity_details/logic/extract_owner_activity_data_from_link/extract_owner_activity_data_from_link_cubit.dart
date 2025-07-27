import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_screen_data.dart';
import 'package:snap_local/common/utils/share/repository/value_compressor_repository.dart';

part 'extract_owner_activity_data_from_link_state.dart';

class ExtractOwnerActivityDataFromLinkCubit
    extends Cubit<ExtractOwnerActivityDataFromLinkState> {
  ExtractOwnerActivityDataFromLinkCubit()
      : super(const ExtractOwnerActivityDataFromLinkState());

//Fetch the shared post details from the deeplink
  Future<void> extractOwnerActivityData(String encryptedData) async {
    try {
      emit(state.copyWith(dataLoading: true));

      //Decrypting the data
      final decryptedData =
          await ValueCompressorRepository().decompressValue(encryptedData);

      if (decryptedData == null) {
        throw ("Unable to open the post");
      }

      //Converting the decrypted data to model
      final ownerActivityScreenData =
          OwnerActivityDetailsScreenData.fromJson(decryptedData);

      //Emitting the state with the extracted data
      emit(state.copyWith(ownerActivityScreenData: ownerActivityScreenData));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
      return;
    }
  }
}

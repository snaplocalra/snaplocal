import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/logic/models/manage_bank_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/repository/bank_details_repository.dart';

part 'manage_bank_details_state.dart';

class ManageBankDetailsCubit extends Cubit<ManageBankDetailsState> {
  final ManageBankRepository bankDetailsRepository;
  ManageBankDetailsCubit(this.bankDetailsRepository)
      : super(AddBankDetailsInitial());

  //Add bank details
  Future<void> addBankDetails(ManageBankDetailsModel bankDetails) async {
    try {
      emit(AddBankDetailsLoading());
      await bankDetailsRepository.addBankDetails(bankDetails);
      emit(AddBankDetailsSuccess());
    } catch (e) {
      emit(AddBankDetailsFailure(e.toString()));
    }
  }
}

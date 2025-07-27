import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/model/bank_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/repository/bank_details_repository.dart';

part 'bank_list_controller_state.dart';

class BankListControllerCubit extends Cubit<BankListControllerState> {
  final ManageBankRepository manageBankRepository;
  BankListControllerCubit(this.manageBankRepository)
      : super(const BankListControllerState());

  //Fetch Bank List
  Future<void> fetchBankList() async {
    try {
      emit(state.copyWith(requestLoading: true));
      await manageBankRepository.fetchBankList().then((bankList) {
        emit(state.copyWith(
          requestSuccess: true,
          banklist: bankList,
        ));
      });
    } catch (e) {
      emit(state.copyWith(errorMessage: "Unable to fetch bank list"));
    }
  }

  //Select Bank based on index, remove default from other banks
  void bankListControllerCubit(int index) {
    try {
      emit(state.copyWith(requestLoading: true));
      final bankList = state.banklist;
      for (var i = 0; i < bankList.length; i++) {
        if (i == index) {
          bankList[i].isDefault = true;
          //Add api call to update default bank in backend
        } else {
          bankList[i].isDefault = false;
        }
      }
      emit(state.copyWith(banklist: bankList));
    } catch (e) {
      emit(state.copyWith(requestLoading: false));
    }
  }
}

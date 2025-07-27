import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/introduction/helper/introduction_shared_pref.dart';

part 'user_consent_handler_state.dart';

class UserConsentHandlerCubit extends Cubit<UserConsentHandlerState> {
  UserConsentHandlerCubit() : super(const UserConsentHandlerState());
  final _introductionSharedPref = IntroductionSharedPref();

  Future<void> checkLanguageAndAgreement() async {
    emit(state.copyWith(loading: true));

    bool languageSelected =
        await _introductionSharedPref.isInitialChooseLanguageCompleted();
    bool termsAgreed = await _introductionSharedPref.isIntroductionCompleted();

    emit(state.copyWith(
      languageSelected: languageSelected,
      termsAgreed: termsAgreed,
    ));

    return;
  }
}

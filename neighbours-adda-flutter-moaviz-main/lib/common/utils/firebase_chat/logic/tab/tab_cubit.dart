import 'package:flutter_bloc/flutter_bloc.dart';

class MainConversationTabsCubit extends Cubit<int> {
  MainConversationTabsCubit() : super(1) {
    print('MainConversationTabsCubit initialized with state: $state');
  }

  void changeTab(int index) {
    print('MainConversationTabsCubit: Changing tab from $state to $index');
    if (state != index) {
      emit(index);
      print('MainConversationTabsCubit: State updated to $index');
    } else {
      print('MainConversationTabsCubit: State unchanged, already at $index');
    }
  }
} 
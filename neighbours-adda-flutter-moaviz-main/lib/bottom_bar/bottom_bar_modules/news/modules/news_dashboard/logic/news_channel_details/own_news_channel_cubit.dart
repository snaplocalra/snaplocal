import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/model/manage_news_channel_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/repository/manage_news_channel_repository.dart';

part 'own_news_channel_state.dart';

class OwnNewsChannelCubit extends Cubit<OwnNewsChannelState> {
  final ManageNewsChannelRepositoryImpl manageNewsChannelRepositoryImpl;
  OwnNewsChannelCubit(this.manageNewsChannelRepositoryImpl)
      : super(OwnNewsChannelInitial());

  //Fetch the own news channel
  Future<void> fetchOwnNewsChannel() async {
    try {
      emit(OwnNewsChannelLoading());
      final newsChannel =
          await manageNewsChannelRepositoryImpl.getNewsChannel();
      emit(OwnNewsChannelLoaded(ownNewsChannel: newsChannel));
    } catch (e) {
      emit(OwnNewsChannelLoadFailed(errorMessage: e.toString()));
    }
  }
}

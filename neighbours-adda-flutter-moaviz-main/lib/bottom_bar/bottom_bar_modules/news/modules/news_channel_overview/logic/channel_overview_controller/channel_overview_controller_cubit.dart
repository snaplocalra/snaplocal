import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/model/news_channel_overview_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/repository/news_channel_overview_repository.dart';

part 'channel_overview_controller_state.dart';

class ChannelOverviewControllerCubit
    extends Cubit<ChannelOverviewControllerState> {
  final NewsChannelOverviewRepository newsChannelOverviewRepository;

  ChannelOverviewControllerCubit(this.newsChannelOverviewRepository)
      : super(ChannelOverviewControllerInitial());

  //Get the channel overview data
  Future<void> getChannelOverviewData(String channelId) async {
    try {
      // if the state is not the ChannelOverviewControllerSuccess then run the loading state
      if (state is ChannelOverviewControllerInitial ||
          state is ChannelOverviewControllerError) {
        //Emit the loading state
        emit(ChannelOverviewControllerLoading());
      }

      //Get the channel overview data
      final newsChannelOverViewModel =
          await newsChannelOverviewRepository.getChannelOverviewData(channelId);

      //Emit the success state
      emit(ChannelOverviewControllerSuccess(
        newsChannelOverViewModel: newsChannelOverViewModel,
      ));
    } catch (e) {
      //Emit the error state
      emit(ChannelOverviewControllerError(errorMessage: e.toString()));
    }
  }
}

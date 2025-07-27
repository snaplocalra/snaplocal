import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/logic/news_location_type_selector/cubit/news_location_type_selector_state.dart';

class NewsLocationTypeSelectorCubit
    extends Cubit<NewsLocationTypeSelectorState> {
  final NewsLocationTypeEnum preSelectedType;

  NewsLocationTypeSelectorCubit(this.preSelectedType)
      : super(NewsLocationTypeSelectorState(preSelectedType));

  void switchType(NewsLocationTypeEnum selectedLocationType) {
    emit(state.copyWith(selectedLocationType: selectedLocationType));
  }
}

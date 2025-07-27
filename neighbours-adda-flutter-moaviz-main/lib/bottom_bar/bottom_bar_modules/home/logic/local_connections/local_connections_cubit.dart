import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_connections/local_connections_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_connection_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';

class LocalConnectionsCubit extends Cubit<LocalConnectionsState> {
  final HomeDataRepository homeDataRepository;

  LocalConnectionsCubit(this.homeDataRepository) : super(const LocalConnectionsState());

  Future<void> loadConnections() async {
    try {
      emit(state.copyWith(dataLoading: true));
      
      final connections = await homeDataRepository.fetchLocalConnections();
      
      emit(state.copyWith(
        connections: connections,
        dataLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        dataLoading: false,
      ));
    }
  }

 
} 
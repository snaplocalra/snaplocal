// import 'package:designer/utility/theme_toast.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'multi_media_list_manager_state.dart';

// class MultiMediaListManagerCubit extends Cubit<MultiMediaListManagerState> {
//   final int? maxAllowedElementCount;
//   MultiMediaListManagerCubit({this.maxAllowedElementCount})
//       : super(MultiMediaListManagerState(
//             maxAllowedElementCount: maxAllowedElementCount ?? 8));

//   void changeCurrentAllowedElementCount({bool? useMaxElement}) {
//     if (state.currentAllowedElementCount <= state.maxAllowedElementCount) {
//       int newCurrentAllowedElementCount = 0;
//       if (useMaxElement != null && useMaxElement) {
//         newCurrentAllowedElementCount = useMaxElement
//             ? state.maxAllowedElementCount
//             : state.defaultAllowElement;
//       } else {
//         if (state.usedElementCount > 4) {
//           newCurrentAllowedElementCount = state.maxAllowedElementCount;
//         } else {
//           newCurrentAllowedElementCount = state.defaultAllowElement;
//         }
//       }
//       emit(state.copyWith(
//           currentAllowedElementCount: newCurrentAllowedElementCount));
//     } else {
//       ThemeToast.errorToast("Unable to change current allowed element count");
//     }
//   }

//   void setUsedElementCount(int usedElementCount, {bool remove = false}) {
//     if (state.usedElementCount <= state.maxAllowedElementCount) {
//       final newUsedElementCount =
//           remove ? state.usedElementCount - usedElementCount : usedElementCount;

//       emit(state.copyWith(usedElementCount: newUsedElementCount));

//       //Check and update the current allowed element count
//       if (state.usedElementCount > state.defaultAllowElement) {
//         changeCurrentAllowedElementCount(useMaxElement: true);
//       } else {
//         changeCurrentAllowedElementCount();
//       }
//     } else {
//       ThemeToast.errorToast("Unable to set used element count");
//     }
//   }
// }

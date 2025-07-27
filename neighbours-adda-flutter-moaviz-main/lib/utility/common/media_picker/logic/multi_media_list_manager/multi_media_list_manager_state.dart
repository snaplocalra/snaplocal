// part of 'multi_media_list_manager_cubit.dart';

// class MultiMediaListManagerState extends Equatable {
//   final int maxAllowedElementCount;
//   final int defaultAllowElement;
//   final int usedElementCount;
//   final int currentAllowedElementCount;

//   const MultiMediaListManagerState({
//     this.maxAllowedElementCount = 8,
//     this.usedElementCount = 0,
//     this.defaultAllowElement = 4,
//     this.currentAllowedElementCount = 4,
//   });

//   bool get allowAddElement => usedElementCount < maxAllowedElementCount;

//   @override
//   List<Object> get props =>
//       [maxAllowedElementCount, usedElementCount, currentAllowedElementCount];

//   MultiMediaListManagerState copyWith({
//     int? maxAllowedElementCount,
//     int? usedElementCount,
//     int? currentAllowedElementCount,
//   }) {
//     return MultiMediaListManagerState(
//       maxAllowedElementCount:
//           maxAllowedElementCount ?? this.maxAllowedElementCount,
//       usedElementCount: usedElementCount ?? this.usedElementCount,
//       currentAllowedElementCount:
//           currentAllowedElementCount ?? this.currentAllowedElementCount,
//     );
//   }
// }

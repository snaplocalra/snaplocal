import 'package:equatable/equatable.dart';

class LocalChatFlagedCountState extends Equatable {
  final String flagCount;
  final bool isLoading;
  final String? error;
  final bool hasAccess;
  final String? status;
  final String? message;

  const LocalChatFlagedCountState({
    this.flagCount = "0",
    this.isLoading = false,
    this.error,
    this.hasAccess = true,
    this.status,
    this.message,
  });

  LocalChatFlagedCountState copyWith({
    String? flagCount,
    bool? isLoading,
    String? error,
    bool? hasAccess,  
    String? status,
    String? message,
  }) {
    return LocalChatFlagedCountState(
      flagCount: flagCount ?? this.flagCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasAccess: hasAccess ?? this.hasAccess,    
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        flagCount,
        isLoading,
        error,
        hasAccess,
        status,
        message,
      ];
}
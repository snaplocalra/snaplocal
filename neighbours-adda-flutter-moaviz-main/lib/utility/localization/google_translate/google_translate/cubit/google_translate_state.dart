part of 'google_translate_cubit.dart';

class GoogleTranslateState extends Equatable {
  final String translatedText;

  const GoogleTranslateState({required this.translatedText});

  @override
  List<Object> get props => [translatedText];

  //copyWith method
  GoogleTranslateState copyWith({String? translatedText}) {
    return GoogleTranslateState(
      translatedText: translatedText ?? this.translatedText,
    );
  }
}

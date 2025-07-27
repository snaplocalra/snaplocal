import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:snap_local/utility/api_manager/config/env/env.dart';
import 'package:synchronized/synchronized.dart';

/// This class is responsible for handling the Google Gemini model.
class GoogleGeminiModel {
  GoogleGeminiModel._(); // Private constructor to prevent direct instantiation.

  // Singleton instance of GenerativeModel.
  static GenerativeModel? _instance;

  // Lock for thread safety.
  static final _lock = Lock();

  /// Initializes the GoogleGeminiModel 
  static Future<void> initialize() async {
    if (_instance == null) {
      await _lock.synchronized(() {
        _instance = GenerativeModel(
          model: "gemini-1.5-flash",
          apiKey: googleGenerateModelAPIKey,
        );
      });
    }
  }

  /// Returns the singleton instance of GenerativeModel.
  static GenerativeModel get instance {
    if (_instance == null) {
      throw Exception("GoogleGeminiModel is not initialized. Call initialize first.");
    }
    return _instance!;
  }
}

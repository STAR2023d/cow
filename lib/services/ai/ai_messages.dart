import 'package:cow/services/ai/ai_generator.dart';

/// Farmer-friendly wording for each way an AI request can fail, so every
/// screen explains it the same way.
extension AiFailureMessage on AiFailure {
  String get message => switch (this) {
    AiFailure.noKey =>
      'The AI is not set up in this version of the app (no API key).',
    AiFailure.network =>
      "Couldn't reach the AI. Check your internet and try again.",
    AiFailure.busy =>
      'The AI is very busy right now. Wait a minute and try again.',
    AiFailure.blocked =>
      "The AI didn't give an answer. Try again, or describe things in "
          'different words.',
    AiFailure.unknown => 'Something went wrong. Please try again.',
  };
}

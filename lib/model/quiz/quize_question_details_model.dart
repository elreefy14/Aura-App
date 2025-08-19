class QuizQuestionDetailsModel {
  QuizQuestionDetailsModel({
    required this.quizSession,
    required this.previousWasCorrect,
    required this.question,
  });

  final QuizSession quizSession;
  final bool? previousWasCorrect;
  final Question? question;

  QuizQuestionDetailsModel.fromJson(Map<String, dynamic> json)
      : quizSession = QuizSession.fromJson(json['quiz_session']),
        previousWasCorrect = json['previous_was_correct'] as bool?,
        question = json['question'] == null
            ? null
            : Question.fromJson(json['question']);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['quiz_session'] = quizSession.toJson();
    data['previous_was_correct'] = previousWasCorrect;
    data['question'] = question?.toJson();
    return data;
  }
}

class QuizSession {
  QuizSession({
    required this.id,
    required this.seenQuestionIds,
    required this.rightAnswerCount,
    required this.wrongAnswerCount,
    required this.skippedAnswerCount,
    required this.obtainedMark,
  });

  final int id;
  final List<int> seenQuestionIds;
  final int rightAnswerCount;
  final int wrongAnswerCount;
  final int skippedAnswerCount;
  final int obtainedMark;

  QuizSession.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        seenQuestionIds =
            List.castFrom<dynamic, int>(json['seen_question_ids']),
        rightAnswerCount = json['right_answer_count'],
        wrongAnswerCount = json['wrong_answer_count'],
        skippedAnswerCount = json['skipped_answer_count'],
        obtainedMark = json['obtained_mark'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['seen_question_ids'] = seenQuestionIds;
    data['right_answer_count'] = rightAnswerCount;
    data['wrong_answer_count'] = wrongAnswerCount;
    data['skipped_answer_count'] = skippedAnswerCount;
    data['obtained_mark'] = obtainedMark;
    return data;
  }
}

class Question {
  Question({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.options,
  });

  final int id;
  final String questionText;
  final String questionType;
  final List<Options> options;

  Question.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        questionText = json['question_text'],
        questionType = _mapQuestionType(json['question_type']),
        options =
            List.from(json['options']).map((e) => Options.fromJson(e)).toList();

  static String _mapQuestionType(String type) {
    switch (type) {
      case "multiple_choice":
        return "multiple";
      case "single_choice":
        return "single";
      case "binary":
        return "binary";
      default:
        throw ArgumentError("Unknown question type: $type");
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['question_text'] = questionText;
    data['question_type'] = questionType;
    data['options'] = options.map((e) => e.toJson()).toList();
    return data;
  }
}

class Options {
  Options({
    required this.text,
    required this.isCorrect,
  });

  final String text;
  final bool isCorrect;

  Options.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        isCorrect = json['is_correct'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['is_correct'] = isCorrect;
    return data;
  }
}

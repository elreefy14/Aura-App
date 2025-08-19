class ExamQustion {
  ExamQustion({
    required this.examSession,
    required this.questions,
  });
  late final ExamSession examSession;
  late final List<Questions> questions;

  ExamQustion.fromJson(Map<String, dynamic> json) {
    examSession = ExamSession.fromJson(json['examSession']);
    questions =
        List.from(json['questions']).map((e) => Questions.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['examSession'] = examSession.toJson();
    data['questions'] = questions.map((e) => e.toJson()).toList();
    return data;
  }
}

class ExamSession {
  ExamSession({
    required this.id,
    required this.totalMark,
    required this.passMark,
    required this.obtainedMark,
  });
  late final int id;
  late final int totalMark;
  late final int passMark;
  late final int obtainedMark;

  ExamSession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalMark = json['total_mark'];
    passMark = json['pass_mark'];
    obtainedMark = json['obtained_mark'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['total_mark'] = totalMark;
    data['pass_mark'] = passMark;
    data['obtained_mark'] = obtainedMark;
    return data;
  }
}

class Questions {
  Questions({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.options,
  });
  late final int id;
  late final String questionText;
  late final String questionType;
  late final List<Options> options;

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionText = json['question_text'];
    questionType = _mapQuestionType(json['question_type']);
    options =
        List.from(json['options']).map((e) => Options.fromJson(e)).toList();
  }
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
  late final String text;
  late final bool isCorrect;

  Options.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    isCorrect = json['is_correct'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['is_correct'] = isCorrect;
    return data;
  }
}

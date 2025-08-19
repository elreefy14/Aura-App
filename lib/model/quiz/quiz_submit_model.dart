class QuizSubmitModel {
  QuizSubmitModel({
    required this.questionId,
    required this.choice,
    required this.choices,
    required this.skip,
  });
  late final int questionId;
  late final String? choice;
  late final List<String> choices;
  late final bool skip;

  QuizSubmitModel.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    choice = json['choice'];
    choices = List.castFrom<dynamic, String>(json['choices']);
    skip = json['skip'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['choice'] = choice;
    data['choices'] = choices;
    data['skip'] = skip;
    return data;
  }
}

class Answer {
  Answer({
    required this.questionId,
    required this.choice,
    required this.choices,
  });
  late final int questionId;
  String? choice;
  late final List<String> choices;

  Answer.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    choice = json['choice'];
    choices = List.castFrom<dynamic, String>(json['choices']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['choice'] = choice;
    data['choices'] = choices;
    return data;
  }
}

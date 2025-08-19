class ExamResultModel {
  ExamResultModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.totalMark,
    required this.passMark,
    required this.obtainedMark,
    required this.submitted,
  });
  late final int id;
  late final String startTime;
  late final String endTime;
  late final int totalMark;
  late final int passMark;
  late final int obtainedMark;
  late final bool submitted;

  ExamResultModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    totalMark = json['total_mark'];
    passMark = json['pass_mark'];
    obtainedMark = json['obtained_mark'];
    submitted = json['submitted'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['total_mark'] = totalMark;
    data['pass_mark'] = passMark;
    data['obtained_mark'] = obtainedMark;
    data['submitted'] = submitted;
    return data;
  }
}

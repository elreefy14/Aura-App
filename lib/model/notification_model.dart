import 'dart:convert';

class NotificationModel {
  int? id;
  String? logo;
  int? courseId;
  String? type;
  String? heading;
  String? content;
  bool? isRead;
  String? createdAt;
  String? dateFormat;
  String? rowTime;
  NotificationModel({
    this.id,
    this.logo,
    this.courseId,
    this.type,
    this.heading,
    this.content,
    this.isRead,
    this.createdAt,
    this.dateFormat,
    this.rowTime,
  });

  NotificationModel copyWith({
    int? id,
    String? logo,
    int? courseId,
    String? type,
    String? heading,
    String? content,
    bool? isRead,
    String? createdAt,
    String? dateFormat,
    String? rowTime,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      logo: logo ?? this.logo,
      courseId: courseId ?? this.courseId,
      type: type ?? this.type,
      heading: heading ?? this.heading,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      dateFormat: dateFormat ?? this.dateFormat,
      rowTime: rowTime ?? this.rowTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'logo': logo,
      'courseId': courseId,
      'type': type,
      'heading': heading,
      'content': content,
      'isRead': isRead,
      'createdAt': createdAt,
      'dateFormat': dateFormat,
      'rowTime': rowTime,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    bool isRead = map['is_read'] == 0 ? false : true;
    return NotificationModel(
      id: map['id'] != null ? map['id'] as int : null,
      logo: map['logo'] != null ? map['logo'] as String : null,
      courseId: map['course_id'] != null ? map['course_id'] as int : null,
      type: map['type'] != null ? map['type'] as String : null,
      heading: map['heading'] != null ? map['heading'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      isRead: isRead,
      createdAt: map['created_at'] != null ? map['created_at'] as String : null,
      dateFormat:
          map['date_format'] != null ? map['date_format'] as String : null,
      rowTime: map['raw_time'] != null ? map['raw_time'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

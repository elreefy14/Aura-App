class ContactSupport {
  ContactSupport({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });
  late final String name;
  late final String email;
  late final String subject;
  late final String message;

  ContactSupport.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    subject = json['subject'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['subject'] = subject;
    data['message'] = message;
    return data;
  }
}

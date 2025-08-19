// class UpdateUser {
//   String? phone;
//   String? email;
//   String? name;

//   UpdateUser({
//     this.phone,
//     this.email,
//     this.name,
//   });

//   UpdateUser.fromMap(Map<String, dynamic> json) {
//     phone = json['phone'];
//     email = json['email'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toMap() {
//     final Map<String, dynamic> data = <String, dynamic>{
//        'phone': phone,
//       'email': email,
//       'name': name,
//     };
//     if (data['phone'] != null) {
//       data['phone'] = phone;
//     }
//     if (data['email'] != null) {
//       data['email'] = email;
//     }
//     if (data['name'] != null) {
//       data['name'] = name;
//     }
//     return data;
//   }
// }

// demo code

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdateUser {
  String? phone;
  String? email;
  String? name;

  UpdateUser({
    this.phone,
    this.email,
    this.name,
  });

  UpdateUser.fromMap(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
    name = json['name'];
  }

  UpdateUser copyWith({
    String? phone,
    String? email,
    String? name,
  }) {
    return UpdateUser(
      phone: phone ?? this.phone,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone': phone,
      'email': email,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());

  factory UpdateUser.fromJson(String source) =>
      UpdateUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UpdateUser(phone: $phone, email: $email, name: $name)';

  @override
  bool operator ==(covariant UpdateUser other) {
    if (identical(this, other)) return true;

    return other.phone == phone && other.email == email && other.name == name;
  }

  @override
  int get hashCode => phone.hashCode ^ email.hashCode ^ name.hashCode;
}

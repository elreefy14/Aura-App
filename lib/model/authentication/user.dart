class User {
  int? id;
  String? phone;
  String? email;
  String? name;
  String? profilePicture;
  var isActive;
  var isAdmin;

  User(
      {this.id,
      this.phone,
      this.email,
      this.name,
      this.profilePicture,
      this.isActive,
      this.isAdmin});

  User.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    email = json['email'];
    name = json['name'];
    profilePicture = json['profile_picture'];
    isActive = json['is_active'];
    isAdmin = json['is_admin'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone;
    data['email'] = email;
    data['name'] = name;
    data['profile_picture'] = profilePicture;
    data['is_active'] = isActive;
    data['is_admin'] = isAdmin;
    return data;
  }
}

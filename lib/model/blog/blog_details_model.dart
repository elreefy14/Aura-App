class BlogDetailsModel {
  BlogDetailsModel({
    required this.message,
    required this.data,
  });
  late final String message;
  late final Data data;

  BlogDetailsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final data1 = <String, dynamic>{};
    data1['message'] = message;
    data1['data'] = data.toJson();
    return data1;
  }
}

class Data {
  Data({
    required this.blog,
    required this.shareableUrl,
  });
  late final Blog blog;
  late final String shareableUrl;

  Data.fromJson(Map<String, dynamic> json) {
    blog = Blog.fromJson(json['blog']);
    shareableUrl = json['shareable_url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['blog'] = blog.toJson();
    data['shareable_url'] = shareableUrl;
    return data;
  }
}

class Blog {
  Blog({
    required this.id,
    required this.user,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.status,
    required this.updatedAt,
  });
  late final int id;
  late final User user;
  late final String thumbnail;
  late final String title;
  late final String description;
  late final int status;
  late final String updatedAt;

  Blog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = User.fromJson(json['user']);
    thumbnail = json['thumbnail'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user.toJson();
    data['thumbnail'] = thumbnail;
    data['title'] = title;
    data['description'] = description;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class User {
  User({
    required this.id,
    required this.phone,
    required this.email,
    required this.name,
    required this.profilePicture,
    required this.isActive,
    required this.isAdmin,
  });
  late final int id;
  late final String phone;
  late final String email;
  late final String name;
  late final String profilePicture;
  late final int isActive;
  late final int isAdmin;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    email = json['email'];
    name = json['name'];
    profilePicture = json['profile_picture'];
    isActive = json['is_active'];
    isAdmin = json['is_admin'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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

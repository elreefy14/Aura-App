class CategoryModel {
  int? id;
  String? title;
  String? image;
  int? isFeatured;
  String? color;
  int? courseCount;

  CategoryModel(
      {this.id,
      this.title,
      this.image,
      this.isFeatured,
      this.color,
      this.courseCount});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    isFeatured = json['is_featured'];
    color = json['color'];
    courseCount = json['course_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['is_featured'] = isFeatured;
    data['color'] = color;
    data['course_count'] = courseCount;
    return data;
  }
}

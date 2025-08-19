class MasterModel {
  MasterModel({
    required this.name,
    required this.currencySymbol,
    required this.currency,
    required this.minCoursePrice,
    required this.maxCoursePrice,
    required this.paymentMethods,
    required this.pages,
  });
  late final String name;
  late final String currencySymbol;
  late final String currency;
  late final int minCoursePrice;
  late final int maxCoursePrice;
  late final List<PaymentMethods> paymentMethods;
  late final List<Pages> pages;
  late final String? footerContact;

  MasterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    currencySymbol = json['currency_symbol'];
    currency = json['currency'];
    minCoursePrice = json['min_course_price'];
    maxCoursePrice = json['max_course_price'];
    paymentMethods = List.from(json['payment_methods'])
        .map((e) => PaymentMethods.fromJson(e))
        .toList();
    pages = List.from(json['pages']).map((e) => Pages.fromJson(e)).toList();
    footerContact = json['footer_contact'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['currency_symbol'] = currencySymbol;
    data['currency'] = currency;
    data['min_course_price'] = minCoursePrice;
    data['max_course_price'] = maxCoursePrice;
    data['payment_methods'] = paymentMethods.map((e) => e.toJson()).toList();
    data['pages'] = pages.map((e) => e.toJson()).toList();
    data['footer_contact'] = footerContact;
    return data;
  }
}

class PaymentMethods {
  PaymentMethods({
    required this.name,
    required this.gateway,
    required this.isActive,
    required this.logo,
  });
  late final String name;
  late final String gateway;
  late final int isActive;
  late final String logo;

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gateway = json['gateway'];
    isActive = json['is_active'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['gateway'] = gateway;
    data['is_active'] = isActive;
    data['logo'] = logo;
    return data;
  }
}

class Pages {
  Pages({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
  });
  late final int id;
  late final String title;
  late final String slug;
  late final String content;

  Pages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['content'] = content;
    return data;
  }
}

class SignUpCredential {
  String firstName;
  String email;
  String phoneNumber;
  String password;
  String confirmPassword;
  SignUpCredential({
    required this.firstName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  SignUpCredential copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
  }) {
    return SignUpCredential(
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': firstName,
      'email': email,
      'phone': phoneNumber,
      'password': password,
      'password_confirmation': confirmPassword,
    };
  }
}

class RegisterResponse {
  final String name;
  final String email;
  final String password;

  RegisterResponse({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
}

class RegisterModel {
  RegisterModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.country,
      required this.password,
      this.token});

  String name;
  String email;
  String phone;
  String country;
  String password;
  String? token;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      country: json["country"],
      password: json["password"],
      token: json["token"]);

  Map<String, dynamic> toJson() => {
        "token": token,
        "name": name,
        "email": email,
        "phone": phone,
        "country": country,
        "password": password,
      };
}

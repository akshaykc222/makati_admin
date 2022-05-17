class CountryModel {
  final String name;

  CountryModel({required this.name});

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      CountryModel(name: json['name']);
  Map<String, dynamic> toJson() => {'name': name};
}

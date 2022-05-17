class ServiceLocations {
  final String country;
  final String location;

  ServiceLocations({required this.country, required this.location});

  factory ServiceLocations.fromJson(Map<String, dynamic> json) =>
      ServiceLocations(country: json['country'], location: json['name']);

  Map<String, dynamic> toJson() => {'country': country, 'name': location};
}

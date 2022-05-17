class BoxSubmitModel {
  BoxSubmitModel(
      {required this.customerName,
      required this.address,
      required this.mobile,
      required this.email,
      required this.countryId,
      required this.branchId,
      required this.date,
      required this.deliveryCountry,
      required this.deliveryTime,
      required this.locationId,
      required this.note,
      required this.cargoType,
      required this.jumbo,
      required this.regular,
      required this.noBoxes,
      required this.totalWeight,
      required this.deliveryLocation});

  String customerName;
  String address;
  String mobile;
  String email;
  int countryId;
  String branchId;
  DateTime date;
  String deliveryTime;
  String locationId;
  String note;
  deliveryType cargoType;
  String deliveryLocation;
  int noBoxes;
  double totalWeight;
  String deliveryCountry;
  int jumbo;
  int regular;

  String mapFromEnum(deliveryType type) {
    switch (type) {
      case deliveryType.cargo:
        return "CARGO";

      case deliveryType.courier:
        return "COURIER";
      default:
        return "COURIER";
    }
  }

  deliveryType mapToEnum(String type) {
    switch (type) {
      case "CARGO":
        return deliveryType.cargo;

      case "COURIER":
        return deliveryType.courier;
      default:
        return deliveryType.cargo;
    }
  }

  factory BoxSubmitModel.fromJson(Map<String, dynamic> json) => BoxSubmitModel(
      customerName: json["customer_name"],
      address: json["address"],
      mobile: json["mobile"],
      email: json["email"],
      deliveryLocation: json['deliveryLocation'],
      countryId: json["country_id"],
      branchId: json["branch_id"],
      date: DateTime.parse(json["date"]),
      deliveryTime: json["delivery_time"],
      locationId: json["location_id"],
      note: json["note"],
      cargoType: json["cargo_type"] == "CARGO"
          ? deliveryType.cargo
          : deliveryType.courier,
      jumbo: json["Jumbo"],
      regular: json["Regular"],
      noBoxes: json['noBoxes'],
      deliveryCountry: json['deliveryCountry'],
      totalWeight: json['totalWeight']);

  Map<String, dynamic> toJson() => {
        "customer_name": customerName,
        "address": address,
        "mobile": mobile,
        "email": email,
        "deliveryCountry": deliveryCountry,
        "deliveryLocation": deliveryLocation,
        "country_id": countryId,
        "branch_id": branchId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "delivery_time": deliveryTime,
        "location_id": locationId,
        "note": note,
        "cargo_type": mapFromEnum(cargoType),
        "Jumbo": jumbo,
        "Regular": regular,
        "noBoxes": noBoxes,
        "totalWeight": totalWeight
      };
}

class ParamsModel {
  ParamsModel({
    required this.params,
  });

  BoxSubmitModel params;

  factory ParamsModel.fromJson(Map<String, dynamic> json) => ParamsModel(
        params: BoxSubmitModel.fromJson(json["params"]),
      );

  Map<String, dynamic> toJson() => {
        "params": params.toJson(),
      };
}

enum deliveryType { cargo, courier }

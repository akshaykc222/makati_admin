class NotificationModel {
  NotificationModel({
    this.image,
    required this.title,
    required this.message,
  });

  String? image;
  String title;
  String message;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        image: json["image"],
        title: json["title"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "title": title,
        "message": message,
      };
}

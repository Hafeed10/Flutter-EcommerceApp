class UserModel {
  String? name;
  String? phone;
  String? address;
  String? username;

  UserModel({
    this.name,
    this.phone,
    this.address,
    this.username,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "address": address,
        "username": username,
      };
}
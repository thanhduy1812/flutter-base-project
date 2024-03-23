class BmeUser {
  int? id;
  DateTime? createdAt;
  DateTime? updateAt;
  String? createdBy;
  String? updatedBy;
  bool? isDeleted;
  String? fullName;
  String? socialName;
  String? dob;
  String? avatar;
  String? username;
  String? password;
  String? role;
  String? email;
  String? phoneNumber;
  String? address;
  String? tag;
  bool? isRemember;

  BmeUser({
    this.id,
    this.createdAt,
    this.updateAt,
    this.createdBy,
    this.updatedBy,
    this.isDeleted,
    this.fullName,
    this.socialName,
    this.dob,
    this.avatar,
    this.username,
    this.password,
    this.role,
    this.email,
    this.phoneNumber,
    this.address,
    this.tag,
    this.isRemember,
  });

  factory BmeUser.fromJson(Map<String, dynamic> json) => BmeUser(
        id: json["id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updateAt: json["updateAt"] == null ? null : DateTime.parse(json["updateAt"]),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        isDeleted: json["is_deleted"],
        fullName: json["fullName"],
        socialName: json["socialName"],
        dob: json["dob"],
        avatar: json["avatar"],
        username: json["username"],
        password: json["password"],
        role: json["role"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        tag: json["tag"],
        isRemember: json["isRemember"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updateAt": updateAt?.toIso8601String(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "is_deleted": isDeleted,
        "fullName": fullName,
        "socialName": socialName,
        "dob": dob,
        "avatar": avatar,
        "username": username,
        "password": password,
        "role": role,
        "email": email,
        "phoneNumber": phoneNumber,
        "address": address,
        "tag": tag,
        "isRemember": isRemember,
      };
}

enum BmeUserRole {
  admin("ADMIN"),
  mentor("MENTOR"),
  user("USER");

  final String roleValue;
  const BmeUserRole(this.roleValue);
}

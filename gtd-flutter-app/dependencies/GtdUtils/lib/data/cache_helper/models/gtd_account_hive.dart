import 'package:gtd_utils/data/cache_helper/models/gtd_cached_object.dart';
import 'package:hive/hive.dart';

part 'gtd_account_hive.g.dart';

@HiveType(typeId: 4)
class GtdAccountHive extends GtdCachedObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? profileId;
  @HiveField(2)
  int? travellerId;
  @HiveField(3)
  String? firstName;
  @HiveField(4)
  String? lastName;
  @HiveField(5)
  String? avatarImage;
  @HiveField(6)
  String? gender;
  @HiveField(7)
  DateTime? dateOfBirth;
  @HiveField(8)
  String? nationality;
  @HiveField(9)
  String? email;
  @HiveField(10)
  String? passportNumber;
  @HiveField(11)
  String? passportCountry;
  @HiveField(12)
  DateTime? passportExpireDate;
  @HiveField(13)
  String? membershipClass;
  @HiveField(14)
  String? orgCode;
  @HiveField(15)
  String? branchCode;
  @HiveField(16)
  String? customerCode;
  @HiveField(17)
  String? userRefcode;

  GtdAccountHive({
    this.id,
    this.profileId,
    this.travellerId,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.nationality,
    this.email,
    this.passportNumber,
    this.passportCountry,
    this.passportExpireDate,
    this.avatarImage,
    this.membershipClass,
    this.branchCode,
    this.customerCode,
    this.orgCode,
    this.userRefcode,
  });

  GtdAccountHive copyWith({
    int? id,
    int? profileId,
    int? travellerId,
    String? firstName,
    String? lastName,
    String? avatarImage,
    String? gender,
    DateTime? dateOfBirth,
    String? nationality,
    String? email,
    String? passportNumber,
    String? passportCountry,
    DateTime? passportExpireDate,
    String? membershipClass,
  }) {
    return GtdAccountHive(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      travellerId: travellerId ?? this.travellerId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarImage: avatarImage ?? this.avatarImage,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      email: email ?? this.email,
      passportNumber: passportNumber ?? this.passportNumber,
      passportCountry: passportCountry ?? this.passportCountry,
      passportExpireDate: passportExpireDate ?? this.passportExpireDate,
      membershipClass: membershipClass ?? this.membershipClass,
    );
  }

  @override
  int get typeId => 4;
}

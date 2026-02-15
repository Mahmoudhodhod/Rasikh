import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String userId;
  final String email;

  final String firstName;
  final String? middleName;
  final String lastName;

  final String phoneNumber;

  final dynamic countryId;
  final String? countryName;

  final String? city;
  final String? address;
  final String? image;

  final int? age;
  final int? planId;
  final String? currentplanName;

  String get id => userId;
  String get phone => phoneNumber;
  String? get country => countryName;
  String? get addressDetails => address;
  String? get profileImage => image;

  UserModel({
    required this.userId,
    required this.email,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.phoneNumber,
    this.countryId, 
    this.countryName,
    this.city,
    this.address,
    this.image,
    this.age,
    this.planId,
    this.currentplanName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: json['userId'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  middleName: json['middleName'] as String?,
  lastName: json['lastName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  countryId: json['countryId'],
  countryName: json['countryName'] as String?,
  city: json['city'] as String?,
  address: json['address'] as String?,
  image: json['image'] as String?,
  age: (json['age'] as num?)?.toInt(),
  planId: (json['planId'] as num?)?.toInt(),
  currentplanName: json['currentplanName'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'firstName': instance.firstName,
  'middleName': instance.middleName,
  'lastName': instance.lastName,
  'phoneNumber': instance.phoneNumber,
  'countryId': instance.countryId,
  'countryName': instance.countryName,
  'city': instance.city,
  'address': instance.address,
  'image': instance.image,
  'age': instance.age,
  'planId': instance.planId,
  'currentplanName': instance.currentplanName,
};

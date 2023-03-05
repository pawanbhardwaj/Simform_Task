import 'dart:convert';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.results,
  });

  List<Result> results;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 1)
class Result {
  Result({
    required this.email,
    required this.phone,
    required this.cell,
    required this.nat,
  });
  @HiveField(0)
  String email;
  @HiveField(1)
  String phone;
  @HiveField(2)
  String cell;
  @HiveField(3)
  String nat;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        email: json["email"],
        phone: json["phone"],
        cell: json["cell"],
        nat: json["nat"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone": phone,
        "cell": cell,
        "nat": nat,
      };
}

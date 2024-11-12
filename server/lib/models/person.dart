import 'package:objectbox/objectbox.dart';

@Entity()
class Person {
  @Id()
  late int id; // Let ObjectBox auto-assign the ID

  String personalNumber;
  String name;
  String email;

  Person({
    required this.personalNumber,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personalNumber': personalNumber,
      'name': name,
      'email': email,
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      personalNumber: json['personalNumber'],
      name: json['name'],
      email: json['email'],
    )..id = json['id'] ?? 0; // Assign ID only if it exists in the JSON
  }
}

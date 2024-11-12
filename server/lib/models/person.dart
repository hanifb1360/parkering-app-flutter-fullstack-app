import 'package:objectbox/objectbox.dart';

@Entity()
class Person {
  @Id()
  int id;

  String personalNumber;
  String name;
  String email;
  String password; // Added field for potential authentication

  Person({
    this.id = 0,
    required this.personalNumber,
    required this.name,
    required this.email,
    required this.password,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? 0,
      personalNumber: json['personalNumber'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personalNumber': personalNumber,
      'name': name,
      'email': email,
      // We may want to omit password in responses for security reasons.
    };
  }
}

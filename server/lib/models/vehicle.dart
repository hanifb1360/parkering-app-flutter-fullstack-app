import 'package:objectbox/objectbox.dart';

@Entity()
class Vehicle {
  @Id(assignable: true)
  int id;

  String regNumber;
  int ownerId; // Reference to Person's ID
  String model;

  Vehicle({
    this.id = 0,
    required this.regNumber,
    required this.ownerId,
    required this.model,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'regNumber': regNumber,
      'ownerId': ownerId,
      'model': model,
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? 0,
      regNumber: json['regNumber'],
      ownerId: json['ownerId'], // Fetching by ID now
      model: json['model'],
    );
  }
}

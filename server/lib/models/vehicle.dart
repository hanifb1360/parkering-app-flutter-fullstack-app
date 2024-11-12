import 'package:objectbox/objectbox.dart';

@Entity()
class Vehicle {
  @Id(assignable: true)
  int id;

  String vehicleRegNumber; // Updated to match Parking model
  int ownerId; // Reference to Person's ID
  String model;

  Vehicle({
    this.id = 0,
    required this.vehicleRegNumber,
    required this.ownerId,
    required this.model,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? 0,
      vehicleRegNumber: json['vehicleRegNumber'],
      ownerId: json['ownerId'],
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleRegNumber': vehicleRegNumber,
      'ownerId': ownerId,
      'model': model,
    };
  }
}

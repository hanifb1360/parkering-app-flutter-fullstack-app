import 'package:objectbox/objectbox.dart';

@Entity()
class ParkingSpace {
  @Id(assignable: true)
  int id;

  String spaceNumber; // e.g., "A1"
  bool isOccupied; // true if occupied, false otherwise
  double pricePerHour; // Cost per hour for using the space

  ParkingSpace({
    this.id = 0,
    required this.spaceNumber,
    this.isOccupied = false,
    required this.pricePerHour,
  });

  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json['id'] ?? 0,
      spaceNumber: json['spaceNumber'],
      isOccupied: json['isOccupied'] ?? false,
      pricePerHour: json['pricePerHour'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spaceNumber': spaceNumber,
      'isOccupied': isOccupied,
      'pricePerHour': pricePerHour,
    };
  }
}

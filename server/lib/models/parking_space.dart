import 'package:objectbox/objectbox.dart';

@Entity()
class ParkingSpace {
  @Id(assignable: true)
  int id;

  final String spaceNumber; // e.g., "A1"
  final bool isOccupied; // true if occupied, false otherwise

  ParkingSpace({
    this.id = 0,
    required this.spaceNumber,
    required this.isOccupied,
  });

  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json['id'] ?? 0,
      spaceNumber: json['spaceNumber'],
      isOccupied: json['isOccupied'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spaceNumber': spaceNumber,
      'isOccupied': isOccupied,
    };
  }
}

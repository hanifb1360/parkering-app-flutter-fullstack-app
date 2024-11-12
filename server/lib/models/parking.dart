import 'package:objectbox/objectbox.dart';

@Entity()
class Parking {
  @Id(assignable: true)
  int id;

  String vehicleRegNumber; // Registration number of the vehicle parked
  String spaceNumber; // Parking space identifier
  DateTime startTime;
  DateTime? endTime;
  double? totalCost; // Optional field to store parking cost

  Parking({
    this.id = 0,
    required this.vehicleRegNumber,
    required this.spaceNumber,
    required this.startTime,
    this.endTime,
    this.totalCost,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'] ?? 0,
      vehicleRegNumber: json['vehicleRegNumber'],
      spaceNumber: json['spaceNumber'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      totalCost: json['totalCost']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleRegNumber': vehicleRegNumber,
      'spaceNumber': spaceNumber,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'totalCost': totalCost,
    };
  }
}

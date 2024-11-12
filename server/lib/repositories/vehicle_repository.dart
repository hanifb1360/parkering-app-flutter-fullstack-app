import 'package:objectbox/objectbox.dart';
import '../models/vehicle.dart';
import 'dart:async';

class VehicleRepository {
  final Box<Vehicle> _box;

  VehicleRepository(this._box);

  Future<List<Vehicle>> getAll() async {
    try {
      return _box.getAll();
    } catch (e) {
      throw Exception("Failed to fetch vehicles: $e");
    }
  }

  Future<Vehicle?> getById(int id) async {
    try {
      return _box.get(id);
    } catch (e) {
      throw Exception("Failed to fetch vehicle by ID: $e");
    }
  }

  Future<Vehicle> create(Vehicle vehicle) async {
    try {
      vehicle.id = _box.put(vehicle);
      return vehicle;
    } catch (e) {
      throw Exception("Failed to create vehicle: $e");
    }
  }

  Future<Vehicle> update(int id, Vehicle updatedVehicle) async {
    try {
      final existingVehicle = await getById(id);
      if (existingVehicle != null) {
        updatedVehicle.id = id;
        _box.put(updatedVehicle);
        return updatedVehicle;
      } else {
        throw Exception("Vehicle not found");
      }
    } catch (e) {
      throw Exception("Failed to update vehicle: $e");
    }
  }

  Future<Vehicle> delete(int id) async {
    try {
      final existingVehicle = await getById(id);
      if (existingVehicle != null) {
        _box.remove(id);
        return existingVehicle;
      } else {
        throw Exception("Vehicle not found");
      }
    } catch (e) {
      throw Exception("Failed to delete vehicle: $e");
    }
  }
}

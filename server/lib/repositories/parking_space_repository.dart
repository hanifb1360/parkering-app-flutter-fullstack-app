import 'package:objectbox/objectbox.dart';
import '../models/parking_space.dart';
import 'dart:async';

class ParkingSpaceRepository {
  final Box<ParkingSpace> _box;

  ParkingSpaceRepository(this._box);

  Future<List<ParkingSpace>> getAll() async {
    try {
      return _box.getAll();
    } catch (e) {
      throw Exception("Failed to fetch parking spaces: $e");
    }
  }

  Future<ParkingSpace?> getById(int id) async {
    try {
      return _box.get(id);
    } catch (e) {
      throw Exception("Failed to fetch parking space by ID: $e");
    }
  }

  Future<ParkingSpace> create(ParkingSpace space) async {
    try {
      space.id = _box.put(space);
      return space;
    } catch (e) {
      throw Exception("Failed to create parking space: $e");
    }
  }

  Future<ParkingSpace> update(int id, ParkingSpace updatedSpace) async {
    try {
      final existingSpace = await getById(id);
      if (existingSpace != null) {
        updatedSpace.id = id;
        _box.put(updatedSpace);
        return updatedSpace;
      } else {
        throw Exception("Parking space not found");
      }
    } catch (e) {
      throw Exception("Failed to update parking space: $e");
    }
  }

  Future<ParkingSpace> delete(int id) async {
    try {
      final existingSpace = await getById(id);
      if (existingSpace != null) {
        _box.remove(id);
        return existingSpace;
      } else {
        throw Exception("Parking space not found");
      }
    } catch (e) {
      throw Exception("Failed to delete parking space: $e");
    }
  }
}

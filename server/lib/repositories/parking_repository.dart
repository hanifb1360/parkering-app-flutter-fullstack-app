import 'package:objectbox/objectbox.dart';
import '../models/parking.dart';
import 'dart:async';

class ParkingRepository {
  final Box<Parking> _box;

  ParkingRepository(this._box);

  Future<List<Parking>> getAll() async {
    try {
      return _box.getAll();
    } catch (e) {
      throw Exception("Failed to fetch parking records: $e");
    }
  }

  Future<Parking?> getById(int id) async {
    try {
      return _box.get(id);
    } catch (e) {
      throw Exception("Failed to fetch parking record by ID: $e");
    }
  }

  Future<Parking> create(Parking parking) async {
    try {
      parking.id = _box.put(parking);
      return parking;
    } catch (e) {
      throw Exception("Failed to create parking record: $e");
    }
  }

  Future<Parking> update(int id, Parking updatedParking) async {
    try {
      final existingParking = await getById(id);
      if (existingParking != null) {
        updatedParking.id = id;
        _box.put(updatedParking);
        return updatedParking;
      } else {
        throw Exception("Parking not found");
      }
    } catch (e) {
      throw Exception("Failed to update parking record: $e");
    }
  }

  Future<Parking> delete(int id) async {
    try {
      final existingParking = await getById(id);
      if (existingParking != null) {
        _box.remove(id);
        return existingParking;
      } else {
        throw Exception("Parking not found");
      }
    } catch (e) {
      throw Exception("Failed to delete parking record: $e");
    }
  }
}

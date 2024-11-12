import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../repositories/parking_repository.dart';
import '../models/parking.dart';

class ParkingHandler {
  final ParkingRepository repository;

  ParkingHandler(this.repository);

  // Handle GET request to fetch all parking records
  Future<Response> getAll(Request request) async {
    try {
      final parkings = await repository.getAll();
      return Response.ok(jsonEncode(parkings.map((p) => p.toJson()).toList()));
    } catch (e) {
      return Response.internalServerError(body: 'Failed to fetch parkings: $e');
    }
  }

  // Handle GET request to fetch a parking by ID
  Future<Response> getById(Request request, String id) async {
    try {
      final parkingId = int.tryParse(id);
      if (parkingId == null) {
        return Response.badRequest(body: 'Invalid parking ID');
      }
      final parking = await repository.getById(parkingId);
      return parking != null
          ? Response.ok(jsonEncode(parking.toJson()))
          : Response.notFound('Parking not found');
    } catch (e) {
      return Response.internalServerError(body: 'Failed to fetch parking: $e');
    }
  }

  // Handle POST request to create a new parking record
  Future<Response> create(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final parking = Parking.fromJson(data);
      await repository.create(parking);
      return Response(201, body: 'Parking created');
    } catch (e) {
      return Response.internalServerError(body: 'Failed to create parking: $e');
    }
  }

  // Handle PUT request to update a parking record by ID
  Future<Response> update(Request request, String id) async {
    try {
      final parkingId = int.tryParse(id);
      if (parkingId == null) {
        return Response.badRequest(body: 'Invalid parking ID');
      }
      final payload = await request.readAsString();
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final parking = Parking.fromJson(data);
      await repository.update(parkingId, parking);
      return Response.ok('Parking updated');
    } catch (e) {
      return Response.internalServerError(body: 'Failed to update parking: $e');
    }
  }

  // Handle DELETE request to remove a parking by ID
  Future<Response> delete(Request request, String id) async {
    try {
      final parkingId = int.tryParse(id);
      if (parkingId == null) {
        return Response.badRequest(body: 'Invalid parking ID');
      }
      await repository.delete(parkingId);
      return Response.ok('Parking deleted');
    } catch (e) {
      return Response.internalServerError(body: 'Failed to delete parking: $e');
    }
  }
}

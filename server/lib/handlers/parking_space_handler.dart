import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../repositories/parking_space_repository.dart';
import '../models/parking_space.dart';

class ParkingSpaceHandler {
  final ParkingSpaceRepository repository;

  ParkingSpaceHandler(this.repository);

  Future<Response> getAll(Request request) async {
    try {
      final parkingSpaces = await repository.getAll();
      return Response.ok(
          jsonEncode(parkingSpaces.map((p) => p.toJson()).toList()));
    } catch (e) {
      return Response.internalServerError(
          body: 'Failed to fetch parking spaces: $e');
    }
  }

  Future<Response> getById(Request request, String id) async {
    try {
      final parkingSpaceId = int.tryParse(id);
      if (parkingSpaceId == null) {
        return Response.badRequest(body: 'Invalid parking space ID');
      }
      final parkingSpace = await repository.getById(parkingSpaceId);
      return parkingSpace != null
          ? Response.ok(jsonEncode(parkingSpace.toJson()))
          : Response.notFound('Parking space not found');
    } catch (e) {
      return Response.internalServerError(
          body: 'Failed to fetch parking space: $e');
    }
  }

  Future<Response> create(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final parkingSpace = ParkingSpace.fromJson(data);
      await repository.create(parkingSpace);
      return Response(201, body: 'Parking space created');
    } catch (e) {
      return Response.internalServerError(
          body: 'Failed to create parking space: $e');
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      final parkingSpaceId = int.tryParse(id);
      if (parkingSpaceId == null) {
        return Response.badRequest(body: 'Invalid parking space ID');
      }
      final payload = await request.readAsString();
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final parkingSpace = ParkingSpace.fromJson(data);
      await repository.update(parkingSpaceId, parkingSpace);
      return Response.ok('Parking space updated');
    } catch (e) {
      return Response.internalServerError(
          body: 'Failed to update parking space: $e');
    }
  }

  Future<Response> delete(Request request, String id) async {
    try {
      final parkingSpaceId = int.tryParse(id);
      if (parkingSpaceId == null) {
        return Response.badRequest(body: 'Invalid parking space ID');
      }
      await repository.delete(parkingSpaceId);
      return Response.ok('Parking space deleted');
    } catch (e) {
      return Response.internalServerError(
          body: 'Failed to delete parking space: $e');
    }
  }
}

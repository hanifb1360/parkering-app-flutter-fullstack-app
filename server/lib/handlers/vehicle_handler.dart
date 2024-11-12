import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../repositories/vehicle_repository.dart';
import '../repositories/person_repository.dart'; // Import the person repository
import '../models/vehicle.dart';

class VehicleHandler {
  final VehicleRepository repository;
  final PersonRepository personRepository; // Inject the person repository

  VehicleHandler(this.repository, this.personRepository);

  Future<Response> getAll(Request request) async {
    try {
      final vehicles = await repository.getAll();
      return Response.ok(jsonEncode(vehicles.map((v) => v.toJson()).toList()));
    } catch (e) {
      return Response.internalServerError(body: 'Failed to fetch vehicles: $e');
    }
  }

  Future<Response> getById(Request request, String id) async {
    try {
      final vehicleId = int.tryParse(id);
      if (vehicleId == null) {
        return Response(400,
            body:
                'Invalid vehicle ID'); // Directly using Response with status code 400
      }
      final vehicle = await repository.getById(vehicleId);
      return vehicle != null
          ? Response.ok(jsonEncode(vehicle.toJson()))
          : Response(404,
              body:
                  'Vehicle not found'); // Directly using Response with status code 404
    } catch (e) {
      return Response.internalServerError(body: 'Failed to fetch vehicle: $e');
    }
  }

  Future<Response> create(Request request) async {
    print('Received request to create vehicle');
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload) as Map<String, dynamic>;

      // Extract owner's ID and check for existence
      final ownerId = data['ownerId'];
      if (ownerId == null) {
        print('Owner ID is missing');
        return Response(400,
            body:
                'Owner ID is required'); // Directly using Response with status code 400
      }

      // Check if owner exists by ID
      final owner = await personRepository.getById(ownerId);
      if (owner == null) {
        print('Owner not found with ID: $ownerId');
        return Response(404,
            body:
                'Owner not found'); // Directly using Response with status code 404
      }

      // Create the vehicle if owner exists
      final vehicle = Vehicle.fromJson(data);
      await repository.create(vehicle);
      print('Vehicle created successfully with owner: ${owner.name}');
      return Response(201, body: 'Vehicle created');
    } catch (e) {
      print('Error during vehicle creation: $e');
      return Response.internalServerError(body: 'Failed to create vehicle: $e');
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      final vehicleId = int.tryParse(id);
      if (vehicleId == null) {
        return Response(400,
            body:
                'Invalid vehicle ID'); // Directly using Response with status code 400
      }
      final payload = await request.readAsString();
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final vehicle = Vehicle.fromJson(data);
      await repository.update(vehicleId, vehicle);
      return Response.ok('Vehicle updated');
    } catch (e) {
      return Response.internalServerError(body: 'Failed to update vehicle: $e');
    }
  }

  Future<Response> delete(Request request, String id) async {
    try {
      final vehicleId = int.tryParse(id);
      if (vehicleId == null) {
        return Response(400,
            body:
                'Invalid vehicle ID'); // Directly using Response with status code 400
      }
      await repository.delete(vehicleId);
      return Response.ok('Vehicle deleted');
    } catch (e) {
      return Response.internalServerError(body: 'Failed to delete vehicle: $e');
    }
  }
}

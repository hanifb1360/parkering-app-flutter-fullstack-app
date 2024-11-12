import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'handlers/person_handler.dart';
import 'handlers/vehicle_handler.dart';
import 'handlers/parking_handler.dart';
import 'handlers/parking_space_handler.dart';
import 'repositories/person_repository.dart';
import 'repositories/vehicle_repository.dart';
import 'repositories/parking_repository.dart';
import 'repositories/parking_space_repository.dart';
import 'package:objectbox/objectbox.dart';
import 'models/person.dart';
import 'models/vehicle.dart';
import 'models/parking.dart';
import 'models/parking_space.dart';

Router setupRouter(Store store) {
  final router = Router();

  // Initialize repositories with Box instances from the store
  final personRepository = PersonRepository(store.box<Person>());
  final vehicleRepository = VehicleRepository(store.box<Vehicle>());
  final parkingRepository = ParkingRepository(store.box<Parking>());
  final parkingSpaceRepository =
      ParkingSpaceRepository(store.box<ParkingSpace>());

  // Initialize handlers with their respective repositories
  final personHandler = PersonHandler(personRepository);
  final vehicleHandler = VehicleHandler(vehicleRepository,
      personRepository); // Pass personRepository to vehicleHandler
  final parkingHandler = ParkingHandler(parkingRepository);
  final parkingSpaceHandler = ParkingSpaceHandler(parkingSpaceRepository);

  // Root and echo routes
  router.get('/', _rootHandler);
  router.get('/echo/<message>', _echoHandler);

  // Person routes
  router.get('/persons', personHandler.getAll);
  router.post('/persons', personHandler.create);
  router.get('/persons/<id>', personHandler.getById);
  router.put('/persons/<id>', personHandler.update);
  router.delete('/persons/<id>', personHandler.delete);

  // Vehicle routes
  router.get('/vehicles', vehicleHandler.getAll);
  router.post('/vehicles', vehicleHandler.create);
  router.get('/vehicles/<id>', vehicleHandler.getById);
  router.put('/vehicles/<id>', vehicleHandler.update);
  router.delete('/vehicles/<id>', vehicleHandler.delete);

  // Parking routes
  router.get('/parkings', parkingHandler.getAll);
  router.post('/parkings', parkingHandler.create);
  router.get('/parkings/<id>', parkingHandler.getById);
  router.put('/parkings/<id>', parkingHandler.update);
  router.delete('/parkings/<id>', parkingHandler.delete);

  // ParkingSpace routes
  router.get('/parking-spaces', parkingSpaceHandler.getAll);
  router.post('/parking-spaces', parkingSpaceHandler.create);
  router.get('/parking-spaces/<id>', parkingSpaceHandler.getById);
  router.put('/parking-spaces/<id>', parkingSpaceHandler.update);
  router.delete('/parking-spaces/<id>', parkingSpaceHandler.delete);

  return router;
}

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

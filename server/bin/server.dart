import 'dart:io';
import 'package:server/router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:server/objectbox.g.dart';

// Define the CORS middleware
Middleware corsHeaders() {
  return createMiddleware(
    responseHandler: (Response response) {
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*', // Allows requests from any origin
        'Access-Control-Allow-Methods':
            'POST, GET, DELETE, PUT, OPTIONS', // HTTP methods allowed
        'Access-Control-Allow-Headers':
            'Origin, Content-Type', // Headers allowed
      });
    },
    requestHandler: (Request request) {
      if (request.method == 'OPTIONS') {
        // Respond to preflight requests for CORS
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, GET, DELETE, PUT, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type',
        });
      }
      return null; // Continue to the next handler if it's not an OPTIONS request
    },
  );
}

void main(List<String> args) async {
  // Initialize ObjectBox store
  final store = Store(
    getObjectBoxModel(),
    directory: './objectbox',
  );

  // Register routes and start the server, passing the store to setupRouter
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(setupRouter(store).call);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, InternetAddress.anyIPv4, port);
  print('Server listening on port ${server.port}');
}

import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  await printIps();
  final server = await createServer();
  print(
      'Server DART started: ${server.address} port ${server.port} : http://${server.address.host}:${server.port}');
  await handleRequests(server);
}

Future<HttpServer> createServer() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 4040;
  return await HttpServer.bind(address, port);
}

Future<void> handleRequests(HttpServer server) async {
  await for (HttpRequest request in server) {
    switch (request.method) {
      case 'GET':
        handleGet(request);
        break;
      case 'POST':
        handlePost(request);
        break;
      default:
        handleDefault(request);
    }
  }
}

//var myStringStorage = 'Hola desde Dart Server';
var myStringStorage =
    '<!DOCTYPE html><head>server Response DART</head><body><h1> This page was render direcly from the server DART <p>Hello there welcome to my website DART</p></h1></body></html>';

void handleGet(HttpRequest request) {
  //request.headers.set(HttpHeaders.cacheControlHeader, 'max-age=3600, must-revalidate');
  request.response.headers.contentType = ContentType.html;
  request.response
    ..write(myStringStorage)
    ..close();
}

Future<void> handlePost(HttpRequest request) async {
  myStringStorage = await utf8.decoder.bind(request).join();
  request.response
    ..write('Got it. Thanks.')
    ..close();
}

void handleDefault(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.methodNotAllowed
    ..write('Unsupported request: ${request.method}.')
    ..close();
}

Future printIps() async {
  for (var interface in await NetworkInterface.list()) {
    print('== Interface: ${interface.name} ==');
    for (var addr in interface.addresses) {
      print(
          '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
    }
  }
}

//Future<InternetAddress> get selfIP async {
//    String ip = await Wifi.ip;
//    return InternetAddress(ip);
//}
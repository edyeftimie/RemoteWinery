import 'dart:async';
import 'dart:convert';
import 'package:remote_winery/src/domain/model/wine.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerRepository {
  late WebSocketChannel _channel;
  bool _isConnected = false;
  final _pendingRequests = <String, Completer>{}; // Store pending requests by their id or type

  ServerRepository() {
    _initializeConnection();
  }

  Future<void> _initializeConnection() async {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8081'),
      );
      _isConnected = true;
      if (_isConnected) {
        print('CONSTRUCTOR: Connected to the server');
        _channel.stream.listen(
          (message) {
            var message_ = jsonDecode(message);
            var type = message_['message'];
            print('Message received: $type');
            _handleIncomingMessage(message);
            _isConnected = true;
          },
          onError: (error) {
            print('CONSTRUCTOR_ERROR: Error listening to the stream: $error');
            _isConnected = false;
          },
          onDone: () {
            print('CONSTRUCTOR: Connection closed');
            _isConnected = false;
          },
        );
      }
    } catch (e) {
      print('CONSTRUCTOR_ERROR: connecting to the server: $e');
    }
  }

  // Method to handle incoming messages
  void _handleIncomingMessage(String message) {
    var response = jsonDecode(message);

    // Check if the response has a matching pending request based on message type
    if (_pendingRequests.isNotEmpty) {
      // Iterate over pending requests to find a match based on message type
      for (var requestType in _pendingRequests.keys) {
        print (requestType);
        var completer = _pendingRequests[requestType];

        if (response['message'] == 'Data fetched' ||
            response['message'] == 'Data inserted' ||
            response['message'] == 'Data updated' ||
            response['message'] == 'Data deleted') {

          if (response['message'] == 'Data inserted') {
            print ('INSERTED');
            completer?.complete(response['data']['id']);
          } else if (response['message'] == 'Data fetched') {
            List<Wine> wines = [];
            // print(response['data']);
            // print(response['data'].runtimeType);
            print("RESPONSE DATA");
            for (var wine in response['data']) {
              print ('WINE: $wine');
              int id = wine['id'];
              String nameOfProducer = wine['nameofproducer']?? '';
              String type = wine['type']?? '';
              int yearOfProduction = wine['yearofproduction']?? 0;
              String region = wine['region']?? '';
              String listOfIngredients = wine['listofingredients']?? '';
              int calories = wine['calories']?? 0;
              String photoURL = wine['photourl']?? '';
              Wine _wine = Wine(id, nameOfProducer, type, yearOfProduction, region, listOfIngredients, calories, photoURL);
              wines.add(_wine);
              // wines.add(Wine(wine['id'], wine['nameOfProducer'], wine['type'], wine['yearOfProduction'],
              //     wine['region'], wine['listOfIngredients'], wine['calories'], wine['photoURL']));
            }
            print ('WINES: $wines');
            completer?.complete(wines);
          } else if (response['message'] == 'Data updated' || response['message'] == 'Data deleted') {
            print ('UPDATED/DELETED');
            completer?.complete(response['data']);
          }

          // Remove the completed request from the map
          _pendingRequests.remove(requestType);
          break; // Exit the loop once the matching request is handled
        } else {
          completer?.completeError('Error: ${response['message']}');
        }
      }
    }
  }

  // void _handleIncomingMessage(String message) {
  //   var response = jsonDecode(message);
  //   print ('RESPONSE: $response');
  //   // Check if the response has a matching pending request
  //   if (_pendingRequests.containsKey(response['type'])) {
  //     var completer = _pendingRequests[response['type']];

  //     if (response['message'] == 'Data fetched' || response['message'] == 'Data inserted' || response['message'] == 'Data updated' || response['message'] == 'Data deleted') {
  //       if (response['message'] == 'Data inserted') {
  //           completer?.complete(response['data']['id']);
  //       } else if (response['message'] == 'Data fetched') {
  //         List<Wine> wines = [];
  //         print (response['data']);
  //         print (response['data'].runtimeType);
  //         print ("RESPONSE DATA");
  //         for (var wine in response['data']) {
  //           wines.add(Wine(wine['id'], wine['nameOfProducer'], wine['type'], wine['yearOfProduction'], wine['region'], wine['listOfIngredients'], wine['calories'], wine['photoURL']));
  //         }
  //         completer?.complete(wines);
  //       } else if (response['message'] == 'Data updated' || response['message'] == 'Data deleted') {
  //         completer?.complete(true);
  //       }
  //     } else {
  //       completer?.completeError('Error: ${response['message']}');
  //     }

  //     // Remove the completed request from the map
  //     _pendingRequests.remove(response['type']);
  //   }
  // }

  Future<List<Wine>> getWines() async {
    if (!_isConnected) {
      await _initializeConnection();
      if (!_isConnected) {
        print('GET_ERROR connecting to the server');
        return [];
      } else {
        print('GET: Connected to the server');
      }
    }

    final json = jsonEncode({'type': 'GET'});
    _channel.sink.add(json);

    // Create a completer to await the result
    Completer<List<Wine>> completer = Completer();
    _pendingRequests['GET'] = completer;

    print ('GET: Waiting for response');
    print('Pending request for type GET: ${_pendingRequests['GET']}');
    print('Completer status before returning: ${completer.isCompleted ? "Completed" : "Pending"}');

    return completer.future;
  }

  Future<int> addWine(Wine wine) async {
    if (!_isConnected) {
      await _initializeConnection();
      if (!_isConnected) {
        print('ADD_ERROR connecting to the server');
        return 0;
      } else {
        print('ADD: Connected to the server');
      }
    }

    final json = jsonEncode({
      'type': 'POST',
      'data': {
        'nameOfProducer': wine.nameOfProducer,
        'type': wine.type,
        'yearOfProduction': wine.yearOfProduction,
        'region': wine.region,
        'listOfIngredients': wine.listOfIngredients,
        'calories': wine.calories,
        'photoURL': wine.photoURL,
      }
    });

    _channel.sink.add(json);

    // Create a completer to await the result
    Completer<int> completer = Completer();
    _pendingRequests['POST'] = completer;

    return completer.future;
  }

  Future<bool> updateWine(Wine wine) async {
    if (!_isConnected) {
      await _initializeConnection();
      if (!_isConnected) {
        print('UPDATE_ERROR connecting to the server');
        return false;
      } else {
        print('UPDATE: Connected to the server');
      }
    }

    final json = jsonEncode({
      'type': 'PUT',
      'data': {
        'id': wine.id,
        'nameOfProducer': wine.nameOfProducer,
        'type': wine.type,
        'yearOfProduction': wine.yearOfProduction,
        'region': wine.region,
        'listOfIngredients': wine.listOfIngredients,
        'calories': wine.calories,
        'photoURL': wine.photoURL,
      }
    });

    // print("UPDATE: Sending update request");
    _channel.sink.add(json);

    // Create a completer to await the result
    Completer<bool> completer = Completer();
    _pendingRequests['PUT'] = completer;

    return completer.future;
  }

  Future<bool> removeWine(int id) async {
    if (!_isConnected) {
      await _initializeConnection();
      if (!_isConnected) {
        print('DELETE_ERROR connecting to the server');
        return false;
      } else {
        print('DELETE: Connected to the server');
      }
    }

    final json = jsonEncode({'type': 'DELETE', 'data': {'id': id}});
    _channel.sink.add(json);

    // Create a completer to await the result
    Completer<bool> completer = Completer();
    _pendingRequests['DELETE'] = completer;

    return completer.future;
  }

  Future<Wine> getWineById(int id) async {
    final json = jsonEncode({'type': 'GET_ONE', 'id': id});
    _channel.sink.add(json);

    // Create a completer to await the result
    Completer<Wine> completer = Completer();
    _pendingRequests['GET_ONE'] = completer;

    return completer.future;
  }

  // Close the WebSocket connection
  void closeConnection() {
    _channel.sink.close();
    _isConnected = false;
    print('CLOSE: Connection closed');
  }
}

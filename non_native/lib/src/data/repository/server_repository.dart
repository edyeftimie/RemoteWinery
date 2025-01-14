import 'dart:async';
import 'dart:convert';
import 'package:remote_winery/src/domain/model/wine.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerRepository {
  late WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream; // Converted stream to broadcast
  bool _isConnected = false;

  // Track the stream subscription to manage it properly
  StreamSubscription? _subscription;

  ServerRepository() {
    try {
      connect().then((value) {
        print('CONSTRUCTOR: Connected to the server');
        _broadcastStream = _channel.stream.asBroadcastStream(); // Convert to broadcast stream
      });
    } catch (e) {
      print('CONSTRUCTOR_ERROR: connecting to the server: $e');
    }
  }

  Future<bool> connect() async {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8081'),
      );
      _isConnected = true;
      print('CONNECT: Connected to the server');
      return true;
    } catch (e) {
      _isConnected = false;
      print('CONNECT_ERROR: connecting to the server: $e');
      return false;
    }
  }

  Future<List<Wine>> getWines() async {
    if (!_isConnected) {
      var isConnected = await connect();
      if (!isConnected) {
        print('GET_ERROR connecting to the server');
        return [];
      }
    }

    final json = jsonEncode({'type': 'GET'});
    _channel.sink.add(json);

    // Use Completer to wait for the data
    Completer<List<Wine>> completer = Completer();
    List<Wine> wines = [];

    // Listen to the broadcast stream for messages
    late StreamSubscription subscription;
    subscription = _broadcastStream.listen((message) {
      var response = jsonDecode(message);
      print ("GET: Response fetched:");
      if (response['message'] == 'Data fetched') {
        print('GET: Wines retrieved');
        if (response['data'] is List) {
          for (var wine in response['data']) {
            print("wine");
            print(wine);
            wines.add(Wine(
              wine['id'],
              wine['nameofproducer'],
              wine['type'],
              wine['yearofproduction'],
              wine['region'],
              wine['listofingredients'],
              wine['calories'],
              wine['photourl'],
            ));
          }
        }
        completer.complete(wines); // Complete the completer with the list of wines
        subscription.cancel(); // Cancel subscription after processing
      } else if (!completer.isCompleted) {
        completer.complete([]);
      }
    });
    // .onError((error) {
    //   if (!completer.isCompleted) completer.completeError(error);
    //   // subscription.cancel();
    // });
    return completer.future; // Return the future of the completer
  }

  Future<int> addWine(Wine wine) async {
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

    // Use Completer to get the ID response
    Completer<int> completer = Completer();

    late StreamSubscription subscription;
    subscription = _broadcastStream.listen((message){
      final response = jsonDecode(message);
      if (response['message'] == 'Data inserted' && !completer.isCompleted) {
        print('ADD: Wine added');
        completer.complete(response['data']['id']); // Complete the completer with the ID
        subscription.cancel(); // Cancel subscription after processing
      } else {
        return;
      } 
    }, onError: (error) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
      subscription.cancel();
    });

    return completer.future;
  }

  Future<bool> updateWine(Wine wine) async {
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

    _channel.sink.add(json);

    Completer<bool> completer = Completer();

    late StreamSubscription subscription;
    subscription = _broadcastStream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data updated') {
        print('UPDATE: Wine updated');
        bool succes = response['data'] ?? false;
        completer.complete(succes);
        subscription.cancel();
      } else {
        return;
      }
    }, onError: (error) {
      if (!completer.isCompleted) completer.completeError(error);
      subscription.cancel();
    });
    return completer.future;
  }

  Future<bool> removeWine(int id) async {
    final json = jsonEncode({'type': 'DELETE', 'data': {'id': id}});
    _channel.sink.add(json);

    Completer<bool> completer = Completer();

    late StreamSubscription subscription;
    subscription = _broadcastStream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data deleted') {
        print('DELETE: Wine deleted');
        bool succes = response['data'] ?? false;
        completer.complete(succes);
        subscription.cancel();
      } else {
        return;
      }
    }, onError: (error) {
      if (!completer.isCompleted) completer.completeError(error);
      subscription.cancel();
    });
    return completer.future;
  }

  Future<Wine> getWineById(int id) async {
    final json = jsonEncode({'type': 'GET_ONE', 'id': id});
    _channel.sink.add(json);

    Completer<Wine> completer = Completer();
    Wine wine = Wine.empty();

    _broadcastStream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data fetched') {
        print('GET_ID: Wine retrieved');
        wine = Wine(
          response['wine']['id'],
          response['wine']['name'],
          response['wine']['type'],
          response['wine']['yearOfProduction'],
          response['wine']['region'],
          response['wine']['listOfIngredients'],
          response['wine']['calories'],
          response['wine']['photoURL'],
        );
        completer.complete(wine);
      }
    }).onError((error) {
      if (!completer.isCompleted) completer.completeError(error);
    });

    return completer.future;
  }

  // Close the WebSocket connection and cancel the subscription
  void closeConnection() {
    _subscription?.cancel();
    _channel.sink.close();
    _isConnected = false;
    print('CLOSE: Connection closed');
  }
}

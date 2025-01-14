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
        print('Connected to the server');
        _broadcastStream = _channel.stream.asBroadcastStream(); // Convert to broadcast stream
      });
    } catch (e) {
      print('Error connecting to the server: $e');
    }
  }

  Future<bool> connect() async {
    try {
      print('Connecting...');
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8081'),
      );
      _isConnected = true;
      print('Connected to the server');
      return true;
    } catch (e) {
      _isConnected = false;
      print('Error connecting to the server: $e');
      return false;
    }
  }

  Future<List<Wine>> getWines() async {
    if (!_isConnected) {
      var isConnected = await connect();
      if (!isConnected) {
        print('Error connecting to the server');
        return [];
      }
    }

    final json = jsonEncode({'type': 'GET'});
    _channel.sink.add(json);

    // Use Completer to wait for the data
    Completer<List<Wine>> completer = Completer();
    List<Wine> wines = [];

    // Listen to the broadcast stream for messages
    _broadcastStream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data retrieved') {
        print('Wines retrieved');
        for (var wine in response['wines']) {
          wines.add(Wine(
            wine['id'],
            wine['name'],
            wine['type'],
            wine['yearOfProduction'],
            wine['region'],
            wine['listOfIngredients'],
            wine['calories'],
            wine['photoURL'],
          ));
        }
        completer.complete(wines);
      } else if (!completer.isCompleted) {
        completer.complete([]);
      }
    }).onError((error) {
      if (!completer.isCompleted) completer.completeError(error);
    });

    return completer.future;
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

    _broadcastStream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data inserted') {
        print('Wine added');
        completer.complete(response['data']['id']);
      } else if (!completer.isCompleted) {
        completer.complete(-1);
      }
    }).onError((error) {
      if (!completer.isCompleted) completer.completeError(error);
    });

    return completer.future;
  }

  Future<void> updateWine(Wine wine) async {
    final json = jsonEncode({
      'type': 'PUT',
      'wine': {
        'id': wine.id,
        'name': wine.nameOfProducer,
        'type': wine.type,
        'yearOfProduction': wine.yearOfProduction,
        'region': wine.region,
        'listOfIngredients': wine.listOfIngredients,
        'calories': wine.calories,
        'photoURL': wine.photoURL,
      }
    });

    _channel.sink.add(json);

    _broadcastStream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data updated') {
        print('Wine updated');
      }
    });
  }

  Future<void> removeWine(int id) async {
    final json = jsonEncode({'type': 'DELETE', 'id': id});
    _channel.sink.add(json);

    _broadcastStream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data deleted') {
        print('Wine deleted');
      }
    });
  }

  Future<Wine> getWineById(int id) async {
    final json = jsonEncode({'type': 'GET_ONE', 'id': id});
    _channel.sink.add(json);

    Completer<Wine> completer = Completer();
    Wine wine = Wine.empty();

    _broadcastStream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data fetched') {
        print('Wine retrieved');
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
    print('Connection closed');
  }
}

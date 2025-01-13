import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:remote_winery/src/domain/model/wine.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerRepository {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080'),
  );

  ServerRepository();

  Future<List<Wine>> getWines() async {
    //create the json object
    final json = jsonEncode ({
      'type': 'GET',
    });

    //send the json object to the server
    _channel.sink.add(json);

    List<Wine> wines = [];

    _channel.stream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data retrieved') {
        print('Wines retrieved');
        for (var wine in response['wines']) {
          wines.add(Wine(wine['id'],wine['name'],wine['type'],wine['yearOfProduction'],wine['region'],wine['listOfIngredients'],wine['calories'],wine['photoURL'],));
        }
      }
    });

    //close the channel
    _channel.sink.close();
    return wines;
  }

  Future<int> addWine(Wine wine) async {
    //create the json object
    final json = jsonEncode ({
      'type': 'POST',
      'wine': {
        'name': wine.nameOfProducer,
        'type': wine.type,
        'yearOfProduction': wine.yearOfProduction,
        'region': wine.region,
        'listOfIngredients': wine.listOfIngredients,
        'calories': wine.calories,
        'photoURL': wine.photoURL,
      }
    });

    //send the json object to the server
    _channel.sink.add(json);

    var id;

    _channel.stream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data inserted') {
        print('Wine added');
        id = response['id'];}
    });

    //close the channel
    _channel.sink.close();
    if (id != null) {
      return id;
    } else {
      return -1;
    }
  }

  Future<void> updateWine(Wine wine) async {
    //create the json object
    final json = jsonEncode ({
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

    //send the json object to the server
    _channel.sink.add(json);

    _channel.stream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data updated') {
        print('Wine updated');
      }
    });

    //close the channel
    _channel.sink.close();
  }

  Future<void> removeWine(int id) async {
    //create the json object
    final json = jsonEncode ({
      'type': 'DELETE',
      'id': id,
    });

    //send the json object to the server
    _channel.sink.add(json);

    _channel.stream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data deleted') {
        print('Wine deleted');
      }
    });

    //close the channel
    _channel.sink.close();
  }

  Future<Wine> getWineById(int id) async {
    //create the json object
    final json = jsonEncode ({
      'type': 'GET_ONE',
      'id': id,
    });

    //send the json object to the server
    _channel.sink.add(json);

    Wine wine = Wine.empty();

    _channel.stream.listen((message) {
      var response = jsonDecode(message);
      if (response['message'] == 'Data fetched') {
        print('Wine retrieved');
        wine = Wine(response['wine']['id'],response['wine']['name'],response['wine']['type'],response['wine']['yearOfProduction'],response['wine']['region'],response['wine']['listOfIngredients'],response['wine']['calories'],response['wine']['photoURL'],);
      }
    });

    //close the channel
    _channel.sink.close();
    return wine;
  }

}
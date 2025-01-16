import "package:remote_winery/src/domain/model/wine.dart";
import "package:remote_winery/src/data/repository/wines_repository.dart";
import "package:remote_winery/src/data/repository/server_repository.dart";
import 'package:remote_winery/src/data/repository/log_repository.dart';

class ProducerService {
  final WinesRepository _winesRepository;
  final LogRepository _logRepository;
  final ServerRepository _serverRepository;

  ProducerService(this._winesRepository, this._serverRepository, this._logRepository){
    _initializeSync();
  }

  Future<void> _initializeSync() async {
    try {
      final List<Wine> wines = await _serverRepository.getWines();
      if (wines.isEmpty) {
        print("No wines retrieved from the server");
        return;
      }
      _winesRepository.setWines(wines);
      print("INITIALIZING: Wines retrieved from the server");
      await _syncLogs();
      print("INITIALIZING: Logs synced");
    } catch (e) {
      print("INITIALIZING: Error initializing sync: $e");
    }
  }

  Future addWine(Wine wine) async {
    try {
      await _winesRepository.addWine(wine);
      final serverWineId = await _serverRepository.addWine(wine);
      if (serverWineId == -1) {
        print ("Add failed in the server");
        final log = {
          "type": "POST",
          "wine": {
            "id": wine.id,
            "name": wine.nameOfProducer,
            "type": wine.type,
            "yearOfProduction": wine.yearOfProduction,
            "region": wine.region,
            "listOfIngredients": wine.listOfIngredients,
            "calories": wine.calories,
            "photoURL": wine.photoURL,
          }
        };
        _logRepository.addLog(log);
        return false;
      } else {
        var oldID = wine.id;
        wine.id = serverWineId;
        print ("Add completed in the server");
        var status = await _winesRepository.updateWineID(wine, oldID);
        if (status) {
          print ("Update completed in the local database");
          _logRepository.editLogsWineID(oldID, serverWineId);
          return true;
        } else {
          print ("Update failed in the local database");
          return false;
        }
      }
    } catch (e) {
      print("Error adding wine: $e");
      return false;
    }
  }

  Future _syncLogs() async {
    final logs = _logRepository.getLogs();
    for (var log in logs) {
      print ("Syncing log: $log");
      if (log["type"] == "POST") {
        final wine = Wine(
          log["wine"]["id"],
          log["wine"]["name"],
          log["wine"]["type"],
          log["wine"]["yearOfProduction"],
          log["wine"]["region"],
          log["wine"]["listOfIngredients"],
          log["wine"]["calories"],
          log["wine"]["photoURL"]
        );
        await addWine(wine);
      }
    }
  }

  // bool removeWine(int wineID) {
  Future removeWine(int wineID) async {
    try {
      await _winesRepository.removeWine(wineID);
      final status = await _serverRepository.removeWine(wineID);
      if (!status) {
        print ("Remove failed in the server");
        final log = {
          "type": "DELETE",
          "data": {
            "id": wineID,
          }
        };
        _logRepository.addLog(log);
        return false;
      }
      return true;
    } catch (e) {
      print("Error removing wine: $e");
      return false;
    }
  }

  // bool updateWine(Wine wine) {
  Future updateWine(Wine wine) async {
    try {
      await _winesRepository.updateWine(wine);
      final status = await _serverRepository.updateWine(wine);
      if (!status) {
        print ("Update failed in the server");
        final log = {
          "type": "PUT",
          "wine": {
            "id": wine.id,
            "name": wine.nameOfProducer,
            "type": wine.type,
            "yearOfProduction": wine.yearOfProduction,
            "region": wine.region,
            "listOfIngredients": wine.listOfIngredients,
            "calories": wine.calories,
            "photoURL": wine.photoURL,
          }
        };
        _logRepository.addLog(log);
        return false;
      }
      return true;
    } catch (e) {
      print("Error updating wine: $e");
      return false;
    }
  }

  // List<Wine> getWines() {
  Future<List<Wine>> getWines() async {
    return await _winesRepository.getWines();
  }

  // Wine getWineById(int id) {
  Future getWineById(int id) {
    return _winesRepository.getWineById(id);
  }
}

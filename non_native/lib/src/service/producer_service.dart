import "package:remote_winery/src/domain/model/wine.dart";
import "package:remote_winery/src/data/repository/wines_repository.dart";
import "package:remote_winery/src/data/repository/server_repository.dart";
import 'package:remote_winery/src/data/repository/log_repository.dart';
import 'dart:async';

class ProducerService {
  final WinesRepository _winesRepository;
  final LogRepository _logRepository;
  final ServerRepository _serverRepository;

  ProducerService(this._winesRepository, this._serverRepository, this._logRepository){
    initializeSync();
  }

  Future<void> initializeSync() async {
    print ("INITIALIZING: Syncing data");
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
    final completer = Completer<void>();
    _winesRepository.addWine(wine).then((_) {
      print ("ADD: Add completed in the local database");
      _serverRepository.addWine(wine).then((serverWineId) {
        if (serverWineId == -1) {
          print ("ADD: Add failed in the server");
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
          completer.completeError("ADD: Add failed in the server");
        } else {
          var oldID = wine.id;
          wine.id = serverWineId;
          print ("ADD: Add completed in the server");
          _winesRepository.updateWineID(wine, oldID).then((status) {
            if (status) {
              print ("ADD: Update completed in the local database");
              _logRepository.editLogsWineID(oldID, serverWineId);
              completer.complete();
            } else {
              print ("ADD: Update failed in the local database");
              completer.completeError("ADD: Update failed in the local database");
            }
          }).catchError((e) {
            print("ADD: Error updating wine's id: $e");
            completer.completeError("ADD: Error updating wine's id: $e");
          });
        }
      }).catchError((e) {
        print("ADD: Error adding wine on server: $e");
        completer.completeError("ADD: Error adding wine on server: $e");
      });
    }).catchError((e) {
      print("ADD: Error adding wine locally: $e");
      completer.completeError("ADD: Error adding wine locally: $e");
    });
    completer.future.then((_) {
      print("ADD: Add completed");
    }).catchError((e) {
      print("ADD: Add failed: $e");
    });

    return completer.future;
  }

  Future _syncLogs() async {
    print ("SYNCING: Syncing logs");
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

  Future removeWine(int wineID) async {
    final completer = Completer<void>();
    _winesRepository.removeWine(wineID).then((_) {
      print("REMOVE: Remove completed in the local database");
      _serverRepository.removeWine(wineID).then((status) {
        if (!status) {
          print("REMOVE: Remove failed in the server");
          final log = {
            "type": "DELETE",
            "data": {
              "id": wineID,
            }
          };
          _logRepository.addLog(log);
        } else {
          print("REMOVE: Remove completed in the server");
          completer.complete();
        }
      }).catchError((e) {
        print("REMOVE: Error removing wine on server: $e");
        completer.completeError(e);
      });
    }).catchError((e) {
      print("REMOVE: Error removing wine locally: $e");
      completer.completeError(e);
    });
    return completer.future;
  }

  Future updateWine(Wine wine) async {
    final completer = Completer<void>();
    _winesRepository.updateWine(wine).then((_) {
      print("UPDATE: Update completed in the local database");

      _serverRepository.updateWine(wine).then((status) {
        print("UPDATE: Server update status: $status"); 
        print("STATUS");
        if (!status) {
          print("UPDATE: Update failed in the server");

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
        } else {
          print("UPDATE: Update completed in the server");
          completer.complete();
        }
      }).catchError((e) {
        print("UPDATE: Error updating wine on server: $e");
        completer.completeError(e);
      });
    }).catchError((e) {
      print("UPDATE: Error updating wine locally: $e");
      completer.completeError(e);
    });
    completer.future.then((_) {
      print("UPDATE: Update completed");
    }).catchError((e) {
      print("UPDATE: Update failed: $e");
    });
    return completer.future;
  }

  Future<List<Wine>> getWines() async {
    return await _winesRepository.getWines();
  }

  // // Wine getWineById(int id) {
  // Future getWineById(int id) {
  //   return _winesRepository.getWineById(id);
  // }
}
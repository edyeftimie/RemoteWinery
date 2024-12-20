import "package:remote_winery/src/domain/model/wine.dart";
import "package:remote_winery/src/data/repository/wines_repository.dart";

class ProducerService {
  final WinesRepository _winesRepository = WinesRepository();

  // bool addWine(Wine wine) {
  Future addWine(Wine wine) {
    return _winesRepository.addWine(wine);
  }

  // bool removeWine(int wineID) {
  Future removeWine(int wineID) {
    return _winesRepository.removeWine(wineID);
  }

  // bool updateWine(Wine wine) {
  Future updateWine(Wine wine) {
    return _winesRepository.updateWine(wine);
  }

  // List<Wine> getWines() {
  Future<List<Wine>> getWines() {
    return _winesRepository.getWines();
  }

  // Wine getWineById(int id) {
  Future getWineById(int id) {
    return _winesRepository.getWineById(id);
  }
}

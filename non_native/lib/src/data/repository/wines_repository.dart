import "package:remote_winery/src/data/repository/database_helper.dart";
import "package:remote_winery/src/domain/model/wine.dart";


class WinesRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Wine> _wines = [];

  Future<List<Wine>> getWines() async {
    // for (Wine wine in _wines) {
    //   await _databaseHelper.insertWine(wine);
    // }
    _wines = await _databaseHelper.getWines();
    return _wines;
    // return await _databaseHelper.getWines();
  }

  Future<Wine> getWineById(int id) async {
    return await _databaseHelper.getWine(id);
  }

  Future<bool> addWine(Wine wine) async {
    wine.id = await _databaseHelper.getNextWineID();
    _wines.add(wine);
    return await _databaseHelper.insertWine(wine) > 0;
  }

  Future<bool> updateWine(Wine wine) async {
    _wines[_wines.indexWhere((element) => element.id == wine.id)] = wine;
    return await _databaseHelper.updateWine(wine) > 0;
  }

  Future<bool> removeWine(int wineID) async {
    _wines.removeWhere((element) => element.id == wineID);
    return await _databaseHelper.deleteWine(wineID) > 0;
  }

  // final List<Wine> _wines = [
  //   Wine(0, "Gitana Lupi", "Red", 2003, "Tuscany", "Cabernet Sauvignon, Merlot, Cabernet Franc, natural yeasts", 175, "https://wineful.ro/wp-content/uploads/2017/09/DSCF6465.jpg"),
  //   Wine(1, "Château Margaux", "Red", 2015, "Bordeaux", "Cabernet Sauvignon, Merlot, Petit Verdot, Cabernet Franc, natural yeasts", 125, "https://static.millesima.com/s3/attachements/h1000px/1001_2015_c.png"),
  //   Wine(2, "Sassicaia", "Red", 2016, "Tuscany", "Cabernet Sauvignon, Cabernet Franc, natural yeasts", 130, "https://vinotecamea.ro/139-large_default/sassicaia-2016-bolgheri-rosso-superiore-0.jpg"),
  //   Wine(3, "Opus One", "Red", 2017, "Napa Valley", "Cabernet Sauvignon, Merlot, Cabernet Franc, Petit Verdot, Malbec, natural yeasts", 120, "https://www.crushwineshop.ro/uploads/product/1464/opus-one-2018-cupaj-bordeaux-california-napa-valley.jpg"),
  //   Wine(4, "Penfolds Grange", "Red", 2014, "South Australia", "Shiraz, natural yeasts", 135, "https://www.winepoint.ro/images/penfolds-grange-2015.jpg"),
  //   Wine(5, "Château d'Yquem", "White", 2017, "Bordeaux", "Sauvignon Blanc, Semillon, natural yeasts", 110, "https://finding.wine/cdn/shop/files/Chateaud_Yquem-2020-Sauternes_49a3176b-8245-4081-9b8f-3407974ebab1_2000x.png?v=1720201869"),
  //   Wine(6, "Tignanello", "Red", 2018, "Tuscany", "Sangiovese, Cabernet Sauvignon, Cabernet Franc, natural yeasts", 115, "https://www.premiumdrinks.ro/2315-home_default/tignanello-2017.jpg"),
  //   Wine(7, "Vega Sicilia", "Red", 2019, "Ribera del Duero", "Tempranillo, Cabernet Sauvignon, Merlot, Malbec, natural yeasts", 105, "https://vinosvicente.lu/wp-content/uploads/2023/12/Unico-Rouge-2014-Bodegas-Vega-Sicilia-Ribera-del-Duero-1-600x600.jpg"),
  //   Wine(8, "Barola Riserva", "Red", 2010, "Piedmont", "Nebbiolo, natural yeasts", 110, "https://botta-di-cru.com/cdn/shop/products/barolo_riserva_460x@2x.jpg?v=1651986419"),
  //   Wine(9, "Chateau Lafite", "Red", 2003, "Bordeaux", "Cabernet Sauvignon, Merlot, Cabernet Franc, natural yeasts", 120, "https://cdn.premiumgrandscrus.com/8433-large_default/chateau-lafite-rothschild-2015.jpg"),
  //   Wine(10, "Chateau Mouton", "Red", 1999, "Bordeaux", "Cabernet Sauvignon, Merlot, Cabernet Franc, natural yeasts", 125, "https://www.bordeaux-tradition.com/wp-content/uploads/2018/02/mouton-2016.png"),
  //   Wine(11, "La Tache", "Red", 1920, "Burgundy", "Pinot Noir, natural yeasts", 130, "https://images.vivino.com/thumbs/rUPGZo11SwW6haQta4COqQ_pb_x960.png"),
  //   Wine(12, "Chateau Haut Brion", "Red", 2014, "Bordeaux", "Cabernet Sauvignon, Merlot, Cabernet Franc, natural yeasts", 135, "https://www.haut-brion.com/wp-content/uploads/sites/3/2022/04/HBR-sans-millesime-min-408x1024.png"),
  //   Wine(13, "Chateau Petrus", "Red", 2005, "Bordeaux", "Merlot, natural yeasts", 140, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTx1wti8kdtm5qWgXiL265gfYrg9pg0i8vTPw&s"),
  //   Wine(14, "Gaja Barbaresco", "Red", 2006, "Piedmont", "Nebbiolo, natural yeasts", 145, "https://i0.wp.com/connectingbrands.pt/wp-content/uploads/2019/02/Gaja-Barbaresco.png?fit=531%2C1000&ssl=1"),
  //   Wine(15, "Ornellaia", "Red", 2017, "Tuscany", "Cabernet Sauvignon, Merlot, Cabernet Franc, natural yeasts", 150, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6L7N1yoAoYyIXJKHHUJg2rRIyv8nRZgWtLw&s"),
  //   Wine(16, "Solaia", "Red", 1982, "Tuscany", "Cabernet Sauvignon, Sangiovese, natural yeasts", 155, "https://apollowine.com/public/products/Solaia-Apollowine-Selection.jpg"),
  //   Wine(17, "Close de Tart", "Red", 2000, "Burgundy", "Pinot Noir, natural yeasts", 160, "https://selectionsommelier.com/wp-content/uploads/2023/04/CLOS-DE-TART-CLOS-DE-TART-ROUGE-1.jpg"),
  //   Wine(18, "Amarone", "Red", 2003, "Veneto", "Corvina, Rondinella, Molinara, natural yeasts", 165, "https://bespokewineandspirits.com/cdn/shop/files/3948026_Amarone_20classico_8edf1719-2d8a-451a-a25f-cee10167b642.jpg?v=1723655664"),
  //   Wine(19, "Masseto", "Red", 1970, "Tuscany", "Merlot, natural yeasts", 170, "https://trianglewineco.com/cdn/shop/files/wine-tomasello-raspberry-wine-42536281506081.png?v=1704823377"),
  // ];
  // int index = 20;

  // bool addWine(Wine wine) {
  //   if (_wines.contains(wine)) {
  //     return false;
  //   }
  //   wine.id = index + 1;
  //   _wines.add(wine);
  //   index += 1;
  //   return true;
  // }

  // bool removeWine(int wineID) {
  //   if (!_wines.any((element) => element.id == wineID)) {
  //     return false;
  //   }
  //   _wines.removeWhere((element) => element.id == wineID);
  //   return true;
  // }

  // bool updateWine(Wine wine) {
  //   int index = _wines.indexWhere((element) => element.id == wine.id);
  //   if (index == -1) {
  //     return false;
  //   }
  //   _wines[index] = wine;
  //   return true;
  // }

  // List<Wine> getWines() {
  //   return _wines;
  // }

  // Wine getWineById(int id) {
  //   if (!_wines.any((element) => element.id == id)) {
  //     return Wine.empty();
  //   }
  //   return _wines.firstWhere((wine) => wine.id == id);
  // }
}

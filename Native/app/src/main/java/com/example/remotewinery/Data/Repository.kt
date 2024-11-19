package com.example.remotewinery.Data

object Repository {
    val winesMap: MutableMap<Int, Wine> = HashMap()

    var INDEX = 20

    init {
        addWine(Wine(1, "Château Margaux", "Red(Bordeaux)", 2015, "Cabernet Sauvignon, Merlot, Petit Verdot, Cabernet Franc, natural yeasts", 125, "https://static.millesima.com/s3/attachements/h1000px/1001_2015_c.png"))
        addWine(Wine(2, "Sassicaia", "Red(Tuscany)", 2016, "Cabernet Sauvignon, Cabernet Franc, natural yeasts", 130, "https://vinotecamea.ro/139-large_default/sassicaia-2016-bolgheri-rosso-superiore-0.jpg"))
        addWine(Wine(3, "Opus One", "Red(Bordeaux Blend)", 2017, "Cabernet Sauvignon, Merlot, Cabernet Franc, Petit Verdot, Malbec, natural yeasts", 120, "https://www.crushwineshop.ro/uploads/product/1464/opus-one-2018-cupaj-bordeaux-california-napa-valley.jpg"))
        addWine(Wine(4, "Penfolds Grange", "Red(Shiraz)", 2014, "Shiraz, natural yeasts", 135, "https://www.winepoint.ro/images/penfolds-grange-2015.jpg"))
        addWine(Wine(5, "Château d'Yquem", "White", 2017, "Sauvignon Blanc, Semillon, natural yeasts", 110, "https://finding.wine/cdn/shop/files/Chateaud_Yquem-2020-Sauternes_49a3176b-8245-4081-9b8f-3407974ebab1_2000x.png?v=1720201869"))
        addWine(Wine(6, "Tignanello", "Red(Tuscany)", 2018, "Sangiovese, Cabernet Sauvignon, Cabernet Franc, natural yeasts", 115, "https://www.premiumdrinks.ro/2315-home_default/tignanello-2017.jpg"))
        addWine(Wine(7, "Vega Sicilia", "Red(Ribera del Duero)", 2019, "Tempranillo, Cabernet Sauvignon, Merlot, Malbec, natural yeasts", 105, "https://vinosvicente.lu/wp-content/uploads/2023/12/Unico-Rouge-2014-Bodegas-Vega-Sicilia-Ribera-del-Duero-1-600x600.jpg"))
        addWine(Wine(8, "Barola Riserva", "Red(Piedmont)", 2010, "Nebbiolo, natural yeasts", 110, "https://botta-di-cru.com/cdn/shop/products/barolo_riserva_460x@2x.jpg?v=1651986419"))
        addWine(Wine(9, "Chateau Lafite", "Red(Bordeaux)", 2003, "Cabernet Sauvignon, Merlot, Cabernet Franc, natural yeasts", 120, "https://cdn.premiumgrandscrus.com/8433-large_default/chateau-lafite-rothschild-2015.jpg"))
        addWine(Wine(10, "Chateau Mouton", "Red(Bordeaux)", 1999, "Cabernet Sauvignon, Merlot, Cabernet Franc, natural yeasts", 125, "https://www.bordeaux-tradition.com/wp-content/uploads/2018/02/mouton-2016.png"))
        addWine(Wine(11, "La Tache", "Red(Burgundy)", 1920, "Pinot Noir, natural yeasts", 130, "https://images.vivino.com/thumbs/rUPGZo11SwW6haQta4COqQ_pb_x960.png"))
        addWine(Wine(12, "Chateau Haut Brion", "Red(Bordeaux)", 2014, "Cabernet Sauvignon, Merlot, Cabernet Franc, natural yeasts", 135, "https://www.haut-brion.com/wp-content/uploads/sites/3/2022/04/HBR-sans-millesime-min-408x1024.png"))
        addWine(Wine(13, "Chateau Petrus", "Red(Bordeaux)", 2005, "Merlot, natural yeasts", 140, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTx1wti8kdtm5qWgXiL265gfYrg9pg0i8vTPw&s"))
        addWine(Wine(14, "Gaja Barbaresco", "Red(Piedmont)", 2006, "Nebbiolo, natural yeasts", 145, "https://i0.wp.com/connectingbrands.pt/wp-content/uploads/2019/02/Gaja-Barbaresco.png?fit=531%2C1000&ssl=1"))
        addWine(Wine(15, "Ornellaia", "Red(Tuscany)", 2017, "Cabernet Sauvignon, Merlot, Cabernet Franc, natural yeasts", 150, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6L7N1yoAoYyIXJKHHUJg2rRIyv8nRZgWtLw&s"))
        addWine(Wine(16, "Solaia", "Red(Tuscany)", 1982, "Cabernet Sauvignon, Sangiovese, natural yeasts", 155, "https://apollowine.com/public/products/Solaia-Apollowine-Selection.jpg"))
        addWine(Wine(17, "Close de Tart", "Red(Burgundy)", 2000, "Pinot Noir, natural yeasts", 160, "https://selectionsommelier.com/wp-content/uploads/2023/04/CLOS-DE-TART-CLOS-DE-TART-ROUGE-1.jpg"))
        addWine(Wine(18, "Amarone", "Red(Veneto)", 2003, "Corvina, Rondinella, Molinara, natural yeasts", 165, "https://bespokewineandspirits.com/cdn/shop/files/3948026_Amarone_20classico_8edf1719-2d8a-451a-a25f-cee10167b642.jpg?v=1723655664"))
        addWine(Wine(19, "Masseto", "Red(Tuscany)", 1970, "Merlot, natural yeasts", 170, "https://trianglewineco.com/cdn/shop/files/wine-tomasello-raspberry-wine-42536281506081.png?v=1704823377"))
        addWine(Wine(20, "Gitana Lupi", "Red(Tuscany)", 2003, "Cabernet Sauvignon, Merlot, Cabernet Franc, natural yeasts", 175, "https://wineful.ro/wp-content/uploads/2017/09/DSCF6465.jpg"))
    }

    private fun addWine(wine: Wine) {
        
        winesMap[wine.id] = wine
    }

    public fun createWine(name: String, type: String, year: Int, listOfIngredients: String, numberOfCalories: Int, photoURL: String) {
        INDEX += 1
        addWine(Wine(INDEX, name, type, year, listOfIngredients, numberOfCalories, photoURL))
    }

    public fun deleteWine(id: Int) {
        winesMap.remove(id)
    }

    public fun updateWine(id: Int, name: String, type: String, year: Int, listOfIngredients: String, numberOfCalories: Int, photoURL: String) {
        val w = Wine(id, name, type, year, listOfIngredients, numberOfCalories, photoURL)
        winesMap[id] = w
    }

    public fun editWine(updatedWine: Wine) {
        winesMap[updatedWine.id] = updatedWine
    }

    public fun getWine(id: Int): Wine? {
        return winesMap[id]
    }

    public fun getWinesList(): List<Wine> {
        return winesMap.values.toList()
    }
}
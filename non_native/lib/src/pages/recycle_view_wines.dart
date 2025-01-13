import 'package:flutter/material.dart';
import 'package:remote_winery/src/domain/model/wine.dart';
import 'package:remote_winery/src/service/producer_service.dart';
import 'package:remote_winery/src/settings/settings_view.dart';
import 'package:remote_winery/src/pages/widges/delete_confirmation.dart';

class RecycleViewWines extends StatefulWidget {
  const RecycleViewWines({super.key});

  static const routeName = '/wines';

  @override
  State<RecycleViewWines> createState() => _RecycleViewWinesState();
}

class _RecycleViewWinesState extends State<RecycleViewWines> {
  final ProducerService _producerService = ProducerService();

  Future<void> _navigateToAddingWine() async {
    final result = await Navigator.pushNamed(context, '/addWine');
    if (result != null) {
      final wine = result as Wine;
      print(wine);
      await _producerService.addWine(wine);
      setState(() {
      });
      debugPrint('Wine added');
    }
  }

  Future<void> _navigateToEditingWine(Wine wine) async {
    final result = await Navigator.pushNamed(context, '/editWine', arguments: wine);
    if (result != null) {
      final newWine = result as Wine;
      print(newWine);
      await _producerService.updateWine(newWine);
      setState(() {
      });
      debugPrint('Wine updated');
    }
  }

  Future<void> _navigateToDeletingWine(Wine wine) async {
    final result = await showDialog<bool> (
        context: context,
        builder: (BuildContext context) {
          return DeleteConfirmation (
            title: 'Delete Wine',
            content: 'Are you sure you want to delete ${wine.nameOfProducer}?',
          );
        },
      );
    if (result != null && result == true) {
      await _producerService.removeWine(wine.id);
      setState(() {
      });
      debugPrint('Wine deleted');
    }
  } 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wines'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      //card:
      //  sized box:
      //    row:
      //      container:
      //        cliprrect:
      //          image
      //      sizedbox
      //      expanded:
      //        column:
      //          attributes

      body: FutureBuilder<List<Wine>>(
        future: _producerService.getWines(),
        builder: (BuildContext context, AsyncSnapshot<List<Wine>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center (
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError){
            return Center (
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final wines = snapshot.data!;
            return ListView.builder(
              restorationId: 'winesListView',
              padding: const EdgeInsets.all(3.0),
              itemCount: wines.length,
              itemBuilder: (BuildContext context, int index) {
                final Wine wine = wines[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToEditingWine(wine);
                  },
                  onLongPress: ()  {
                    _navigateToDeletingWine(wine);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      color: const Color.fromARGB(255, 139, 17, 9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(
                          // color: Colors.white,
                          color: const Color.fromARGB(255, 139, 17, 9),
                          width: 0.1
                        ),
                      ),
                      child: SizedBox(
                        height: 120, // Set the height of the card here
                        child: Row(
                          children: [
                            // Image container with fixed height
                            Container(
                              width: 110, // Width of the image container
                              height: 120, // Height should match the Card's height

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  bottomLeft: Radius.circular(25.0),
                                )
                              ),

                              child: ClipRRect(
                                borderRadius: BorderRadius.only (
                                  topLeft: Radius.circular(25.0),
                                  bottomLeft: Radius.circular(25.0),
                                ),
                                child: Image.network(
                                  wine.photoURL,
                                  fit: BoxFit.fitHeight,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error, size: 40, color: Colors.redAccent);
                                  },
                                ),
                              ),
                            ),

                            SizedBox(width: 10),  // Space between image and text

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wine.nameOfProducer,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Text(wine.type, style: TextStyle(color: Colors.white)),
                                  Text(wine.yearOfProduction.toString(), style: TextStyle(color: Colors.white)),
                                  Text(wine.region, style: TextStyle(color: Colors.white)),
                                  Text(wine.listOfIngredients, style: TextStyle(color: Colors.white)),
                                  Text(wine.calories.toString(), style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No wines available'),
            );
          }
        }

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddingWine();
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );

  }
}
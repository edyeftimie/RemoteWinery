import 'package:flutter/material.dart';
import 'package:remote_winery/src/domain/model/wine.dart';
import 'package:remote_winery/src/pages/widges/wine_form.dart';

class AddWine extends StatelessWidget {
  static const routeName = '/addWine';

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Add Wine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WineForm(
          intialData: Wine.empty(),
          onSubmit: (wine) {
            Navigator.pop(context, wine);
          },
        )
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:remote_winery/src/domain/model/wine.dart';
import 'package:remote_winery/src/pages/widges/wine_form.dart';

class EditWine extends StatelessWidget {
  static const routeName = '/editWine';

  @override
  Widget build (BuildContext context) {
    final oldWine = ModalRoute.of(context)!.settings.arguments as Wine;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Edit Wine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WineForm(
          intialData: oldWine,
          onSubmit: (wine) {
            Navigator.pop(context, wine);
          },
        )
      )
    );
  }
}
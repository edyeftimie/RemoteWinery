import 'package:flutter/material.dart';
import 'package:remote_winery/src/domain/model/wine.dart';

class WineForm extends StatelessWidget {
  final Wine intialData;
  final Function(Map<String, dynamic>) onSubmit;

  WineForm({required this.intialData, required this.onSubmit});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _typeController = TextEditingController();
  final _regionController = TextEditingController();
  final _ingredientsController = TextEditingController(); 
  final _caloriesController = TextEditingController();
  final _photoURLController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (intialData.id != 0) {
      _nameController.text = intialData.nameOfProducer;
      _yearController.text = intialData.yearOfProduction.toString();
      _typeController.text = intialData.type;
      _regionController.text = intialData.region;
      _ingredientsController.text = intialData.listOfIngredients;
      _caloriesController.text = intialData.calories.toString();
      _photoURLController.text = intialData.photoURL;
    }

    void submitForm() {
      if (_formKey.currentState!.validate()) {
        var wine = Wine.empty();
        if (intialData.id != 0) {
          wine = intialData;
        }
        wine.nameOfProducer = _nameController.text;
        wine.yearOfProduction = int.parse(_yearController.text);
        wine.type = _typeController.text;
        wine.region = _regionController.text;
        wine.listOfIngredients = _ingredientsController.text;
        wine.calories = int.parse(_caloriesController.text);
        wine.photoURL = _photoURLController.text;
        Navigator.pop(context, wine);
      }
    }
    return SingleChildScrollView(

    child: Form (
      key: _formKey,
      child: Column (
        children: [
          TextFormField (
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              // if (value != intialData.nameOfProducer) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter a name';
              //   }
              //   if (value.length < 3) {
              //     return 'Please enter a name with at least 3 characters';
              //   }
              //   // the name must contain only letters and spaces
              //   if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
              //     return 'Please enter a name with only letters and spaces';
              //   }
              //   if (value.length > 50) {
              //     return 'Please enter a name with at most 50 characters';
              //   }
              // }
              return null;
            }
          ),
          TextFormField(
            controller: _yearController,
            decoration: InputDecoration(labelText: 'Year'),
            validator: (value) {
              // if (value != intialData.yearOfProduction.toString()) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter a year';
              //   }
              //   if (int.tryParse(value) == null) {
              //     return 'Please enter a valid year';
              //   }
              //   if (int.parse(value) < 1900 || int.parse(value) > 2024) {
              //     return 'Please enter a year between 1900 and 2024';
              //   }
              // }
              return null; // means no error
            }
          ),
          TextFormField(
            controller: _typeController,
            decoration: InputDecoration(labelText: 'Type'),
            validator: (value) {
              // if (value == null || value.isEmpty) {
              //   return 'Please enter a type';
              // }
              return null;
            }
          ),
          TextFormField(
            controller: _regionController,
            decoration: InputDecoration(labelText: 'Region'),
            validator: (value) {
              // if (value == null || value.isEmpty) {
              //   return 'Please enter a region';
              // }
              return null;
            }
          ),
          TextFormField(
            controller: _ingredientsController,
            decoration: InputDecoration(labelText: 'Ingredients'),
            validator: (value) {
              // if (value == null || value.isEmpty) {
              //   return 'Please enter ingredients';
              // }
              return null;
            }
          ),
          TextFormField(
            controller: _caloriesController,
            decoration: InputDecoration(labelText: 'Calories'),
            validator: (value) {
              // if (value == null || value.isEmpty) {
              //   return 'Please enter calories';
              // }
              // if (int.tryParse(value) == null) {
              //   return 'Please enter a valid number';
              // }
              // if (int.parse(value) < 0) {
              //   return 'Please enter a positive number';
              // }
              return null;
            }
          ),
          TextFormField(
            controller: _photoURLController,
            decoration: InputDecoration(labelText: 'Photo URL'),
            validator: (value) {
            //   if (value != intialData.photoURL) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter a photo URL';
            //     }
            //     if (!Uri.parse(value).isAbsolute) {
            //       return 'Please enter a valid URL';
            //     }
            //     // if (!value.endsWith('.jpg') && !value.endsWith('.png')) {
            //     //   return 'Please enter a valid image URL';
            //     // }
            //   }
              return null;
            }
          ),
          ElevatedButton(
            onPressed: submitForm,
            child: Text('Submit')
          )
        ]
      )
    )
    );
  }
}
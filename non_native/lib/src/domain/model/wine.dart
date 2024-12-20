class Wine {
  int id;
  String nameOfProducer;
  String type;
  int yearOfProduction;
  String region;
  String listOfIngredients;
  int calories;
  String photoURL;

  Wine(this.id, this.nameOfProducer, this.type, this.yearOfProduction, this.region, this.listOfIngredients, this.calories, this.photoURL);
  Wine.empty() :
    id = 0,
    nameOfProducer = 'ceva',
    type = '',
    yearOfProduction = 0,
    region = '',
    listOfIngredients = '',
    calories = 0,
    photoURL = '';

  @override
  bool operator ==(Object other) {
    return other is Wine && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  bool isIdentical(Wine other) {
    return other.id == id && other.nameOfProducer == nameOfProducer && other.type == type && other.yearOfProduction == yearOfProduction && other.region == region && other.listOfIngredients == listOfIngredients && other.calories == calories && other.photoURL == photoURL;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nameOfProducer': nameOfProducer,
      'type': type,
      'yearOfProduction': yearOfProduction,
      'region': region,
      'listOfIngredients': listOfIngredients,
      'calories': calories,
      'photoURL': photoURL
    };
    map['id'] = id;
    return map;
  }
  //make a fromMap method that has parameter only one element from the map, not the map itself
  Wine.fromMap(Map<dynamic, dynamic> map) :
    id = map['id'],
    nameOfProducer = map['nameOfProducer'],
    type = map['type'],
    yearOfProduction = map['yearOfProduction'],
    region = map['region'],
    listOfIngredients = map['listOfIngredients'],
    calories = map['calories'],
    photoURL = map['photoURL'];
}
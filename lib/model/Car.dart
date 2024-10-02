class Car {
  int? id;
  String make;
  String model;
  bool isrunning;
  double price;
  DateTime builddate;
  int? useraccount_id;

  Car({
    required this.make,
    required this.model,
    required this.isrunning,
    required this.price,
    required this.builddate,
    this.useraccount_id,
    this.id,
  });

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      make: map['make'],
      model: map['model'],
      isrunning: map['isrunning'] is bool ? map['isrunning'] : map['isrunning'] == 'true',
      price: double.parse(map['price'].toString()),
      builddate: DateTime.parse(map['builddate']),
      useraccount_id: map['useraccount_id'],
    );
  }

  toMap() {
    return {
      'id': id.toString(),
      'make': make,
      'model': model,
      'isrunning': isrunning.toString(),
      'price': price.toString(),
      'builddate': builddate.toIso8601String(),
    };
  }
}

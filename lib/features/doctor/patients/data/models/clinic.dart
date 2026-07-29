class Clinic {
  Clinic({this.id, this.name, this.address, this.price});

  Clinic.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw const FormatException('Invalid JSON');
    id = json['_id'];
    name = json['name'];
    address = json['address'];
    price = json['price'];
  }
  String? id;
  String? name;
  String? address;
  num? price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['address'] = address;
    map['price'] = price;
    return map;
  }
}

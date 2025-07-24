import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String organiserId;
  final String title;
  final String description;
  final DateTime date;
  final String horaire;
  final String location;
  final double? long;
  final double? lat;
  final String imageUrl;
  final List<TicketType> ticketTypes;

  Event({
    required this.id,
    required this.organiserId,
    required this.title,
    required this.description,
    required this.date,
    required this.horaire,
    required this.location,
    required this.long,
    required this.lat,
    required this.imageUrl,
    required this.ticketTypes,
  });

  static Event fromMap(Map<String, dynamic> data, String id) {
  return Event(
    id: id,
    organiserId: data["organiserId"] ?? '',
    title: data["title"] ?? '',
    description: data["description"] ?? '',
    date: data["date"]  is Timestamp
    ? (data["date"] as Timestamp).toDate()
    : DateTime.parse(data["date"]),
    horaire: data["horaire"] ?? '',
    location: data["location"] ?? '',
    long: (data["long"] as num?)?.toDouble() ?? 0.0,
    lat: (data["lat"] as num?)?.toDouble() ?? 0.0,
    imageUrl: data["imageUrl"] ?? '',
    ticketTypes: (data["ticketTypes"] as List<dynamic>? ?? [])
        .map((e) => TicketType.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}


  Map<String, dynamic> toJon() {
    return {
      '_id': id,
      'organiserId':organiserId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'horaire': horaire,
      'location': location,
      'long': long,
      'lat': lat,
      'imageUrl':imageUrl,
      'ticketTypes': ticketTypes,
    };
  }

}

class TicketType {
  final String type;
  final int price;
  final int available;
  final int sold;

  TicketType({
    required this.type,
    required this.price,
    required this.available,
    required this.sold
  });

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      type: json['type'] ?? "",
      price: json['price'] ?? 0,
      available: json['available'] ?? 0,
      sold:json["sold"] ?? 0
    );
  }

  Map<String, dynamic> toJon() {
    return {'type': type, 'price': price, 'available': available, 'sold':sold};
  }
}

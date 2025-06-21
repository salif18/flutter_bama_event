class Event {
  final String id;
  final String organiserId;
  final String title;
  final String description;
  final String date;
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

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      organiserId:json["organiserId"] ,
      title: json['title'],
      description: json['description'],
      date: json['date'],
      horaire: json['horaire'],
      location: json['location'],
      long: json['long'] ?? 0,
      lat: json['lat'] ?? 0,
      imageUrl: json['imageUrl'],
      ticketTypes: (json['ticketTypes'] as List)
          .map((e) => TicketType.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJon() {
    return {
      '_id': id,
      'organiserId':organiserId,
      'title': title,
      'description': description,
      'date': date,
      'horaire': horaire,
      'location': location,
      'long': long,
      'lat': lat,
      'imageUrl':imageUrl,
      'ticketTypes': ticketTypes,
    };
  }

 static List<Event> getFakeEvents() {
  return [
    Event(
      id: '1',
      organiserId: "12a",
      title: 'Concert Burna Boy',
      description: 'Un concert exceptionnel de Burna Boy avec des invités surprise.',
      date: '2025-07-20',
      horaire: '20:00',
      location: 'Palais de la Culture, Bamako',
      long: -7.9856,
      lat: 12.6392,
      imageUrl: 'https://th.bing.com/th/id/OSK.HEROApeSfUon61vwCV-4kQ9CMZgVag75KYkmDbanKjc-4HQ?w=472&h=280&c=13&rs=2&o=6&oif=webp&pid=SANGAM',
      ticketTypes: [
        TicketType(type: 'Standard', price: 10000, available: 200, sold:29),
        TicketType(type: 'VIP', price: 20000, available: 50,sold:20),
      ],
    ),
    Event(
      id: '2',
       organiserId: "12a",
      title: 'Festival de la Musique Africaine',
      description: '3 jours de festivités, danses, concerts et gastronomie locale.',
      date: '2025-08-15',
      horaire: '14:00',
      location: 'Stade Omnisports, Bamako',
      long: -8.0002,
      lat: 12.6538,
      imageUrl: 'https://images.unsplash.com/photo-1506157786151-b8491531f063?auto=format&fit=crop&w=800&h=600&q=80',
      ticketTypes: [
        TicketType(type: 'Pass Jour', price: 5000, available: 300,sold:100),
        TicketType(type: 'Pass 3 Jours', price: 12000, available: 100,sold:50),
      ],
    ),
    Event(
      id: '3',
       organiserId: "12a",
      title: 'Match Mali vs Sénégal',
      description: 'Match de football amical entre deux géants de l’Afrique de l’Ouest.',
      date: '2025-09-10',
      horaire: '18:00',
      location: 'Stade 26 Mars, Bamako',
      long: -7.9428,
      lat: 12.5674,
      imageUrl: 'https://c8.alamy.com/comp/2HF1298/soccer-football-competition-match-national-teams-senegal-vs-mali-2HF1298.jpg',
      ticketTypes: [
        TicketType(type: 'Tribune', price: 3000, available: 500,sold:400),
        TicketType(type: 'VIP', price: 10000, available: 100,sold:90),
      ],
    ),
    Event(
      id: '4',
       organiserId: "12a",
      title: 'Soirée Dîner dansant',
      description: 'Dîner romantique accompagné de musique live et ambiance festive.',
      date: '2025-07-28',
      horaire: '21:00',
      location: 'Hôtel Salam, Bamako',
      long: -7.9801,
      lat: 12.6233,
      imageUrl: 'https://th.bing.com/th/id/OIP.DZLo3qvsvkmKpjqPQMfBGAHaKd?w=138&h=195&c=7&r=0&o=7&pid=1.7&rm=3',
      ticketTypes: [
        TicketType(type: 'Solo', price: 15000, available: 100,sold:100),
        TicketType(type: 'Couple', price: 25000, available: 50,sold:40),
      ],
    ),
    Event(
      id: '5',
       organiserId: "12a",
      title: 'Avant-première "Racines Africaines"',
      description: 'Film historique avec débat post-projection en présence des acteurs.',
      date: '2025-10-05',
      horaire: '19:30',
      location: 'Cinéma Babemba, Bamako',
      long: -7.9902,
      lat: 12.6321,
      imageUrl: 'https://th.bing.com/th/id/OIP.yfjx8fvFN41Vmv4hql-uYwHaKe?w=127&h=180&c=7&r=0&o=7&pid=1.7&rm=3',
      ticketTypes: [
        TicketType(type: 'Normal', price: 2000, available: 150, sold:100),
        TicketType(type: 'VIP', price: 5000, available: 30, sold:20),
      ],
    ),
    Event(
      id: '6',
       organiserId: "12a",
      title: 'Gala de l’humour africain',
      description: 'Les plus grands humoristes du continent sur une seule scène.',
      date: '2025-11-02',
      horaire: '20:00',
      location: 'Centre Culturel Français',
      long: -7.9867,
      lat: 12.6350,
      imageUrl: 'https://gaboncelebrites.com/wp-content/uploads/2017/11/AFRIQUE-DU-RIRE.jpg',
      ticketTypes: [
        TicketType(type: 'Standard', price: 7000, available: 200,sold:150),
        TicketType(type: 'VIP', price: 12000, available: 40,sold:38),
      ],
    ),
    Event(
      id: '7',
       organiserId: "12a",
      title: 'Foire Artisanale de Bamako',
      description: 'Exposition-vente d’objets d’art, vêtements, nourriture locale.',
      date: '2025-12-01',
      horaire: '10:00',
      location: 'Parc des Expositions, Bamako',
      long: -8.0120,
      lat: 12.6511,
      imageUrl: 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&w=800&h=600&q=80',
      ticketTypes: [
        TicketType(type: 'Entrée Simple', price: 1000, available: 1000,sold:1000),
      ],
    ),
    Event(
      id: '8',
       organiserId: "12a",
      title: 'Journée Santé & Bien-être',
      description: 'Consultations gratuites, dépistage, conférences et yoga.',
      date: '2025-09-18',
      horaire: '08:00',
      location: 'Maison des Jeunes, Bamako',
      long: -7.9760,
      lat: 12.6240,
      imageUrl: 'https://th.bing.com/th/id/R.6603b893bda9c52211d9c4f51545dd1b?rik=dgvYtx4MyKp4WA&pid=ImgRaw&r=0',
      ticketTypes: [
        TicketType(type: 'Entrée Libre', price: 0, available: 9999, sold:9000),
      ],
    ),
    Event(
      id: '9',
       organiserId: "12a",
      title: 'Voyage organisé à Ségou',
      description: 'Excursion touristique avec transport, repas et activités inclus.',
      date: '2025-10-22',
      horaire: '06:00',
      location: 'Départ depuis Bamako',
      long: -6.2667,
      lat: 13.4333,
      imageUrl: 'https://tse1.mm.bing.net/th/id/OIP.eZwEziPNr3C4HMaFA7-lBQHaHa?r=0&rs=1&pid=ImgDetMain&cb=idpwebpc1',
      ticketTypes: [
        TicketType(type: 'Pack Standard', price: 25000, available: 40, sold:40),
        TicketType(type: 'Pack VIP', price: 40000, available: 20, sold:20),
      ],
    ),
  ];
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
      type: json['type'],
      price: json['price'],
      available: json['available'],
      sold:json["sold"]
    );
  }

  Map<String, dynamic> toJon() {
    return {'type': type, 'price': price, 'available': available, 'sold':sold};
  }
}

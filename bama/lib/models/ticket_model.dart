import 'package:uuid/uuid.dart';

class TicketModel {
  final String ticketId;
  final String eventId;
  final String userId;
  final String eventTitle;
  final String ticketType;
  final String qrCode;
  final String purchasedAt;
  final bool isUsed;

  TicketModel({
    required this.ticketId,
    required this.eventId,
    required this.userId,
    required this.eventTitle,
    required this.ticketType,
    required this.qrCode,
    required this.purchasedAt,
    required this.isUsed
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      ticketId: json["ticket_id"],
      eventId: json["event_id"],
      userId: json["user_id"],
      eventTitle: json["event_title"],
      ticketType: json["ticket_type"],
      qrCode: json["qr_code"],
      purchasedAt: json["purchasedAt"],
      isUsed: json['is_used'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ticket_id": ticketId,
      "event_id": eventId,
      "user_id": userId,
      "event_title":eventTitle,
      "type": ticketType,
      "qr_code": qrCode,
      "purchased_at": purchasedAt,
      'is_used': isUsed,
    };
  }

   static List<TicketModel> generateFakeTickets() {
    final uuid = Uuid();
    return [
      TicketModel(
        ticketId: uuid.v4(),
        eventId: '1',
        userId: 'user_101',
        eventTitle: 'Concert Burna Boy',
        ticketType: 'VIP',
        qrCode: 'QR-001-VIP-${uuid.v4().substring(0, 8)}',
        purchasedAt: '2025-06-10T15:45:00Z',
        isUsed: false,
      ),
      TicketModel(
        ticketId: uuid.v4(),
        eventId: '2',
        userId: 'user_102',
        eventTitle: 'Festival de la Musique Africaine',
        ticketType: 'Pass Jour',
        qrCode: 'QR-002-JOUR-${uuid.v4().substring(0, 8)}',
        purchasedAt: '2025-06-11T10:30:00Z',
        isUsed: false,
      ),
      TicketModel(
        ticketId: uuid.v4(),
        eventId: '3',
        userId: 'user_103',
        eventTitle: 'Match Mali vs Sénégal',
        ticketType: 'Tribune',
        qrCode: 'QR-003-TRIB-${uuid.v4().substring(0, 8)}',
        purchasedAt: '2025-06-12T09:20:00Z',
        isUsed: false,
      ),
      TicketModel(
        ticketId: uuid.v4(),
        eventId: '4',
        userId: 'user_104',
        eventTitle:  'Soirée Dîner dansant',
        ticketType: 'Couple',
        qrCode: 'QR-004-COUPLE-${uuid.v4().substring(0, 8)}',
        purchasedAt: '2025-06-13T19:10:00Z',
        isUsed: false,
      ),
      TicketModel(
        ticketId: uuid.v4(),
        eventId: '5',
        userId: 'user_105',
        eventTitle:  'Avant-première "Racines Africaines"',
        ticketType: 'VIP',
        qrCode: 'QR-005-VIP-${uuid.v4().substring(0, 8)}',
        purchasedAt: '2025-06-14T13:00:00Z',
        isUsed: false,
      ),
    ];
  }
}

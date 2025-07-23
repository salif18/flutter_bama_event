class TicketModel {
  final String ticketId;
  final String eventId;
  final String userId;
  final String eventTitle;
  final String ticketType;
  final String organiserId;
  final int commission;
  final int netRevenue;
  final String qrCode;
  final String purchasedAt;
  final bool isUsed;

  TicketModel({
    required this.ticketId,
    required this.eventId,
    required this.userId,
    required this.eventTitle,
    required this.ticketType,
    required this.organiserId,
    required this.commission,
    required this.netRevenue,
    required this.qrCode,
    required this.purchasedAt,
    required this.isUsed
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
  return TicketModel(
    ticketId: json["ticket_id"] ?? "",
    eventId: json["event_id"] ?? "",
    userId: json["user_id"] ?? "",
    eventTitle: json["event_title"] ?? "",
    ticketType: json["ticket_type"] ?? "",
    organiserId: json['organiserId'] ?? "",
    commission: json['commission'] ?? 0,
    netRevenue: json['netRevenue'] ?? 0,
    qrCode: json["qr_code"] ?? "", // Ajouté fallback
    purchasedAt: json["purchasedAt"]?.toDate() ?? "", // Ajouté fallback
    isUsed: json['is_used'] ?? false, // Ajouté fallback
  );
}


  Map<String, dynamic> toJson() {
    return {
      "ticket_id": ticketId,
      "event_id": eventId,
      "user_id": userId,
      "event_title":eventTitle,
      "type": ticketType,
      'organiserId':organiserId,
      'commission':commission,
      'netRevenue':netRevenue,
      "qr_code": qrCode,
      "purchased_at": purchasedAt,
      'is_used': isUsed,
    };
  }
}

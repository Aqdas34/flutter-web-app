class BookedDate {
  final String id;
  final DateTime date;
  final String bookingId;

  BookedDate({
    required this.id,
    required this.date,
    required this.bookingId,
  });

  factory BookedDate.fromJson(Map<String, dynamic> json) {
    return BookedDate(
      id: json['_id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      bookingId: json['bookingId'] ?? '',
    );
  }
}

class NotificationEntity {
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final DateTime receivedAt;

  const NotificationEntity({
    required this.title,
    required this.body,
    this.data,
    required this.receivedAt,
  });
}

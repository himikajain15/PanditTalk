class AppNotification {
  final int id;
  final String title;
  final String body;
  bool read; // <-- made mutable so UI can toggle read status

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.read,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'read': read,
    };
  }
}

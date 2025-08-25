class Event {
  final int id;
  final int adminId;
  final String eventTitle;
  final String eventDescription;
  final String eventLocation;
  final DateTime eventStartDate;
  final DateTime eventEndDate;
  final String eventStartTime;
  final String eventEndTime;
  final String eventImages;
  final String eventHost;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.adminId,
    required this.eventTitle,
    required this.eventDescription,
    required this.eventLocation,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.eventImages,
    required this.eventHost,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      adminId: json['adminId'],
      eventTitle: json['eventTitle'],
      eventDescription: json['eventDescription'],
      eventLocation: json['eventLocation'],
      eventStartDate: DateTime.parse(json['eventStartDate']),
      eventEndDate: DateTime.parse(json['eventEndDate']),
      eventStartTime: json['eventStartTime'],
      eventEndTime: json['eventEndTime'],
      eventImages: json['eventImages'],
      eventHost: json['eventHost'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Mom {
  Mom({
    this.id, // Optional id for Firestore document
    required this.dateTime,
    required this.startTime,
    required this.endTime,
    required this.present,
    required this.total,
    required this.createdBy,
    required this.content,
  });

  String? id;
  final DateTime dateTime;
  final DateTime startTime;
  final DateTime endTime;
  final int present;
  final int total;
  final String createdBy;
  final String content;

  // New getter to return the day of the week
  String get day {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[dateTime.weekday - 1];
  }

  // Convert Mom instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'present': present,
      'total': total,
      'createdBy': createdBy,
      'content': content,
    };
  }

  // Create a Mom instance from a Firestore map, with optional id
  factory Mom.fromMap(Map<String, dynamic> map, String id) {
    return Mom(
      id: id,
      dateTime: DateTime.parse(map['dateTime']),
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      present: map['present'],
      total: map['total'],
      createdBy: map['createdBy'],
      content: map['content'],
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String link;
  final String teamLeader;
  final String status;
  final List<ProjectUpdate> updates;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.link,
    required this.teamLeader,
    required this.status,
    this.updates = const [],
  });

  // Factory constructor to create a Project from Firestore document
  factory Project.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Project.fromMap(map, doc.id);
  }

  // Existing fromMap factory method
  factory Project.fromMap(Map<String, dynamic> map, String id) {
    return Project(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      link: map['link'] ?? '',
      teamLeader: map['teamLeader'] ?? '',
      status: map['status'] ?? 'ongoing',
      updates: map['updates'] != null
          ? (map['updates'] as List)
              .map((update) => ProjectUpdate.fromMap(update))
              .toList()
          : [],
    );
  }

  // Convert Project to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'link': link,
      'teamLeader': teamLeader,
      'status': status,
      'updates': updates.map((update) => update.toMap()).toList(),
    };
  }
}

class ProjectUpdate {
  final String title;
  final String description;
  final DateTime date;
  final String addedBy;
  final List<String> images;
  final List<String> comments;

  ProjectUpdate({
    required this.title,
    required this.description,
    required this.date,
    required this.addedBy,
    this.images = const [],
    this.comments = const [],
  });

  // Factory constructor to create a ProjectUpdate from a map
  factory ProjectUpdate.fromMap(Map<String, dynamic> map) {
    return ProjectUpdate(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      // Handle both Timestamp and DateTime
      date: map['date'] is Timestamp 
          ? (map['date'] as Timestamp).toDate() 
          : map['date'] is DateTime 
              ? map['date'] 
              : DateTime.now(),
      addedBy: map['addedBy'] ?? '',
      images: map['images'] != null 
          ? List<String>.from(map['images']) 
          : [],
      comments: map['comments'] != null 
          ? List<String>.from(map['comments']) 
          : [],
    );
  }

  // Convert ProjectUpdate to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'addedBy': addedBy,
      'images': images,
      'comments': comments,
    };
  }
}
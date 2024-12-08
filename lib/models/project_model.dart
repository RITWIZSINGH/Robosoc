import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String link;
  final List<ProjectUpdate> updates;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.link,
    this.updates = const [],
  });

  factory Project.fromMap(Map<String, dynamic> map, String id) {
    return Project(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      link: map['link'] ?? '',
      updates: (map['updates'] as List<dynamic>?)
          ?.map((update) => ProjectUpdate.fromMap(update))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'link': link,
      'updates': updates.map((update) => update.toMap()).toList(),
    };
  }
}

class ProjectUpdate {
  final String title;
  final String description;
  final DateTime date;
  final List<String> images;

  ProjectUpdate({
    required this.title,
    required this.description,
    required this.date,
    required this.images,
  });

  factory ProjectUpdate.fromMap(Map<String, dynamic> map) {
    return ProjectUpdate(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      images: List<String>.from(map['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'images': images,
    };
  }
}
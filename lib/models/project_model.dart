class Project {
  final String id;
  final String title;
  final String description;
  final String link;
  final String imageUrl;

  Project({
    required this.id, 
    required this.title, 
    required this.description, 
    required this.link,
    this.imageUrl = '',
  });

  factory Project.fromMap(Map<String, dynamic> map, String id) {
    return Project(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      link: map['link'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'imageUrl': imageUrl,
    };
  }
}
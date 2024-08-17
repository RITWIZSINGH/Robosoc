import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robosoc/models/project_model.dart';

class ProjectProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  Future<void> fetchProjects() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('projects').get();
      _projects = querySnapshot.docs
          .map((doc) => Project.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching projects: $e');
    }
  }

  Future<void> addProject(Project project) async {
    try {
      await _firestore.collection('projects').add(project.toMap());
      await fetchProjects();
    } catch (e) {
      print('Error adding project: $e');
    }
  }
}
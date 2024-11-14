// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robosoc/models/project_model.dart';

class ProjectProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Project> _projects = [];
  bool _isLoading = false;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;

  Future<void> fetchProjects() async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await _firestore.collection('projects').get();
      _projects = querySnapshot.docs
          .map((doc) => Project.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error fetching projects: $e');
      notifyListeners();
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

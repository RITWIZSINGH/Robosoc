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
      rethrow;
    }
  }

  Future<String> addProject(Project project) async {
    try {
      DocumentReference docRef = await _firestore.collection('projects').add(project.toMap());
      await fetchProjects();
      return docRef.id;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding project: $e');
      }
      rethrow;
    }
  }

  Future<void> addProjectUpdate(String projectId, ProjectUpdate update) async {
    try {
      DocumentReference projectRef = _firestore.collection('projects').doc(projectId);
      
      DocumentSnapshot projectDoc = await projectRef.get();
      List<dynamic> currentUpdates = (projectDoc.data() as Map<String, dynamic>)['updates'] ?? [];
      
      currentUpdates.add(update.toMap());
      
      await projectRef.update({'updates': currentUpdates});
      await fetchProjects();
    } catch (e) {
      print('Error adding project update: $e');
      rethrow;
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toMap());
      await fetchProjects();
    } catch (e) {
      print('Error updating project: $e');
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
      await fetchProjects();
    } catch (e) {
      print('Error deleting project: $e');
      rethrow;
    }
  }
}
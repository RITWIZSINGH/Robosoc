import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/utilities/project_provider.dart';
import 'package:robosoc/screens/new_project_screen.dart';

class ProjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          return ListView.builder(
            itemCount: projectProvider.projects.length,
            itemBuilder: (context, index) {
              final project = projectProvider.projects[index];
              return ListTile(
                title: Text(project.title),
                subtitle: Text(project.description),
                onTap: () {
                  // TODO: Implement project details screen
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewProjectScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
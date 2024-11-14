// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/utilities/project_provider.dart';
import 'package:robosoc/mainscreens/projects_screen/detailed_project_viewscreen.dart';
import 'package:robosoc/mainscreens/projects_screen/add_new_project_screen.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch projects when the page loads
    Future.microtask(() =>
        Provider.of<ProjectProvider>(context, listen: false).fetchProjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          if (projectProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (projectProvider.projects.isEmpty) {
            return const Center(
              child: Text('No projects available'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projectProvider.projects.length,
            itemBuilder: (context, index) {
              final project = projectProvider.projects[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(
                    project.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    project.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedProjectViewscreen(
                          project: project,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
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
    Future.microtask(() =>
        Provider.of<ProjectProvider>(context, listen: false).fetchProjects());
  }

  Widget _buildImageWidget(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      httpHeaders: {
        'Access-Control-Allow-Origin': '*',
      },
      placeholderFadeInDuration: const Duration(milliseconds: 250),
      placeholder: (context, url) => Container(
        color: Colors.grey[800],
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white54,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[800],
        child: const Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.white54,
            size: 30,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 2.0,
        title: const Text(
          'PROJECTS',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 20,
        shadowColor: Colors.black45,
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

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: projectProvider.projects.length,
            itemBuilder: (context, index) {
              final project = projectProvider.projects[index];
              return GestureDetector(
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
                child: Card(
                  color: Colors.black,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: _buildImageWidget(project.imageUrl),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            project.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

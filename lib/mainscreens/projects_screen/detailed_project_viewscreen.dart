// ignore_for_file: use_build_context_synchronously, use_super_parameters

import 'package:flutter/material.dart';
import 'package:robosoc/models/project_model.dart';
import 'package:robosoc/mainscreens/project_updates/add_update_screen.dart';
import 'package:robosoc/mainscreens/project_updates/view_update_screen.dart';
import 'package:robosoc/widgets/project_update_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:robosoc/utilities/project_provider.dart';
import 'package:provider/provider.dart';

class DetailedProjectScreen extends StatelessWidget {
  final Project project;

  const DetailedProjectScreen({
    Key? key,
    required this.project,
  }) : super(key: key);

  // Color scheme based on project status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'ongoing':
        return Colors.amber;
      case 'completed':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'not started':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status) {
      case 'ongoing':
        return Colors.amber.withValues(alpha: 0.2);
      case 'completed':
        return Colors.green.withValues(alpha: 0.2);
      case 'paused':
        return Colors.orange.withValues(alpha: 0.2);
      case 'not started':
        return Colors.grey.withValues(alpha: 0.2);
      default:
        return Colors.blue.withValues(alpha: 0.2);
    }
  }

  Future<void> _launchProjectLink() async {
    final Uri url = Uri.parse(project.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _updateProjectStatus(BuildContext context) async {
    try {
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Update Project Status',
              style: TextStyle(
                  fontFamily: "NexaBold",
                  color: _getStatusColor(project.status)),
            ),
            content: Text(
              'Are you sure you want to mark this project as ${project.status == 'ongoing' ? 'completed' : 'ongoing'}?',
              style: TextStyle(
                  fontFamily: "NexaRegular",
                  color: _getStatusColor(project.status)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "NexaRegular",
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: _getStatusColor(project.status),
                    fontFamily: "NexaBold",
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        final newStatus = project.status == 'ongoing' ? 'completed' : 'ongoing';
        await Provider.of<ProjectProvider>(context, listen: false)
            .updateProjectStatus(project.id, newStatus);

        // Show success message with status-specific color
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Project status updated successfully!',
              style: TextStyle(fontFamily: "NexaRegular"),
            ),
            backgroundColor: _getStatusColor(newStatus),
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update project status: $e',
            style: TextStyle(fontFamily: "NexaRegular"),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(project.status);
    final statusBackgroundColor = _getStatusBackgroundColor(project.status);

    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              project.title.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontFamily: "NexaBold",
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        actions: [
          // Status update button with dynamic color
          IconButton(
            icon: Icon(
              project.status == 'ongoing'
                  ? Icons.check_circle_outline
                  : Icons.refresh,
              color: statusColor,
            ),
            onPressed: () => _updateProjectStatus(context),
            tooltip: project.status == 'ongoing'
                ? 'Mark as Completed'
                : 'Mark as Ongoing',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUpdateScreen(project: project),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with dynamic border color
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: statusColor, width: 4),
                  borderRadius: BorderRadius.circular(19)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: AspectRatio(
                  aspectRatio: 1 / 1.25,
                  child: Image.network(
                    project.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: "NexaBold",
                        color: statusColor),
                  ),
                  const SizedBox(height: 8),
                  // Status chip with dynamic colors
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      project.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontFamily: "NexaBold",
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    project.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontFamily: "NexaRegular"),
                  ),
                  const SizedBox(height: 16),
                  if (project.link.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: _launchProjectLink,
                      icon: Icon(
                        Icons.link,
                        color: statusColor,
                      ),
                      label: Text(
                        'View Project',
                        style: TextStyle(
                            color: statusColor, fontFamily: "NexaBold"),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'UPDATES',
                    style: TextStyle(
                      fontFamily: "NexaBold",
                      fontSize: 26,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  project.updates.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.update_disabled_outlined,
                                size: 80,
                                color: statusColor.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Updates Yet',
                                style: TextStyle(
                                  fontFamily: "NexaBold",
                                  fontSize: 22,
                                  color: statusColor.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'When project progress is made, updates will appear here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "NexaRegular",
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddUpdateScreen(project: project),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: statusColor,
                                ),
                                label: Text(
                                  'Add First Update',
                                  style: TextStyle(
                                    fontFamily: "NexaBold",
                                    color: statusColor,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: statusBackgroundColor,
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: project.updates.length,
                          itemBuilder: (context, index) {
                            final update = project.updates[index];
                            return ProjectUpdateCard(
                              update: update,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewUpdateScreen(
                                      update: update,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

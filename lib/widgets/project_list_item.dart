// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:robosoc/models/project_model.dart';

class ProjectListItem extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectListItem({
    Key? key,
    required this.project,
    required this.onTap,
  }) : super(key: key);

  // Extract color logic to a separate method for better readability
  Color _getBorderColor() {
    return project.status == 'completed' ? Color(0xff2ed12e) : Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
          color: _getBorderColor(),
          width: 1.5, // Optional: make the border slightly more prominent
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _buildProjectImage(),
        ),
        title: Text(
          project.title.toUpperCase(),
          style: const TextStyle(
              fontFamily: "NexaBold",
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Leader: ${project.teamLeader}',
              style: TextStyle(
                fontFamily: "NexaRegular",
                color: Colors.grey[600],
              ),
            ),
            // Add status indicator
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getBorderColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                project.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "NexaBold",
                  color: _getBorderColor(),
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: _getBorderColor(),
        ),
      ),
    );
  }

  Widget _buildProjectImage() {
    return project.imageUrl.isNotEmpty
        ? Image.network(
            project.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: _getBorderColor(), // Match the border color
                  ),
                ),
              );
            },
          )
        : Container(
            width: 50,
            height: 50,
            color: Colors.grey[300],
            child: const Icon(
              Icons.image,
              color: Colors.grey,
            ),
          );
  }
}

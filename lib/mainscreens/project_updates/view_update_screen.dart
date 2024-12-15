// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:robosoc/models/project_model.dart';
import 'package:robosoc/widgets/view_update_widgets/update_header.dart';
import 'package:robosoc/widgets/view_update_widgets/update_description.dart';
import 'package:robosoc/widgets/view_update_widgets/comments_section.dart';

class ViewUpdateScreen extends StatelessWidget {
  final ProjectUpdate update;

  const ViewUpdateScreen({
    Key? key,
    required this.update,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          update.title,
          style: const TextStyle(
            color: Colors.amber,
            fontFamily: "NexaBold",
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpdateHeader(
                  addedBy: update.addedBy,
                  date: update.date,
                ),
                const SizedBox(height: 24),
                UpdateDescription(
                  description: update.description,
                ),
                if (update.images.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: update.images.length,
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(right: 16),
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(update.images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                CommentsSection(comments: update.comments),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

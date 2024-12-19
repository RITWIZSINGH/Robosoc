import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:robosoc/models/component.dart';

//this is also for profile page
class IssuedCommponentCard extends StatelessWidget {
  const IssuedCommponentCard({super.key, required this.component});
  final Component component;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  height: 40,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100)),
                  child: CachedNetworkImage(imageUrl: component.imageUrl)),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    component.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "Quantity Issued: ${component.quantity}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 98, 98, 98),
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings_backup_restore_outlined,
                color: Colors.red,
                size: 40,
              ))
        ],
      ),
    );
  }
}

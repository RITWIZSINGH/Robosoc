import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/component.dart';

class IssuedComponentHistoryCard extends StatelessWidget {
  final Component component;
  final DateTime? issueDate;
  final DateTime? returnDate;
  final String approvedBy;
  final String imageUrl;
  final int quantity;

  const IssuedComponentHistoryCard({
    Key? key,
    required this.component,
    required this.issueDate,
    this.returnDate,
    required this.approvedBy,
    required this.imageUrl,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Component Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            
            // Component Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    component.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantity: $quantity',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Issued: ${DateFormat('MMM dd, yyyy')}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    returnDate != null
                        ? 'Returned: ${DateFormat('MMM dd, yyyy')}'
                        : 'Status: Still Issued',
                    style: TextStyle(
                      fontSize: 14,
                      color: returnDate != null ? Colors.green : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Approved by: $approvedBy',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
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
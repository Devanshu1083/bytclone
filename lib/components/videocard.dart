import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VideoCard extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final String description;
  final String duration;
  final String url;
  final String dateUploaded;
  final VoidCallback onTap;

  const VideoCard({super.key,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.duration,
    required this.url,
    required this.dateUploaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    List<String> parts = duration.split(':');

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: const Color(0xFF000B49),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                height: 150,
              ),
            ),
            Divider(
              thickness: 2, // Adjust the thickness of the divider
              color: Colors.white, // Color of the divider
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14,color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${parts[0]} hrs ${parts[1]} min ${parts[2]} sec',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        Text(
                          '${DateFormat('yyyy-MM-dd').format(DateTime.parse(dateUploaded))}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

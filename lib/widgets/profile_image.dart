import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:robosoc/widgets/animated_upload_overlay.dart';

class ProfileImage extends StatelessWidget {
  final String profileImageUrl;
  final Uint8List? selectedImage;
  final bool isUploading;
  final VoidCallback onSelectImage;
  final bool isUploadingDisabled;

  const ProfileImage({
    super.key,
    required this.profileImageUrl,
    required this.selectedImage,
    required this.isUploading,
    required this.onSelectImage,
    required this.isUploadingDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Profile Image
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 70,
            backgroundImage: profileImageUrl.isNotEmpty
                ? NetworkImage(profileImageUrl)
                : (selectedImage != null
                    ? MemoryImage(selectedImage!)
                    : const AssetImage("assets/images/defaultPerson.png"))
                as ImageProvider,
            child: isUploading ? const AnimatedUploadOverlay() : null,
          ),
        ),
        
        // Camera Button
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: isUploadingDisabled
                  ? Colors.grey
                  : Colors.yellow[700],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: isUploadingDisabled ? null : onSelectImage,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
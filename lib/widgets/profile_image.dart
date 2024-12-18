import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:robosoc/widgets/animated_upload_overlay.dart';

class ProfileImage extends StatelessWidget {
  final String profileImageUrl;
  final Uint8List? selectedImage;
  final bool isUploading;
  final VoidCallback onSelectImage;
  final bool isUploadingDisabled;

  const ProfileImage({
    Key? key,
    required this.profileImageUrl,
    required this.selectedImage,
    required this.isUploading,
    required this.onSelectImage,
    required this.isUploadingDisabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: selectedImage != null
                ? Image.memory(
                    selectedImage!,
                    fit: BoxFit.cover,
                    width: 140,
                    height: 140,
                  )
                : Center(
                    child: CachedNetworkImage(
                      imageUrl: profileImageUrl.isNotEmpty
                          ? profileImageUrl
                          : 'assets/images/defaultPerson.png',
                      fit: BoxFit.cover,
                      width: 140,
                      height: 140,
                      placeholder: (context, url) =>
                          const AnimatedUploadOverlay(),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/defaultPerson.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
        ),
        if (isUploading) const AnimatedUploadOverlay(),

        // Camera Button
        if (!isUploadingDisabled)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow[700],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: onSelectImage,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
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

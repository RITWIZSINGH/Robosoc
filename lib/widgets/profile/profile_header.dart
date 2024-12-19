import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/utilities/user_profile_provider.dart';
import 'package:robosoc/widgets/profile/profile_image.dart';
import 'package:robosoc/utilities/image_picker.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  dynamic _selectedImage;
  bool _isUploading = false;

  Future<void> _updateProfileImage() async {
    if (_selectedImage == null) return;
    
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    
    setState(() => _isUploading = true);
    try {
      final imageUrl = await ImagePickerUtils.uploadImage(
        _selectedImage,
        'profile_images',
      );
      
      if (imageUrl != null) {
        await provider.updateProfile(imageUrl: imageUrl);
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProvider, child) {
        return Column(
          children: [
            ProfileImage(
              profileImageUrl: userProvider.profileImageUrl,
              selectedImage: _selectedImage,
              isUploading: _isUploading,
              onSelectImage: () async {
                // Assuming the second parameter is for handling the selected image
                final image = await ImagePickerUtils.showImageSourceDialog(
                  context,
                  (selectedImage) async {
                    if (selectedImage != null) {
                      setState(() => _selectedImage = selectedImage);
                      await _updateProfileImage();
                    }
                  },
                );
              },
              isUploadingDisabled: false,
            ),
            const SizedBox(height: 24),
            Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamily: 'NexaBold',
                color: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }
}
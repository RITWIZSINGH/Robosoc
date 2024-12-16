import 'package:flutter/material.dart';
import 'package:robosoc/widgets/user_image.dart';

class AnimatedProfileImage extends StatefulWidget {
  final String profileImageUrl;
  final VoidCallback onTap;
  final bool isLoading;

  const AnimatedProfileImage({
    super.key,
    required this.profileImageUrl,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  State<AnimatedProfileImage> createState() => _AnimatedProfileImageState();
}

class _AnimatedProfileImageState extends State<AnimatedProfileImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.1),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isLoading ? _scaleAnimation.value : 1.0,
            child: Transform.rotate(
              angle: widget.isLoading ? _rotationAnimation.value : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: widget.profileImageUrl.isNotEmpty
                    ? CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(widget.profileImageUrl),
                      )
                    : const UserImage(
                        imagePath: "assets/images/defaultPerson.png",
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../cards/presentation/screens/add_card_form_screen.dart';
import '../../../cards/presentation/screens/all_cards_screen.dart';

class SecondTabScreen extends StatefulWidget {
  const SecondTabScreen({super.key});

  @override
  State<SecondTabScreen> createState() => _SecondTabScreenState();
}

class _SecondTabScreenState extends State<SecondTabScreen> {
  Future<void> _openCameraAndNavigate() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery, // Gallery instead of camera
        imageQuality: 85,
      );

      if (image != null) {
        // Navigate to add card form screen with the selected image
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CardFormScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('فشل في اختيار الصورة: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: null,
      ),
      body: AllCardsScreen(), // Same as first page
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 16),
        child: FloatingActionButton(
          onPressed: _openCameraAndNavigate,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4CAF50), // Green
                  const Color(0xFF2196F3), // Blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.camera_alt, // Camera icon instead of QR scanner
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

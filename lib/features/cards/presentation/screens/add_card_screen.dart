import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/image_storage.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../data/model/business_card_model.dart';
import '../bloc/cards_bloc.dart';
import '../bloc/cards_event.dart';
import 'add_card_form_screen.dart';

/// Screen for adding or editing a business card
class AddCardScreen extends StatefulWidget {
  final String userId;
  final BusinessCardModel? card;
  final String? initialImagePath;

  const AddCardScreen({
    super.key,
    required this.userId,
    this.card,
    this.initialImagePath,
  });

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _isScanning = false;
  final _fullNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();

  String? _imagePath;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize form with existing card data if editing
    if (widget.card != null) {
      _fullNameController.text = widget.card!.fullName;
      _companyNameController.text = widget.card!.companyName;
      _jobTitleController.text = widget.card!.jobTitle;
      _emailController.text = widget.card!.email;
      _phoneController.text = widget.card!.phone;
      _websiteController.text = widget.card!.website ?? '';
      _addressController.text = widget.card!.address ?? '';
      _imagePath = widget.card!.imagePath;
    } else if (widget.initialImagePath != null) {
      // If we have an initial image from camera
      _imagePath = widget.initialImagePath;
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _companyNameController.dispose();
    _jobTitleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isScanning) return;

    try {
      setState(() => _isScanning = true);
      
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        // Save image to permanent storage
        final String permanentPath = await ImageStorage.saveImage(image.path);
        
        setState(() {
          _imagePath = permanentPath;
        });
        
        if (mounted) {
          context.showSuccessSnackBar('تم التقاط الصورة بنجاح!');
          // Navigate to form screen after capturing image
          _navigateToFormScreen();
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Failed to capture image: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  void _navigateToFormScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCardFormScreen(
          userId: widget.userId,
          imagePath: _imagePath,
          existingCard: widget.card,
        ),
      ),
    );
  }

  void _removeImage() {
    if (_imagePath != null && _imagePath!.isNotEmpty) {
      ImageStorage.deleteImage(_imagePath!);
    }
    setState(() {
      _imagePath = null;
    });
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final card = BusinessCardModel(
        id: widget.card?.id ?? const Uuid().v4(),
        userId: widget.userId,
        fullName: _fullNameController.text.trim(),
        companyName: _companyNameController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        website: _websiteController.text.trim().isEmpty
            ? null
            : _websiteController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        imagePath: _imagePath,
        createdAt: widget.card?.createdAt ?? DateTime.now(),
      );

      if (widget.card == null) {
        context.read<CardsBloc>().add(AddCard(card));
      } else {
        context.read<CardsBloc>().add(UpdateCard(card));
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Failed to save card: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.card != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Card' : 'Add New Card'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Camera/Image Section
                _buildImageSection(),
                const SizedBox(height: 24),

                // Form Fields
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _companyNameController,
                  label: 'Company Name',
                  icon: Icons.business,
                  validator: Validators.validateRequired,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _jobTitleController,
                  label: 'Job Title',
                  icon: Icons.work,
                  validator: Validators.validateRequired,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _websiteController,
                  label: 'Website (Optional)',
                  icon: Icons.language,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _addressController,
                  label: 'Address (Optional)',
                  icon: Icons.location_on,
                  maxLines: 2,
                ),
                const SizedBox(height: 32),

                // Action Buttons
                if (_imagePath != null && _imagePath!.isNotEmpty) ...[
                  // Navigate to Form Button
                  ElevatedButton(
                    onPressed: _navigateToFormScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'انتقل لحقول النص',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Save Button
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          isEditing ? 'تحديث البطاقة' : 'حفظ البطاقة',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _imagePath != null && _imagePath!.isNotEmpty
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(_imagePath!),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _isScanning ? null : _pickImage,
                        icon: _isScanning
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Icon(Icons.camera_alt),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _removeImage,
                        icon: const Icon(Icons.delete),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: _isScanning ? null : _pickImage,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isScanning)
                      const CircularProgressIndicator(
                        color: AppColors.primary,
                      )
                    else
                      Icon(
                        Icons.camera_alt,
                        size: 64,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      _isScanning
                          ? 'Scanning...'
                          : 'Tap to scan business card',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      enabled: !_isSaving,
    );
  }
}

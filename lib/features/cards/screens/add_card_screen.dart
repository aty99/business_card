import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../models/business_card_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/validators.dart';
import '../../../utils/image_storage.dart';
import '../../../utils/custom_snackbar.dart';
import '../bloc/card_bloc.dart';
import '../bloc/card_event.dart';

/// Screen for adding a new business card with camera scanning
class AddCardScreen extends StatefulWidget {
  final String userId;
  final BusinessCardModel? card; // For editing existing card

  const AddCardScreen({
    Key? key,
    required this.userId,
    this.card,
  }) : super(key: key);

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
  bool _isScanned = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    
    if (widget.card != null) {
      _fullNameController.text = widget.card!.fullName;
      _companyNameController.text = widget.card!.companyName;
      _jobTitleController.text = widget.card!.jobTitle;
      _emailController.text = widget.card!.email;
      _phoneController.text = widget.card!.phone;
      _websiteController.text = widget.card!.website ?? '';
      _addressController.text = widget.card!.address ?? '';
      _imagePath = widget.card!.imagePath;
      _isScanned = true;
    }
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

  Future<void> _scanCard() async {
    if (_isScanning) return;
    
    setState(() {
      _isScanning = true;
    });
    
    final ImagePicker picker = ImagePicker();
    
    // Show dialog to choose camera or gallery
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Business Card'),
        content: const Text('Choose how to capture the card:'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Camera'),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            icon: const Icon(Icons.photo_library),
            label: const Text('Gallery'),
          ),
        ],
      ),
    );

    if (source == null) return;

    try {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        // Save image to permanent storage
        final String permanentPath = await ImageStorage.saveImage(image.path);
        
        setState(() {
          _imagePath = permanentPath;
          _isScanned = true;
        });

        // Mock OCR - Generate dummy data
        _fillMockData();

        if (mounted) {
        context.showSuccessSnackBar('Card scanned! Please verify the details.');
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  void _fillMockData() {
    // Mock OCR data extraction
    if (_fullNameController.text.isEmpty) {
      _fullNameController.text = 'John Smith';
    }
    if (_companyNameController.text.isEmpty) {
      _companyNameController.text = 'Tech Solutions Inc.';
    }
    if (_jobTitleController.text.isEmpty) {
      _jobTitleController.text = 'Senior Developer';
    }
    if (_emailController.text.isEmpty) {
      _emailController.text = 'john.smith@techsolutions.com';
    }
    if (_phoneController.text.isEmpty) {
      _phoneController.text = '+1 (555) 123-4567';
    }
    if (_websiteController.text.isEmpty) {
      _websiteController.text = 'www.techsolutions.com';
    }
    if (_addressController.text.isEmpty) {
      _addressController.text = '123 Tech Street, San Francisco, CA 94105';
    }
  }

  void _saveCard() async {
    if (!_isScanned) {
      context.showWarningSnackBar('Please scan a card first');
      return;
    }
    
    if (_isSaving) return; // Prevent multiple saves
    
    setState(() {
      _isSaving = true;
    });

    if (_formKey.currentState!.validate()) {
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

      try {
        context.read<CardBloc>().add(AddCard(card));
        Navigator.pop(context, true);
      } catch (e) {
        if (mounted) {
          context.showErrorSnackBar('Error saving card: $e');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    } else {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.card != null ? 'Edit Card' : 'Add Card'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Scan card button/preview
            if (!_isScanned)
              InkWell(
                onTap: _isScanning ? null : _scanCard,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isScanning
                          ? SizedBox(
                              width: 64,
                              height: 64,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 64,
                              color: AppColors.primary,
                            ),
                      const SizedBox(height: 16),
                      Text(
                        _isScanning ? 'Scanning...' : 'Tap to Scan Business Card',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isScanning ? 'Please wait while we process your card' : 'Use camera or select from gallery',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: _imagePath != null
                      ? DecorationImage(
                          image: FileImage(File(_imagePath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: AppColors.grey,
                ),
                child: Stack(
                  children: [
                    if (_imagePath == null)
                      const Center(
                        child: Icon(
                          Icons.credit_card,
                          size: 64,
                          color: AppColors.white,
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child:                       IconButton(
                        icon: _isScanning
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                ),
                              )
                            : const Icon(Icons.camera_alt),
                        color: AppColors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: _isScanning ? null : _scanCard,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    icon: Icons.person,
                    validator: Validators.validateFullName,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _companyNameController,
                    label: 'Company Name',
                    icon: Icons.business,
                    validator: (v) =>
                        Validators.validateRequired(v, 'Company name'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _jobTitleController,
                    label: 'Job Title',
                    icon: Icons.work,
                    validator: (v) =>
                        Validators.validateRequired(v, 'Job title'),
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
                    validator: Validators.validateUrl,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Address (Optional)',
                    icon: Icons.location_on,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isSaving
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                widget.card != null ? 'Updating...' : 'Saving...',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            widget.card != null ? 'Update Card' : 'Save Card',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
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
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.white,
      ),
    );
  }
}


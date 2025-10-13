import 'dart:io';
import 'package:bcode/shared_widgets/default_button.dart';
import 'package:bcode/shared_widgets/text_fields/default.dart';
import 'package:bcode/shared_widgets/text_fields/email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../models/business_card_model.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/image_storage.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../bloc/card_bloc.dart';
import '../bloc/card_event.dart';

/// Screen for adding a new business card with camera scanning
class AddCardScreen extends StatefulWidget {
  final String userId;
  final BusinessCardModel? card; // For editing existing card

  const AddCardScreen({Key? key, required this.userId, this.card})
    : super(key: key);

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          context.showSuccessSnackBar(
            'Card scanned! Please verify the details.',
          );
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                size: 64,
                                color: AppColors.primary,
                              ),
                        const SizedBox(height: 16),
                        Text(
                          _isScanning
                              ? 'Scanning...'
                              : 'Tap to Scan Business Card',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isScanning
                              ? 'Please wait while we process your card'
                              : 'Use camera or select from gallery',
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
                        Center(
                          child: Container(
                            width: 100,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.business,
                                  size: 24,
                                  color: AppColors.white.withOpacity(0.8),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 40,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  width: 60,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: _isScanning
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.white,
                                    ),
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
                    DefaultTextField(
                      _fullNameController,
                      hint: 'full_name',
                      icon: Icons.person,
                      validator: Validators().validateFullName,
                    ),
                    const SizedBox(height: 16),
                    DefaultTextField(
                      _companyNameController,
                      hint: 'company_name',
                      icon: Icons.business,
                      validator: Validators().validateRequired,
                    ),
                    const SizedBox(height: 16),
                    DefaultTextField(
                      _jobTitleController,
                      hint: 'job_title',
                      icon: Icons.work,
                      validator: Validators().validateRequired,
                    ),
                    const SizedBox(height: 16),
                    EmailTextField(_emailController),
                    const SizedBox(height: 16),
                    DefaultTextField(
                      _phoneController,
                      hint: 'phone',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: Validators().validatePhone,
                    ),
                    const SizedBox(height: 16),
                    DefaultTextField(
                      _websiteController,
                      hint: 'website_(Optional)',
                      icon: Icons.language,
                      keyboardType: TextInputType.url,
                      validator: Validators().validateUrl,
                    ),
                    const SizedBox(height: 16),
                    DefaultTextField(
                      _addressController,
                      hint: 'address_(Optional)',
                      icon: Icons.location_on,
                      maxLength: 2,
                    ),
                    const SizedBox(height: 24),
                    DefaultButton(
                      onPressed: _saveCard,
                      label: widget.card != null ? 'update_card' : 'save_card',
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
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../shared_widgets/default_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../data/model/business_card_model.dart';
import '../bloc/cards_bloc.dart';
import '../bloc/cards_event.dart';
import 'add_card_screen.dart';

class AddCardFormScreen extends StatefulWidget {
  final String userId;
  final String? imagePath;
  final BusinessCardModel? existingCard;

  const AddCardFormScreen({
    super.key,
    required this.userId,
    this.imagePath,
    this.existingCard,
  });

  @override
  State<AddCardFormScreen> createState() => _AddCardFormScreenState();
}

class _AddCardFormScreenState extends State<AddCardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();

  Color _backgroundColor = const Color(0xFF4CAF50);
  Color _textColor = const Color(0xFFE91E63);

  @override
  void initState() {
    super.initState();
    
    // Initialize form with existing card data if editing
    if (widget.existingCard != null) {
      _firstNameController.text = widget.existingCard!.fullName.split(' ').first;
      _lastNameController.text = widget.existingCard!.fullName.split(' ').skip(1).join(' ');
      _jobTitleController.text = widget.existingCard!.jobTitle;
      _companyNameController.text = widget.existingCard!.companyName;
      _phoneController.text = widget.existingCard!.phone;
      _emailController.text = widget.existingCard!.email;
      _websiteController.text = widget.existingCard!.website ?? '';
      _addressController.text = widget.existingCard!.address ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _jobTitleController.dispose();
    _companyNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _retakePhoto() async {
    // Navigate back to camera/scan screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddCardScreen(
          userId: widget.userId,
        ),
      ),
    );
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
      
      final card = BusinessCardModel(
        id: widget.existingCard?.id ?? const Uuid().v4(),
        userId: widget.userId,
        fullName: fullName,
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
        imagePath: widget.imagePath,
        createdAt: widget.existingCard?.createdAt ?? DateTime.now(),
      );

      if (widget.existingCard == null) {
        context.read<CardsBloc>().add(AddCard(card));
      } else {
        context.read<CardsBloc>().add(UpdateCard(card));
      }

      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('${'failed_to_save_card'.tr()}: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingCard != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? 'edit_card_title'.tr() : 'confirm_add_new_card'.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48), // Space for balance
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form Fields
              DefaultTextField(
                controller: _firstNameController,
                label: 'first_name'.tr(),
                hint: 'enter_first_name'.tr(),
                validator: Validators.validateRequired,
                enabled: !_isSaving,
              ),

              DefaultTextField(
                controller: _lastNameController,
                label: 'second_name'.tr(),
                hint: 'enter_second_name'.tr(),
                validator: Validators.validateRequired,
                enabled: !_isSaving,
              ),

              DefaultTextField(
                controller: _jobTitleController,
                label: 'position'.tr(),
                hint: 'enter_position'.tr(),
                validator: Validators.validateRequired,
                enabled: !_isSaving,
              ),

              DefaultTextField(
                controller: _companyNameController,
                label: 'company_name'.tr(),
                hint: 'enter_company_name'.tr(),
                validator: Validators.validateRequired,
                enabled: !_isSaving,
              ),

              DefaultTextField(
                controller: _phoneController,
                label: 'phone_number'.tr(),
                hint: 'enter_phone_number'.tr(),
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
                enabled: !_isSaving,
              ),

              DefaultTextField(
                controller: _emailController,
                label: 'email_address'.tr(),
                hint: 'enter_email_address'.tr(),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                enabled: !_isSaving,
              ),

              DefaultTextField(
                controller: _websiteController,
                label: 'website'.tr(),
                hint: 'enter_website'.tr(),
                keyboardType: TextInputType.url,
                enabled: !_isSaving,
              ),

              DefaultTextField(
                controller: _addressController,
                label: 'location'.tr(),
                hint: 'enter_location'.tr(),
                maxLines: 2,
                enabled: !_isSaving,
              ),
              const SizedBox(height: 24),

              // Color Selection Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textSecondary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'customize_colors'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildColorSelector(
                            title: 'select_background_color'.tr(),
                            selectedColor: _backgroundColor,
                            onColorSelected: (color) {
                              setState(() {
                                _backgroundColor = color;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildColorSelector(
                            title: 'select_text_color'.tr(),
                            selectedColor: _textColor,
                            onColorSelected: (color) {
                              setState(() {
                                _textColor = color;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveCard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
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
                              'add_new_card'.tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _retakePhoto,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2196F3),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF2196F3), width: 1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.qr_code_scanner,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'capture_again'.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // تم استبدال دالة الإدخال الافتراضية بدالة DefaultTextField الموحدة

  Widget _buildColorSelector({
    required String title,
    required Color selectedColor,
    required Function(Color) onColorSelected,
  }) {
    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFE91E63),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
      const Color(0xFF607D8B),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            color: selectedColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                  border: selectedColor == color
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

import 'package:bcode/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bcode/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../shared_widgets/default_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../data/model/business_card_model.dart';
import '../bloc/cards_bloc.dart';
import '../bloc/cards_event.dart';

class CardFormScreen extends StatefulWidget {
  final BusinessCardModel? existingCard;

  const CardFormScreen({super.key, this.existingCard});

  @override
  State<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends State<CardFormScreen> {
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

  Color backgroundPickerColor = AppColors.primary;
  Color currentBackgroundColor = AppColors.primary;

  Color textPickerColor = Colors.white;
  Color currentTextColor = Colors.white;

  @override
  void initState() {
    super.initState();

    // Initialize form with existing card data if editing
    if (widget.existingCard != null) {
      _firstNameController.text = widget.existingCard!.fullName
          .split(' ')
          .first;
      _lastNameController.text = widget.existingCard!.fullName
          .split(' ')
          .skip(1)
          .join(' ');
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

  Future<void> _saveCard() async {
    final authState = context.read<AuthBloc>().state;
    String userId = authState is Authenticated
        ? authState.user.id
        : 'guest_user';
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final fullName =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
              .trim();

      final card = BusinessCardModel(
        id: widget.existingCard?.id ?? const Uuid().v4(),
        userId: userId,
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
        //   textColor: widget.imagePath,
        createdAt: widget.existingCard?.createdAt ?? DateTime.now(),
        textColor: currentTextColor,
        cardColor: currentBackgroundColor,
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
                child: Row(
                  children: [
                    Expanded(
                      child: _buildColorSelector(
                        title: 'select_background_color'.tr(),
                        selectedColor: currentBackgroundColor,
                        onColorSelected: () {
                          showColorPicker(true);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildColorSelector(
                        title: 'select_text_color'.tr(),
                        selectedColor: currentTextColor,
                        onColorSelected: () {
                          showColorPicker(false);
                        },
                      ),
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
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorSelector({
    required String title,
    required Color selectedColor,
    required Function() onColorSelected,
  }) {
    return InkWell(
      onTap: () => onColorSelected(),
      child: SizedBox(
        height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void changeColor(Color currentColor, bool isBackground) {
    if (isBackground) {
      setState(() => backgroundPickerColor = currentColor);
    } else {
      setState(() => textPickerColor = currentColor);
    }
  }

  showColorPicker(bool isBackground) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: isBackground ? backgroundPickerColor : textPickerColor,
          onColorChanged: (newColor) => changeColor(newColor, isBackground),
        ),
        // Use Material color picker:
        //
        // child: MaterialPicker(
        //   pickerColor: pickerColor,
        //   onColorChanged: changeColor,
        //   showLabel: true, // only on portrait mode
        // ),
        //
        // Use Block color picker:
        //
        // child: BlockPicker(
        //   pickerColor: currentColor,
        //   onColorChanged: changeColor,
        // ),
        //
        // child: MultipleChoiceBlockPicker(
        //   pickerColors: currentColors,
        //   onColorsChanged: changeColors,
        // ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Got it'),
          onPressed: () {
            if (isBackground) {
              setState(() => currentBackgroundColor = backgroundPickerColor);
            } else {
              setState(() => currentTextColor = textPickerColor);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

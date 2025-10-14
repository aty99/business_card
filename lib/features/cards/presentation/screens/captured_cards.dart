import 'dart:developer';
import 'package:bcode/core/utils/file_picker.dart';
import 'package:bcode/features/cards/data/model/business_card_model.dart';
import 'package:bcode/features/cards/presentation/screens/widgets/floating_btn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import 'add_card_form_screen.dart';
import 'all_cards_screen.dart';

class CapturedCards extends StatefulWidget {
  const CapturedCards({super.key});

  @override
  State<CapturedCards> createState() => _CapturedCardsState();
}

class _CapturedCardsState extends State<CapturedCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AllCardsScreen(1), // Same as first page
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 16),
        child: CustomFloatingButton(_pickImage, Icons.camera_alt),
      ),
    );
  }

  void _pickImage() async {
    final imagePicker = await showImageTypeBottomSheet(context);
    if (imagePicker == null) return;

    try {
      await imagePicker.pick();
      final dummyCard = BusinessCardModel(
        firstName: 'Mohamed',
        secName: 'Ahmed',
        jobTitle: 'Software Engineer',
        companyName: 'BCompany',
        email: 'test@BCompany.com',
        phone: '+1234567890',
        address: 'Egypt',
        website: 'https://google.com',
        tabId: 1
      );
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CardFormScreen(existingCard: dummyCard),
          ),
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<FilePickerHelper?> showImageTypeBottomSheet(BuildContext context) {
    return showCupertinoModalPopup<FilePickerHelper>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('gallery'.tr()),
            onPressed: () =>
                Navigator.of(context).pop(FilePickerHelper.gallery()),
          ),
          CupertinoActionSheetAction(
            child: Text('camera'.tr()),
            onPressed: () =>
                Navigator.of(context).pop(FilePickerHelper.camera()),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: Navigator.of(context).pop,
          child: Text('cancel'.tr()),
        ),
      ),
    );
  }
}

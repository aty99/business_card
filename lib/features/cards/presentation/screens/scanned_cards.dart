import 'package:bcode/core/utils/animated_page_route.dart';
import 'package:bcode/features/cards/data/model/business_card_model.dart';
import 'package:bcode/features/cards/presentation/screens/add_card_form_screen.dart';
import 'package:bcode/features/cards/presentation/screens/all_cards_screen.dart';
import 'package:bcode/features/cards/presentation/screens/widgets/floating_btn.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';

class ScannedCards extends StatefulWidget {
  const ScannedCards({super.key});

  @override
  State<ScannedCards> createState() => _ScannedCardsState();
}

class _ScannedCardsState extends State<ScannedCards> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AllCardsScreen(0), // Same as first page
        Positioned(
          right: 16,
          bottom: 16,
          child: CustomFloatingButton(() async {
            Navigator.push(
              context,
              SlidePageRoute(page: const MobileScannerSimple()),
            );
          }, Icons.qr_code_scanner),
        ),
      ],
    );
  }
}

class MobileScannerSimple extends StatelessWidget {
  const MobileScannerSimple({super.key});

  void _handleBarcode(BarcodeCapture barcodes, BuildContext context) {
    final result = barcodes.barcodes.firstOrNull;
    Navigator.of(context).pop();
    if (result != null) {
      final dummyCard = BusinessCardModel(
        id: const Uuid().v4(),
        firstName: 'Mohamed',
        secName: 'Ahmed',
        jobTitle: 'Software Engineer',
        companyName: 'BCompany',
        email: 'test@BCompany.com',
        phone: '+1234567890',
        address: 'Egypt',
        website: 'https://google.com',
        tabId: 0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardFormScreen(existingCard: dummyCard),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (barcode) => _handleBarcode(barcode, context),
          ),
        ],
      ),
    );
  }
}

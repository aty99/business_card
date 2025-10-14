import 'dart:async';
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

class MobileScannerSimple extends StatefulWidget {
  const MobileScannerSimple({super.key});

  @override
  State<MobileScannerSimple> createState() => _MobileScannerSimpleState();
}

class _MobileScannerSimpleState extends State<MobileScannerSimple> {
  bool _isProcessing = false;
  Timer? _debounceTimer;
  String? _lastScannedCode;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    final result = barcodes.barcodes.firstOrNull;
    if (result == null) return;

    final currentCode = result.rawValue;
    
    // Prevent processing the same code multiple times
    if (_lastScannedCode == currentCode || _isProcessing) return;
    
    _lastScannedCode = currentCode;
    _isProcessing = true;
    
    // Cancel any existing timer
    _debounceTimer?.cancel();
    
    // Debounce the processing
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      // Close scanner first
      Navigator.of(context).pop();
      
      // Create dummy card
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
      
      // Navigate to form screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardFormScreen(existingCard: dummyCard),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),
        ],
      ),
    );
  }
}

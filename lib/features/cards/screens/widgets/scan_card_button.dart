import 'package:bcode/core/utils/animated_page_route.dart';
import 'package:bcode/core/utils/app_colors.dart';
import 'package:bcode/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bcode/features/auth/presentation/bloc/auth_state.dart';
import 'package:bcode/features/cards/bloc/card_bloc.dart';
import 'package:bcode/features/cards/bloc/card_event.dart';
import 'package:bcode/features/cards/bloc/card_state.dart';
import 'package:bcode/features/cards/screens/add_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScanCardFloatingButton extends StatefulWidget {
  const ScanCardFloatingButton({super.key});

  @override
  State<ScanCardFloatingButton> createState() => _ScanCardFloatingButtonState();
}

class _ScanCardFloatingButtonState extends State<ScanCardFloatingButton>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    // FAB animation
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabScaleAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardBloc = context.read<CardBloc>();
    final authState = context.read<AuthBloc>().state;

    bool isAddingCard = cardBloc.state is AddingCard;

    return ScaleTransition(
      scale: _fabScaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            if (isAddingCard) return;
            // Scale down animation
            _fabAnimationController.reverse();
            await Future.delayed(const Duration(milliseconds: 100));
            _fabAnimationController.forward();

            if (authState is Authenticated) {
              final result = await Navigator.push(
                context,
                ScalePageRoute(
                  page: BlocProvider.value(
                    value: cardBloc,
                    child: AddCardScreen(userId: authState.user.id),
                  ),
                ),
              );
              if (result == true && mounted) {
                cardBloc.add(LoadCards(authState.user.id));
              }
            }
          },
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          heroTag: 'scan_card_fab',
          child: isAddingCard
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(Icons.qr_code_scanner_rounded, size: 28),
        ),
      ),
    );
  }
}

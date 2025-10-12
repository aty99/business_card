import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/business_card_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/animated_page_route.dart';
import '../../../utils/image_storage.dart';
import '../bloc/card_bloc.dart';
import '../bloc/card_event.dart';
import 'add_card_screen.dart';

/// Screen to view and manage a single business card
class CardDetailScreen extends StatefulWidget {
  final BusinessCardModel card;

  const CardDetailScreen({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteCard(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing during deletion
      builder: (dialogContext) => ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutBack,
        ),
        child: AlertDialog(
          title: const Text('Delete Card'),
          content: const Text('Are you sure you want to delete this card?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: _isDeleting ? null : () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            StatefulBuilder(
              builder: (context, setDialogState) {
                return TextButton(
                  onPressed: _isDeleting ? null : () async {
                    setDialogState(() {
                      _isDeleting = true;
                    });
                    
                    try {
                      // Delete the image file if it exists
                      if (widget.card.imagePath != null) {
                        await ImageStorage.deleteImage(widget.card.imagePath!);
                      }
                      
                      context.read<CardBloc>().add(DeleteCard(widget.card.id));
                      
                      if (mounted) {
                        Navigator.pop(dialogContext);
                        Navigator.pop(context, true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Card deleted successfully'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        setDialogState(() {
                          _isDeleting = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error deleting card: $e'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                  child: _isDeleting
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.error,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Deleting...'),
                          ],
                        )
                      : const Text('Delete'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editCard(BuildContext context) async {
    final result = await Navigator.push(
      context,
      ScalePageRoute(
        page: BlocProvider.value(
          value: context.read<CardBloc>(),
          child: AddCardScreen(
            userId: widget.card.userId,
            card: widget.card,
          ),
        ),
      ),
    );
    if (result == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'card_${widget.card.id}',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: widget.card.imagePath != null
                        ? null
                        : AppColors.primaryGradient,
                  ),
                  child: widget.card.imagePath != null
                      ? Image.file(
                          File(widget.card.imagePath!),
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            Icons.credit_card,
                            size: 80,
                            color: AppColors.primary.withValues(alpha: 0.7),
                          ),
                        ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.white),
                onPressed: () => _editCard(context),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: AppColors.white),
                onPressed: () => _deleteCard(context),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and title
                      _AnimatedCard(
                        delay: 0,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.card.fullName,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.card.jobTitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.business,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.card.companyName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  const SizedBox(height: 16),

                  // Contact information
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                      const SizedBox(height: 12),

                      _AnimatedCard(
                        delay: 100,
                        child: _buildContactCard(
                          context,
                          icon: Icons.email,
                          label: 'Email',
                          value: widget.card.email,
                          onTap: () => _copyToClipboard(context, widget.card.email, 'Email'),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _AnimatedCard(
                        delay: 200,
                        child: _buildContactCard(
                          context,
                          icon: Icons.phone,
                          label: 'Phone',
                          value: widget.card.phone,
                          onTap: () => _copyToClipboard(context, widget.card.phone, 'Phone'),
                        ),
                      ),

                      if (widget.card.website != null) ...[
                        const SizedBox(height: 12),
                        _AnimatedCard(
                          delay: 300,
                          child: _buildContactCard(
                            context,
                            icon: Icons.language,
                            label: 'Website',
                            value: widget.card.website!,
                            onTap: () =>
                                _copyToClipboard(context, widget.card.website!, 'Website'),
                          ),
                        ),
                      ],

                      if (widget.card.address != null) ...[
                        const SizedBox(height: 12),
                        _AnimatedCard(
                          delay: 400,
                          child: _buildContactCard(
                            context,
                            icon: Icons.location_on,
                            label: 'Address',
                            value: widget.card.address!,
                            onTap: () =>
                                _copyToClipboard(context, widget.card.address!, 'Address'),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Metadata
                      _AnimatedCard(
                        delay: 500,
                        child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Added on ${_formatDate(widget.card.createdAt)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.copy,
                size: 20,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Animated card widget with delay
class _AnimatedCard extends StatelessWidget {
  final Widget child;
  final int delay;

  const _AnimatedCard({
    required this.child,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

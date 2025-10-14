import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants/app_constants.dart';
import '../utils/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// A reusable empty state widget with customizable content
class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Widget? customIcon;
  final Color? iconColor;
  final Color? textColor;
  final bool showActionButton;

  const EmptyStateWidget({
    Key? key,
    this.title,
    this.message,
    this.icon,
    this.actionText,
    this.onActionPressed,
    this.customIcon,
    this.iconColor,
    this.textColor,
    this.showActionButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleColor = textColor ?? AppColors.textPrimary;
    final messageColor = textColor ?? AppColors.textSecondary;
    final iconColorValue = iconColor ?? AppColors.primary.withOpacity(0.6);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largeSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            if (customIcon != null)
              customIcon!
            else
              Container(
                padding: const EdgeInsets.all(AppConstants.largeSpacing),
                decoration: BoxDecoration(
                  color: iconColorValue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.inbox_outlined,
                  size: 64,
                  color: iconColorValue,
                ),
              ),

            const SizedBox(height: AppConstants.largeSpacing),

            // Title
            if (title != null)
              Text(
                title!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
                textAlign: TextAlign.center,
              ),

            if (title != null) const SizedBox(height: AppConstants.smallSpacing),

            // Message
            if (message != null)
              Text(
                message!,
                style: TextStyle(
                  fontSize: 16,
                  color: messageColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: AppConstants.extraLargeSpacing),

            // Action Button
            if (showActionButton && actionText != null && onActionPressed != null)
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.add),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.largeSpacing,
                    vertical: AppConstants.mediumSpacing,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Predefined empty state widgets for common scenarios
class EmptyStateWidgets {
  /// Empty state for no cards
  static Widget noCards({
    VoidCallback? onAddCard,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom card illustration
          Stack(
            alignment: Alignment.center,
            children: [
              // Back card (blue border)
              Transform.rotate(
                angle: -0.05,
                child: Container(
                  width: 200,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.cardBorderBlue,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8, right: 8),
                        width: 30,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8, left: 12),
                        height: 2,
                        width: 60,
                        color: Colors.grey.shade400,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8, left: 12),
                        height: 2,
                        width: 40,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
              // Front card (green border)
              Transform.rotate(
                angle: 0.05,
                child: Container(
                  width: 200,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.cardBorderGreen,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side lines
                          Container(
                            margin: const EdgeInsets.only(left: 12, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 2,
                                  width: 60,
                                  color: Colors.grey.shade400,
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                Container(
                                  height: 2,
                                  width: 40,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ),
                          // Right side QR placeholder
                          Container(
                            margin: const EdgeInsets.only(right: 12, bottom: 8),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'no_cards_found'.tr(),
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Empty state for no search results
  static Widget noSearchResults({
    VoidCallback? onClearSearch,
  }) {
    return EmptyStateWidget(
      title: AppStrings.noSearchResults.tr(),
      message: AppStrings.noSearchResultsMessage.tr(),
      icon: Icons.search_off,
      actionText: AppStrings.refresh.tr(),
      onActionPressed: onClearSearch,
    );
  }

  /// Empty state for loading errors
  static Widget loadingError({
    VoidCallback? onRetry,
  }) {
    return EmptyStateWidget(
      title: AppStrings.somethingWentWrong.tr(),
      message: AppStrings.networkError.tr(),
      icon: Icons.error_outline,
      actionText: AppStrings.retry.tr(),
      onActionPressed: onRetry,
    );
  }

  /// Empty state for network errors
  static Widget networkError({
    VoidCallback? onRetry,
  }) {
    return EmptyStateWidget(
      title: AppStrings.networkError.tr(),
      message: 'check_internet_connection'.tr(),
      icon: Icons.wifi_off,
      actionText: AppStrings.retry.tr(),
      onActionPressed: onRetry,
    );
  }

  /// Empty state for permission denied
  static Widget permissionDenied({
    required String permission,
    VoidCallback? onRequestPermission,
  }) {
    return EmptyStateWidget(
      title: 'permission_denied'.tr(),
      message: 'permission_required_message'.tr(args: [permission]),
      icon: Icons.security,
      actionText: 'grant_permission'.tr(),
      onActionPressed: onRequestPermission,
    );
  }

  /// Custom empty state with animated icon
  static Widget withAnimatedIcon({
    required Widget animatedIcon,
    required String title,
    String? message,
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    return EmptyStateWidget(
      title: title,
      message: message,
      customIcon: animatedIcon,
      actionText: actionText,
      onActionPressed: onActionPressed,
    );
  }
}

/// Extension for easy empty state creation
extension EmptyStateExtensions on BuildContext {
  /// Show empty state for no cards
  Widget noCardsEmptyState({VoidCallback? onAddCard}) {
    return EmptyStateWidgets.noCards(onAddCard: onAddCard);
  }

  /// Show empty state for no search results
  Widget noSearchResultsEmptyState({VoidCallback? onClearSearch}) {
    return EmptyStateWidgets.noSearchResults(onClearSearch: onClearSearch);
  }

  /// Show empty state for loading errors
  Widget loadingErrorEmptyState({VoidCallback? onRetry}) {
    return EmptyStateWidgets.loadingError(onRetry: onRetry);
  }

  /// Show empty state for network errors
  Widget networkErrorEmptyState({VoidCallback? onRetry}) {
    return EmptyStateWidgets.networkError(onRetry: onRetry);
  }
}

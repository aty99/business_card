import 'dart:async';

import 'package:bcode/core/utils/app_colors.dart';
import 'package:bcode/core/utils/type_defs.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    super.key,
    this.label,
    required this.onPressed,
    this.labelColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
    this.margin = const EdgeInsets.only(),
    this.labelStyle = const TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    this.alignment = Alignment.center,
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.borderColor,
    this.shadow,
    this.isExpanded = false,
    this.keepButtonSizeOnLoading = false,
    this.icon,
    this.borderWidth = 1.0,
    this.enabled = true,
    this.contentAlignment = MainAxisAlignment.center,
    this.backgroundColor = AppColors.primary,
    this.initLoadingState = false,
  });

  final FutureCallback? onPressed;
  final String? label;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final TextStyle labelStyle;
  final Color? borderColor;
  final Color? labelColor;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry borderRadius;
  final bool isExpanded;
  final bool keepButtonSizeOnLoading;
  final Widget? icon;
  final double borderWidth;
  final bool enabled;
  final Color backgroundColor;
  final List<BoxShadow>? shadow;
  final MainAxisAlignment contentAlignment;
  final bool initLoadingState;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton>
    with TickerProviderStateMixin {
  bool _isBusy = false;

  @override
  void initState() {
    _isBusy = widget.initLoadingState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final buttonContents = <Widget>[
      ...widget.icon != null
          ? [widget.icon!, if (widget.label != null) const SizedBox(width: 8.0)]
          : [],
      if (widget.label != null)
        Padding(
          padding: widget.icon != null
              ? const EdgeInsets.only(top: 3.0)
              : EdgeInsets.zero,
          child: Text(
            widget.label!,
            style: widget.labelColor == null
                ? widget.labelStyle
                : widget.labelStyle.copyWith(color: widget.labelColor),
          ),
        ),
    ];
    return Container(
      margin: widget.margin,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
        alignment: widget.alignment,
        child: _isBusy
            ? _buildLoading(widget.keepButtonSizeOnLoading)
            : GestureDetector(
                onTap: widget.enabled && widget.onPressed != null
                    ? () {
                        FocusScope.of(context).unfocus();
                        final futureOr = widget.onPressed!();
                        if (futureOr is Future) {
                          _setButtonToBusy();
                          futureOr.whenComplete(_setButtonToReady);
                        }
                      }
                    : null,
                child: Container(
                  padding: widget.padding,
                  alignment: widget.isExpanded ? Alignment.center : null,
                  decoration: BoxDecoration(
                    color: widget.enabled
                        ? widget.backgroundColor
                        : Colors.grey,
                    boxShadow: widget.shadow,
                    borderRadius: widget.borderRadius,
                    border: widget.borderColor != null
                        ? Border.all(
                            color: widget.borderColor!,
                            width: widget.borderWidth,
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: widget.contentAlignment,
                    children: buttonContents,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildLoading(bool keepButtonSizeOnLoading) {
    final loadingSize = widget.labelStyle.fontSize ?? 16.0 * 1.5;
    final padding = widget.padding.vertical / 2;
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(padding),
        width: keepButtonSizeOnLoading ? null : (loadingSize + padding * 2),
        height: (loadingSize + padding * 2),
        alignment: keepButtonSizeOnLoading ? Alignment.center : null,
        decoration: BoxDecoration(
          shape: keepButtonSizeOnLoading ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: keepButtonSizeOnLoading ? widget.borderRadius : null,
          color: widget.backgroundColor,
          border: widget.borderColor != null
              ? Border.all(
                  color: widget.borderColor!,
                  width: widget.borderWidth,
                )
              : null,
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: CircularProgressIndicator(color: widget.labelStyle.color),
        ),
      ),
    );
  }

  void _setButtonToReady() {
    _isBusy = false;
    if (mounted) setState(() {});
  }

  void _setButtonToBusy() {
    _isBusy = true;
    if (mounted) setState(() {});
  }
}

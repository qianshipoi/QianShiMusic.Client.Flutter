import 'package:flutter/material.dart';

class ToastWidget extends StatefulWidget {
  final String text;
  final Duration duration;
  final Duration animationDuration;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  const ToastWidget({
    Key? key,
    required this.text,
    required this.duration,
    required this.animationDuration,
    this.icon,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);
  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: widget.animationDuration, vsync: this, value: 0.0);
    _animationController.forward();

    final startFadeOutAt = widget.duration - widget.animationDuration;

    Future.delayed(startFadeOutAt, _animationController.reverse);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ??
                Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).size.height * .125,
          ),
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            if (widget.icon != null) widget.icon!,
            Expanded(
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: widget.textColor ??
                          Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

extension ToastExtension on BuildContext {
  void showToast({
    required String text,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 300),
  }) {
    _showToast(ToastWidget(
      text: text,
      duration: duration,
      animationDuration: animationDuration,
    ));
  }

  void _showToast(widget) {
    final overlayState = Overlay.of(this);
    final overlayEntry = OverlayEntry(builder: (context) => widget);
    overlayState.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), overlayEntry.remove);
  }

  void showErrorToast({
    required String text,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 300),
  }) {
    _showToast(ToastWidget(
      text: text,
      duration: duration,
      animationDuration: animationDuration,
      backgroundColor: Theme.of(this).colorScheme.error,
      textColor: Theme.of(this).colorScheme.onError,
      icon: const Icon(Icons.error, color: Colors.redAccent),
    ));
  }

  void showSuccessToast({
    required String text,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 300),
  }) {
    _showToast(ToastWidget(
      text: text,
      duration: duration,
      animationDuration: animationDuration,
      backgroundColor: Theme.of(this).colorScheme.secondary,
      textColor: Theme.of(this).colorScheme.onSecondary,
      icon: const Icon(Icons.check, color: Colors.greenAccent),
    ));
  }

  void showWarningToast({
    required String text,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 300),
  }) {
    _showToast(ToastWidget(
      text: text,
      duration: duration,
      animationDuration: animationDuration,
      backgroundColor: Theme.of(this).colorScheme.surface,
      textColor: Theme.of(this).colorScheme.onSurface,
      icon: const Icon(Icons.warning, color: Colors.yellowAccent),
    ));
  }
}

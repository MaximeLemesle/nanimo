import 'package:flutter/material.dart';

/// Wraps the whole app so that, while the soft keyboard is visible, the first
/// tap anywhere outside the focused field only dismisses the keyboard.
class KeyboardDismissWrapper extends StatelessWidget {
  final Widget child;

  const KeyboardDismissWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (keyboardVisible)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            ),
          ),
      ],
    );
  }
}

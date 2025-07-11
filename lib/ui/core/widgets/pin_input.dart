import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PinEntrySheet extends HookWidget {
  final int pinLength;
  final void Function(String pin) onCompleted;
  final String? title;
  final String? subtitle;
  final bool showError;
  final VoidCallback? onCancel;

  const PinEntrySheet({
    super.key,
    this.pinLength = 4,
    required this.onCompleted,
    this.title,
    this.subtitle,
    this.showError = false,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final pin = useState('');
    final isShaking = useState(false);
    final isProcessing = useState(false);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    // Shake animation for errors
    final shakeAnimation = useAnimation(
      Tween<double>(begin: 0, end: 10).animate(
        CurvedAnimation(parent: animationController, curve: Curves.elasticIn),
      ),
    );

    void triggerShake() {
      isShaking.value = true;
      animationController.forward().then((_) {
        animationController.reset();
        isShaking.value = false;
      });
    }

    void addDigit(String digit) {
      if (pin.value.length < pinLength && !isProcessing.value) {
        // Haptic feedback
        HapticFeedback.selectionClick();

        pin.value += digit;

        if (pin.value.length == pinLength) {
          isProcessing.value = true;
          Future.delayed(const Duration(milliseconds: 300), () {
            onCompleted(pin.value);
            isProcessing.value = false;
          });
        }
      }
    }

    void removeDigit() {
      if (pin.value.isNotEmpty && !isProcessing.value) {
        HapticFeedback.selectionClick();
        pin.value = pin.value.substring(0, pin.value.length - 1);
      }
    }

    // Reset pin and trigger shake on error
    useEffect(() {
      if (showError) {
        pin.value = '';
        triggerShake();
      }
      return null;
    }, [showError]);

    Widget buildPinDots() {
      return Transform.translate(
        offset: Offset(isShaking.value ? shakeAnimation : 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pinLength, (index) {
            final filled = index < pin.value.length;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: filled
                    ? (showError ? Colors.red : Theme.of(context).primaryColor)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: showError
                      ? Colors.red
                      : (filled
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300]!),
                  width: 2,
                ),
                boxShadow: filled
                    ? [
                        BoxShadow(
                          color:
                              (showError
                                      ? Colors.red
                                      : Theme.of(context).primaryColor)
                                  .withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
            );
          }),
        ),
      );
    }

    Widget buildNumpadButton(String value, {VoidCallback? onTap}) {
      final isBackspace = value == 'backspace';

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () => addDigit(value),
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: isBackspace
                  ? Icon(
                      Icons.backspace_outlined,
                      size: 24,
                      color: Colors.grey[600],
                    )
                  : Text(
                      value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard if it appears
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(top: 16, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                children: [
                  /*
                  // Security icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.security,
                      size: 32,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),*/

                  const SizedBox(height: 16),

                  Text(
                    title ?? 'Enter PIN',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),

                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  if (showError) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Incorrect PIN. Please try again.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            // PIN dots
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: buildPinDots(),
            ),

            // Numpad
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildNumpadButton('1'),
                      buildNumpadButton('2'),
                      buildNumpadButton('3'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildNumpadButton('4'),
                      buildNumpadButton('5'),
                      buildNumpadButton('6'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildNumpadButton('7'),
                      buildNumpadButton('8'),
                      buildNumpadButton('9'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (onCancel != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: onCancel,
                              icon: const Icon(Icons.close),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                foregroundColor: Colors.grey[600],
                                fixedSize: const Size(72, 72),
                              ),
                            ),
                          ],
                        ),
                      //buildNumpadButton(Icons.cancel, onTap: onCancel)// Empty space
                      buildNumpadButton('0'),
                      buildNumpadButton('backspace', onTap: removeDigit),
                    ],
                  ),
                ],
              ),
            ),

            // Processing indicator
            if (isProcessing.value) ...[
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Verifying...',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Helper service for showing the PIN entry sheet
class PinEntryService {
  static Future<String?> showPinEntry(
    BuildContext context, {
    int pinLength = 4,
    String? title,
    String? subtitle,
    bool isDismissible = true,
  }) async {
    String? enteredPin;
    bool showError = false;

    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      // Prevent accidental keyboard trigger
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => PinEntrySheet(
          pinLength: pinLength,
          title: title,
          subtitle: subtitle,
          showError: showError,
          onCompleted: (pin) {
            enteredPin = pin;
            Navigator.of(context).pop(pin);
          },
          onCancel: isDismissible ? () => Navigator.of(context).pop() : null,
        ),
      ),
    );

    return enteredPin;
  }

  static Future<String?> showPinEntryWithRetry(
    BuildContext context, {
    int pinLength = 4,
    String? title,
    String? subtitle,
    bool Function(String pin)? validator,
    int maxAttempts = 3,
  }) async {
    String? enteredPin;
    bool showError = false;
    int attempts = 0;

    while (attempts < maxAttempts) {
      final pin = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        // Prevent accidental keyboard trigger
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => PinEntrySheet(
            pinLength: pinLength,
            title: title ?? 'Enter PIN',
            subtitle: attempts > 0
                ? 'Incorrect PIN. ${maxAttempts - attempts} attempts remaining.'
                : subtitle,
            showError: showError,
            onCompleted: (pin) {
              Navigator.of(context).pop(pin);
            },
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      );

      if (pin == null) {
        return null; // User cancelled
      }

      if (validator == null || validator(pin)) {
        return pin; // Valid PIN
      }

      attempts++;
      showError = true;

      if (attempts >= maxAttempts) {
        // Show error dialog or handle max attempts exceeded
        break;
      }
    }

    return null; // Max attempts exceeded
  }
}
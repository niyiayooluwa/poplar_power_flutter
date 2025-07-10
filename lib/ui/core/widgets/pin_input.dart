import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PinEntrySheet extends HookWidget {
  final int pinLength;
  final void Function(String pin) onCompleted;

  const PinEntrySheet({
    super.key,
    this.pinLength = 4,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final pin = useState('');

    void addDigit(String digit) {
      if (pin.value.length < pinLength) {
        pin.value += digit;
        if (pin.value.length == pinLength) {
          Future.delayed(Duration(milliseconds: 150), () {
            onCompleted(pin.value);
          });
        }
      }
    }

    void removeDigit() {
      if (pin.value.isNotEmpty) {
        pin.value = pin.value.substring(0, pin.value.length - 1);
      }
    }

    Widget buildPinDots() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pinLength, (index) {
          final filled = index < pin.value.length;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: filled ? Colors.black : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
          );
        }),
      );
    }

    Widget buildNumpadButton(String value, {VoidCallback? onTap}) {
      return InkWell(
        onTap: onTap ?? () => addDigit(value),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: value == 'backspace'
              ? const Icon(Icons.backspace, size: 24)
              : Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Enter PIN', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          buildPinDots(),
          const SizedBox(height: 24),
          // Replace GridView with manual rows for better control
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildNumpadButton('1'),
                  buildNumpadButton('2'),
                  buildNumpadButton('3'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildNumpadButton('4'),
                  buildNumpadButton('5'),
                  buildNumpadButton('6'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildNumpadButton('7'),
                  buildNumpadButton('8'),
                  buildNumpadButton('9'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 60, height: 60), // Empty space
                  buildNumpadButton('0'),
                  buildNumpadButton('backspace', onTap: removeDigit),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
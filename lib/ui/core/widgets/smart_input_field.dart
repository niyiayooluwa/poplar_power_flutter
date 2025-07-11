import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SmartInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType keyboardType;
  final String errorMessage;
  final IconData? suffixIcon;
  final List<String>? options;
  final bool enableSearch;
  final void Function(String)? onSelected;
  final Function(String)? onChanged;

  const SmartInputField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.errorMessage = 'You haven’t selected anything yet',
    this.suffixIcon,
    this.options,
    this.enableSearch = false,
    this.onSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        // If options are provided, show bottom sheet and disable typing
        if (options != null) {
          final selected = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            backgroundColor: theme.colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) {
              return FractionallySizedBox(
                heightFactor: 0.6,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Select $label',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    if (enableSearch)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (query) {
                            // Not implemented: dynamic search logic.
                            // In a real version, you'd wrap this in a stateful widget.
                          },
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: options!.length,
                        itemBuilder: (_, index) {
                          final value = options![index];
                          return ListTile(
                            title: Text(value, style: theme.textTheme.bodyLarge),
                            onTap: () => Navigator.pop(context, value),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );

          // If the user made a selection, update controller
          if (selected != null) {
            controller.text = selected;
            onSelected?.call(selected);
          }
        }
      },
      child: AbsorbPointer(
        absorbing: options != null || readOnly,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          decoration: InputDecoration(
            labelText: label,
            labelStyle: theme.textTheme.bodyMedium,
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: theme.iconTheme.color)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ),
    );
  }
}
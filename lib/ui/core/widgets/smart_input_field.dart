// Import necessary packages for Flutter UI and services.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Define a class for a smart input field widget.
/// A versatile input field widget that can function as a standard text field
/// or a selection field with a bottom sheet picker.
///
/// If [options] are provided, tapping the field opens a modal bottom sheet
/// allowing the user to select from the list. Otherwise, it behaves as a
/// regular [TextField].
///
class SmartInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType keyboardType;
  final String errorMessage;
  final IconData? suffixIcon;
  final List<String>? options;
  final bool enableSearch;
  final String? hintText;
  final void Function(String)? onSelected;
  final Function(String)? onChanged;
  final double defaultModalHeightFactor;
  final int? maxLength;

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
    this.hintText,
    this.defaultModalHeightFactor = 0.65,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expandedModalHeightFactor = 0.95;

    // Use GestureDetector to handle taps on the input field.
    return GestureDetector(
      onTap: () async {
        // If options are provided, show bottom sheet and disable typing
        final selected = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: theme.colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) {
            final focusNode = FocusNode();
            List<String> filteredOptions = List.from(options!);
            double modalHeightFactor = defaultModalHeightFactor;

            return StatefulBuilder(
              builder: (context, setModalState) {
                focusNode.addListener(() {
                  setModalState(() {
                    modalHeightFactor = focusNode.hasFocus
                        ? expandedModalHeightFactor
                        : defaultModalHeightFactor;
                  });
                });

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height:
                      MediaQuery.of(context).size.height * modalHeightFactor,
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      Text(
                        'Select $label',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (enableSearch)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (query) {
                              setModalState(() {
                                filteredOptions = options!
                                    .where(
                                      (opt) => opt.toLowerCase().contains(
                                        query.toLowerCase(),
                                      ),
                                    )
                                    .toList();
                              });
                            },
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredOptions.length,
                          itemBuilder: (_, index) {
                            final value = filteredOptions[index];
                            return ListTile(
                              title: Text(value),
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
          },
        );

        // If the user made a selection, update controller
        if (selected != null) {
          // Set the text of the controller to the selected value.
          controller.text = selected;
          // Call the onSelected callback with the selected value.
          onSelected?.call(selected);
          onChanged?.call(selected);
        }
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 8),

          // AbsorbPointer to disable interaction with the TextField if options
          // are provided or it's read-only.
          AbsorbPointer(
            absorbing: options != null || readOnly,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxLength,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                // Hide the default counter
                hintText: hintText,
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
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

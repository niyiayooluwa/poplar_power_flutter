import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A data class to hold the information for each item in the selection list.
class SelectableOption {
  final String name;
  final String? imageUrl;

  const SelectableOption({required this.name, this.imageUrl});
}
class AsyncSelectableField extends ConsumerWidget {
  final String label;
  final TextEditingController controller;

  /// Trigger fetch before modal is shown
  final Future<void> Function()? onTap;

  /// Instead of passing AsyncValue directly, pass the provider itself.
  final ProviderListenable<AsyncValue<List<SelectableOption>>> optionsProvider;

  final void Function(SelectableOption)? onSelected;
  final Widget? fallbackIcon;

  const AsyncSelectableField({
    super.key,
    required this.label,
    required this.controller,
    required this.optionsProvider,
    this.onTap,
    this.onSelected,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        onTap?.call();

        showModalBottomSheet<SelectableOption>(
          context: context,
          isScrollControlled: true,
          backgroundColor: theme.colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => _SelectionModal(
            label: label,
            optionsProvider: optionsProvider,
            fallbackIcon: fallbackIcon,
          ),
        ).then((selected) {
          if (selected != null) {
            controller.text = selected.name;
            onSelected?.call(selected);
          }
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 8),
          AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.arrow_drop_down),
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
        ],
      ),
    );
  }
}

class _SelectionModal extends ConsumerWidget {
  const _SelectionModal({
    required this.label,
    required this.optionsProvider,
    this.fallbackIcon,
  });

  final String label;
  final ProviderListenable<AsyncValue<List<SelectableOption>>> optionsProvider;
  final Widget? fallbackIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncOptions = ref.watch(optionsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: asyncOptions.when(
                  loading: () =>
                  const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Failed to load options: $err',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  data: (options) {
                    if (options.isEmpty) {
                      return const Center(
                        child: Text('No options available.'),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: options.length,
                      itemBuilder: (_, index) {
                        final option = options[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: option.imageUrl != null
                                ? Image.network(
                              option.imageUrl!,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return fallbackIcon ?? const SizedBox();
                              },
                              errorBuilder: (context, error, stack) =>
                              fallbackIcon ?? const SizedBox(),
                            )
                                : fallbackIcon,
                          ),
                          title: Text(option.name),
                          onTap: () => Navigator.pop(context, option),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

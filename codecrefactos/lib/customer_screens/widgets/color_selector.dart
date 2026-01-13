import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final List<int> colors;
  final int selected;
  final Function(int) onSelect;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(colors.length, (i) {
        final isActive = i == selected;
        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(right: 8),
            width: isActive ? 26 : 22,
            height: isActive ? 26 : 22,
            decoration: BoxDecoration(
              color: Color(colors[i]),
              shape: BoxShape.circle,
              border: isActive
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
            ),
          ),
        );
      }),
    );
  }
}

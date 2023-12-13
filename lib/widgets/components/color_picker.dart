import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final List<Color> colorSuggestions;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  ColorPicker({
    required this.colorSuggestions,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40, // Set a fixed height for the color picker
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colorSuggestions.length,
        itemBuilder: (BuildContext context, int index) {
          final Color color = colorSuggestions[index];
          return GestureDetector(
            onTap: () {
              onColorSelected(color);
            },
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedColor == color
                      ? Colors.black
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

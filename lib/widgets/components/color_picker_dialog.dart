import 'package:flutter/material.dart';
import 'package:watermark_generator/widgets/components/color_picker.dart';

class ColorPickerDialog extends StatelessWidget {
  final List<Color> colorSuggestions;
  final Color selectedColor;
  final Function(Color) onColorSelected;

  ColorPickerDialog({
    required this.colorSuggestions,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue, // Set the background color
              child: const Row(
                children: [
                  Icon(
                    Icons.palette,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Watermark Color',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: ColorPicker(
                colorSuggestions: colorSuggestions,
                selectedColor: selectedColor,
                onColorSelected: onColorSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

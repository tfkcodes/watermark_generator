import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  const Button(
      {super.key,
      required this.text,
      required this.onTap,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            color:  Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          child: Center(
            child: isLoading
                ? const CupertinoActivityIndicator(
                    color: Colors.white,
                  )
                : Text(
                    text.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ),
    );
  }
}
